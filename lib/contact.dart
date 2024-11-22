import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'mines.dart';
import 'navbar.dart';

class contactus extends StatefulWidget {
  const contactus({Key? key}) : super(key: key);

  @override
  _contactusState createState() =>
      _contactusState();
}

class _contactusState extends State<contactus> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController upi = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
    final __formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  Box? login = Hive.box('login');
//  var refferalcontroller = TextEditingController();
  contact( String amount,String upi,String number) async {
   var resp =await http.get(
        Uri.parse('https://app.nextbox.in/cont/${login?.get('email')}/$amount/$upi/$number'));

print(resp.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: __formkey,
            child: Container(
              padding: EdgeInsets.all(30),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
              
                  FadeInDown(
                    child: Text(
                      'Contact us',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.grey.shade900),
                    ),
                  ),
                    FadeInDown(
                    delay: Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20),
                      child: Text(
                        'Agar Aap Ke Paisa Game Ma Add nhi Hoa toh Ya form Fill Kro.Wait 1 Hour After Filled',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: const Color.fromARGB(255, 0, 0, 0),),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
              
                 
                
                  FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withOpacity(0.13)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffeeeeee),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                         TextFormField(
                           validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requird Field';
                        
                        }
                        return null;
                      },
                        controller: amount,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.monetization_on,
                            // color: c1,
                          ),
                          labelText: "Enter Amount",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      
                         ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withOpacity(0.13)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffeeeeee),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                         TextFormField(
                           validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requird Field';
                        
                        }
                        return null;
                      },
                        controller: upi,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.bank,
                            // color: c1,
                          ),
                          labelText: "Enter Upi",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      
                         ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 10,
                  ),
                  FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withOpacity(0.13)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffeeeeee),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                         TextFormField(
                           validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Requird Field';
                        
                        }
                        return null;
                      },
                        controller: phonenumber,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            // color: c1,
                          ),
                          labelText: "Enter Phone number",
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      
                         ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FadeInDown(
                    delay: Duration(milliseconds: 600),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () {
                         if (__formkey.currentState!.validate()){
 setState(() {
                          _isLoading = true;
                        });
          
                        Future.delayed(Duration(seconds: 2), () {
                          setState(() {
                            _isLoading = false;
                          });
                         contact(amount.text,upi.text,phonenumber.text);
                          
                        });
                         }
                       
                      },
                      color: Color.fromARGB(255, 223, 160, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: _isLoading
                          ? Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Color.fromARGB(255, 41, 0, 223),
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "SUBMIT",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  // SizedBox(height: 20,),
                  // FadeInDown(
                  //   delay: Duration(milliseconds: 800),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('Already have an account?', style: TextStyle(color: Colors.grey.shade700),),
                  //       SizedBox(width: 5,),
                  //       InkWell(
                  //         onTap: () {
                  //           Navigator.of(context).pushReplacementNamed('/login');
                  //         },
                  //         child: Text('Login', style: TextStyle(color: Colors.black),),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }
}
