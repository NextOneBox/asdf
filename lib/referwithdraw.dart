import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mines_mines/login.dart';
import 'package:url_launcher/url_launcher.dart';

import 'addfunds.dart';
import 'qr.dart';

// $upiid@sbi  159 wala upi
class referwithdraw extends StatefulWidget { 
  referwithdraw({
    super.key,
  });

  @override
  State<referwithdraw> createState() => _referwithdrawState();
}

class _referwithdrawState extends State<referwithdraw> {
  // var allcoin = wallet!.get('withdraw');
getbalace() async {
   var response = await http.get(
        Uri.parse('https://app.nextbox.in/GetAccount/${login?.get('email')}'));
        // print(response.body);
    setState(() {
      ballance?.put('ballance',double.parse(response.body));
    
    });
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
  
  var accountnumber = TextEditingController();
  var amountcontroller = TextEditingController();
Widget sh(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sw(double width) {
  return SizedBox(
    width: width,
  );
}

  final __formkey = GlobalKey<FormState>();
  DateTime pre_backpress = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var paypal = false;
  var paytm = true;

   minusbalance(int amount) async {
  var res=        await http.get(
      Uri.parse('https://app.nextbox.in/Update/${login?.get('email')}/$amount/minus'),
      
    );
print(res);
 setState(() {
  getbalace();
});
   }


  // Box? sendamount = Hive.box('sendamount');
  Box? date = Hive.box('date');

  @override
  Widget build(BuildContext context) {
    var withdrawamount=int.parse(account?.get('referearning'));

Color c3 = Colors.black;
Color c1 = Color.fromARGB(255, 14, 2, 118);
Color c6 = Colors.white;
var textstyle = TextStyle(color: c6, fontWeight: FontWeight.w500);

    return Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            // ignore: deprecated_member_use
            launch('https://t.me/Dcx_w');
          },
          child: Icon(
            Icons.telegram,
            
            size: 40,
            color: Color.fromARGB(255, 52, 58, 237),
          )),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            color: c6,
            height: 60,
            child: GestureDetector(
                onTap: () async {
                  if (__formkey.currentState!.validate()) {
                    var ammont = amountcontroller.text.trim();
                    var amountt = int.parse(ammont);

                    if (amountt > withdrawamount) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Insufficient Funds Minimium refer withdraw is ₹40 ',
                            style: textstyle,
                          )));
                    } else if (withdrawamount > 39 &&
                        amountt > 39) {
                         await http.get(
      Uri.parse('https://app.nextbox.in/WidReq/${login?.get('email')}/$amountt/${accountnumber.text}/referwithdraw'));
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Withdrawl request submitted successfully',
                            style: textstyle,
                          )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Reach the minimum payout ₹40',
                            style: textstyle,
                          )));
                    }
                  }
                },
                child: Container(
                    child: Center(
                        child: Text(
                      'Withdraw',
                      style: TextStyle(
                          fontSize: 17, color: c6, fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 234, 119, 18), borderRadius: BorderRadius.circular(8))))),
      ),
//! App Bar-----------------------------------------------{Started}-------------
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          '₹${withdrawamount}',
          style:
              TextStyle(color: c3, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.history,
                  color: c1,
                  size: 30,
                )),
          )
        ],
      ),
      
