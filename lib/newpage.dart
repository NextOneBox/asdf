// import 'package:permission_handler/permission_handler.dart';


import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:path_provider/path_provider.dart';

import 'list.dart';

Future<void> main() async {
   

  WidgetsFlutterBinding.ensureInitialized();

  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox('widrawreq');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationsLog(),
    );
  }
}

class NotificationsLog extends StatefulWidget {
  @override
  _NotificationsLogState createState() => _NotificationsLogState();
}

class _NotificationsLogState extends State<NotificationsLog> {
  List<Map<String, String>> _log = [];
  List<Map<String, String>> _loog = [];
  bool started = false;

  ReceivePort port = ReceivePort();

  @override
  void initState() {
        // launch('tez://upi/pay?pa=MAB0450526A0216246@yesbank&am=1.97&cu=INR&tn=1pwk',);


    startListening();
    initPlatformState();
    super.initState();
  
  }

  void startListening() async {
    print("Start listening");
    var hasPermission = await NotificationsListener.hasPermission;
    if (!hasPermission!) {
      print("No permission, opening settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isRunning = await NotificationsListener.isRunning;

    if (!isRunning!) {
      await NotificationsListener.startService();
    }

    setState(() => started = true);
  }


  @pragma('vm:entry-point')
  static void _callback(NotificationEvent evt) {
    print("Send event to UI: $evt");
    final SendPort? send = IsolateNameServer.lookupPortByName("listener");
    if (send == null) print("Can't find the sender");
    send?.send(evt);
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize(callbackHandle: _callback);

    IsolateNameServer.removePortNameMapping("listener");
    IsolateNameServer.registerPortWithName(port.sendPort, "listener");
    port.listen((message) => onData(message));
    

    var isRunning = (await NotificationsListener.isRunning) ?? false;
    print("""Service is ${!isRunning ? "not " : ""}already running""");

    setState(() {
      started = isRunning;
    });
  }
 
  Future<void> onData(NotificationEvent event) async {
  if (event.packageName == 'com.android.mms') {
    String? text = event.text;

    // Update regex to extract only the amount and UPI ID
    RegExp regExp = RegExp(
      r'Rs\. (\d+\.\d{2}) received .+ for BQR-UPI\/.+\/(\d{10})@([a-zA-Z]+)'
    );

    Match? match = regExp.firstMatch(text ?? '');

    if (match != null) {
      // Extract amount and UPI ID
      var amountStr = match.group(1) ?? '';
      double amount = double.parse(amountStr);

      String phoneNumber = match.group(2) ?? '';
      String upiId = '${match.group(2)}@${match.group(3)}';

      RegExp regEmail = RegExp(r'^[^@]+');
      String? email = regEmail.stringMatch(upiId);
      // Convert amount to an integer string if it has no decimals
      String amountForUrl = amount.toStringAsFixed(0);

      print('Amount: Rs. $amountForUrl');
      print(phoneNumber);
      print('UPI ID: $upiId');

      // Fetch the response from the server using the URL
      var resp = await http.get(Uri.parse(
        'https://elitezeen.com/UpdateBalNew/$phoneNumber/$amountForUrl/$upiId/$email/null'));
      
      String serverResponse = resp.body;
      print('Server response $serverResponse');

      // Create a map to store the amount, UPI ID, and server response
      Map<String, String> logEntry = {
        'amount': 'INR $amountForUrl',
        'name': 'name',
        'phone': phoneNumber,
        'upiId': upiId,
        'response': serverResponse,
      };

      // Add the log entry to the _log list
      setState(() {
        _log.add(logEntry);
      });
    } else {
      print('No match found in text');
      print('Received text: $text');
    }
  }
}

  Box? widrawreq = Hive.box('widrawreq');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
        title: GestureDetector(
          // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => noti(),)),
          child: Text('YES BANK ✅')),
        actions: [
          MaterialButton(
            color: Color.fromARGB(255, 246, 246, 247),
            
            onPressed: () {
               
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WithdrawalHistory(),
                  ));
            },
            child: Text('Admin'),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _log.length,
                reverse: true,
                itemBuilder: (BuildContext context, int idx) {
                  final entry = _log[idx];
            
                  // Check if the response is "done" to set the color
                 Color containerColor = entry['response']?.toLowerCase().contains('done') == true
                ? Colors.blue
                : Colors.black;
            
            
                  return ListTile(
                    title: Container(
                       decoration: BoxDecoration(
                                color: containerColor, // Set color conditionally
                                borderRadius: BorderRadius.circular(10),
                              ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Text('Amount: ${entry['amount']}')),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Copied to Name")),
                              );
                              Clipboard.setData(
                                  ClipboardData(text: '${entry['name']}'));
                              setState(() {
                                widrawreq?.put('number', '${entry['name']}');
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WithdrawalHistory(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                           
                              child: Center(
                                child: Text(
                                  'Name: ${entry['name']}\nResponse: ${entry['response']}', // Display name and response
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Copied to number")),
                              );
                              var upiId = entry['upiId'];
                              String number = upiId!.split('@')[0];
            
                              Clipboard.setData(ClipboardData(text: number));
                              setState(() {
                                widrawreq?.put('number', number);
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WithdrawalHistory(),
                                ),
                              );
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: containerColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'UPI ID: ${entry['upiId']}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                  
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Add Here as expanded


            
         
          ],
        ),
      ),
    );
  }
}