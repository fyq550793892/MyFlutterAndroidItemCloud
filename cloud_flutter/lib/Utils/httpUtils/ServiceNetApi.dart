import 'dart:async';

import 'DioNetUtils.dart';
import 'Method.dart';


class ServiceNetApi {
  //获取验证码
  Future<Map> getCodeData(data) async {
    return await DioNetUtils().request<String>(
        "/api/user/sendMsg",
        queryParameters: data,
        method:Method.get
    );
  }

  //登录
  Future<Map> loginRequest(data) async {
    return await DioNetUtils().request<String>(
        "/api/user/login",
        queryParameters: data,
        method:Method.get
    );
  }
}