import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/products/product_card.dart';
import 'package:flutter_course/scoped_models/products.dart';

class Products extends StatelessWidget {

	/// Returns a ListView widget that contains Cards for each product.
	Widget _buildProductList(List<Product> products) {
		Widget productCards = Center(child: Text('No products found'));

		if (products.length > 0) {
			productCards = ListView.builder(
				itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
				itemCount: products.length,
			);
		} else {
			productCards = Container();
		}

		return productCards;
	}

	@override
	Widget build(BuildContext context) {
		return ScopedModelDescendant<ProductsModel>(
			builder: (BuildContext context, Widget child, ProductsModel model) {
				return _buildProductList(model.products);
			},
		);
	}
}
