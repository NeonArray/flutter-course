import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped_models/products.dart';
import 'package:flutter_course/widgets/ui/title_default.dart';
import 'package:flutter_course/widgets/products/address_tag.dart';

class ProductPage extends StatelessWidget {
	final int productIndex;

	ProductPage(this.productIndex);

	Widget _buildAddressPriceRow(double price) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.center,
			children: <Widget>[
				AddressTag('Union Square San Francisco, CA'),
				Container(
					child: Text(
						'|',
						style: TextStyle(
							color: Colors.grey,
						),
					),
					margin: EdgeInsets.symmetric(horizontal: 5.0),
				),
				Text(
					'\$${price.toString()}',
					style: TextStyle(
						color: Colors.grey,
						fontFamily: 'Oswald',
					),
				),
			],
		);
	}


	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () {
				Navigator.pop(context, false);
				return Future.value(false);
			},
			child: ScopedModelDescendant<ProductsModel>(
				builder: (BuildContext context, Widget widget, ProductsModel model) {
					final Product product = model.products[productIndex];

					return Scaffold(
						appBar: AppBar(
							title: Text('Product Details'),
						),
						body: Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							children: <Widget>[
								Image.asset(product.image),
								Container(
									padding: EdgeInsets.all(10.0),
									child: TitleDefault(product.title),
								),
								_buildAddressPriceRow(product.price),
								Container(
									padding: EdgeInsets.all(10.0),
									child: Text(
										product.description,
										textAlign: TextAlign.center,
									),
								),
							],
						),
					);
				},
			),
		);
	}
}