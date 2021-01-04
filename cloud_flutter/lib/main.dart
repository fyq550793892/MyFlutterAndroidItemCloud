import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Models/login_entity.dart';
import 'Utils/httpUtils/ServiceNetApi.dart';
import 'main_activity.dart';

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

  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  var _count;
  var _password = '';//用户名
  var _username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);

    //监听用户名框的输入改变
    _focusNodeUserName.addListener(() {
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if(_userNameController.text.length > 0) {
        _isShowClear = true;
      } else{
        _isShowClear = false;
      }
      setState(() {

      });

    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
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

  Future<Null> _focusNodeListener() async{
    if (_focusNodeUserName.hasFocus) {
      _focusNodePassWord.unfocus();
    }

    if(_focusNodePassWord.hasFocus) {
      _focusNodeUserName.unfocus();
    }
  }

  //获取验证码
  void getCodeData(String phone) async {
    Map<String, String> params = Map();
    params['phone'] = phone;
    params['validTime'] = "1";
    print("phone= $phone");
    await ServiceNetApi().getCodeData(params).then((json) {
      print("验证码的数据为：$json");
    }).catchError((e) {

    });
  }

  //请求登录
  void requestLogin(int type, String phone, String codeNum) async {
    Map<String, String> params = Map();
    params["type"] = type.toString();
    params['identifier'] = phone;
    params['credential'] = codeNum;
    print("验证码为$codeNum");
    await ServiceNetApi().loginRequest(params).then((json) {
      print("登录请求");
      print(json);
      var loginEntity = new LoginEntity.fromJson(json);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp1()),
      );

    }).catchError((e) {
      print(e.toString());
    });
  }


  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width:750,height:1334)..init(context);
    print(ScreenUtil().scaleHeight);

    /**
     * 验证用户名
     */
    String validateUserName(value){
      print("进入验证用户名");
      // 正则匹配手机号
      RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
      if (value.isEmpty) {
        return '用户名不能为空!';
      }else if (!exp.hasMatch(value)) {
        return '请输入正确手机号';
      }
      return null;
    }

    /**
     * 验证密码
     */
    String validatePassWord(value){
      if (value.isEmpty) {
        return '密码不能为空';
      }else if(value.trim().length<6){
        return '密码长度不正确';
      }
      return null;
    }

    //头部区域
    Widget headArea = new Container(
      alignment: Alignment.center,
      child: Container(
          //通过ConstrainedBox来确保Stack占满屏幕
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(300)),
            child: Stack(
              alignment:Alignment.center , //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Positioned(
                  top: 30,
                  left: 20,
                  child: Text(
                    "您好",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: 20,
                  child:Text(
                    "欢迎登录博汇乐课",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                ),
              ],
            )
        )
        )
    );

    //输入区域
    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon:(_isShowClear)
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: (){
                    // 清空输入框内容
                    _userNameController.clear();
                  },
                ) : null ,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value){
                print("进入保存数据");
                _username = value;
              },
            ),
            TextFormField(
              focusNode: _focusNodePassWord,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "密码",
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: RaisedButton(
                  color: Colors.blue,
                  highlightColor: Colors.blue[700],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text("获取验证码"),
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  // icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off,),
                  onPressed: () {
                    setState(() {
                      //只有输入通过验证，才会执行这里
                      _formKey.currentState.save();
                      getCodeData(_username);
                    });
                },
                ),
              ),

              validator: validatePassWord,
              //保存数据
              onSaved: (String value){
                _password = value;
              },
            ),
          ],
        ),

      ),
    );

    Widget loginButtonArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: new RaisedButton(
        onPressed: () {
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();

          if(_formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState.save();
            setState(() {
              requestLogin(2, _username, _password);
            });
          }
        },
        color: Colors.blue,
        child: Text(
          "登录",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        //圆角
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      ),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login_bg.png'),
          )
        ),
        child: new ListView(
          children: <Widget>[
            new SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            headArea,

             new SizedBox(height: ScreenUtil().setHeight(70),),
             inputTextArea,
            new SizedBox(height: ScreenUtil().setHeight(80),),
            loginButtonArea,
          ],
        ),
      ),

    );
  }
}
