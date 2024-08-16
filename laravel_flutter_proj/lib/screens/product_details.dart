import 'package:card_swiper/card_swiper.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:laravel_flutter_proj/models/products_model.dart';
import 'package:laravel_flutter_proj/services/api_handler.dart';

import '../consts/global_colors.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  const ProductDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final titleStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  Future<ProductsModel> getproductdetails() async {
    try {
      ProductsModel productsModel =
          await ApiHandler.getProductById(id: widget.id);
      return productsModel;
    } catch (err) {
      showSnakBar(context, err.toString());
      throw err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ProductsModel>(
          future: getproductdetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text("No data"),
              );
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  const BackButton(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.category!.name.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Text(
                                snapshot.data!.title.toString(),
                                textAlign: TextAlign.start,
                                style: titleStyle,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: RichText(
                                text: TextSpan(
                                    text: '\$',
                                    style: const TextStyle(
                                        fontSize: 25,
                                        color: Color.fromRGBO(33, 150, 243, 1)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: snapshot.data!.price.toString(),
                                          style: TextStyle(
                                              color: lightTextColor,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.4,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return FancyShimmerImage(
                          width: double.infinity,
                          imageUrl: snapshot.data!.images![index].toString(),
                          boxFit: BoxFit.fill,
                        );
                      },

                      autoplay: true,
                      itemCount: 3,
                      pagination: const SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.white,
                          activeColor: Colors.red,
                        ),
                      ),
                      // control: const SwiperControl(),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description', style: titleStyle),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          snapshot.data!.description.toString(),
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
