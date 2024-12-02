
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mines_mines/contact.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'login.dart';
import 'qr.dart';

Box? upi = Hive.box('upi');
// Box? ballance = Hive.box('balance');

class Deposit_page extends StatefulWidget {
  final superam;
  const Deposit_page({super.key, this.superam});

  @override
  State<Deposit_page> createState() => _Deposit_pageState();
}

class _Deposit_pageState extends State<Deposit_page> {
  Color c3 = Colors.white;
  Color c6 = Color.fromARGB(255, 2, 15, 28);
// Color c3 = Colors.white;
  Color c1 = Color.fromARGB(255, 234, 119, 18);
  Color c11 = Color.fromARGB(255, 234, 119, 18);
  Color ct = Color(0xff83c5be);
  Color ci = Color(0xffffd60a);
  Color cb = Color(0xff000000);
  Color blue = Color.fromARGB(255, 8, 209, 239);
  Color buttoncolor = Color.fromARGB(255, 234, 119, 18);
  Color green = Colors.green;

  Box? date = Hive.box('date');
Getupi() async {
    var response = await http.get(
        Uri.parse('https://app.nextbox.in/GetUPiId/S_Mines/1'));
    setState(() {
      upi?.put('upi', response.body.toString());
  });
  }
  getbalace() async {
  var response = await http.get(
    Uri.parse('https://app.nextbox.in/GetAccount/${login?.get('email')}')
  );

  // Parse the response and handle negative values
  double balance = double.parse(response.body);
  if (balance < 0) {
    balance = 0;
     await http.get(
                  Uri.parse('https://app.nextbox.in/UpdateBallance/${login?.get('email')}/1/sucess/5555'));

  }

  setState(() {
    ballance?.put('ballance', balance);
  });
}

