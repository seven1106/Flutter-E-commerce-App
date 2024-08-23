import 'package:emigo/models/order.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/loader.dart';
import '../../order_details/screens/order_details.dart';
import '../services/vendor_services.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const String routeName = '/order-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  List<OrderModel>? orders;
  final VendorServices adminServices = VendorServices();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'To Ship'),
            Tab(text: 'To Receive'),
            Tab(text: 'To Review'),
            Tab(text: 'Returns'),
          ],
        ),
      ),
      body: orders == null
          ? const Loader()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(orders!),
                _buildOrderList(
                    orders!.where((order) => order.status == 0).toList()),
                _buildOrderList(
                    orders!.where((order) => order.status == 1).toList()),
                _buildOrderList(
                    orders!.where((order) => order.status == 2 | 3).toList()),
                _buildOrderList(orders!
                    .where((order) => order.status == 'RETURNED')
                    .toList()),
              ],
            ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orderList) {
    return ListView.builder(
      itemCount: orderList.length,
      itemBuilder: (context, index) {
        final orderData = orderList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                orderData.products[0].images[0],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Order #${orderData.id}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                orderData.status == 0
                    ? const Text('Status: Pending')
                    : orderData.status == 1
                        ? const Text('Status: Shipping')
                        : orderData.status == 2
                            ? const Text('Status: Delivered')
                            : const Text('Status: Received'),
                const SizedBox(height: 4),
                Text('Total: \$${orderData.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.red)),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(
                context,
                OrderDetailScreen.routeName,
                arguments: orderData,
              );
            },
          ),
        );
      },
    );
  }
}
