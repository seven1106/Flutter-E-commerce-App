import 'package:emigo/core/common/long_button.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../models/voucher.dart';
import '../../../providers/user_provider.dart';
import '../../address/screens/address_screen.dart';
import '../../address/services/address_services.dart';
import '../../vendor/services/voucher_service.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';
  final String totalAmount;

  const CheckoutScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final AddressServices addressServices = AddressServices();
  String selectedPaymentMethod = 'Credit Card';
  String? selectedVoucher;
  List<VoucherModel>? vouchers;
  List<PaymentItem> paymentItems = [];
  final VoucherServices voucherServices = VoucherServices();
  double total = 0;
  @override
  void initState() {
    super.initState();
    fetchVouchers();
    paymentItems.add(
      PaymentItem(
        amount: total.toString(),
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  void fetchVouchers() async {
    vouchers = await voucherServices.fetchAllVouchers(context);
    setState(() {});
  }

  void onGooglePayResult(res) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Google Pay result: $res'),
      ),
    );
  }

  String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.sams.fish",
    "displayName": "Sam's Fish",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },
      {
        "amount": "4.99",
        "detail": "5-8 Business Days",
        "identifier": "flat_rate_shipping_id_2",
        "label": "UPS Ground"
      },
      {
        "amount": "29.99",
        "detail": "1-3 Business Days",
        "identifier": "flat_rate_shipping_id_1",
        "label": "FedEx Priority Mail"
      }
    ]
  }
}''';
  String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';
  void _placeOrder(String address) {
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a shipping address')),
      );
      return;
    }

    // Here you would typically integrate with your payment processing and order placement logic
    addressServices.placeOrder(
      context: context,
      address: address,
      totalSum: total,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GooglePayButton(
          onPressed: () => _placeOrder(user.address),
          width: double.infinity,
          paymentConfiguration:
              PaymentConfiguration.fromJsonString(defaultGooglePay),
          onPaymentResult: onGooglePayResult,
          paymentItems: paymentItems,
          height: 80,
          type: GooglePayButtonType.buy,
          margin: const EdgeInsets.only(top: 15),
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Shipping Address'),
              _buildAddressSection(user.address),
              const SizedBox(height: 24),
              _buildSectionTitle('Payment Method'),
              _buildPaymentMethodSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('Voucher'),
              _buildVoucherSection(),
              const SizedBox(height: 24),
              _buildSectionTitle('Order Summary'),
              _buildOrderSummary(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherSection() {
    return GestureDetector(
      onTap: () {
        _buildVoucherList(vouchers!);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedVoucher ?? 'Select a voucher',
              style: TextStyle(
                fontSize: 14,
                color: selectedVoucher != null ? Colors.black : Colors.grey,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _buildVoucherList(List<VoucherModel> voucherList) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select a Voucher',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: voucherList.length,
                itemBuilder: (context, index) {
                  final voucherData = voucherList[index];
                  return ListTile(
                    title: Text('Voucher #${voucherData.code}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        voucherData.discountType == 'percentage'
                            ? Text(
                                'Discount: ${voucherData.discountValue.toStringAsFixed(2)}%')
                            : Text(
                                'Discount: \$${voucherData.discountValue.toStringAsFixed(2)}'),
                        const SizedBox(height: 4),
                        Text(
                            'Valid From: ${voucherData.startDate.toLocal().toShortDateString()}'),
                        Text(
                            'Valid Until: ${voucherData.endDate.toLocal().toShortDateString()}'),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        selectedVoucher = voucherData.code;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    // Calculate discount based on selected voucher
    double discount = 0;
    if (selectedVoucher != null) {
      final voucher = vouchers!.firstWhere((v) => v.code == selectedVoucher);
      if (voucher.discountType == 'percentage') {
        discount = double.parse(widget.totalAmount) * (voucher.discountValue / 100);
      } else {
        discount = voucher.discountValue;
      }
    }
    total = double.parse(widget.totalAmount) - discount;
    if(total < 0) {
      total = 0;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Subtotal', '\$${widget.totalAmount}'),
          _buildSummaryRow('Shipping', 'Free'),
          if (discount > 0)
            _buildSummaryRow('Discount', '-\$${discount.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax', '\$0.00'),
          const Divider(),
          _buildSummaryRow('Total', '\$${total.toStringAsFixed(2)}',
              isBold: true),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddressSection(String address) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AddressScreen.routeName,
          arguments: widget.totalAmount),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.isNotEmpty ? address : 'Add shipping address',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Change',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      children: [
        // _buildPaymentOption('Credit Card', Icons.credit_card),
        // _buildPaymentOption('PayPal', Icons.paypal),
        // _buildPaymentOption('Apple Pay', Icons.apple),
        _buildPaymentOption('Google Pay', Icons.g_mobiledata),
      ],
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    return RadioListTile<String>(
      title: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Text(method),
        ],
      ),
      value: method,
      groupValue: selectedPaymentMethod,
      onChanged: (String? value) {
        setState(() {
          selectedPaymentMethod = value!;
        });
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

extension DateFormat on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }
}
