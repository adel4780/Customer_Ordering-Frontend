import 'package:cached_network_image/cached_network_image.dart';
import 'package:customer_ordering_frontend/view/search.dart';
import 'package:customer_ordering_frontend/view/serach1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../model/entity/Rating.dart';
import '../model/entity/collection.dart';
import '../model/entity/product.dart';
import '../utils/constants.dart';
import '../view_model/collection_view_model.dart';
import '../view_model/rating_view_model.dart';

List<Collection> searchCollection = [];
List<Product> searchProduct = [];
List<Rating> searchRating = [];

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  late int _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();

  // TODO initial storeId
  late int storeId;
  final List<Collection> collections = [
    Collection(
      id: 1,
      title: 'ایرانی',
      storeId: 1,
      products: [
        Product(
          id: 1,
          title: 'آش',
          unitPrice: 20000,
          isAvailable: true,
          collectionId: 1,
          storeId: 1,
          description:
              'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است،',
        ),
        Product(
          id: 2,
          title: 'کباب',
          unitPrice: 20000,
          isAvailable: true,
          collectionId: 1,
          storeId: 1,
          description: 'خوشمزه است',
        ),
        Product(
          id: 3,
          title: 'حلیم',
          unitPrice: 20000,
          isAvailable: true,
          collectionId: 1,
          storeId: 1,
          description: 'خوشمزه است',
        ),
      ],
    ),
    Collection(id: 2, title: 'فست فود', storeId: 1, products: [
      Product(
        id: 4,
        title: 'پیتزا',
        unitPrice: 20000,
        isAvailable: true,
        collectionId: 2,
        storeId: 1,
        description: 'خوشمزه است',
      ),
      Product(
        id: 5,
        title: 'اسنک',
        unitPrice: 20000,
        isAvailable: true,
        collectionId: 2,
        storeId: 1,
        description: 'خوشمزه است',
      ),
    ]),
  ];
  late List<Product> products = [];
  late List<Product> orderProducts = [];
  late List<Product> totalProducts = [];
  final List<Rating> _rates = [
    Rating(product: 1, score: 4),
    Rating(product: 2, score: 5),
    Rating(product: 3, score: 3),
    Rating(product: 4, score: 1),
    Rating(product: 5, score: 2),
  ];
  final _collectionViewModel = CollectionViewModel();
  final _ratingViewModel = RatingViewModel();

  // TODO false
  var _gotFromServer = true;

  @override
  void initState() {
    _selectedCategoryId = collections[0].id ?? 0;
    //loadFood();
    //getRate();
    for (var collection in collections) {
      for (var product in collection.products!) {
        products.add(product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_gotFromServer
        ? loading()
        : Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 24,
                        color: BlackColor,
                      ),
                      onPressed: () {
                        searchProduct = products;
                        searchRating = _rates;
                        // Get.toNamed(SearchPage);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPagee(
                              products: products,
                              onSearch: (List<Product> results) {
                                setState(() {
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  SizedBox(width: 5),
                  SizedBox(
                      height: 35,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: categoryBuild()),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: productsList(),
              ),
            ],
          );
  }

  Widget categoryBuild() {
    return ListView.builder(
      itemCount: collections.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedCategoryId = collections[index].id!;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: EdgeInsets.only(left: 10),
            width: 100,
            decoration: BoxDecoration(
              color: _selectedCategoryId == collections[index].id
                  ? RedColor
                  : WhiteColor,
              border: Border.all(color: BlackColor),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                collections[index].title,
                style: TextStyle(
                  color: _selectedCategoryId == collections[index].id
                      ? WhiteColor
                      : RedColor,
                  height: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget productsList() {
    return ListView(
      children: [
        Column(
          children: List.generate(
            collections[_selectedCategoryId - 1].products!.length,
            (index) {
              final product =
                  collections[_selectedCategoryId - 1].products![index];
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: EdgeInsets.only(top: 10, right: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: BlackColor,
                      ),
                    ),
                  ),
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 150,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CachedNetworkImage(
                                imageUrl: "",
                                width: 100,
                                height: 100,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  EmptyImg,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                            foodCounter(product),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${_rates[index].score}"
                                            .toPersianDigit(),
                                        style: TextStyle(
                                          color: BlackColor,
                                          fontFamily: IranSansWeb,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.star_border,
                                          color: YellowColor,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  product.title,
                                  style: TextStyle(
                                      fontFamily: IranSansWeb,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                (product.description!),
                                style: TextStyle(
                                  fontFamily: IranSansWeb,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "تومان",
                                    style: TextStyle(
                                      fontFamily: IranSansWeb,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${product.unitPrice}".toPersianDigit(),
                                    style: TextStyle(
                                      fontFamily: IranSansWeb,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 50,
          width: 5,
          child: ElevatedButton(
            onPressed: () {
              for (var product in products) {
                orderProducts.add(product);
              }
              orderProducts.removeWhere((element) => element.quantity == 0);
              totalProducts = orderProducts;
              //totalProducts.forEach((element) {print("${element.title}\t${element.quantity}");});
              orderProducts.clear();
              //Get.toNamed(PaymentPage, arguments: totalProducts);
              // print
            },
            child: Text(
              "تکمیل خرید",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: IranSansWeb,
                  fontWeight: FontWeight.bold),
            ),
            style: buttonStyle_build(5, 5, 10, RedColor),
          ),
        ),
      ],
    );
  }

  Widget foodCounter(Product product) {
    return Container(
      height: 40,
      width: 170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    if (product.quantity > 0) {
                      product.quantity--;
                    }
                    for (var element in products) {
                      if (element.id == product.id) {
                        products[products.indexOf(element)].Quantity =
                            product.quantity;
                      }
                    }
                  },
                );
              },
              style: buttonStyle(5, 5, 10, WhiteColor),
              child: Icon(
                Icons.remove,
                color: BlackColor,
              ),
            ),
          ),
          Text(
            '${product.quantity}'.toPersianDigit(),
            style: TextStyle(fontFamily: IranSansWeb, fontSize: 24),
          ),
          SizedBox(
            width: 36,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                setState(
                  () {
                    product.quantity++;
                  },
                );
                for (var element in products) {
                  if (element.id == product.id) {
                    products[products.indexOf(element)].Quantity =
                        product.quantity;
                  }
                }
              },
              style: buttonStyle(5, 5, 10, RedColor),
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle buttonStyle(
      double width, double height, double radius, Color color) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(color),
      elevation: MaterialStateProperty.all<double>(0.0),
      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
      fixedSize: MaterialStateProperty.all<Size>(
        Size(width, height),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: BlackColor),
        ),
      ),
    );
  }

  void loadFood() {
    var storeId = 1;
    _collectionViewModel.getCollections(storeId);
    _collectionViewModel.getProducts(storeId);
    _collectionViewModel.collections.stream.listen((listCollections) {
      _collectionViewModel.products.stream.listen((listProducts) {
        setState(() {
          _gotFromServer = true;
          collections.addAll(listCollections);
          for (var collection in collections) {
            collection.products = [];
            for (var product in listProducts) {
              if (product.collectionId == collection.id) {
                collection.products!.add(product);
              }
            }
          }
        });
      });
    });
  }

  void getRate() {
    for (var product in products) {
      _ratingViewModel.getRatings(product.id!);
      _ratingViewModel.ratings.stream.listen(
        (list) async {
          setState(() {
            _gotFromServer = true;
            for (var rating in list) {
              _rates.add(rating as Rating);
            }
          });
        },
      );
    }
  }
}
