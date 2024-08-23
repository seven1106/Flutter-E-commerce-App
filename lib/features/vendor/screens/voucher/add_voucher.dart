import 'package:emigo/core/common/long_button.dart';
import 'package:emigo/features/vendor/services/voucher_service.dart';
import 'package:flutter/material.dart';

class AddVoucherScreen extends StatefulWidget {
  static const String routeName = '/add-voucher';
  const AddVoucherScreen({Key? key}) : super(key: key);

  @override
  _AddVoucherScreenState createState() => _AddVoucherScreenState();
}

class _AddVoucherScreenState extends State<AddVoucherScreen> {
  final VoucherServices _voucherServices = VoucherServices();
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  String _discountType = 'percentage';
  double _minOrderValue = 0;
  double _maxDiscountAmount = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  int _usageLimit = 1;

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _voucherServices.createVoucher(
        context: context,
        code: _codeController.text,
        description: _descriptionController.text,
        discountValue: double.tryParse(_discountValueController.text) ?? 0,
        discountType: _discountType,
        minOrderValue: _minOrderValue,
        maxDiscountAmount: _maxDiscountAmount,
        startDate: _startDate,
        endDate: _endDate,
        usageLimit: _usageLimit,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voucher Added Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Voucher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Voucher Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a voucher code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _discountType,
                      decoration: const InputDecoration(
                        labelText: 'Discount Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'percentage', child: Text('Percentage')),
                        DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _discountType = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a discount type';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _discountValueController,
                decoration: const InputDecoration(
                  labelText: 'Discount Value',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a discount value';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _minOrderValue.toString(),
                decoration: const InputDecoration(
                  labelText: 'Minimum Order Value',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _minOrderValue = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_discountType == 'percentage')
                TextFormField(
                  initialValue: _maxDiscountAmount.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Max Discount Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _maxDiscountAmount = double.tryParse(value) ?? 0;
                    });
                  },
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Start Date: ${_startDate.toLocal().toShortDateString()}', style: const TextStyle(fontSize: 20)),
                  const Spacer(),
                  IconButton(onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null && selectedDate != _startDate) {
                      setState(() {
                        _startDate = selectedDate;
                      });
                    }
                  }, icon: const Icon(Icons.calendar_today)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('End Date: ${_endDate.toLocal().toShortDateString()}', style: const TextStyle(fontSize: 20)),
                  const Spacer(),
                  IconButton(onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _endDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (selectedDate != null && selectedDate != _endDate) {
                      setState(() {
                        _endDate = selectedDate;
                      });
                    }
                  }, icon: const Icon(Icons.calendar_today)),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _usageLimit.toString(),
                decoration: const InputDecoration(
                  labelText: 'Usage Limit',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _usageLimit = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 32),
              LongButton(buttonText: 'Add Voucher', onPressed: _submitForm)
            ],
          ),
        ),
      ),
    );
  }
}

extension DateFormat on DateTime {
  String toShortDateString() {
    return '$day/$month/$year';
  }
}
