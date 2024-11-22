import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'auth.dart';
import 'login.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Firebase.initializeApp();
    var date = await Hive.openBox('date');

  var account = await Hive.openBox('account');
  var sendamount = await Hive.openBox('sendamount');
  var upi = await Hive.openBox('upi');
  var ballance = await Hive.openBox('ballance');
   var login = await Hive.openBox('login');
   sendamount.put('depositamount', 100);
//  var date = await Hive.openBox('date');
final registerdate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
//  wallet.put('winning',0);
if (date.isEmpty){
   date.put('register', registerdate);
}
if (ballance.isEmpty){
ballance.put('withdrawable',0);

}

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Mines',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: RegisterWithPhoneNumber()
      home: AuthService().handleAuthState()
    );
  }
}
