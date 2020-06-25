import 'package:budget_tracker/EbookCartPage.dart';
import 'package:budget_tracker/MainPage.dart';
import 'package:budget_tracker/SplashPage.dart';
import 'package:flutter/services.dart';

import 'order.dart';
import 'package:budget_tracker/OrderDetailPage.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(PaymentHistoryPage());

class PaymentHistoryPage extends StatefulWidget {
  final User user;
  const PaymentHistoryPage({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryPageState createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  List _paymentdata;

  String titlecenter = "Loading payment history...";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  String server = "http://shabab-it.com/budget_tracker";

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        drawer: navigationDrawer(context),
        appBar: AppBar(
          title: Text(
            'Payment History',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: secondaryColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(MdiIcons.home),
              onPressed: () => {
                Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => MainPage(
                              user: widget.user,
                            ))),
              },
            )
          ],
        ),
        body: Stack(children: <Widget>[
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
              _paymentdata == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                              child: Text(
                      titlecenter,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ))))
                  : Expanded(
                      child: ListView.builder(
                          //Step 6: Count the data
                          itemCount:
                              _paymentdata == null ? 0 : _paymentdata.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                                child: InkWell(
                                    onTap: () => loadOrderDetails(index),
                                    child: Card(
                                      elevation: 10,
                                      child: Column(
                                        //crossAxisAlignment:
                                        //CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Payment " +
                                                  (index + 1).toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(
                                              width: screenHeight / 1.5,
                                              child: Container(
                                                height: 2,
                                                color: Colors.grey,
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text("Total Price Pay: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    Text(
                                                      "RM " +
                                                          _paymentdata[index]
                                                              ['total'], style: TextStyle(fontSize: 16)
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("Order ID: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    Text(
                                                      _paymentdata[index]
                                                          ['orderid'], style: TextStyle(fontSize: 16)
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("Bill ID: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    Text(
                                                      _paymentdata[index]
                                                          ['billid'], style: TextStyle(fontSize: 16)
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Text("Date Purchased: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                    Text(
                                                      f.format(DateTime.parse(
                                                          _paymentdata[index]
                                                              ['date'])), style: TextStyle( fontSize: 16)
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )));
                          }))
            ],
          )
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs = server + "/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailPage(
                  order: order,
                )));
  }

  Widget navigationDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            decoration: BoxDecoration(color: secondaryColor),
            otherAccountsPictures: <Widget>[
              // Text("RM " + widget.user.credit,
              //     style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0, color: secondaryColor),
              ),
              // backgroundImage: NetworkImage(
              //     server + "/profileimages/${widget.user.email}.jpg?"),
            ),
            // onDetailsPressed: () => {
            //   Navigator.pop(context),
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (BuildContext context) => ProfileScreen(
            //                 user: widget.user,
            //               )))
            // },
          ),
          ListTile(
            title: Text(
              "My Profile",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: Icon(Icons.person),
            onTap: null,
          ),
          ListTile(
            title: Text(
              "My Cart",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: Icon(MdiIcons.cart),
            onTap: () async {
              if (widget.user.quantity == "0") {
                Toast.show("Cart empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              }
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EbookCartPage(
                            user: widget.user,
                          )));
              _loadCartQuantity();
            },
          ),
          ListTile(
            title: Text(
              "Payment History",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: Icon(Icons.payment),
            onTap: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentHistoryPage(
                            user: widget.user,
                          ))),
            },
          ),
          ListTile(
            title: Text(
              "Log Out",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: Icon(MdiIcons.logout),
            onTap: null,
          ),
        ],
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

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }
}
