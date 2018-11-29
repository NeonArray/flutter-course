import 'dart:async';
import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_course/env.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/models/user.dart';


/// All of the models are located in this file for the use of private members. If the models were
/// separated into three files; connected_products, products, user...the private members in
/// ConnectedProductsModel would not be accessible outside of its' file.

mixin ConnectedProductsModel on Model {
	List<Product> _products = [];
	User _authenticatedUser;
	String _selectedProductId;
	bool _isLoading = false;


	void releaseUI() {
		_isLoading = false;
		notifyListeners();
	}


	void prepareUI() {
		_isLoading = true;
		notifyListeners();
	}


	void interrogateStatusCode(int statusCode) {
		if (statusCode != 200 && statusCode != 201) {
			throw Exception('Status code response was not 200 or 201');
		}
	}
}


mixin ProductsModel on ConnectedProductsModel {
	bool _showFavorites = false;


	List<Product> get allProducts {
		return List.from(_products);
	}


	String get selectedProductId {
		return _selectedProductId;
	}


	Product get selectedProduct {
		if (selectedProductId == null) {
			return null;
		}

		return _products.firstWhere((Product product) {
			return product.id == _selectedProductId;
		});
	}


	List<Product> get displayedProducts {
		if (_showFavorites) {
			return _products.where((Product product) => product.isFavorite).toList();
		}

		return List.from(_products);
	}


	bool get displayFavoritesOnly {
		return _showFavorites;
	}


	int get selectedProductIndex {
		return _products.indexWhere((Product product) {
			return product.id == _selectedProductId;
		});
	}


	Future<bool> addProduct(String title, String description, String image, double price) async {
		prepareUI();

		final Map<String, dynamic> productData = {
			'title': title,
			'description': description,
			'image': 'https://fthmb.tqn.com/6JQIj_mV43sUlBmUvr2tZ35GIFo=/2000x1500/filters:fill(auto,1)/chocolate-bars-Cultura-RM-Exclusive-Diana-Miller-Getty-Images-57c762e23df78c71b64de4bf.jpg',
			'price': price,
			'userEmail': _authenticatedUser.email,
			'userId': _authenticatedUser.id,
		};

		try {
			final http.Response response = await http.post(
				baseUrl + '.json',
				body: jsonEncode(productData),
			);

			interrogateStatusCode(response.statusCode);

			final Map<String, dynamic> responseData = json.decode(response.body);

			_products.add(Product(
				id: responseData['name'],
				title: title,
				description: description,
				image: image,
				price: price,
				userEmail: _authenticatedUser.email,
				userId: _authenticatedUser.id,
			));

			return true;
		} catch (error) {
			print(error);
			return false;
		} finally {
			releaseUI();
		}
	}


	Future<bool> fetchProducts() async {
		prepareUI();

		try {
			final http.Response response = await http.get(baseUrl + '.json');

			interrogateStatusCode(response.statusCode);

			final List<Product> fetchedProductList = [];
			final Map<String, dynamic> productListData = json.decode(response.body);

			if (productListData == null) {
				throw Exception('Product list is empty');
			}

			productListData.forEach((String productId, dynamic productData) {
				final Product product = Product(id: productId, title: productData['title'], description: productData['description'], image: productData['image'], price: productData['price'], userEmail: productData['userEmail'], userId: productData['userId'],);

				fetchedProductList.add(product);
			});

			_products = fetchedProductList;
			_selectedProductId = null;

			return true;
		} catch (error) {
			print(error);
			return false;
		} finally {
			releaseUI();
		}
	}


	Future<bool> updateProduct(String title, String description, String image, double price) async {
		_isLoading = true;
		notifyListeners();

		final Map<String, dynamic> updateData = {
			'title': title,
			'description': description,
			'image': 'https://fthmb.tqn.com/6JQIj_mV43sUlBmUvr2tZ35GIFo=/2000x1500/filters:fill(auto,1)/chocolate-bars-Cultura-RM-Exclusive-Diana-Miller-Getty-Images-57c762e23df78c71b64de4bf.jpg',
			'price': price,
			'userEmail': selectedProduct.userEmail,
			'userId': selectedProduct.userId,
		};

		try {
			await http.put(
				baseUrl + '/${selectedProduct.id}.json',
				body: json.encode(updateData),
			);
			final Product udpatedProduct = Product(
				id: selectedProduct.id,
				title: title,
				description: description,
				image: image,
				price: price,
				userEmail: selectedProduct.userEmail,
				userId: selectedProduct.userId,
			);
			_products[selectedProductIndex] = udpatedProduct;

			return true;
		} catch (error) {
			print(error);
			return false;
		} finally {
			releaseUI();
		}
	}


	Future<bool> deleteProduct() async {
		final deletedProductId = selectedProduct.id;
		_isLoading = true;

		_products.removeAt(selectedProductIndex);
		_selectedProductId = null;
		notifyListeners();

		try {
			await http.delete(baseUrl + '/' + deletedProductId + '.json');

			return true;
		} catch (error) {
			print(error);
			return false;
		} finally {
			releaseUI();
		}
	}


	void selectProduct(String productId) {
		_selectedProductId = productId;
		notifyListeners();
	}


	void toggleDisplayMode() {
		_showFavorites = !_showFavorites;
		notifyListeners();
	}


	void toggleProductFavoriteStatus() {
		_products[selectedProductIndex] = Product(
			id: selectedProduct.id,
			title: selectedProduct.title,
			description: selectedProduct.description,
			price: selectedProduct.price,
			image: selectedProduct.image,
			isFavorite: !selectedProduct.isFavorite,
			userEmail: _authenticatedUser.email,
			userId: _authenticatedUser.id,
		);
		notifyListeners();
	}
}


mixin UserModel on ConnectedProductsModel {

	Future<Map<String, dynamic>> signup(String email, String password) async {
		prepareUI();

		final Map<String, dynamic> authData = {
			'email': email,
			'password': password,
			'returnSecureToken': true,
		};
		final http.Response response = await http.post(
			authRegisterUrl,
			headers: {
				'ContentType': 'application/json',
			},
			body: json.encode(authData),
		);
		final Map<String, dynamic> responseData = json.decode(response.body);
		bool hasError = true;
		String statusMessage = 'Something went wrong';

		if (responseData.containsKey('idToken')) {
			hasError = false;
			statusMessage = 'Authentication success';
		} else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
			statusMessage = 'This email already exists.';
		}

		releaseUI();

		return {
			'success': !hasError,
			'message': statusMessage,
		};
	}


	void login(String email, String password) {
		_authenticatedUser = User(
			id: '1',
			email: email,
			password: password,
		);
	}
}


mixin UtilityModel on ConnectedProductsModel {
	bool get isLoading {
		return _isLoading;
	}
}