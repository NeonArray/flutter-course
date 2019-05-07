import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:flutter_course/widgets/helpers/ensure_visible.dart';


class LocationInput extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _LocationInputState();
	}
}


class _LocationInputState extends State<LocationInput> {
	final FocusNode _addressInputFocusNode = FocusNode();


	Future<void> getStaticMap() async {

	}


	@override
	void initState() {
		_addressInputFocusNode.addListener(_updateLocation);
		super.initState();
	}


	@override
	void dispose() {
		_addressInputFocusNode.removeListener(_updateLocation);
		super.dispose();
	}


	void _updateLocation() {

	}


	@override
	Widget build(BuildContext context) {
		return Column(
			children: <Widget>[
				EnsureVisibleWhenFocused(
					focusNode: _addressInputFocusNode,
					child: TextFormField(
						focusNode: _addressInputFocusNode,
					),
				),
				SizedBox(height: 30.0),
				Image.network(),
			],
		);
	}
}