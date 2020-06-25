import 'dart:async';
import 'dart:convert';
import 'package:budget_tracker/PaymentHistoryPage.dart';
import 'package:budget_tracker/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

void main() => runApp(DashboardPage());

class DashboardPage extends StatefulWidget {
  final User user;
  const DashboardPage({Key key, this.user}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

@override
class _DashboardPageState extends State<DashboardPage> {
  List userData;
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String titleCenter = "Loading\nPlease Wait...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //title: 'Material App',
        home: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomPadding: false,
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.add_event,
            backgroundColor: primaryColor,
            children: [
              SpeedDialChild(
                  child: Icon(MdiIcons.cashPlus),
                  label: "Add New Income",
                  backgroundColor: primaryColor,
                  onTap: null),
              SpeedDialChild(
                  child: Icon(MdiIcons.cashMinus),
                  label: "Add New Expense",
                  backgroundColor: primaryColor, //_changeLocality()
                  onTap: () => null),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/images/Logo.png'))),
              ),
              Container(
                color: Color.fromRGBO(255, 255, 255, 0.19),
              ),
              Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 10,
                child: Container(
                  height: screenHeight / 10,
                  width: screenWidth / 1.2,
                  margin: EdgeInsets.all(20),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Month"),
                      Text(
                          "---------------------------------------------------------------------------------"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Income"),
                          Text("Expenses"),
                          Text("Balance")
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("RM 1000.00"),
                              Text("RM 10.00"),
                              Text("RM 990.00"),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              userData == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titleCenter,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            return Container(
                              //height: screenHeight / 10,
                              //width: screenWidth / 1.2,
                              margin: EdgeInsets.fromLTRB(11, 5, 11, 5),
                              child: Card(
                                  elevation: 10,
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      // GestureDetector(),
                                      Container(
                                        child: dataType(index),
                                        margin: EdgeInsets.all(15),
                                      ),
                                      Container(
                                        width: screenWidth / 1.5,
                                        margin: EdgeInsets.all(15),
                                        child: Column(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              userData[index]['type'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  userData[index]['title'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                ),
                                                Text(
                                                  "RM " +
                                                      userData[index]['total'],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),

                                            // Text(
                                            //   userData[index]['description'],
                                            //   style: TextStyle(color: Colors.black),
                                            // ),
                                            // Text(
                                            //   userData[index]['date'],
                                            //   style: TextStyle(color: Colors.black),
                                            // ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          })),
            ],
          ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text("Exit an app?"),
                  content: new Text("Are you sure you want to exit"),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text("Exit"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("Cancel"),
                    )
                  ],
                )) ??
        false;
  }

  void loadData() async {
    String urlLoadData =
        "http://shabab-it.com/budget_tracker/php/load_data.php";
    await http.post(urlLoadData, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "Data Empty") {
        // cartQuantity = "0";
        titleCenter = "No Data Found";
        print(res.body);
        setState(() {
          userData = null;
        });
      } else {
        setState(() {
          print(res.body);
          var extractdata = json.decode(res.body);
          userData = extractdata["data"];
          // cartQuantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget dataType(index) {
    if (userData[index]['type'] == "Income") {
      return CircleAvatar(
        backgroundColor: blueishColor,
        child: Text(
          "I",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      );
    } else {
      return CircleAvatar(
        backgroundColor: secondaryColor,
        child: Text(
          "E",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      );
    }
  }
}
