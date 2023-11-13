import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hascol_dealer/screens/create_order.dart';
import 'package:hascol_dealer/screens/home.dart';
import 'package:hascol_dealer/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  static const Color contentColorOrange = Color(0xFF00705B);
  final Color leftBarColor = Color(0xFFCB6600);
  final Color rightBarColor = Color(0xFF5BECD2);
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  int _selectedIndex = 1;
  String searchQuery = ''; // State to store the search query
  List<Map<String, dynamic>> filteredData = []; // Filtered list based on search
  List<Map<String, dynamic>> apiData = [];

  create() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("Id");
  }
  Future<List<Map<String, dynamic>>?> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("Id");
    final response = await http.get(Uri.parse('http://151.106.17.246:8080/OMCS-CMS-APIS/get/dealer_orders.php?key=03201232927&id=${id}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  void filterData(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        filteredData = apiData.where((order) => order['id'].contains(query)).toList();
      } else {
        filteredData = List<Map<String, dynamic>>.from(apiData);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);
    return Builder(builder: (context) {
      return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 10,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), // Use the back arrow icon
            color: Color(0xff12283D),
            onPressed: () {
              Navigator.of(context).pop(); // Pop the current page when the back button is pressed
            },
          ),
          title: Text(
            'Orders',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Color(0xff12283D),
                fontSize: 16),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Create_Order()),
                  );
                },
                icon: Icon(
                  // <-- Icon
                  Icons.add,
                  size: 24.0,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff3B8D5A), // Background color
                ),
                label: Text(
                  'Create Order',
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                  ),
                ), // <-- Text
              ),
            ),
          ],
        ),

        body: SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                  await fetchData(); // Add code to fetch and update data here
                print("MOIZ AQIL Rasheed");
                },
              child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  elevation: 5,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(FluentIcons.search_12_regular,
                            color: Color(0xff8d8d8d)),
                        hintText: 'Search using Order Number',
                        hintStyle: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            color: Color(0xff12283D),
                            fontSize: 16),
                        border: InputBorder.none),
                    onChanged: (value) {
                      filterData(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text('No data available.');
                    } else {
                      List<Map<String, dynamic>> apiData = snapshot.data!;
                      filteredData = List<Map<String, dynamic>>.from(apiData); // Assign to filtered data initially
                      if (searchQuery.isNotEmpty) {
                        filteredData = apiData.where((order) => order['id'].contains(searchQuery)).toList();
                      }
                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: filteredData.map((item) {
                          final orderNumber = item["id"];
                          final totalAmount = item['total_amount'];
                          final type = item['type'];
                          final created_at = item['created_at'];
                          final productJsonString = item["product_json"];
                          final current_status = item["current_status"];
                          final List<Map<String, dynamic>> products = List<Map<String, dynamic>>.from(json.decode(productJsonString));
                          print("Khan-----> $products");
                          int index = 0;
                          Color backgroundColor = Colors.white;
                          return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false, // user must tap button!
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text("Order Detail"),
                                        content: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height/4,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Temp Order#'),
                                                      Text('$orderNumber',
                                                        style: TextStyle(fontWeight: FontWeight.bold,),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text('Type:'),
                                                      Text('$type',
                                                        style: TextStyle(fontWeight: FontWeight.bold,),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Product",style: TextStyle(fontWeight: FontWeight.bold,),),
                                                  Text("Quantity",style: TextStyle(fontWeight: FontWeight.bold,),),
                                                  Text("Indent Price",style: TextStyle(fontWeight: FontWeight.bold,),),
                                                  Text("Amount",style: TextStyle(fontWeight: FontWeight.bold,),),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              for (var i = 0; i < products.length; i++)
                                                if (products[i]['quantity'] != null && products[i]['quantity'] != '0')
                                                  Container(
                                                  color: backgroundColor = i % 2 == 0 ? Colors.grey : Colors.white,

                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text("${products[i]['product_name']}"),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("${products[i]['quantity']}"),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("${products[i]['indent_price']}"),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("${products[i]['amount']}"),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                  SizedBox(height: 5,),
                                              SizedBox(height: 10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text('Total Amount: '),
                                                  Text('$totalAmount Rs.',
                                                    style: TextStyle(fontWeight: FontWeight.bold,),
                                                  )

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }
                                          )
                                        ],
                                      );
                                    }
                                    );
                                },
                            child: Card(
                            elevation: 10,
                            color: Color(0xffF0F0F0),
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Order#: $orderNumber',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                                color: Color(0xff12283D),
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              'Quantity: 23000 Ltr.',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w200,
                                                fontStyle: FontStyle.normal,
                                                color: Color(0xff737373),
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              'PKR. $totalAmount',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.normal,
                                                color: Color(0xff3B8D5A),
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 32,
                                            ),
                                            Text(
                                              '$created_at',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w300,
                                                fontStyle: FontStyle.normal,
                                                color: Color(0xff9b9b9b),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Card(
                                              color: Color(0xffFFF3D4),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text(
                                                  '$current_status',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                    color: Color(0xffE7AD18),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            /*
                                            Text(
                                              'Waiting For Approval',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w300,
                                                fontStyle: FontStyle.normal,
                                                color: Color(0xff9b9b9b),
                                                fontSize: 12,
                                              ),
                                            ),
                                            */
                                            SizedBox(
                                              height: 3,
                                            ),
                                            SizedBox(
                                              width: 90,
                                              height: 20,
                                              child: ElevatedButton(
                                                child: Text(
                                                  'Shortage',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w100,
                                                    fontSize: 11,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xff12283D),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        color: Colors.white54,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 30),
                                                            Icon(
                                                              FontAwesomeIcons.cameraRetro,
                                                              color: Color(0xff12283d),
                                                              size: 160,
                                                            ),
                                                            Text(
                                                              'Click Here To Upload Photos',
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: 16,
                                                                fontStyle: FontStyle.normal,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(18.0),
                                                              child: SizedBox(
                                                                height: 50,
                                                                child: TextFormField(
                                                                  onFieldSubmitted: (value) {
                                                                    print(value);
                                                                  },
                                                                  keyboardType: TextInputType.number,
                                                                  style: GoogleFonts.poppins(
                                                                    color: Color(0xffa8a8a8),
                                                                    fontWeight: FontWeight.w300,
                                                                    fontSize: 16,
                                                                    fontStyle: FontStyle.normal,
                                                                  ),
                                                                  decoration: InputDecoration(
                                                                    hintStyle: GoogleFonts.poppins(
                                                                      color: Color(0xffa8a8a8),
                                                                      fontWeight: FontWeight.w300,
                                                                      fontSize: 16,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                    labelStyle: GoogleFonts.poppins(
                                                                      color: Color(0xffa8a8a8),
                                                                      fontWeight: FontWeight.w300,
                                                                      fontSize: 16,
                                                                      fontStyle: FontStyle.normal,
                                                                    ),
                                                                    filled: true,
                                                                    fillColor: Color(0xffF1F4FF),
                                                                    hintText: 'Received',
                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                        width: 2,
                                                                        color: Color(0xff3b5fe0),
                                                                      ),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    ),
                                                                    border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                        width: 2,
                                                                        color: Color(0xffF1F4FF),
                                                                      ),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    ),
                                                                    labelText: 'Received Qty',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 20),
                                                              child: MaterialButton(
                                                                onPressed: () {},
                                                                child: Text(
                                                                  'Add Shortage',
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontFamily: 'SFUIDisplay',
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                                color: Color(0xff12283d),
                                                                elevation: 0,
                                                                minWidth: 350,
                                                                height: 60,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            TextButton.icon(
                                              // <-- TextButton
                                              onPressed: () {},
                                              icon: Icon(
                                                FluentIcons.drawer_arrow_download_24_regular,
                                                size: 16.0,
                                                color: Color(0xff12283D),
                                              ),
                                              label: Text(
                                                'Invoice',
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.normal,
                                                  color: Color(0xff12283D),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),

              ],
          ),
        ),
            )),
        /*
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x8ca9a9a9),
                blurRadius: 20,
              ),
            ],
          ),
          child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              unselectedItemColor: Color(0xff8d8d8d),
              unselectedLabelStyle:
                  const TextStyle(color: Color(0xff8d8d8d), fontSize: 14),
              unselectedFontSize: 14,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedIconTheme: IconThemeData(
                color: Color(0xff12283D),
              ),
              type: BottomNavigationBarType.shifting,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      FluentIcons.home_32_regular,
                      size: 20,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(
                      FluentIcons.weather_sunny_16_regular,
                      size: 20,
                    ),
                    label: 'Orders',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                  icon: Icon(
                    FluentIcons.inprivate_account_16_regular,
                    size: 20,
                  ),
                  label: 'Profile',
                  backgroundColor: Colors.white,
                ),
              ],
              selectedItemColor: Color(0xff12283D),
              iconSize: 40,
              onTap: _onItemTapped,
              elevation: 15),
        ),
        */
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // if (_selectedIndex == 1) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => Orders()),
    //   );
    // }
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    }
  }
}
