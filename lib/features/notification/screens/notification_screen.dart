import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../widgets/noti_widget.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = '/notifications';
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              // gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text('Notifications'),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (user.notifications.isEmpty)
              const Center(
                child: Text(
                  'No notifications available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                itemCount: user.notifications.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return NotificationWidget(
                    index: index,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}