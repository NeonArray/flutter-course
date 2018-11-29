import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/scoped_models/main.dart';
import 'package:flutter_course/widgets/products/products.dart';
import 'package:flutter_course/widgets/ui/logout_list_tile.dart';


class ProductsPage extends StatefulWidget {
	final MainModel model;

	ProductsPage(this.model);

	State<StatefulWidget> createState() {
		return _ProductsPageState();
	}
}


class _ProductsPageState extends State<ProductsPage> {

	@override
	initState() {
		widget.model.fetchProducts();
		super.initState();
	}


	Drawer _buildDrawer(BuildContext context) {
		return Drawer(
			child: Column(
				children: <Widget>[
					AppBar(
						automaticallyImplyLeading: false,
						title: Text('Choose'),
					),
					ListTile(
						leading: Icon(Icons.edit),
						title: Text('Manage Products'),
						onTap: () {
							Navigator.pushReplacementNamed(context, '/admin');
						},
					),
					Divider(),
					LogoutListTile(),
				],
			),
		);
	}


	Widget _buildProductsList() {
		return ScopedModelDescendant(
			builder: (BuildContext context, Widget child, MainModel model) {
				Widget content = Center(child: Text('No Products Found'));

				if (model.displayedProducts.length > 0 && !model.isLoading) {
					content = Products();
				} else if (model.isLoading) {
					content = Center(child: CircularProgressIndicator());
				}

				return RefreshIndicator(
					child: content,
					onRefresh: model.fetchProducts,
				);
			}
		);
	}


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			drawer: _buildDrawer(context),
			appBar: AppBar(
				title: Text('EasyList'),
				actions: <Widget>[
					ScopedModelDescendant<MainModel>(
					  	builder: (BuildContext context, Widget child, MainModel model) {
					  		final IconData icon = model.displayFavoritesOnly ? Icons.favorite : Icons.favorite_border;

							return IconButton(
								icon: Icon(icon),
								onPressed: () {
									model.toggleDisplayMode();
								},
							);
						},
					),
				],
			),
			body: _buildProductsList(),
		);
	}
}
