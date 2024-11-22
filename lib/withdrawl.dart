
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mines_mines/login.dart';
import 'package:url_launcher/url_launcher.dart';

import 'addfunds.dart';
import 'qr.dart';
// $upiid@sbi  159 wala upi
class withdrawal extends StatefulWidget { 
  withdrawal({
    super.key,
  });

  @override
  State<withdrawal> createState() => _withdrawalState();
}

class _withdrawalState extends State<withdrawal> {
  // var allcoin = wallet!.get('withdraw');
getbalace() async {
   var response = await http.get(
        Uri.parse('https://app.nextbox.in/GetAccount/${login?.get('email')}'));
        // print(response.body);
    setState(() {
      ballance?.put('ballance',double.parse(response.body));
    
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
  // var res=        await http.get(
  //     Uri.parse('https://app.nextbox.in/Update/${login?.get('email')}/$amount/minus'),
      
  //   );
// print(res);
 setState(() {
    ballance?.put('withdrawable',ballance?.get('withdrawable')-amount);
  // getbalace();
});
   }


  Box? sendamount = Hive.box('sendamount');
  Box? date = Hive.box('date');

  @override
  Widget build(BuildContext context) {
               var upiid =  upi?.get('upi');

Color c3 = Colors.black;
Color c1 = Color.fromARGB(255, 14, 2, 118);
Color c6 = Colors.white;
var textstyle = TextStyle(color: c6, fontWeight: FontWeight.w500);

    return Scaffold(
        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     // ignore: deprecated_member_use
        //     launch('https://t.me/Dcx_w');
        //   },
        //   child: Icon(
        //     Icons.telegram,
            
        //     size: 40,
        //     color: Color.fromARGB(255, 52, 58, 237),
        //   )),
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

                    if (amountt > ballance?.get('withdrawable')) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Insufficient Funds Minimium withdraw is ₹250 ',
                            style: textstyle,
                          )));
                    } else if (ballance?.get('withdrawable') > 249 &&
                        amountt > 249) {
                      var response = await http.get(Uri.parse(
                          // 'https://app.nextbox.in/GetAccountPro/slanbge@gmail.com'));
                          'https://app.nextbox.in/GetAccountPro/${login?.get('email')}'));
                      print(response.body);
                      if (response.body == 'Success') {
                        var promax = await http.get(Uri.parse(
                            // 'https://app.nextbox.in/GetAccountProMax/slanbge@gmail.com'));
                            'https://app.nextbox.in/GetProMax/${login?.get('email')}'));
                        print(promax.body);
                        if (promax.body == 'Pending') {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.leftSlide, //19066500
                            headerAnimationLoop: false,
                            dialogType: DialogType.success,
                            showCloseIcon: true,
                            title: 'Withdrawal fee ₹159 Only',
                            desc:
                                'Withdraw Daily ₹10000 NO Limits And Instant Withdrawals In Your Account Pay withdrawal fee',
                            btnOkOnPress: () async {
                              if (sendamount?.get('phonepe') == true) {
                                // var phonepe =
                                //     'phonepe://pay?mc=5732&pa=$upiid&tn=Xq9G&am=159&cu=INR&pn=42971757871&url=&mode=02&purpose=00&orgid=159002&sign=MEYCIQCHBg/RU0nnqGczGT+3qmufIH0d4syWKuN/93J8Of+pVwIhAJRHuz0ouV+LC1+MLU9is5mIfphzIYAnLb9OqPQ9z1k+&featuretype=money_transfer';

                                // launch(phonepe);
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Qrcode(amount: 159),));

                                var email = login?.get('email');
                                var name = login?.get('name');
                                var number = login?.get('number');
                                await http.get(Uri.parse(
                                    'https://app.nextbox.in/CreatePayReqNew/$email/159.0/$name/${date?.get('register')}/S_Mines=$number'));
                              } else if (sendamount?.get('paytm') == true) {
                                var paytm =
                                    'paytmmp://cash_wallet?featuretype=money_transfer&pa=$upiid&am=159&pn=BAJRANGI%20ENTERPRISES&tn=1pwk';

                                launch(paytm);
                                var email = login?.get('email');
                                var name = login?.get('name');
                                var number = login?.get('number');
                                await http.get(Uri.parse(
                                    'https://app.nextbox.in/CreatePayReqNew/$email/159.0/$name/${date?.get('register')}/S_Mines=$number'));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Deposit_page(),
                                    ));
                              }
                            },
                            btnOkIcon: Icons.check_circle,
                            btnOkText: 'Pay Now',
                            onDismissCallback: (type) {},
                          ).show();
                        } else {

                                await http.get(
      Uri.parse('https://app.nextbox.in/WidReq/${login?.get('email')}/$amountt/${accountnumber.text}/$amountt'));
                   minusbalance(amountt);
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Withdrawl request submitted successfully.',
                            style: textstyle,
                          )));
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.leftSlide, //19066500
                          headerAnimationLoop: false,
                          dialogType: DialogType.success,
                          showCloseIcon: true,
                          title: 'Buy VIP Plan ₹139 Only',
                          desc:
                              'Withdraw Daily ₹5000 NO Limits And Instant Withdrawals In Your Account',
                          btnOkOnPress: () async {
                            if (sendamount?.get('phonepe') == true) {
                              // var phonepe =
                              //     'phonepe://pay?mc=5732&pa=$upiid&tn=Xq9G&am=139&cu=INR&pn=42971757871&url=&mode=02&purpose=00&orgid=159002&sign=MEYCIQCHBg/RU0nnqGczGT+3qmufIH0d4syWKuN/93J8Of+pVwIhAJRHuz0ouV+LC1+MLU9is5mIfphzIYAnLb9OqPQ9z1k+&featuretype=money_transfer';

                              // launch(phonepe);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Qrcode(amount: 139),));

                              var email = login?.get('email');
                              var name = login?.get('name');
                              var number = login?.get('number');
                              // String pro ='139';
                              await http.get(Uri.parse(
                                  'https://app.nextbox.in/CreatePayReqNew/$email/139.0/$name/${date?.get('register')}/S_Mines=$number'));
                            } else if (sendamount?.get('paytm') == true) {
                              var paytm =
                                  'paytmmp://cash_wallet?featuretype=money_transfer&pa=$upiid&am=139&pn=BAJRANGI%20ENTERPRISES&tn=1pwk';

                              launch(paytm);
                              var email = login?.get('email');
                              var name = login?.get('name');
                              var number = login?.get('number');
                              await http.get(Uri.parse(
                                  'https://app.nextbox.in/CreatePayReqNew/$email/139.0/$name/${date?.get('register')}/S_Mines=$number'));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Deposit_page(),
                                  ));
                            }
                          },
                          btnOkIcon: Icons.check_circle,
                          btnOkText: 'Buy Now',
                          onDismissCallback: (type) {},
                        ).show();
                      }
                      // appballance?.put('withdraw',appballance?.get('withdraw')-amountt);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Reach the minimum payout ₹250',
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
          '₹${ballance?.get('withdrawable')}',
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
                  'Assets/apps.jpg',
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
                          'Minimium withdrwal is ₹250 ',
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
                  //                   'https://S_Minesmir.com/AddWidrawRequest'),
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
