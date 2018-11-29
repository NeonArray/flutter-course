import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/pages/auth.dart';
import 'package:flutter_course/pages/products_admin.dart';
import 'package:flutter_course/pages/products.dart';
import 'package:flutter_course/pages/product.dart';
import 'package:flutter_course/scoped_models/main.dart';
import 'package:flutter_course/models/product.dart';


void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
	@override
	_MyAppState createState() => new _MyAppState();
}


class _MyAppState extends State<MyApp> {
	final MainModel _model = MainModel();
	bool _isAuthenticated = false;


	@override
	void initState() {
		_model.autoAuthenticate();
		_model.userSubject.listen((bool isAuthenticated) {
			setState(() {
				_isAuthenticated = isAuthenticated;
			});
		});
		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		return ScopedModel<MainModel>(
			model: _model,
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
					'/': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),
					'/admin': (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
				},
				// This property allows us to use 'dynamic' named routes. Think of them as '/route/:id'
				// These routes are supplemental to the routes property/values as any routes that are hit
				// that aren't in routes, go to this function
				onGenerateRoute: (RouteSettings settings) {
					if (!_isAuthenticated) {
						return MaterialPageRoute(
							builder: (BuildContext context) => AuthPage(),
						);
					}
					final List<String> pathElements = settings.name.split('/');

					if (pathElements[0] != '') {
						return null;
					}

					if (pathElements[1] == 'product') {
						String productId = pathElements[2];

						final Product product = _model.allProducts.firstWhere((Product product) {
							return product.id == productId;
						});

						_model.selectProduct(productId);

						return MaterialPageRoute<bool>(
							builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductPage(product),
						);
					}

					return null;
				},
				// Executes whenever onGenerateRoute fails to generate a route which will happen if
				// the "null" is returned from onGenerateRoute.
				onUnknownRoute: (RouteSettings settings) {
					return MaterialPageRoute(
						builder: (BuildContext context) => !_isAuthenticated ? AuthPage() : ProductsPage(_model),
					);
				},
			)
		);
	}
}

