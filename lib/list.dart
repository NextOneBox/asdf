import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mines_mines/newpage.dart';

import 'main.dart';
import 'web.dart';

  Box? widrawreq = Hive.box('widrawreq');

class WithdrawalHistory extends StatefulWidget {

  final number;
  const WithdrawalHistory({Key? key, this.number}) : super(key: key);
  @override
  _WithdrawalHistoryState createState() => _WithdrawalHistoryState();
}

// var depositrequest = widrawreq?.values.toList();
class _WithdrawalHistoryState extends State<WithdrawalHistory> {
  TextEditingController _searchController = TextEditingController(
    text:widrawreq?.get('number')
  );
  List<dynamic> _filteredRequests = [];
  String _currentFilterQuery = '';

  @override
  void initState() {
    super.initState();
    getwidreq();
    _searchController.addListener(_filterRequests);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRequests);
    _searchController.dispose();
    super.dispose();
  }

   Future<void> getwidreq() async {
    http.Response getwithdrareq = await http.get(Uri.parse('https://elitezeen.com/GetPayReq'));
    if (getwithdrareq.reasonPhrase == 'OK') {
      await widrawreq!.clear();
      var da = jsonDecode(getwithdrareq.body);

      for (var a in da) {
        widrawreq!.add(a);
      }
      setState(() {
        _filteredRequests = widrawreq!.values.toList().reversed.toList();
      });
    }
  }

  void _filterRequests() {
    String query = _searchController.text.toLowerCase();
    _currentFilterQuery = query;  // Update the current filter query
    _applyFilters();
  }

  void _quickFilter(String query) {
    if (_currentFilterQuery.isNotEmpty) {
      _currentFilterQuery += ' $query'; // Append the new filter to the current query
    } else {
      _currentFilterQuery = query;
    }
    _searchController.text = _currentFilterQuery; // Update the search field
    _applyFilters();
  }

  void _applyFilters() {
    List<String> queries = _currentFilterQuery.split(' ').where((q) => q.isNotEmpty).toList();
    List<dynamic> filtered = widrawreq!.values.where((item) {
      return queries.every((query) =>
        item['Name'].toLowerCase().contains(query) ||
        item['Email'].toLowerCase().contains(query) ||
        item['app'].toLowerCase().contains(query) ||
        item['Amount'].toString().toLowerCase().contains(query)
      );
    }).toList();
    setState(() {
      _filteredRequests = filtered.reversed.toList();
    });
  }
  var textstyl = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
  var textstyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 12);
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
String formatDate(String dateString) {
  // Parse the date string into individual components
  int year = int.parse(dateString.substring(0, 4));
  int month = int.parse(dateString.substring(4, 6));
  int day = int.parse(dateString.substring(6, 8));
  int hour = int.parse(dateString.substring(8, 10));
  int minute = int.parse(dateString.substring(10, 12));
  int second = int.parse(dateString.substring(12, 14));

  // Create a DateTime object
  DateTime dateTime = DateTime(year, month, day, hour, minute, second);
String _twoDigits(int n) => n.toString().padLeft(2, '0');
  // Format the DateTime object to a desired string format
  String formattedDate = '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
      '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';

  return formattedDate;
}


      String dateString = "20240807115410";
  String formattedDate = formatDate(dateString);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: TextButton(
          child: Text(
            '🔄',
            style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0), fontSize: 30),
          ),
          onPressed: () {
            getwidreq();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Successfully Updated"),
            ));
          },
        ),
        automaticallyImplyLeading: true,

        title: Row(
          children: [
            TextButton(
              child: Text(
                '👈',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 30),
              ),
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsLog(),));
              },
            ),
            TextButton(
              child: Text(
                '🗑️',
                style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0), fontSize: 30),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Webvie()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            TextButton(
              child: Text('70',style: TextStyle(fontSize: 20,color: Colors.white, backgroundColor: Colors.black),),
              onPressed: () => _quickFilter('70'),
            ),
                TextButton(
              child: Text('100',style: TextStyle(fontSize: 20,color: Colors.white, backgroundColor: Colors.black),),
              onPressed: () => _quickFilter('100'),
            ),
            TextButton(
             child: Text('sha',style: TextStyle(fontSize: 18,color: Colors.white,backgroundColor: Colors.black ),),
              onPressed: () => _quickFilter('shahid'),
            ),
               TextButton(
             child: Text('zah',style: TextStyle(fontSize: 15,color: Colors.white,backgroundColor: Colors.black),),
              onPressed: () => _quickFilter('zahe'),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _filteredRequests.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
            color: Colors.white,
                      height: 60,
                      child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  double amoun = double.parse( 
                                      _filteredRequests[index]['Amount']);
                                  int amount = amoun.toInt();
                              
                                  var a = await http.get(Uri.parse(
                                      'https://elitezeen.com/UpdateBallance/${_filteredRequests[index]['Email']}/${amount}/Success/${_filteredRequests[index]['Date']}'));
                                  // print(a);
                                  setState(() {
                                    getwidreq();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Updating balance"),
                                    ));
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      '${_filteredRequests[index]['Status']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${_filteredRequests[index]['Name']}',
                                      style: textstyl),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${_filteredRequests[index]['Amount']} \n ${_filteredRequests[index]['app']}\n${formatDate(_filteredRequests[index]['extra'])}',
                                    style: textstyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
