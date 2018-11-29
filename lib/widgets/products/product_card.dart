import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_course/scoped_models/main.dart';
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
							Text(product.userEmail),
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
		return ScopedModelDescendant<MainModel>(
			builder: (BuildContext context, Widget child, MainModel model) {
				final IconData icon = model.allProducts[productIndex].isFavorite ? Icons.favorite : Icons.favorite_border;

				return ButtonBar(
					alignment: MainAxisAlignment.center,
					children: <Widget>[
						IconButton(
							color: Colors.grey,
							icon: Icon(Icons.info),
							onPressed: () {
								Navigator.pushNamed<bool>(context,
									'/product/' + model.allProducts[productIndex].id,
								);
							},
						),
						IconButton(
							color: Colors.red,
							icon: Icon(icon),
							onPressed: () {
								model.selectProduct(model.allProducts[productIndex].id);
								model.toggleProductFavoriteStatus();
							},
						),
					],
				);
			}
		);
	}


	@override
	Widget build(BuildContext context) {
		return Card(
			child: Column(
				children: <Widget>[
					FadeInImage(
						placeholder: AssetImage('assets/food.jpg'),
						height: 300.0,
						fit: BoxFit.cover,
						image: NetworkImage(product.image),
					),
					_buildTitlePriceRow(),
					_buildActionButtons(context),
				],
			),
		);
	}
}