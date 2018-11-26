import 'package:flutter/material.dart';

import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';
import 'package:flutter_course/widgets/ui/title_default.dart';
import 'package:flutter_course/models/product.dart';

class ProductCard extends StatelessWidget {
	final Product product;
	final int productIndex;

	ProductCard(this.product, this.productIndex);

	Widget _buildTitlePriceRow() {
		return Container(
			padding: EdgeInsets.all(10.0),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: <Widget>[
					Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: <Widget>[
							TitleDefault(product.title),
							AddressTag('Union Square, San Francisco'),
						],
					),
					SizedBox(
						width: 8.0,
					),
					PriceTag(product.price.toString()),
				],
			)
		);
	}

	Widget _buildActionButtons(BuildContext context) {
		return ButtonBar(
			alignment: MainAxisAlignment.center,
			children: <Widget>[
				IconButton(
					color: Colors.grey,
					icon: Icon(Icons.info),
					onPressed: () => Navigator.pushNamed<bool>(
						context,
						'/product/' + productIndex.toString()
					),
				),
				IconButton(
					color: Colors.red,
					icon: Icon(Icons.favorite_border),
					onPressed: () {},
				),
			],
		);
	}

	@override
	Widget build(BuildContext context) {
		return Card(
			child: Column(
				children: <Widget>[
					Image.asset(product.image),
					_buildTitlePriceRow(),
					_buildActionButtons(context),
				],
			),
		);
	}
}