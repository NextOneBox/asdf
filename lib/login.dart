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

  Box? login = Hive.box('login');
  Box? ballance = Hive.box('ballance');
  Box? account = Hive.box('account');

class RegisterWithPhoneNumber extends StatefulWidget {
  const RegisterWithPhoneNumber({Key? key}) : super(key: key);

  @override
  _RegisterWithPhoneNumberState createState() =>
      _RegisterWithPhoneNumberState();
}

class _RegisterWithPhoneNumberState extends State<RegisterWithPhoneNumber> {
  final TextEditingController controller = TextEditingController();
    final __formkey = GlobalKey<FormState>();

  bool _isLoading = false;
  Box? login = Hive.box('login');
 var refferalcontroller = TextEditingController();
 signInWithGoogle() async {
   ballance?.put('ballance',0.0);
    GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      var reslut = await _googleSignIn.signIn();
      if (reslut == null) {
        return;
      }
      Fluttertoast.showToast( 
          msg: "${reslut.email}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

        if (refferalcontroller.text.isNotEmpty){
        await http.get(Uri.parse('https://app.nextbox.in/CreateAccountNew/${reslut.email}/${reslut.displayName}/$refferalcontroller'));

        }else{
        await http.get(Uri.parse('https://app.nextbox.in/CreateAccountNew/${reslut.email}/${reslut.displayName}/....'));

        }
        // await http.get(Uri.parse('https://app.nextbox.in/CreateAccount/${reslut.email}/${reslut.displayName}'));
        
//  await http.get(
//                                               Uri.parse('https://app.nextbox.in/Update/${login?.get('email')}/750/minus'));

      await http.get(
                  Uri.parse('https://app.nextbox.in/UpdateBallance/${reslut.email}/0/sucess/5555'));
                  
                          login?.put('key', 'lol');
                          login?.put('email', reslut.email);
                          login?.put('name', reslut.displayName);
                          login?.put('number',controller.text.toString());
                          ballance?.put('withdrawable', 0);
                          ballance?.put('2nddeposit', false);
                          
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Bottomapp()),
                            (Route<dynamic> route) => false,
                          );
  }catch(e){

  }}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: __formkey,
            child: Container(
              padding: EdgeInsets.all(30),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://img.freepik.com/free-vector/mobile-login-concept-illustration_114360-83.jpg?t=st=1729788891~exp=1729792491~hmac=39901c7b34d387dcacb90cc1be9cc9ff6361454649612a1643f6eb86f7a551f8&w=740',
                    fit: BoxFit.cover,
                    width: 280,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  FadeInDown(
                    child: Text(
                      'REGISTER',
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
                        'Enter your phone number to continue.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeInDown(
                    delay: Duration(milliseconds: 400),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                          InternationalPhoneNumberInput(
                          
                            validator: (value) {
                        String patttern = r'(^[0-9]*$)';
                        RegExp regExp = new RegExp(patttern);
                        if (value?.length == 0) {
                          return "Mobile Number is Required";
                        } else if (value?.length != 10) {
                          return "Mobile number must 10 digits";
                        } else if (!regExp.hasMatch(value!)) {
                          return "Mobile Number must be digits";
                        }
                        return null;
                      },
                            onInputChanged: (PhoneNumber number) {
                              // print(number.phoneNumber);
                            },
                            onInputValidated: (bool value) {
                              // print(value);
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            // countries: ['0'],
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            textFieldController: controller,
                            formatInput: false,
                            maxLength: 10,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            cursorColor: Colors.black,
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 15, left: 0),
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16),
                            ),
                            initialValue: PhoneNumber(isoCode: 'IN'),
                            onSaved: (PhoneNumber number) {
                              // print('On Saved: $number');
                            },
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
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                    SizedBox(
                    height: 20,
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
                        controller: refferalcontroller,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.bullhorn,
                            // color: c1,
                          ),
                          labelText: "Refferal Code ( Optional )",
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
                          signInWithGoogle();
                          
                        });
                         }
                       
                      },
                      color: Color.fromARGB(255, 41, 0, 223),
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
                              "REGISTER",
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
