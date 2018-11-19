import 'package:flutter/material.dart';

class Products extends StatelessWidget {
	final List<Map<String, dynamic>> _products;

	Products(this._products);

	Widget _buildProductItem(BuildContext context, int index) {
		return Card(
			child: Column(
				children: <Widget>[
					Image.asset(_products[index]['image']),
					Text(_products[index]['title']),
					ButtonBar(
						alignment: MainAxisAlignment.center,
						children: <Widget>[
							FlatButton(
								child: Text('Details'),
								onPressed: () => Navigator.pushNamed<bool>(
									context,
									'/product/' + index.toString()
								),
							)
						],
					),
				],
			),
		);
	}

	Widget _buildProductList() {
		Widget productCards = Center(child: Text('No products found'));

		if (_products.length > 0) {
			productCards = ListView.builder(
				itemBuilder: _buildProductItem,
				itemCount: _products.length,
			);
		} else {
			productCards = Container();
		}

		return productCards;
	}

	@override
	Widget build(BuildContext context) {
		return _buildProductList();
	}
}