  @override
  void initState() {
     getbalace();
    Getupi();
    // updatebalace();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // final FacebookAppEvents facebookAppEvents = FacebookAppEvents();
  Box? sendamount = Hive.box('sendamount');

  bool hundred = false;
  bool two = true;
  bool three = false;
  bool five = false;
  bool eight = false;
  bool sixteen = false;
  bool thirty = false;
  bool fifty = false;
  bool seventy = false;
  bool eighty = false;
  bool ninty = false;
  bool sixty = false;
  double height = 55;

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

  updatebalace() async {
    //  await http.get(
    //                   Uri.parse('https://app.nextbox.in/UpdateBallance/${login?.get('email')}/100/sucess/5555'));
    var response = await http.get(
        Uri.parse('https://app.nextbox.in/GetAccount/${login?.get('email')}'));
    // print(response.body);
    setState(() {
      ballance?.put('ballance', int.parse(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    var upiid = upi?.get('upi');
  var textstyle = TextStyle(color: Colors.white,fontWeight: FontWeight.w900);

    double width = MediaQuery.of(context).size.width / 3.5;

    var bctff = Color.fromARGB(255, 234, 119, 18);
    var concolor = Color.fromARGB(255, 234, 119, 18);
    var txcolor = Color.fromARGB(255, 4, 4, 4);
    var amountcontroller = TextEditingController(
        text: sendamount?.get('depositamount').toString());
        if (sendamount?.get('jackpot')==299){
          
  hundred = true;
   two = false;
   three = false;
   five = false;
   eight = false;

        }else{
          // setState(() {
          //   sendamount?.put('depositamount',100);
          // });

        }
        // 
    return Scaffold(
       floatingActionButton: Padding(
         padding: const EdgeInsets.only(bottom: 40),
         child: MaterialButton(
           child: Text('Contact us',style: TextStyle(color: Colors.white),),
           color: Color.fromARGB(255, 191, 138, 3), onPressed: () { 
           Navigator.push(context, MaterialPageRoute(builder: (context) => contactus(),));

            },
         ),
       ),
        bottomNavigationBar: Container(
          // color: bctff,
          height: 57,
          child:  Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //     image: DecorationImage(image: AssetImage('Assets/spinbc.jpeg'),fit: BoxFit.cover)),
       
            child: GestureDetector(
                onTap: () {
                  if (double.parse(amountcontroller.text) < 69) {
                    Fluttertoast.showToast(
                        msg: "Mini Deposit is ₹80",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: c6,
                        textColor: c3,
                        fontSize: 16.0);
                  } else {
                    setState(() {
                      sendamount?.put(
                          'depositamount', double.parse(amountcontroller.text));
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                        minWidth: MediaQuery.of(context).size.width / 3.5,
                        onPressed: () async {
                          if (double.parse(amountcontroller.text) < 69) {
                            Fluttertoast.showToast(
                                msg: "Minimium Deposit is ₹100",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: c6,
                                textColor: c3,
                                fontSize: 16.0);
                          } else {
                            setState(() {
                              sendamount?.put('depositamount',
                                  double.parse(amountcontroller.text));
                            });
                            var amounte = sendamount?.get('depositamount');
          
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Qrcode(amount: amounte),
                                ));
                            sendamount?.put('paytm', false);
                            sendamount?.put('phonepe', true);
                            var email = login?.get('email');
                            var name = login?.get('name');
                            var number = login?.get('number');
          
                            await http.get(Uri.parse(
                                'https://app.nextbox.in/CreatePayReqNew/$email/$amounte/$name/${date?.get('register')}/S_Mines_new=QR=$number'));
                            // }
          
                            //     var phonepe =
          
                            //     'phonepe://pay?mc=5732&pa=$upiid&tn=Xq9G&am=$amounte&cu=INR&pn=42971757871&url=&mode=02&purpose=00&orgid=159002&sign=MEYCIQCHBg/RU0nnqGczGT+3qmufIH0d4syWKuN/93J8Of+pVwIhAJRHuz0ouV+LC1+MLU9is5mIfphzIYAnLb9OqPQ9z1k+&featuretype=money_transfer';
          
                            //     // ignore: deprecated_member_use
                            //     if (await canLaunch(phonepe)) {
                            //       sendamount?.put('phonepe',true);
                            //       sendamount?.put('paytm',false);
                            //       // ignore: deprecated_member_use
                            //       launch(phonepe);
                            //       var email = login?.get('email');
                            //       var name = login?.get('name');
                            //       var number = login?.get('number');
          
                            // // await http.get(Uri.parse(
                            // //           'https://app.nextbox.in/CreatePayReq/$email/$amounte/$name'));
                            // await http.get(Uri.parse(
                            //           'https://app.nextbox.in/CreatePayReqNew/$email/$amounte/$name/${date?.get('register')}/S_Mines=PHNPE=$number'));
                            //           // print(res);
                            //               // showNotification('','hy');
          
                            //     } else {
                            //       AwesomeDialog(
                            //         context: context,
                            //         animType: AnimType.leftSlide,
                            //         headerAnimationLoop: false,
                            //         dialogType: DialogType.info,
                            //         showCloseIcon: true,
                            //         // title: 'Succes',
                            //         desc:
                            //             'Phonepe is not installed in your phone please install phonepe to complete transcation',
                            //         btnOkOnPress: () {},
                            //         btnOkIcon: Icons.check_circle,
                            //         onDismissCallback: (type) {},
                            //       ).show();
                            //     }
                          }
                        },
                        child: Image.asset(
                          'Assets/phonepe.jpg',
                          width: MediaQuery.of(context).size.width / 5,
                        ),
                        // Text(
                        //   'Phonepe',
                        //   style: TextStyle(color: Colors.white,fontWeight: FontWeight.boldfontSize: 15),
                        // ),
                        color: Color.fromARGB(255, 240, 240, 240),
                        height: 50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
          
                    //////////////////////////Qr code button
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 3.5,
          
                      onPressed: () async {
                        if (double.parse(amountcontroller.text) < 69) {
                          Fluttertoast.showToast(
                              msg: "Minimium Deposit is 100",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: c6,
                              textColor: c3,
                              fontSize: 16.0);
                        } else {
                          setState(() {
                            sendamount?.put('depositamount',
                                double.parse(amountcontroller.text));
                          });
                          var amounte = sendamount?.get('depositamount');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Qrcode(amount: amounte),
                              ));
                          sendamount?.put('paytm', false);
                          sendamount?.put('phonepe', true);
                          var email = login?.get('email');
                          var name = login?.get('name');
                          var number = login?.get('number');
          
                          await http.get(Uri.parse(
                              'https://app.nextbox.in/CreatePayReqNew/$email/$amounte/$name/${date?.get('register')}/S_Mines_new=QR=$number'));
                        }
                      },
                      child: Image.asset(
                        'Assets/upi.jpg',
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      //  Text(
                      //   'Qr Code',
                      //   style: TextStyle(color: Colors.white,fontWeight: FontWeight.boldfontSize: 15),
                      // ),
                      color: Color.fromARGB(255, 255, 255, 255),
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    
          
                    ////////////////////////////paytm button
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 3.5,
                      onPressed: () async {
                        if (double.parse(amountcontroller.text) < 69) {
                          Fluttertoast.showToast(
                              msg: "Minimium Deposit is ₹100",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: c6,
                              textColor: c3,
                              fontSize: 16.0);
                        } else {
                          setState(() {
                            sendamount?.put('depositamount',
                                double.parse(amountcontroller.text));
                          });
          
                          var amounte = sendamount?.get('depositamount');
                          var paytm =
                              'paytmmp://cash_wallet?featuretype=money_transfer&pa=$upiid&am=$amounte&pn=BAJRANGI%20ENTERPRISES&tn=1pwk';
                           
                          // if (await canLaunch(paytm)) {
                            sendamount?.put('paytm', true);
                            sendamount?.put('phonepe', false);
                           
                            launch(paytm);
                            var email = login?.get('email');
                            var name = login?.get('name');
                            var number = login?.get('number');
                            await http.get(Uri.parse(
                                'https://app.nextbox.in/CreatePayReqNew/$email/$amounte/$name/${date?.get('register')}/S_Mines_new=PAYTM=$number'));
                          // } else {
                          //   AwesomeDialog(
                          //     context: context,
                          //     animType: AnimType.leftSlide,
                          //     headerAnimationLoop: false,
                          //     dialogType: DialogType.info,
                          //     showCloseIcon: true,
                          
                          //     desc:
                          //         'paytm is not installed in your phone please install paytm to complete transcation',
                          //     btnOkOnPress: () {},
                          //     btnOkIcon: Icons.check_circle,
                          //     onDismissCallback: (type) {},
                          //   ).show();
                          // }
                        }
                      },
                      child: Image.asset(
                        'Assets/paytm.jpg',
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                      //  Text(
                      //   'Paytm',
                      //   style: TextStyle(color: Colors.white,fontWeight: FontWeight.boldfontSize: 15),
                      // ),
                      color: Color.fromARGB(255, 255, 255, 255),
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                )
                // Container(
                //     child: Center(
                //         child: Text(
                //       'Deposit',
                //       style: TextStyle(
                //           fontSize: 17, color: c3, fontWeight: FontWeight.bold),
                //     )),
                //     decoration: BoxDecoration(
                //         color: buttoncolor,
                //         borderRadius: BorderRadius.circular(8)))
          
                ),
          ),
        ),
        appBar: AppBar(
         
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: c3,
            onPressed: () {
              updatebalace();
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Deposit',
            style: textstyle,
          ),
          centerTitle: true,
          backgroundColor: c6,
        ),
        backgroundColor: c6,
        body:  Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //     image: DecorationImage(image: AssetImage('Assets/spinbc.jpeg'),fit: BoxFit.cover)),
       
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text('Deposit ₹200 Get 100% Bonus On Your First Deposit.',
                      //     style: textstyle),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Text('Deposit amount', style: textstyle),
                      sh(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', 80);
                                hundred = true;
                                two = false;
                                three = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: 55,
                              width: width,
                              child: Center(
                                  child: Text(
                              '₹80' ,
                                style: TextStyle(
                                    color: hundred ? txcolor : Colors.white,fontWeight:FontWeight.w900),
                              )),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: hundred ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: hundred ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: hundred ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: hundred ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: concolor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('100'));
                                two = true;
                                hundred = false;
        
                                three = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹100',
                                style: TextStyle(
                                  color: two ? txcolor : Colors.white,fontWeight: FontWeight.bold
                                ),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: two ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: two ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: two ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: two ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('200'));
                                three = true;
                                hundred = false;
                                two = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹200',
                                style: TextStyle(color: three ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: three ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: three ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: three ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: three ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //////.........SecondRow............
                      sh(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('250'));
                                hundred = false;
                                two = false;
                                three = false;
                                five = true;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹250',
                                style: TextStyle(color: five ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: five ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: five ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: five ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: five ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('350'));
                                two = false;
                                hundred = false;
                                three = false;
                                five = false;
                                eight = true;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹350',
                                style: TextStyle(color: eight ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: eight ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: eight ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: eight ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: eight ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('400'));
                                three = false;
                                hundred = false;
                                two = false;
                                five = false;
                                eight = false;
                                sixteen = true;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹400',
                                style: TextStyle(color: sixteen ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: sixteen ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: sixteen ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: sixteen ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: sixteen ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      sh(20),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('700'));
                                hundred = false;
                                two = false;
                                three = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = true;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹700',
                                style: TextStyle(color: thirty ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: thirty ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: thirty ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: thirty ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: thirty ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('800'));
                                two = false;
                                hundred = false;
        
                                three = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = true;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹800',
                                style: TextStyle(color: fifty ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: fifty ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: fifty ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: fifty ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: fifty ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('900'));
                                three = false;
                                hundred = false;
                                two = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = true;
                                 seventy=false;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹900',
                                style: TextStyle(color: sixty ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: sixty ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: sixty ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: sixty ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: sixty ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      sh(20),
        
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('1500'));
                                hundred = false;
                                two = false;
                                three = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                seventy=true;
                                eighty=false;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹1500',
                                style: TextStyle(color: seventy ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: seventy ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: seventy ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: seventy ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: seventy ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('2500'));
                                two = false;
                                hundred = false;
        
                                three = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                  seventy=false;
                                eighty=true;
                                ninty=false;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹2500',
                                style: TextStyle(color: eighty ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: eighty ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: eighty ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: eighty ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: eighty ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                sendamount?.put(
                                    'depositamount', double.parse('4000'));
                                three = false;
                                hundred = false;
                                two = false;
                                five = false;
                                eight = false;
                                sixteen = false;
                                thirty = false;
                                fifty = false;
                                sixty = false;
                                 seventy=false;
                                eighty=false;
                                ninty=true;
                              });
                            },
                            child: Container(
                              height: height,
                              width: width,
                              child: Center(
                                  child: Text(
                                '₹4000',
                                style: TextStyle(color: ninty ? txcolor : c3,fontWeight: FontWeight.bold),
                              )),
                              decoration: BoxDecoration(
                                color: concolor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: ninty ? txcolor : c3,
                                  ),
                                  top: BorderSide(
                                    color: ninty ? txcolor : c3,
                                  ),
                                  left: BorderSide(
                                    color: ninty ? txcolor : c3,
                                  ),
                                  right: BorderSide(
                                    color: ninty ? txcolor : c3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      sh(20),
        
                      ///.........TextFormField.......
                      Container(
                        // height: 50,
                        decoration: BoxDecoration(
                            color: bctff,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: amountcontroller,
                          keyboardType: TextInputType.number,
                          cursorColor: c3,
                          autocorrect: true,
                          style: textstyle,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.currency_rupee,
                              color: Color.fromARGB(255, 3, 129, 231),
                            ),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Enter Deposit Amount',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 128, 123, 123),
                            ),
                          ),
                          onFieldSubmitted: (value) => sendamount?.put(
                              'depositamount',
                              double.parse(amountcontroller.text)),
                        ),
                      ),

        
         
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  var pay1 = true;
  var pay2 = false;
  var pay3 = false;
  Box? account = Hive.box('account');

  
}
