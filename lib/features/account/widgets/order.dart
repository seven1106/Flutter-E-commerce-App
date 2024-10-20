import 'package:emigo/models/order.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/loader.dart';
import '../../order_details/screens/order_details.dart';
import '../../vendor/screens/orders_screen.dart';
import '../services/account_service.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<OrderModel>? orders;
  final AccountService accountServices = AccountService();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Orders',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          OrdersScreen.routeName,
                        );
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildOrderStatusCard('Pending', Icons.content_paste_go,
                        orders!.where((order) => order.status == 0).length),
                    _buildOrderStatusCard('Shipping', Icons.local_shipping,
                        orders!.where((order) => order.status == 1).length),
                    _buildOrderStatusCard('To Review', Icons.rate_review,
                        orders!.where((order) => order.status == 2 | 3).length),
                    _buildOrderStatusCard('Cancelled', Icons.cancel,
                        orders!.where((order) => order.status == 4).length),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders!.length > 3 ? 3 : orders!.length,
                itemBuilder: (context, index) {
                  final order = orders![index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        order.products[0].images[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text('Order #${order.id}'),
                    subtitle: order.status == 0
                        ? const Text('Status: Pending')
                        : order.status == 1
                            ? const Text('Status: Shipping')
                            : order.status == 2
                                ? const Text('Status: Delivered')
                                : const Text('Status: Received'),
                    trailing: Text('\$${order.totalPrice.toStringAsFixed(2)}'),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        OrderDetailScreen.routeName,
                        arguments: order,
                      );
                    },
                  );
                },
              ),
            ],
          );
  }

  Widget _buildOrderStatusCard(String title, IconData icon, int count) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Theme.of(context).primaryColor),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12)),
          Text(count.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