//! App Bar--------------------------------------------------{Ends}-------------

      body: Container(
        child: SingleChildScrollView(
            child: Form(
          key: __formkey,
          child: Column(
            children: [
              Column(
                children: [
                  // sh(10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                  'Assets/apps.png',
                ),
                 sh(10),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //                       GestureDetector(
      //                         onTap: () {
      //                           setState(() {
      //                             paypal = false;
      //                           });
      //                           setState(() {
      //                             if (paytm == false) {
      //                               paytm = true;
      //                             }
      //                           });
      //                         },
      //                         child: Container(
      //                           width: 100,
      //                           height: 40,
      //                           child: Center(
      //                             child: Text(
      //                               'Upi',
      //                               style: TextStyle(
      //                                   fontSize: 15,
      //                                   color: paytm ? c6 : Colors.black),
      //                             ),
      //                           ),
      //                           decoration: BoxDecoration(
      //                               color: paytm ? c1 : Colors.transparent,
      //                               borderRadius: BorderRadius.circular(50),
      //                               border: const Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                                 top: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                                 left: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                                 right: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                               )),
      //                         ),
      //                       ),
      
      //                       ///Gpauy
      //                       GestureDetector(
      //                         onTap: () {
      //                           setState(() {
      //                             paytm = false;
      //                           });
      //                           setState(() {
      //                             if (paypal == false) {
      //                               paypal = true;
      //                             }
      //                           });
      //                         },
      //                         child: Container(
      //                           child: Center(
      //                             child: Text(
      //                               'paypal',
      //                               style: TextStyle(
      //                                   fontSize: 15,
      //                                   color: paypal ? c6 : Colors.black),
      //                             ),
      //                           ),
      //                           width: 100,
      //                           height: 40,
      //                           decoration: BoxDecoration(
      //                               color: paypal ? c1 : Colors.transparent,
      //                               borderRadius: BorderRadius.circular(50),
      //                               border: const Border(
      //                                 bottom: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                                 top: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                                 left: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                                 right: BorderSide(
      //                                     color: Colors.blue, width: 2),
      //                               )),
      //                         ),
      //                       ),
      //                       // SizedBox(
      //                       //   width: 25,
      //                       // ),
      //                     ],
      //                   ),
      
      // //                       sh(20),
      
      // //                       Center(
      // //                         child: Text(
      // // '                       Balance   ₹${wallet?.get('ballance')}',
      // //                           style: TextStyle(
      // //                               color: c3,
      // //                               fontSize: 20,
      // //                               fontWeight: FontWeight.bold),
      // //                         ),
      // //                       ),
      //                   sh(20),
      
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return paypal
                                  ? 'Enter paypal ID'
                                  : paytm
                                      ? 'Enter Upi Id'
                                      : '';
                            }
                            return null;
                          },
                          controller: accountnumber,
                          cursorColor: c3,
                          autocorrect: true,

                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border corner radius
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 1, 5, 253)), // Set border color
                            ),

                            hintText: paypal
                                ? 'Enter paypal ID'
                                : paytm
                                    ? 'Enter Upi Id or Phone Number'
                                    : '',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 123, 123),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
      
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Amount';
                            }
                            return null;
                          },
                          controller: amountcontroller,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          autocorrect: true,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.currency_rupee,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set border corner radius
                              borderSide: BorderSide(
                                  color: Colors.blue), // Set border color
                            ),
                            hintText: 'Enter Withdrawal Amount',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 123, 123),
                            ),
                          ),
                        ),
                        Text(
                          'Minimium referal withdrwal is ₹40 ',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 40,
                  // ),
                  // MaterialButton(
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   minWidth: 120,
                  //   height: 45,
                  //   color: Colors.purple,
                  //   child: Text(
                  //     'SUBMIT',
                  //     style: TextStyle(color: Colors.white, fontSize: 20),
                  //   ),
                  //   onPressed: () async {
                  //     if (__formkey.currentState!.validate()) {
                  //       var ammont = amountcontroller.text.trim();
                  //       var amountt = int.parse(ammont);
                  //       var coin = int.parse(allcoin);
                  //       if (amountt > coin) {
                  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //             backgroundColor: Colors.purple,
                  //             content: Text(
                  //                 'Please enter Amount less than current Balance')));
                  //       } else if (coin > 41599 && amountt > 41599) {
                  //         if (account!.get(0)['completed'] == 'true') {
                  //           http.Response response = await http.post(
                  //               Uri.parse(
                  //                   'https://zaheermir.com/AddWidrawRequest'),
                  //               body: {
                  //                 'email': account!.get(0)['email'].toString(),
                  //                 'amount': amountcontroller.text.toString(),
                  //                 'accountnumber': accountnumber.text.toString(),
                  //               });
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(
                  //                 duration: Duration(seconds: 3),
                  //                 backgroundColor: Colors.purple,
                  //                 content: Text('${response.body}')),
                  //           );
                  //           Navigator.pop(context);
                  //           amountcontroller.clear();
                  //           accountnumber.clear();
                  //         } else {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(
                  //                 duration: Duration(seconds: 3),
                  //                 backgroundColor: Colors.purple,
                  //                 content: Text(
                  //                     'Complete atleast 5 Task to withdraw your money')),
                  //           );
                  //         }
                  //       } else {
                  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //             backgroundColor: Colors.purple,
                  //             content:
                  //                 Text('Reach the minimum payout 5000 coins')));
                  //       }
                  //     }
                  //   },
                  // )
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
