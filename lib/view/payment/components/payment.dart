import 'package:customer_ordering_frontend/model/entity/socketData.dart';
import 'package:customer_ordering_frontend/model/repository/socket_service.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import 'package:customer_ordering_frontend/model/entity/order.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../model/entity/orderItem.dart';
import '../../../model/entity/product.dart';
import '../../../view_model/orderItem_viewmodel.dart';
import '../../../view_model/order_viewmodel.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key? key}) : super(key: key);
  //var products = Get.arguments;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late List<Product> products = [
    Product(
      id: 20,
      title: " کباب",
      unitPrice: 100000.000,
      isAvailable: false,
      collectionId: 9,
      storeId: 4,
    ),
    Product(
      id: 19,
      title: " جوجه",
      unitPrice: 25000.000,
      isAvailable: false,
      collectionId: 9,
      storeId: 4,
    ),
    Product(
      id: 23,
      title: " پیتزا",
      unitPrice: 10000.000,
      isAvailable: true,
      collectionId: 12,
      storeId: 4,
    ),
    Product(
      id: 24,
      title: "اسنک",
      unitPrice: 120000.000,
      isAvailable: true,
      collectionId: 12,
      storeId: 4,
    ),
  ];
  late List<OrderItem> orderItems = [];
  late double sum;
  late double totalCost = 0;
  late String explainText = "";
  late int orderId;
  final _orderViewModel = OrderViewModel();
  final _orderItemViewModel = OrderItemViewModel();

  @override
  void initState() {
    //products = widget.products;
    sum = 0;
    for (var product in products) {
      product.priceCount = (product.quantity ?? 0) * product.unitPrice;
      sum += product.priceCount ?? 0;
    }
    totalCost = sum;
    // TODO put storeID in socket

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // TODO delete products List
          leading: BackButton(
            onPressed: () {
              // TODO back orderList
            },
          ),
          title: Center(
              child: Text(
            "سبد خرید",
            style: TextStyle(
              fontFamily: IranSansWeb,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          )),
          actions: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.delete),
              label: Text(''),
            ),
          ],
        ),
        body: ordering(),
      ),
    );
  }

  Widget ordering() {
    return ListView(
      children: [
        orderItemShow(),
        explain(),
        checkOut(),
        sendOrder(),
      ],
    );
  }

  Widget orderItemShow() {
    return Column(
      children: List.generate(
        products.length,
        (index) {
          final product = products[index];
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: EdgeInsets.only(top: 10, right: 30),
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
                        foodCounter(product, index),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                                "${product.unitPrice.round() ?? 0}"
                                    .toPersianDigit()
                                    .seRagham(),
                                style: TextStyle(
                                  fontFamily: IranSansWeb,
                                  fontSize: 20,
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
    );
  }

  Widget foodCounter(Product product, int index) {
    return Container(
      height: 100,
      width: 170,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        product.priceCount =
                            product.quantity * product.unitPrice;
                        sum = 0;
                        for (var item in products) {
                          sum += item.priceCount ?? 0;
                        }
                        totalCost = sum;
                        products[index].Quantity = product.quantity;
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
                '${product.quantity}'.seRagham(),
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
                    product.priceCount = product.quantity * product.unitPrice;
                    sum = 0;
                    for (var item in products) {
                      sum += item.priceCount ?? 0;
                    }
                    totalCost = sum;
                    products[index].Quantity = product.quantity;
                  },
                  child: Icon(
                    Icons.add,
                  ),
                  style: buttonStyle(5, 5, 10, RedColor),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                '${(product.priceCount?.round() ?? 0)}'
                    .toPersianDigit()
                    .seRagham(),
                style: TextStyle(fontFamily: IranSansWeb, fontSize: 22),
              ),
            ],
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

  Widget explain() {
    return Container(
      padding: EdgeInsets.only(top: 20, right: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BlackColor,
          ),
        ),
      ),
      height: 360,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "توضیحات",
                style: TextStyle(
                    fontFamily: IranSansWeb,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 300,
            height: 200,
            child: TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20.0),
                labelStyle: TextStyle(color: BlackColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: RedColor),
                ),
                hintText: 'توضیحات سفارش خود را اینجا بنویسید',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              style: TextStyle(
                color: BlackColor,
                fontFamily: IranSansWeb,
              ),
              onChanged: (value) {
                setState(() {
                  explainText = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget checkOut() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 100,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BlackColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "جمع کل :",
            style: TextStyle(
                fontFamily: IranSansWeb,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          Row(
            children: [
              Text(
                "${totalCost.round()}".toPersianDigit().seRagham(),
                style: TextStyle(fontFamily: IranSansWeb, fontSize: 26),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "تومان",
                style: TextStyle(
                  fontFamily: IranSansWeb,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sendOrder() {
    void sendOrders(SocketData socketData) {
      SocketService.sendOrder(socketData);
    }

    return Container(
      padding: EdgeInsets.only(
        top: 10,
        right: 100,
        left: 100,
        bottom: 10,
      ),
      child: ElevatedButton(
        onPressed: () {
          products.removeWhere((element) => element.quantity == 0);
          // TODO send total cost for payment
          // TODO get tableNumber and set
          // TODO product -> orderItem
          Order order =
              Order(store: 3, tableNumber: 77, description: explainText);
          _orderViewModel.addOrder(order).asStream().listen((event) async {
            orderId = event.id ?? 0;
            _addOrderItem(orderId);
          });
          SocketData socketData =
              SocketData(order: order, orderItem: orderItems);
          sendOrders(socketData);
        },
        child: Text(
          "ثبت سفارش",
          style: TextStyle(
            fontFamily: IranSansWeb,
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: WhiteColor,
          ),
        ),
      ),
    );
  }

  void _addOrderItem(int orderId) {
    int? product;
    String productTitle;
    double? productUnitPrice;
    int quantity;
    for (var item in products) {
      product = item.id;
      productTitle = item.title;
      productUnitPrice = item.unitPrice;
      quantity = item.quantity;
      OrderItem orderItem = OrderItem(
        product: product,
        quantity: quantity,
        order: orderId,
        productTitle: productTitle,
        productUnitPrice: productUnitPrice,
      );
      _orderItemViewModel
          .addOrderItem(orderItem)
          .asStream()
          .listen((event) async {});
      orderItems.add(orderItem);
    }
    print("mission complete");

    // products.clear();
    //Get.toNamed(SuccessfulPage,);
  }
}
