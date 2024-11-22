import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:mines_mines/referwithdraw.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'login.dart';
class ReferFriend extends StatefulWidget {
  const ReferFriend({super.key});

  @override
  State<ReferFriend> createState() => _ReferFriendState();
}

class _ReferFriendState extends State<ReferFriend> {
  var urlapp =
      'https://elitezeen.com/mines';
  final String _content =
      '✅ Earn daily upto  ₹10000 download this earning app mines Enter My refer code ${account?.get('refercode')}';

  void _shareContent() {
    Share.share('$_content $urlapp ');
  }


getBalance() async {
  var response = await http.get(
    Uri.parse('https://app.nextbox.in/GetData/${login?.get('email')}')
  );

  // Parse the response as JSON
  var data = json.decode(response.body);
  print(data);
  // Assuming the response is a list, get the first item and access RefCode
  String refCode = data[0]['RefCode'];
  String refearning = data[0]['RefAmount'];
  print(refearning);

  print(refCode); // This will print the RefCode

  setState(() {
    account?.put('refercode',refCode);
    account?.put('referearning',refearning);
  });
}


  void _shareOnWhatsApp() async {
    String url = 'https://wa.me/?text=$_content $urlapp';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _shareContent();
      throw 'Could not launch $url';
    }
  }

  void _shareOnFacebook() async {
    String url =
        'https://www.facebook.com/sharer/sharer.php?u=$_content $urlapp';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _shareContent();
      throw 'Could not launch $url';
    }
  }

  void _shareOnTelegram() async {
    String url = 'https://telegram.me/share/url?url=$_content $urlapp';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _shareContent();
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    getBalance();
    super.initState();
  }

  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            Fluttertoast.showToast(
                msg: "Press Back button again to Exit",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height / 1.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                      gradient: LinearGradient(
                          colors: [Color.fromARGB(255, 222, 188, 0), Color.fromARGB(255, 138, 138, 250), Color.fromARGB(255, 67, 199, 236)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Column(
                    children: [
                      // sh(70),
                      // Text(
                      //   'Refer Your Friends\n and Earn',
                      //   style: TextStyle(
                      //       color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(
                        // width: 300,
                        // height: 300,
                        child: Lottie.asset('Assets/refer.json'),
                      ),
                      // Container(
                      //   width: 80,
                      //   height: 80,
                      //   decoration: BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage('images/refe.png'),
                      //           fit: BoxFit.cover)),
                      // ),
                     SizedBox(height: 20,),
                      Text(
                        'Earn ₹20 on your referal friend first deposit\nAnd withdraw instant in your bank account.',
                        style: TextStyle(
                            color: Colors.black, fontSize: 17, fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 254, 252),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid,
                                )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${account!.get('refercode')}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  height: 65,
                                  width: 1,
                                  color: Colors.black,
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: '${account!.get('refercode')}'));
                                    // Handle copy referral code action
                                    Fluttertoast.showToast(
                                        msg: "Copied",
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.black,
                                        fontSize: 16.0);
                                  },
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.black,
                                width: 1,
                                style: BorderStyle.solid,
                                )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${account!.get('referearning')}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                             
                                 GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => referwithdraw(),));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                                                             decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color.fromARGB(255, 244, 232, 123),width: 2),
                     
                                color: Color.fromARGB(255, 51, 156, 242),
                              ),
                              child: Row(children: [
                                Text(
                                  'Withdraw',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                               
                              ]),
                            ),
                          ),
                              ]),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Share Your Refferal Code via',
                        style: TextStyle(
                            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 50,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _shareOnTelegram();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                                                             decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                      border: Border.all(color: Color.fromARGB(255, 244, 232, 123),width: 2),
                     
                                color: Color.fromARGB(255, 51, 156, 242),
                              ),
                              child: Row(children: [
                                Text(
                                  'Telegram',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 5,),
                                Icon(
                                  Icons.telegram,
                                  color: Colors.white,
                                )
                              ]),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _shareOnWhatsApp();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                                                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                      border: Border.all(color: Color.fromARGB(255, 244, 232, 123),width: 2),
                      color: Colors.green
                    ),
                              child: Row(children: [
                                Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                               SizedBox(height: 5,),
                                Icon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.white,
                                )
                              ]),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _shareOnFacebook();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                                                             decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                      border: Border.all(color: Color.fromARGB(255, 244, 232, 123),width: 2),
                      color: Colors.blueAccent
                    ),
                              child: Row(children: [
                                Text(
                                  'FaceBook',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 6,),
                                Icon(
                                  
                                  Icons.facebook,
                                  color: Colors.white,
                                )
                              ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ExpansionTile(
                  title: Text(faqData[0]['question'] ?? ''),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(faqData[0]['answer'] ?? ''),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(faqData[1]['question'] ?? ''),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(faqData[1]['answer'] ?? ''),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(faqData[2]['question'] ?? ''),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(faqData[2]['answer'] ?? ''),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(faqData[3]['question'] ?? ''),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(faqData[3]['answer'] ?? ''),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ));
  }

  List<Map<String, String>> faqData = [
    {
      'question': 'What is refer and earn program ?',
      'answer':
          'Refer And Earn program is when You Refer a friend You Earn Money',
    },
    {
      'question': 'How its work?',
      'answer':
          'When your friend signup with your refferal code and depost you will earn 20 rupees',
    },
    {
      'question': 'How to share ?',
      'answer':
          'Copy Your referal code share with friends or click on the above whatsapp , facebook ,telegram button share with friends.',
    },
    {
      'question': 'Can i withdraw this money ?',
      'answer': 'Yes you can eaisly withdraw this money',
    },
    // Add more questions and answers as needed
  ];
}