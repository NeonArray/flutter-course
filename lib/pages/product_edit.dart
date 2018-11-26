import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/widgets/helpers/ensure_visible.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped_models/products.dart';

class ProductEditPage extends StatefulWidget {
	final Function addProduct;
	final Function updateProduct;
	final Product product;
	final int productIndex;

	ProductEditPage({this.addProduct, this.updateProduct, this.product, this.productIndex});

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

	Widget _buildTitleTextField() {
		return EnsureVisibleWhenFocused(
			focusNode: _titleFocusNode,
			child: TextFormField(
				focusNode: _titleFocusNode,
				decoration: InputDecoration(
					labelText: 'Product Title',
				),
				initialValue: widget.product == null ? '' :  widget.product.title,
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

	Widget _buildDescriptionTextField() {
		return EnsureVisibleWhenFocused(
			focusNode: _descriptionFocusNode,
			child: TextFormField(
				focusNode: _descriptionFocusNode,
				decoration: InputDecoration(
					labelText: 'Product Description',
				),
				initialValue: widget.product == null ? '' :  widget.product.description,
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

	Widget _buildPriceTextField() {
		return EnsureVisibleWhenFocused(
			focusNode: _priceFocusNode,
			child: TextFormField(
				focusNode: _priceFocusNode,
				decoration: InputDecoration(
					labelText: 'Product Price',
				),
				initialValue: widget.product == null ? '' : widget.product.price.toString(),
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
					onPressed: () => _submitForm(model.addProduct, model.updateProduct),
				);
			}
		);
	}

	void _submitForm(Function addProduct, Function updateProduct) {
		if (!_formKey.currentState.validate()) {
			return;
		}

		_formKey.currentState.save();

		if (widget.product == null) {
			addProduct(Product(
				title: _formData['title'],
				description: _formData['description'],
				price: _formData['price'],
				image: _formData['image'],
			));
		} else {
			updateProduct(widget.productIndex, _formData);
		}

		Navigator.pushReplacementNamed(context, '/products');
	}

	Widget _buildPageContent(BuildContext context) {
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
							_buildTitleTextField(),
							_buildDescriptionTextField(),
							_buildPriceTextField(),
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
		final Widget pageContent = _buildPageContent(context);

		return widget.product == null ? pageContent : Scaffold(
			appBar: AppBar(
				title: Text('Edit Product'),
			),
			body: pageContent,
		);
	}
}
