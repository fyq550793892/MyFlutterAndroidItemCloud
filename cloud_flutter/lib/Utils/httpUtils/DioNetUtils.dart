import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../SQToast.dart';
import 'Method.dart';
import 'ResultCode.dart';

class DioNetUtils {
  static final DioNetUtils _singleton = DioNetUtils._init();
  static Dio _dio;

  /// 是否是debug模式.
  static bool _isDebug = true;

  /// 打开debug模式.
  static void openDebug() {
    _isDebug = true;
  }

  DioNetUtils._init() {
    BaseOptions options = new BaseOptions(
      baseUrl: "http://lecmini.bhlec.com",
      connectTimeout: 1000 * 1000,
      receiveTimeout: 1000 * 2000,
      //Http请求头.
      headers: {
        //do something
        "version": "1.0.0"
      },
      //请求的Content-Type，默认值是"application/json; charset=utf-8". 也可以用"application/x-www-form-urlencoded"
      // contentType: "application/json; charset=utf-8",
      //表示期望以那种格式(方式)接受响应数据。接受4种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
      responseType: ResponseType.json,
    );
    _dio = Dio(options);
    //添加拦截器
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("请求之前处理");
      return options; //continue
    }, onResponse: (Response response) {
      print("响应之前处理");
      print(options);
      return response; // continue
    }, onError: (DioError e) {
      print("错误之前提示");
      Response errorInfo = _dealErrorInfo(e);
      return errorInfo; //continue
    }));
  }

  factory DioNetUtils() {
    return _singleton;
  }

  /// Make http request with options.
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  /// [options] The request options.
  /// String 返回 json data .
  Future<Map> request<T>(
      String path, {
        String method = Method.get,
        String contentType= "application/json; charset=utf-8",
        queryParameters,
        Options options,
        // CancelToken cancelToken,
      }) async {
    print('path===' + path);
    Response response;
    if (method == Method.get) {
      //GET方式
      response = await _dio.request(
        path,
        queryParameters: queryParameters,
        options: _checkOptions(method, contentType, options),
        // cancelToken: cancelToken,
      );
    } else {
      //除GET的其他方式
      var requestData;
      print(contentType);
      if (contentType == 'application/x-www-form-urlencoded') {//表单方式
        requestData = new FormData.fromMap({
          "name": "jackson影琪",
          "age": 25,
        });
      }else{//json格式
        requestData = queryParameters;
      }
      response = await _dio.request(
        path,
        data: requestData,
        options: _checkOptions(method, contentType, options),
        // cancelToken: cancelToken,
      );
    }

    _printHttpLog(response);
    if (response.statusCode == 200) {
      var data = response.data;
      Map<String, dynamic> dataMap = json.decode(data);//将json转成map
      print("请求数据为：$data");
      try {
        if (dataMap is Map) {
          print("请求数据为：map");
          if (dataMap["status"] != 0) {
            SQToast.show(dataMap["message"]);
            return new Future.error(new DioError(
              response: response,
              type: DioErrorType.RESPONSE,
            ));
          }
          // 由于不同的接口返回的格式不固定不规范，所以需要根据接口格式自定义.
          return dataMap;
        } else {
          if (dataMap is List) {
            print("请求数据为：list");
            Map<String, dynamic> _dataMap = Map();
            _dataMap["data"] = response.data;
            return _dataMap;
          }
        }
      } catch (e) {
        SQToast.show("网络连接不可用，请稍后重试");
        return new Future.error(new DioError(
          response: response,
          // message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
    SQToast.show("网络连接不可用，请稍后重试");
    return new Future.error(new DioError(
      response: response,
      type: DioErrorType.RESPONSE,
    ));
  }

  /// check Options.
  Options _checkOptions(method, contentType, options) {
    if (options == null) {
      options = new Options();
    }
    // if (contentType) {
    //   //设置请求的类型 json 表单
    //   options.contentType = contentType;
    // }
    options.method = method;
    return options;
  }

  // print Http Log.
  void _printHttpLog(Response response) {
    print(!_isDebug);
    if (!_isDebug) {
      return;
    }
    try {
      print("----------------Http Log Start----------------" +
          _getOptionsStr(response.request));
      print(response);
      print("----------------Http Log end----------------");
    } catch (ex) {
      print("Http Log" + " error......");
    }
  }

  // get Options Str.
  String _getOptionsStr(RequestOptions request) {
    return "method: " +
        request.method +
        "  baseUrl: " +
        request.baseUrl +
        "  path: " +
        request.path;
  }

// 错误全局处理
  _dealErrorInfo(error) {
    print(error.type);
    // 请求错误处理
    Response errorResponse;
    if (error.response != null) {
      errorResponse = error.response;
    } else {
      errorResponse = new Response(statusCode: 201);
    }
    // 请求超时
    if (error.type == DioErrorType.CONNECT_TIMEOUT) {
      SQToast.show("网络请求超时，请稍后重试");
      errorResponse.statusCode = ResultCode.CONNECT_TIMEOUT;
    }
    // 请求连接超时
    else if (error.type == DioErrorType.RECEIVE_TIMEOUT) {
      SQToast.show("网络连接超时，请稍后重试");
      errorResponse.statusCode = ResultCode.RECEIVE_TIMEOUT;
    }
    // 服务器错误
    else if (error.type == DioErrorType.RESPONSE) {
      SQToast.show("服务器繁忙，请稍后重试");
      errorResponse.statusCode = ResultCode.RESPONSE;
    }
    // 一般服务器错误
    else {
      SQToast.show("网络连接不可用，请稍后重试1");
      errorResponse.statusCode = ResultCode.DEFAULT;
    }
    return errorResponse;
  }
}

abstract class DioCallback<T> {
  void onSuccess(T t);

  void onError(DioError error);
}