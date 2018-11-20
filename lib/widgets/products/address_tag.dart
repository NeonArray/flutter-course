import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
	final String address;

	AddressTag(this.address);

	@override
	Widget build(BuildContext context) {
		return Text(
			address,
			style: TextStyle(
				color: Colors.grey,
				fontFamily: 'Oswald',
			),
		);
	}
}