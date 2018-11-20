import 'package:flutter/material.dart';

import 'package:flutter_course/widgets/products/product_card.dart';

class Products extends StatelessWidget {
	final List<Map<String, dynamic>> _products;

	Products(this._products);

	/// Returns a ListView widget that contains Cards for each product.
	Widget _buildProductList() {
		Widget productCards = Center(child: Text('No products found'));

		if (_products.length > 0) {
			productCards = ListView.builder(
				itemBuilder: (BuildContext context, int index) => ProductCard(_products[index], index),
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
