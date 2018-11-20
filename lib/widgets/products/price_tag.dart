import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
	final String _price;

	PriceTag(this._price);

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				color: Theme.of(context).primaryColor,
				borderRadius: BorderRadius.circular(6.0),
			),
			padding: EdgeInsets.symmetric(
				horizontal: 10.0,
				vertical: 8.0,
			),
			child: Text(
				'\$' + _price,
				style: TextStyle(
					color: Colors.white,
				),
			),
		);
	}
}