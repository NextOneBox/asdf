import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AutoScrollView extends StatefulWidget {
  @override
  _AutoScrollViewState createState() => _AutoScrollViewState();
}
dynamic amount;

class _AutoScrollViewState extends State<AutoScrollView> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('assets/users.json');
    final List<dynamic> data = json.decode(response);

    // Parse and generate user data with random amounts
    setState(() {
      for (var user in data) {
             amount = ((random.nextDouble() * 800) - 200);

        final email = user['email'];
        _users.add({
          'email': '${email.substring(0, 7)}***@${email.split('@')[1]}  ₹${(amount.toStringAsFixed(2) )}',
          
        });
      }
    });

    // Start auto-scrolling once users are loaded
    _startAutoScroll();
  }
    final random = Random();

  void _startAutoScroll() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        if (currentScroll < maxScroll) {
          _scrollController.jumpTo(currentScroll + 1);
        } else {
          _scrollController.jumpTo(0); // Reset to the top when reaching the end
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Colors.transparent,
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            reverse: true,
          
              controller: _scrollController,
              itemCount: _users.length,
              scrollDirection:Axis.vertical,
              
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  // leading: CircleAvatar(
                  //   child: Text(user['email'][0].toUpperCase()),
                  // ),
                  title: Text(user['email'],style: TextStyle(
       color:   const Color.fromARGB(255, 176, 241, 139), // Green for positive amounts
        ),),
                  // subtitle: Text('Amount: \₹${user['amount']}',style: TextStyle(color: Colors.white),),
                );
              },
            ),
    );
  }
}
