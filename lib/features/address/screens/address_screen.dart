import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/common/custom_textfield.dart';
import '../../../core/utils/show_snack_bar.dart';
import '../../../providers/user_provider.dart';
import '../services/address_services.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  String addressToBeUsed = "";
  final AddressServices addressServices = AddressServices();

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void saveAddress() {
    if (_addressFormKey.currentState!.validate()) {
      addressToBeUsed =
      '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
      showSnackBar(context, 'Address saved successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Address'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (address.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Default Address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        address,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 24),
              Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              OutlinedButton(
                onPressed: saveAddress,
                child: Text(
                  'Save Address',
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
