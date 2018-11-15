import 'package:flutter/material.dart';

class Products extends StatelessWidget {
	final List<String> _products;

	Products([this._products = const []]);

	Widget _buildProductItem(BuildContext context, int index) {
		return Card(
			child: Column(
				children: <Widget>[
					Image.asset('assets/food.jpg'),
					Text(_products[index]),
				],
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			itemBuilder: _buildProductItem,
			itemCount: _products.length,
		);
	}
}
