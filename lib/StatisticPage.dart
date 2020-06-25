import 'package:budget_tracker/User.dart';
import 'package:flutter/material.dart';

void main() => runApp(StatisticPage());

class StatisticPage extends StatefulWidget {
  final User user;
  const StatisticPage({Key key, this.user}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  Color primaryColor = Color.fromRGBO(255, 82, 48, 1);
  Color secondaryColor = Color.fromRGBO(249, 178, 51, 1);
  Color backgroundColor = Color.fromRGBO(242, 242, 242, 1);
  Color blueishColor = Color.fromRGBO(0, 255, 255, 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
        ],
      )),
    );
  }
}
