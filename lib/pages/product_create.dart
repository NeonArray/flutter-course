import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
	final Function addProduct;

	ProductCreatePage(this.addProduct);

	@override
	_ProductCreatePageState createState() => new _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
	String _titleValue = '';
	String _descriptionValue = '';
	double _priceValue = 0.0;

	Widget _buildTitleTextField() {
		return TextField(
			decoration: InputDecoration(
				labelText: 'Product Title',
			),
			onChanged: (String value) {
				setState(() {
					_titleValue = value;
				});
			},
		);
	}

	Widget _buildDescriptionTextField() {
		return TextField(
			decoration: InputDecoration(
				labelText: 'Product Description',
			),
			maxLines: 4,
			onChanged: (String value) {
				setState(() {
					_descriptionValue = value;
				});
			},
		);
	}

	Widget _buildPriceTextField() {
		return TextField(
			decoration: InputDecoration(
				labelText: 'Product Price',
			),
			keyboardType: TextInputType.number,
			onChanged: (String value) {
				setState(() {
					_priceValue = double.parse(value);
				});
			},
		);
	}

	Widget _buildSaveButton() {
		return RaisedButton(
			child: Text('Save'),
			color: Theme.of(context).accentColor,
			textColor: Colors.black,
			onPressed: () {
				final Map<String, dynamic> product = {
					'title': _titleValue,
					'description': _descriptionValue,
					'price': _priceValue,
					'image': 'assets/food.jpg',
				};

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
