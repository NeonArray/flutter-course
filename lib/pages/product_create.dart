import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
	final Function addProduct;

	ProductCreatePage(this.addProduct);

	@override
	_ProductCreatePageState createState() => new _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
	final Map<String, dynamic> _formData = {
		'title': '',
		'description': '',
		'price': 0.0,
		'image': 'assets/food.jpg',
	};
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

	Widget _buildTitleTextField() {
		return TextFormField(
			decoration: InputDecoration(
				labelText: 'Product Title',
			),
			validator: (String value) {
				if (value.isEmpty || value.length < 5) {
					return 'Title is required and should be 5+ characters';
				}
			},
			onSaved: (String value) {
				_formData['title'] = value;
			},
		);
	}

	Widget _buildDescriptionTextField() {
		return TextFormField(
			decoration: InputDecoration(
				labelText: 'Product Description',
			),
			maxLines: 4,
			validator: (String value) {
				if (value.isEmpty || value.length < 10) {
					return 'Description is required and should be 10+ characters';
				}
			},
			onSaved: (String value) {
				_formData['description'] = value;
			},
		);
	}

	Widget _buildPriceTextField() {
		return TextFormField(
			decoration: InputDecoration(
				labelText: 'Product Price',
			),
			keyboardType: TextInputType.number,
			validator: (String value) {
				if (value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
					return 'Price is required and should be a number';
				}
			},
			onSaved: (String value) {
				_formData['price'] = double.parse(value);
			},
		);
	}

	Widget _buildSaveButton(Map<String, dynamic> product) {
		return RaisedButton(
			child: Text('Save'),
			textColor: Colors.black,
			onPressed: () {

				if (!_formKey.currentState.validate()) {
					return;
				}

				_formKey.currentState.save();

				widget.addProduct(product);

				Navigator.pushReplacementNamed(context, '/products');
			},
		);
	}
	
    @override
    Widget build(BuildContext context) {
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
							_buildSaveButton(_formData),
						],
					),
				),
			),
		);
  	}
}
