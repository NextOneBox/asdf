import 'package:flutter/material.dart';
import 'package:mines_mines/newpage.dart';

import 'list.dart';
import 'main.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Tabs Example'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: "message"),
              Tab(icon: Icon(Icons.star), text: "admin"),
              // Tab(icon: Icon(Icons.settings), text: "Settings"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationsLog(),
           WithdrawalHistory(),
            // Center(child: Text("Settings Tab Content")),
          ],
        ),
      ),
    );
  }
}
