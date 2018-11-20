import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/ui/title_default.dart';
import '../widgets/products/address_tag.dart';

class ProductPage extends StatelessWidget {
	final String title;
	final String imageUrl;
	final double price;
	final String description;

	ProductPage(this.title, this.imageUrl, this.price, this.description);

	Widget _buildAddressPriceRow() {
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
			child: Scaffold(
				appBar: AppBar(
					title: Text('Product Details'),
				),
				body: Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						Image.asset(imageUrl),
						Container(
							padding: EdgeInsets.all(10.0),
							child: TitleDefault(title),
						),
						_buildAddressPriceRow(),
						Container(
							padding: EdgeInsets.all(10.0),
							child: Text(
								description,
								textAlign: TextAlign.center,
							),
						),
					],
				),
			),
		);
	}
}