
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mines_mines/addfunds.dart';
import 'package:mines_mines/demo.dart';
import 'package:mines_mines/refer.dart';
import 'package:mines_mines/withdrawl.dart';
import 'mines.dart';
// /WidReq/email/amount/upi/type
// cont/email/amount/upi/number/
//CreateAccountNew/email/name/referby/
class Bottomapp extends StatefulWidget {
  @override
  _BottomappState createState() => _BottomappState();
}

class _BottomappState extends State<Bottomapp> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  var pagesdata = [
       GameScreen(),
      //  Demo(),
      Deposit_page(),
      ReferFriend(),
      withdrawal(),
      

  
    
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: pagesdata.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
         gradient: LinearGradient(
                                    transform: GradientRotation(10),
                                    colors: [
                                      Color.fromARGB(255, 234, 119, 18),
                                      Color.fromARGB(255, 234, 119, 18),
                                    ])
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Color.fromARGB(255, 15, 9, 183),
            iconSize: 20,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor:  Color.fromARGB(255, 245, 245, 245)!,
            color: Colors.black,
            tabs: [
           
              GButton(
                icon: FontAwesomeIcons.home,
                text: 'Home',
              ),
              //  GButton(
              //   icon: FontAwesomeIcons.exclamationCircle,
              //   text: 'Demo',
              // ),
               GButton(
                icon: FontAwesomeIcons.moneyBill,
                text: 'Add',
              ),
              GButton(
                icon: FontAwesomeIcons.share,
                text: 'Refer',
              ),
              GButton(
                icon: FontAwesomeIcons.wallet,
                text: 'Withdraw',
              ),
             
              // GButton(
              //   icon: FontAwesomeIcons.user,
              //   text: 'Profile',
              // ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
