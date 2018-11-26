import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/widgets/helpers/ensure_visible.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped_models/products.dart';

class ProductEditPage extends StatefulWidget {
	@override
	_ProductEditPageState createState() => new _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
	final Map<String, dynamic> _formData = {
		'title': '',
		'description': '',
		'price': 0.0,
		'image': 'assets/food.jpg',
	};
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
	final FocusNode _titleFocusNode = FocusNode();
	final FocusNode _descriptionFocusNode = FocusNode();
	final FocusNode _priceFocusNode = FocusNode();


	Widget _buildTitleTextField(Product product) {
		return EnsureVisibleWhenFocused(
			focusNode: _titleFocusNode,
			child: TextFormField(
				focusNode: _titleFocusNode,
				decoration: InputDecoration(
					labelText: 'Product Title',
				),
				initialValue: product == null ? '' :  product.title,
				validator: (String value) {
					if (value.isEmpty || value.length < 5) {
						return 'Title is required and should be 5+ characters';
					}
				},
				onSaved: (String value) {
					_formData['title'] = value;
				},
			),
		);
	}


	Widget _buildDescriptionTextField(Product product) {
		return EnsureVisibleWhenFocused(
			focusNode: _descriptionFocusNode,
			child: TextFormField(
				focusNode: _descriptionFocusNode,
				decoration: InputDecoration(
					labelText: 'Product Description',
				),
				initialValue: product == null ? '' :  product.description,
				maxLines: 4,
				validator: (String value) {
					if (value.isEmpty || value.length < 10) {
						return 'Description is required and should be 10+ characters';
					}
				},
				onSaved: (String value) {
					_formData['description'] = value;
				},
			),
		);
	}


	Widget _buildPriceTextField(Product product) {
		return EnsureVisibleWhenFocused(
			focusNode: _priceFocusNode,
			child: TextFormField(
				focusNode: _priceFocusNode,
				decoration: InputDecoration(
					labelText: 'Product Price',
				),
				initialValue: product == null ? '' : product.price.toString(),
				keyboardType: TextInputType.number,
				validator: (String value) {
					if (value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
						return 'Price is required and should be a number';
					}
				},
				onSaved: (String value) {
					_formData['price'] = double.parse(value);
				},
			),
		);
	}


	Widget _buildSaveButton() {
		return ScopedModelDescendant<ProductsModel>(
			builder: (BuildContext context, Widget child, ProductsModel model) {
				return RaisedButton(
					child: Text('Save'),
					textColor: Colors.black,
					onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectedProductIndex),
				);
			}
		);
	}


	void _submitForm(Function addProduct, Function updateProduct, int selectedProductIndex) {
		if (!_formKey.currentState.validate()) {
			return;
		}

		_formKey.currentState.save();

		Product product = new Product(
			title: _formData['title'],
			description: _formData['description'],
			price: _formData['price'],
			image: _formData['image'],
		);

		if (selectedProductIndex == null) {
			addProduct(product);
		} else {
			updateProduct(product);
		}

		Navigator.pushReplacementNamed(context, '/products');
	}


	Widget _buildPageContent(BuildContext context, Product product) {
		final double deviceWidth = MediaQuery.of(context).size.width;
		final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
		final double targetPadding = deviceWidth - targetWidth;

		return GestureDetector(
			onTap: () {
				// Remove focus from tex field node by instantiating an empty FocusNode.
				FocusScope.of(context).requestFocus(FocusNode());
			},
			child: Container(
				width: targetWidth,
				margin: EdgeInsets.all(10.0),
				child: Form(
					key: _formKey,
					child: ListView(
						padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
						children: <Widget>[
							_buildTitleTextField(product),
							_buildDescriptionTextField(product),
							_buildPriceTextField(product),
							SizedBox(
								height: 30.0,
							),
							_buildSaveButton(),
						],
					),
				),
			),
		);
	}


	@override
	Widget build(BuildContext context) {
		return  ScopedModelDescendant<ProductsModel>(
			builder: (BuildContext context, Widget child, ProductsModel model) {
				final Widget pageContent = _buildPageContent(context, model.selectedProduct);

				return model.selectedProductIndex == null
					? pageContent
					: Scaffold(
						appBar: AppBar(
							title: Text('Edit Product'),
						),
						body: pageContent,
					);
			}
		);
	}
}
