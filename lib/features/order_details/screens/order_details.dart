
import 'dart:developer';

import 'package:emigo/features/product/services/product_services.dart';
import 'package:emigo/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../core/common/custom_button.dart';
import '../../../models/product_model.dart';
import '../../../providers/user_provider.dart';
import '../../search/screen/search_screen.dart';
import '../../vendor/services/vendor_services.dart';

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

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();
    currentStep = widget.order.status;
  }
  void changeOrderStatus(int status) {
    vendorServices.changeOrderStatus(
      context: context,
      status: status + 1,
      order: widget.order,
      onSuccess: () {
        setState(() {
          currentStep += 1;
        });
      },
    );
  }

  void showRatingDialog(BuildContext context, ProductModel product) {
    double rating = 0;
    final TextEditingController commentController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool hasRated = false;
    if (product.ratings.any((r) => r.userId == userProvider.user.id)) {
      final userRating = product.ratings.firstWhere((r) => r.userId == userProvider.user.id);
      rating = userRating.rating;
      commentController.text = userRating.comment;
      hasRated = true;
      log('User has rated this product');
    }
    log(product.ratings.toString());
    log(userProvider.user.id  );


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
                // const SizedBox(height: 20),
                // Text(
                //   'Add a photo or video',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 10),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     // Implement image/video upload functionality
                //   },
                //   icon: Icon(Icons.add_a_photo),
                //   label: Text('Add Photos/Videos'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.grey[200],
                //     onPrimary: Colors.black,
                //   ),
                // ),
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
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
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
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Review submitted successfully')),
                  );
                } else {
                  // Show error message if rating or comment is missing
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide both rating and review')),
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
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    Text('Order Total:      \$${widget.order.totalPrice}'),
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
                    for (int i = 0; i < widget.order.products.length; i++)
                      Row(
                        children: [
                          Image.network(
                            widget.order.products[i].images[0],
                            height: 120,
                            width: 120,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.products[i].name,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: ${widget.order.quantity[i]}',
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      return CustomButton(
                        text: 'Confirm',
                        onTap: () => changeOrderStatus(details.currentStep),
                      );
                    }
                    if (user.type == 'vendor' && currentStep == 1) {
                      return CustomButton(
                        text: 'Delivered',
                        onTap: () => changeOrderStatus(details.currentStep),
                      );
                    }
                    if (user.type == 'user' && currentStep == 2) {
                      return CustomButton(
                        text: 'Received',
                        onTap: () => changeOrderStatus(details.currentStep),
                      );
                    }
                    if(user.type == 'user' && currentStep == 3) {
                      return CustomButton(
                        text: 'Rate the product',
                        onTap: () {
                          showRatingDialog(
                            context,
                            widget.order.products[0],
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                  steps: [
                    Step(
                      title: const Text('Pending'),
                      content: const Text(
                        'Your order is pending confirmation',
                      ),
                      isActive: currentStep > 0,
                      state: currentStep > 0
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
                      isActive: currentStep > 1,
                      state: currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Delivered'),
                      content: const Text(
                        'Your order has been delivered',
                      ),
                      isActive: currentStep > 2,
                      state: currentStep > 2
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Completed'),
                      content: const Text(
                        'Your order has been delivered and signed!',
                      ),
                      isActive: currentStep >= 3,
                      state: currentStep >= 3
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

    );
  }
}
