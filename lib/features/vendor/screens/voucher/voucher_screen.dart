import 'package:emigo/features/vendor/services/voucher_service.dart';
import 'package:emigo/models/voucher.dart'; // Đảm bảo rằng bạn đã có model VoucherModel
import 'package:flutter/material.dart';

import '../../../../core/utils/loader.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({Key? key}) : super(key: key);
  static const String routeName = '/voucher-screen';

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> with SingleTickerProviderStateMixin {
  List<VoucherModel>? vouchers;
  final VoucherServices vendorServices = VoucherServices();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchVouchers();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void fetchVouchers() async {
    vouchers = await vendorServices.fetchAllVouchers(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vouchers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Expired'),
          ],
        ),
      ),
      body: vouchers == null
          ? const Loader()
          : TabBarView(
        controller: _tabController,
        children: [
          _buildVoucherList(vouchers!.where((voucher) => voucher.isValid()).toList()), // Active Vouchers
          _buildVoucherList(vouchers!.where((voucher) => !voucher.isValid()).toList()), // Expired Vouchers
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.pushNamed(context, '/add-voucher');
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildVoucherList(List<VoucherModel> voucherList) {
    return ListView.builder(
      itemCount: voucherList.length,
      itemBuilder: (context, index) {
        final voucherData = voucherList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.card_giftcard,
                size: 60,
                color: Colors.grey[700],
              ),
            ),
            title: Text('Voucher #${voucherData.code}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                voucherData.discountType == 'percentage'
                    ? Text('Discount: ${voucherData.discountValue.toStringAsFixed(2)}%')
                    : Text('Discount: \$${voucherData.discountValue.toStringAsFixed(2)}'),
                const SizedBox(height: 4),
                Text('Valid From: ${voucherData.startDate.toLocal().toShortDateString()}'),
                Text('Valid Until: ${voucherData.endDate.toLocal().toShortDateString()}'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigator.pushNamed(
              //   context,
              //   AddVoucherScreen.routeName,
              //   arguments: voucherData,
              // );
            },
          ),
        );
      },
    );
  }
}

extension DateFormat on DateTime {
  String toShortDateString() {
    return '${this.day}/${this.month}/${this.year}';
  }
}
