import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/scoped_models/products.dart';
import 'package:flutter_course/pages/auth.dart';
import 'package:flutter_course/pages/products_admin.dart';
import 'package:flutter_course/pages/products.dart';
import 'package:flutter_course/pages/product.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
	@override
	_MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

	@override
	Widget build(BuildContext context) {
		return ScopedModel<ProductsModel>(
			model: ProductsModel(),
			child: MaterialApp(
				theme: ThemeData(
					brightness: Brightness.light,
					primarySwatch: Colors.teal,
					accentColor: Colors.grey,
					buttonColor: Colors.deepPurple,
				),
				routes: {
					// The '/' is a special route that Flutter uses to show as the 'home' screen.
					// you CANNOT use both the home: property in MaterialApp as well as this '/' route
					// or it will throw an error. Use one or the other.
					'/': (BuildContext context) => AuthPage(),
					'/products': (BuildContext context) => ProductsPage(model),
					'/admin': (BuildContext context) => ProductsAdminPage(model),
				},
				// This property allows us to use 'dynamic' named routes. Think of them as '/route/:id'
				// These routes are supplemental to the routes property/values as any routes that are hit
				// that aren't in routes, go to this function
				onGenerateRoute: (RouteSettings settings) {
					final List<String> pathElements = settings.name.split('/');

					if (pathElements[0] != '') {
						return null;
					}

					if (pathElements[1] == 'product') {
						final int index = int.parse(pathElements[2]);

						return MaterialPageRoute<bool>(
							builder: (BuildContext context) => ProductPage(index),
						);
					}

					return null;
				},
				// Executes whenever onGenerateRoute fails to generate a route which will happen if
				// the "null" is returned from onGenerateRoute.
				onUnknownRoute: (RouteSettings settings) {
					return MaterialPageRoute(
						builder: (BuildContext context) => ProductsPage(),
					);
				},
			)
		);
	}
}

