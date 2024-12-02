import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AutoScrollView1 extends StatefulWidget {
  @override
  _AutoScrollView1State createState() => _AutoScrollView1State();
}
dynamic amount;

class _AutoScrollView1State extends State<AutoScrollView1> {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }



  Future<void> _loadUsers() async {
    // Load the JSON file
  final String response = await rootBundle.loadString('Assets/users.json');
    final List<dynamic> data = json.decode(response);

    // Parse and generate user data with random amounts
  setState(() {
    // Shuffle the data for randomness
    data.shuffle(random);

    // Select random users and generate their data
    for (int i = 0; i < min(10, data.length); i++) {
      final user = data[i];

      // Generate a random amount between 200 and 1000
      final double amount = 200 + (random.nextDouble() * 3000);

      // Extract and mask email
      final String email = user['email'];
      final String maskedEmail = 
          '${email.substring(0, min(email.indexOf('@'), 10))}***@${email.split('@')[1]}';

      // Add user info to the list
        _users.add({
        'email': '\n\n\n\n\n$maskedEmail ₹${amount.toStringAsFixed(2)} \n              Withdrwal Just Now',
      });
    }
  });

    // Start auto-scrolling once users are loaded
    _startAutoScroll();
  }
    final random = Random();

  void _startAutoScroll() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
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
       color:   const Color.fromARGB(255, 6, 68, 16),// Green for positive amounts
        ),),
                  // subtitle: Text('Amount: \₹${user['amount']}',style: TextStyle(color: Colors.white),),
                );
              },
            ),
    );
  }
}
