import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

void main() {
//	debugPaintSizeEnabled = true;
	runApp(MyApp());
}

class MyApp extends StatefulWidget {
	@override
	_MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
	List<Map<String, dynamic>> _products = [];

	void _addProduct(Map<String, dynamic> product) {
		setState(() {
			_products.add(product);
		});
	}

	void _deleteProduct(int index) {
		setState(() {
			_products.removeAt(index);
		});
	}

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			theme: ThemeData(
				brightness: Brightness.light,
				primarySwatch: Colors.teal,
				accentColor: Colors.grey,
				buttonColor: Colors.deepPurple,
			),
			routes: {
				// The '/' is a special route that Flutter uses to show as the 'home' screen.
				// you CANNOT use both the home: property in MaterialApp as well as this '/' route
				// or it will throw an error. Use one or the other.
				'/': (BuildContext context) => AuthPage(),
				'/products': (BuildContext context) => ProductsPage(_products),
				'/admin': (BuildContext context) => ProductsAdminPage(_addProduct, _deleteProduct),
			},
			// This property allows us to use 'dynamic' named routes. Think of them as '/route/:id'
			// These routes are supplemental to the routes property/values as any routes that are hit
			// that aren't in routes, go to this function
			onGenerateRoute: (RouteSettings settings) {
				final List<String> pathElements = settings.name.split('/');

				if (pathElements[0] != '') {
					return null;
				}

				if (pathElements[1] == 'product') {
					final int index = int.parse(pathElements[2]);

					return MaterialPageRoute<bool>(
						builder: (BuildContext context) => ProductPage(
							_products[index]['title'],
							_products[index]['image'],
							_products[index]['price'],
							_products[index]['description'],
						),
					);
				}

				return null;
			},
			// Executes whenever onGenerateRoute fails to generate a route which will happen if
			// the "null" is returned from onGenerateRoute.
			onUnknownRoute: (RouteSettings settings) {
				return MaterialPageRoute(
					builder: (BuildContext context) => ProductsPage(_products),
				);
			},
		);
	}
}

