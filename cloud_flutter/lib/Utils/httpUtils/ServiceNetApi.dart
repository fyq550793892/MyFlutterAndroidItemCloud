import 'dart:async';

import 'DioNetUtils.dart';
import 'Method.dart';


class ServiceNetApi {
  ///获取用户信息
  Future<Map> getSingleDataById(data) async {
    return await DioNetUtils().request<String>(
        "/**/**/yingqi/**/getSingleDataById",
        queryParameters: data,
        method:Method.put
    );
  }
}