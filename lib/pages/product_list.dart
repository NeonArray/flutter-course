import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/scoped_models/products.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/pages/product_edit.dart';

class ProductListPage extends StatelessWidget {

	ListTile _buildListItem(BuildContext context, int index, ProductsModel model) {
		return ListTile(
			leading: CircleAvatar(
				backgroundImage: AssetImage(model.products[index].image),
			),
			title: Text(model.products[index].title),
			subtitle: Text('\$${model.products[index].price.toString()}'),
			trailing: _buildEditButton(context, index, model),
		);
	}


	Widget _buildEditButton(BuildContext context, int index, ProductsModel model) {
		return IconButton(
			icon: Icon(Icons.edit),
			onPressed: () {
				model.selectProduct(index);
				Navigator.of(context).push(MaterialPageRoute(
					builder: (BuildContext context) {
						return ProductEditPage();
					}
				));
			},
		);
	}


	@override
	Widget build(BuildContext context) {
		return ScopedModelDescendant<ProductsModel>(
			builder: (BuildContext context, Widget child, ProductsModel model) {
				return ListView.builder(
					itemBuilder: (BuildContext context, int index) {
						return Dismissible(
							onDismissed: (DismissDirection direction) {
								if (direction == DismissDirection.endToStart) {
									model.selectProduct(index);
									model.deleteProduct();
								}
							},
							background: Container(
								color: Colors.red,
							),
							key: Key(model.products[index].title),
							child: Column(
								children: <Widget>[
									_buildListItem(context, index, model),
									Divider(),
								],
							),
						);
					},
					itemCount: model.products.length,
				);
			},
		);
	}
}
