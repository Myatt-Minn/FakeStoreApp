import 'package:flutter/material.dart';
import 'package:laravel_flutter_proj/models/products_model.dart';
import 'package:provider/provider.dart';

import 'feeds_widget.dart';

class FeedsGridWidget extends StatelessWidget {
  final List<ProductsModel> products;
  const FeedsGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 0.0,
            childAspectRatio: 0.7),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
              value: products[index], child: const FeedsWidget());
        });
  }
}
