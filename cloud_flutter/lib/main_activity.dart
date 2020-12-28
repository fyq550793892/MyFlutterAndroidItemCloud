import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const myPlugin = const MethodChannel('com.flutterToNative');
  static const myEventPlugin = const EventChannel('com.nativeToFlutter');

  StreamSubscription _subscription = null;
  var _count;

  @override
  void initState() {
    super.initState();
    //开启监听
    if(_subscription == null){
      _subscription =  myEventPlugin.receiveBroadcastStream().listen(_onEvent,onError: _onError);
    }

  }

  @override
  void dispose() {
    super.dispose();
    //取消监听
    if(_subscription != null){
      _subscription.cancel();
    }
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

  void getUser() async {
    Map<String, Object> map = {"userId": 101};
    String result = await myPlugin.invokeMethod("getUser", map);
    print(result);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                getUser();
              },
              child: new Text("调用新的原生界面"),
            ),
            Text("收到的值为: $_count"),
          ],
        ),
      ),
    );
  }
}
