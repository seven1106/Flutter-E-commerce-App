import 'package:emigo/features/account/services/account_service.dart';
import 'package:emigo/features/vendor/screens/voucher/voucher_screen.dart';
import 'package:flutter/material.dart';

import '../../wishlist/screens/wishlist_screen.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeatureButton(
                context, Icons.favorite_border, 'Wishlist', () {
              Navigator.pushNamed(context, WishlistScreen.routeName);
            }),
            _buildFeatureButton(context, Icons.loyalty, 'Coupons', () {}),
            _buildFeatureButton(context, Icons.card_giftcard, 'Gift Cards', () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VouchersScreen()));
            }),
            _buildFeatureButton(context, Icons.credit_card, 'Payment', () {}),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeatureButton(context, Icons.location_on_outlined, 'Address',
                () => Navigator.pushNamed(context, '/address')),
            _buildFeatureButton(
                context, Icons.support_agent, 'Customer Service', () {}),
            _buildFeatureButton(context, Icons.settings, 'Settings', () {}),
            _buildFeatureButton(context, Icons.exit_to_app, 'Log Out',
                () => AccountService().logOut(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.black87),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
