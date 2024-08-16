import 'package:flutter/material.dart';
import 'package:laravel_flutter_proj/models/products_model.dart';
import 'package:laravel_flutter_proj/services/api_handler.dart';

import 'package:laravel_flutter_proj/widgets/feeds_widget.dart';
import 'package:provider/provider.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  // List<ProductsModel> products = [];
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getProducts();
  // }

  int limit = 10;
  bool isLoading = false;
  bool isEnd = false;
  ScrollController _scrollController = ScrollController();

  Future<List<ProductsModel>> getProducts() async {
    List<ProductsModel> products =
        await ApiHandler.getAllProduct(limit: limit.toString());
    return products;
  }

  @override
  void didChangeDependencies() {
    _scrollController.addListener(() async {
      if (limit == 200) {
        isEnd = true;
        setState(() {});
        return;
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        isLoading = true;

        limit += 10;

        await getProducts();
        isLoading = false;
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Latest Products"),
        ),
        body: FutureBuilder<List<ProductsModel>>(
            future: getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  isEnd != true) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: Text("No Data Found"),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              return GridView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: 0.7),
                  itemBuilder: (ctx, index) {
                    return ChangeNotifierProvider.value(
                        value: snapshot.data![index],
                        child: const FeedsWidget());
                  });
            }));
  }
}
