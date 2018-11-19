import 'package:flutter/material.dart';

import './pages/product.dart';

class Products extends StatelessWidget {
	final List<String> _products;

	Products([this._products = const []]);

	Widget _buildProductItem(BuildContext context, int index) {
		return Card(
			child: Column(
				children: <Widget>[
					Image.asset('assets/food.jpg'),
					Text(_products[index]),
					ButtonBar(
						alignment: MainAxisAlignment.center,
						children: <Widget>[
							FlatButton(
								child: Text('Details'),
								onPressed: () => Navigator.push(context, MaterialPageRoute(
									builder: (BuildContext context) => ProductPage(),
								)),
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
