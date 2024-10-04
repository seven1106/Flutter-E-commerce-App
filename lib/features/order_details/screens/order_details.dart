import 'dart:developer';

import 'package:emigo/features/product/services/product_services.dart';
import 'package:emigo/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/common/custom_button.dart';
import '../../../models/product_model.dart';
import '../../../models/voucher.dart';
import '../../../providers/user_provider.dart';
import '../../notification/services/notification_services.dart';
import '../../search/screen/search_screen.dart';
import '../../vendor/services/vendor_services.dart';
import '../../vendor/services/voucher_service.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final OrderModel order;
  const OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  final VendorServices vendorServices = VendorServices();
  final ProductServices productServices = ProductServices();
  final NotificationServices notificationServices = NotificationServices();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  final TextEditingController reasonController = TextEditingController();
  List<VoucherModel>? vouchers;
  String? selectedVoucher;
  double discount = 0;
  final VoucherServices voucherServices = VoucherServices();
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
    fetchVouchers();
    selectedVoucher = widget.order.voucherCode;
    isLoaded = true;
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  void changeOrderStatus(int status, String message) {
    vendorServices.changeOrderStatus(
      context: context,
      status: status + 1,
      order: widget.order,
      message: message,
      onSuccess: () {
        setState(() {
          currentStep = status + 1;
          log('Order status changed to $currentStep');
        });
        vendorServices.fetchAllOrders(context);
      },
    );
  }

  void fetchVouchers() async {
    vouchers = await voucherServices.fetchAllVouchers(context);
    setState(() {});
  }

  void showRatingDialog(BuildContext context, String? id) async {
    double rating = 0;
    ProductModel product =
        await vendorServices.fetchProductById(context: context, id: id);
    final TextEditingController commentController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool hasRated = false;
    if (product.ratings.any((r) => r.userId == userProvider.user.id)) {
      final userRating =
          product.ratings.firstWhere((r) => r.userId == userProvider.user.id);
      rating = userRating.rating;
      commentController.text = userRating.comment;
      hasRated = true;
      log('User has rated this product');
    }
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            hasRated ? 'Edit Your Review' : 'Write a Review',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Overall Rating',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Write your review',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'What did you like or dislike?',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                if (rating > 0 && commentController.text.isNotEmpty) {
                  productServices.rateProduct(
                    context: context,
                    product: product,
                    rating: rating,
                    comment: commentController.text,
                  );
                  notificationServices.createNotification(
                    context: context,
                    title: '${userProvider.user.name} has rated your product',
                    content:
                        'Rating: $rating, Comment: ${commentController.text}',
                    type: 'rating',
                    orderId: product.id,
                    receiverId: product.sellerId,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Review submitted successfully')),
                  );
                } else {
                  // Show error message if rating or comment is missing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please provide both rating and review')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
              child: Text(hasRated == true ? 'Save' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate discount based on selected voucher
    if (widget.order.voucherCode != '') {
      selectedVoucher = widget.order.voucherCode;
      if (selectedVoucher != null && vouchers != null) {
        final voucher = vouchers!.firstWhere((v) => v.code == selectedVoucher);
        if (voucher.discountType == 'percentage') {
          discount = widget.order.initialPrice * (voucher.discountValue / 100);
        } else {
          discount = voucher.discountValue;
        }
      }
    }
    final user = Provider.of<UserProvider>(context).user;

    return isLoaded
        ? Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(),
                ),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await vendorServices.fetchAllOrders(context);
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'View order details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order Date:      ${DateFormat().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.order.orderedAt),
                            )}'),
                            Text('Order ID:          ${widget.order.id}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Receiver Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Receiver Name:      ${widget.order.receiverName}'),
                            Text(
                                'Receiver Phone:     ${widget.order.receiverPhone}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Payment Method: ${widget.order.paymentMethod}'),
                            Text(
                                'Subtotal:      \$${widget.order.initialPrice}'),
                            Text(
                                'Discount:      -\$${discount.toStringAsFixed(2)}'),
                            const Text('Shipping: Free'),
                            const Text('Tax:      \$0.00'),
                            const Divider(),
                            Text(
                                'Total:      ${widget.order.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Purchase Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ListView.builder(
                              itemCount: widget.order.products.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/product-details',
                                      arguments: widget.order.products[index],
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image.network(
                                        widget.order.products[index].images[0],
                                        height: 120,
                                        width: 120,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.order.products[index].name,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Qty: ${widget.order.quantity[index]}',
                                            ),
                                            Text(
                                              'Price: \$${widget.order.products[index].discountPrice}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tracking',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                        ),
                        child: Stepper(
                          currentStep: currentStep,
                          controlsBuilder: (context, details) {
                            if (user.type == 'vendor' && currentStep == 0) {
                              return Column(
                                children: [
                                  CustomButton(
                                    text: 'Confirm',
                                    onTap: () {
                                      changeOrderStatus(details.currentStep,
                                          'Order confirmed');
                                      notificationServices.createNotification(
                                        context: context,
                                        title: 'Order Confirmed',
                                        content:
                                            'This order has been confirmed',
                                        type: 'order',
                                        orderId: widget.order.id,
                                        receiverId: widget.order.userId,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  CustomButton(
                                    text: 'Cancel',
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Cancel Order'),
                                              content: TextField(
                                                controller: reasonController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Enter reason here',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    changeOrderStatus(3,
                                                        reasonController.text);
                                                    notificationServices
                                                        .createNotification(
                                                      context: context,
                                                      title:
                                                          'This order has been cancelled',
                                                      content:
                                                          'Reason: ${reasonController.text}',
                                                      type: 'order',
                                                      orderId: widget.order.id,
                                                      receiverId:
                                                          widget.order.userId,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red,
                                                    onPrimary: Colors.white,
                                                  ),
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ],
                              );
                            }
                            if (user.type == 'vendor' && currentStep == 1) {
                              return CustomButton(
                                text: 'Delivered',
                                onTap: () {
                                  changeOrderStatus(
                                      details.currentStep, 'Order delivered');
                                  notificationServices.createNotification(
                                    context: context,
                                    title: 'Order Delivered',
                                    content: 'This order is on the way',
                                    type: 'order',
                                    orderId: widget.order.id,
                                    receiverId: widget.order.userId,
                                  );
                                },
                              );
                            }
                            if (user.type == 'user' && currentStep == 2) {
                              return CustomButton(
                                text: 'Received',
                                onTap: () => changeOrderStatus(
                                    details.currentStep, 'Order received'),
                              );
                            }
                            if (user.type == 'user' && currentStep == 3) {
                              return CustomButton(
                                text: 'Rate the product',
                                onTap: () {
                                  for (int i = 0;
                                      i < widget.order.products.length;
                                      i++) {
                                    showRatingDialog(
                                        context, widget.order.products[i].id);
                                  }
                                },
                              );
                            }
                            return const SizedBox();
                          },
                          steps: [
                            Step(
                              title: const Text('Pending'),
                              content: const Text(
                                'This order is pending confirmation',
                              ),
                              isActive: currentStep == 0,
                              state: currentStep == 0
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Delivering'),
                              content: user.type == 'vendor'
                                  ? const Text(
                                      'Deliver the order to the customer',
                                    )
                                  : const Text(
                                      'Your order is being delivered',
                                    ),
                              isActive: currentStep == 1,
                              state: currentStep == 1
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Delivered'),
                              content: const Text(
                                'This order has been delivered',
                              ),
                              isActive: currentStep == 2,
                              state: currentStep == 2
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Completed'),
                              content: const Text(
                                'This order has been delivered and signed!',
                              ),
                              isActive: currentStep == 3,
                              state: currentStep == 3
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Cancelled'),
                              content: Text(
                                'This order has been cancelled \n Reason: ${widget.order.description}',
                              ),
                              isActive: currentStep == 4,
                              state: currentStep == 4
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
