import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<StatefulWidget> createState() {
    return new _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var _count;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onEvent(Object event) {
    setState(() {
      _count = event;
      print("ChannelPage: $event");
    });
  }

  void _onError(Object error) {
    print("onError: $error");
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login_bg.png'),
          )
        ),
        child: Container(
          //通过ConstrainedBox来确保Stack占满屏幕
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Stack(
              alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Container(child: Text("Hello world",
                    style: TextStyle(color: Colors.white)),
                  color: Colors.red,
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: Text(
                    "您好",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32
                    ),
                  ),

                ),
                Positioned(
                  top: 80.0,
                  left: 10,
                  child:Text(
                    "欢迎登录博汇乐课",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    )
    );
  }
}
