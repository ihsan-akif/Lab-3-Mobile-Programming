import 'dart:async';
import 'package:budget_tracker/ConsultancyServicePage.dart';
import 'package:budget_tracker/DashboardPage.dart';
import 'package:budget_tracker/EbookCartPage.dart';
import 'package:budget_tracker/EbookPage.dart';
import 'package:budget_tracker/PaymentHistoryPage.dart';
import 'package:budget_tracker/StatisticPage.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/User.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  final User user;
  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

@override
class _MainPageState extends State<MainPage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double screenHeight, screenWidth;
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;
  String _title;
  String server = "http://shabab-it.com/budget_tracker";
  String cartQuantity = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCartQuantity();
    _title = "Dashboard";
    cartQuantity = widget.user.quantity;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: Scaffold(
          bottomNavigationBar: _bottomNavigationBar(),
          backgroundColor: backgroundColor,
          drawer: navigationDrawer(context),
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(
              _title,
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: secondaryColor,
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.cart),
                onPressed: () async {
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
              )
            ],
          ),
          body: Center(
            child:
                Navigator(key: _navigatorKey, onGenerateRoute: generateRoute),
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

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          title: Text('Dashboard'),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.chartBar),
          title: Text('Statistic'),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.bookshelf),
          title: Text(
            'E-Book\nCatalogue',
            textAlign: TextAlign.center,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(MdiIcons.face),
          title: Text(
            'Consultancy\nServices',
            textAlign: TextAlign.center,
          ),
        ),
      ],
      currentIndex: _currentTabIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onTap,
    );
  }

  void _onTap(int index) {
    setState(() {
      switch (index) {
        case 0:
          _navigatorKey.currentState.pushReplacementNamed("Dashboard");
          _title = "Dashboard";
          _loadCartQuantity();
          cartQuantity = widget.user.quantity;
          break;
        case 1:
          _navigatorKey.currentState.pushReplacementNamed("Statistic");
          _title = "Statistic";
          _loadCartQuantity();
          cartQuantity = widget.user.quantity;
          break;
        case 2:
          _navigatorKey.currentState.pushReplacementNamed("E-Book Catalogue");
          _title = "E-Book Catalogue";
          _loadCartQuantity();
          cartQuantity = widget.user.quantity;
          break;
        case 3:
          _navigatorKey.currentState
              .pushReplacementNamed("Consultancy Services");
          _title = "Consultancy Services";
          _loadCartQuantity();
          cartQuantity = widget.user.quantity;
          break;
      }
    });

    setState(() {
      _currentTabIndex = index;
      _loadCartQuantity();
    });
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "Statistic":
        return MaterialPageRoute(
            builder: (BuildContext context) => StatisticPage(
                  user: widget.user,
                ));
      case "E-Book Catalogue":
        return MaterialPageRoute(
            builder: (BuildContext context) => EbookPage(
                  user: widget.user,
                ));
      case "Ebook Cart Page":
        return MaterialPageRoute(
            builder: (BuildContext context) => EbookCartPage(
                  user: widget.user,
                ));
      case "Consultancy Services":
        return MaterialPageRoute(
            builder: (BuildContext context) => ConsultancyServicePage(
                  user: widget.user,
                ));
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => DashboardPage(
                  user: widget.user,
                ));
    }
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
