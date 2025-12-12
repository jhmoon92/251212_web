import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

const DEFAULT_TIMEOUT = 15;
const API_MOBILE = "homesens_api/mobile/";

const int responseTimeOut = 10;
const int responseTimeInterval = 1; // 1초 간격

bool statusCodeSuccess(int code) {
  if (code >= 200 && code < 300) {
    return true;
  }
  return false;
}

bool stringError(String? value) => (value != null && value.isNotEmpty);

class ApiResponse {
  int statusCode;
  String body;

  ApiResponse([this.statusCode = 0, this.body = ""]);
}

abstract class Api {
  httpGet(String url);
  httpPost(String url, accessToken, data);
  httpPut(String url, data);
// httpDelete(String url, data);
// dioPost(String url, formData);
// httpUpdate(String url, data);
// httpPostFile(String url, accessToken, data, File file);
}

enum ApiType {
  cloudConfig,
  cloudServerSetting,
  cloudAuth,
  cloudPeople,
  cloudPlace,
  cloudCommon,
  cPEGateway,
  cPEWifi,
  cloudHistory,
  cloudAlarm,
  cloudReport,
  cloudAll,
}

abstract class FailureException implements Exception {
  final dynamic type;
  final dynamic code;
  final String message;

  const FailureException(this.type, this.code, [this.message = ""]);

  dynamic get failureType => type;
  dynamic get failureCode => code;

  @override
  String toString() {
    String report = "Exception";
    if (message.isEmpty) {
      report = "Failure type is $type, code is $code";
    } else {
      report = "$report $message";
    }
    return report;
  }
}

class ClientProvider {
  ClientProvider(this.client, this.type);
  final BaseApi client;
  final dynamic type;
  dynamic get apiType => type;
}

class BaseApi implements Api {
  final String _baseAddressHttps = "https://%{1}/";
  final String _baseAddressHttp = "http://%{1}/";
  BaseApi(
      this.serverUrl, {
        this.token,
        this.tokenType = "Bearer",
        this.isHttp = false,
      });

  final String serverUrl;
  String? token;
  String? tokenType;
  bool isHttp;

  static const int errorRetry = 3;

  final _timeout = const Duration(seconds: DEFAULT_TIMEOUT);

  String get baseUrl => strFormat(isHttp ? _baseAddressHttp : _baseAddressHttps, [serverUrl]);
  String get ipAddress => baseUrl;

  String get requestHeader => token ?? "notoken";
  Future<void> logProviderException(url, statusCode, String? jsonString, exception, stackTrace, [String? body]) async {
    String errorMessage = "";
    String errorCode = "";
    String sentryUrl = ipAddress + url;
    String requestBody = body ?? "nobody";

    Map<String, dynamic> errorData = {};
    if (jsonString != null && jsonString.isNotEmpty) {
      errorData = jsonDecode(jsonString);
      errorMessage = errorData["message"];
      errorCode = errorData["code"];
    }
    if (errorMessage.isEmpty) errorMessage = exception.toString();
    if (errorCode.isEmpty) errorCode = statusCode.toString();

    // Sentry.captureException('AccountID : $accountId,\n'
    //     'UserName : $username,\n'
    //     'ServerURL : $url,\n'
    //     'request header : $requestHeader,\n'
    //     'request body : $requestBody,\n'
    //     'ErrorMessage : $errorMessage,\n'
    //     'ErrorCode : $errorCode,\n');
  }

  @override
  Future<ApiResponse> httpGet(String url, [Duration? timeout]) async {
    // await checkNetworkConnection();

    HttpClient client = HttpClient();
    client.connectionTimeout = timeout ?? _timeout;
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    int? statusCode = 0;
    String? jsonString;

    try {
      //print("http get token is $token");
      HttpClientRequest request = await client.getUrl(Uri.parse(ipAddress + url));

      if (!isHttp) {
        /// server api
        //if (token.isNotEmpty) request.headers.set('Authorization', 'Token $token');
        if (stringError(token)) request.headers.set('Authorization', '$tokenType $token');

      } else {
        /// for cpe local
        if (stringError(token)) request.headers.set('Access-Token', token!);
      }
      // print("TOKEN : ${Factory.Instance.token}");
      debugPrint('[HTTP Get] ${ipAddress + url} header $requestHeader');
      HttpClientResponse response = await request.close();
      jsonString = await response.transform(utf8.decoder).join();
      //print('${jsonString}');
      statusCode = response.statusCode;
      client.findProxy = null;
      debugPrint('[HTTP Get] repose ${response.statusCode}, and body is $jsonString');
      // if (response.statusCode == 401) {
      //   throw forcePeopleSignOutException;
      // } else if (response.statusCode == 403) {
      //   // account 관련 API에서만 403 에러 발생
      //   Map<String, dynamic> resMap = jsonDecode(jsonString.toString());
      //   if (resMap['code'] == cloudErrorCodeC014) {
      //     throw accessDenied;
      //   } else if (resMap['code'] == cloudErrorCodeC019) {
      //     throw noEmailException;
      //   } else {
      //     throw tokenExpiredException;
      //   }
      // } else if (response.statusCode == 500) {
      //   throw serverErrorException;
      // } else if (response.statusCode == 404) {
      //   throw serverErrorException;
      // }
      return ApiResponse(response.statusCode, jsonString);
      // } on FormatException {
      //   // transform
      //   return ApiResponse(_timeoutCode, "");
      // } on Not200ErrorException catch (exception, stackTrace) {
      //   // String userID = Factory.Instance.username;
      //   // String serverUrl = LocalDb.Instance.serverUrl;
      //   // Sentry.captureException('UserID : $userID,\n'
      //   //     'ServerURL : $serverUrl,\n'
      //   //     'StatusCode : $statusCode,\n'
      //   //     'URL : $url,\n'
      //   //     'Method : HttpGET,\n'
      //   //     'stacktrace\n$stackTrace');
      //   if (statusCode == `401`) {
      //     throw new TokenExpiredException('url:$url');
      //   }
      //   return ApiResponse(statusCode!, jsonString!);
    } on SocketException {
      // throw networkErrorException;
      rethrow;
    } on FormatException {
      // transform

      // throw networkErrorException;
      rethrow;
    } catch (exception, stackTrace) {
      // print("HttpGET Error");
      // logProviderException((ipAddress + url), statusCode, jsonString, exception, stackTrace.toString());
      //
      // if (exception == forcePeopleSignOutException) {
      //   GlobalErrorHandler.showForcePeopleSignOuErrorDialog(exception.toString());
      // }
      //
      // if (exception == tokenExpiredException || exception == accessDenied) {
      //   GlobalErrorHandler.showTokenExpiredErrorDialog(exception.toString());
      // }

      rethrow;
    } finally {
      client.close();
    }
  }

  @override
  Future<ApiResponse> httpPost(String url, key, data, [String email = ""]) async {
    // await checkNetworkConnection();
    HttpClient client = HttpClient();
    client.connectionTimeout = _timeout;
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    int? statusCode = 0;
    String? jsonString;

    try {
      HttpClientRequest request = await client.postUrl(Uri.parse(ipAddress + url));

      if (stringError(token)) {
        //request.headers.set('Authorization', 'Token $token');
        if (key == 'local') {
          request.headers.set('Access-Token', '$token');
        } else {
          request.headers.set('Authorization', '$tokenType $token');
        }
        //print("token is not null $token");
      } else {
        //print("token is null");
      }
      // print(token);
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      if (data != null) {
        List<int> bodyBytes = utf8.encode(data);
        request.contentLength = bodyBytes.length;
        request.add(bodyBytes);
        //print(data);
      }
      debugPrint('[HTTP Post] ${ipAddress + url} body ${data.toString()} header $requestHeader');
      HttpClientResponse response = await request.close();
      jsonString = await response.transform(utf8.decoder).join();
      statusCode = response.statusCode;
      client.findProxy = null;
      debugPrint('[HTTP Post] response ${response.statusCode}, and body is $jsonString');

      // if (response.statusCode == 401) {
      //   Map<String, dynamic> resMap = jsonDecode(jsonString.toString());
      //   if (!resMap.containsKey('code')) {
      //     throw forcePeopleSignOutException;
      //   }
      // } else if (response.statusCode == 403) {
      //   // account 관련 API에서만 403 에러 발생
      //   Map<String, dynamic> resMap = jsonDecode(jsonString.toString());
      //   if (resMap['code'] == cloudErrorCodeC014) {
      //     throw accessDenied;
      //   } else if (resMap['code'] == cloudErrorCodeC019) {
      //     throw noEmailException;
      //   } else {
      //     throw tokenExpiredException;
      //   }
      // }
      // if (response.statusCode == 500) {
      //   throw serverErrorException;
      // } else if (response.statusCode == 404) {
      //   throw serverErrorException;
      // }
      return ApiResponse(response.statusCode, jsonString);
    } on SocketException {
      // throw networkErrorException;
      rethrow;
    } on FormatException {
      // transform
      print("FormatException");
      // throw networkErrorException;
      rethrow;
    } catch (exception, stackTrace) {
      // logProviderException((ipAddress + url), statusCode, jsonString, exception, stackTrace.toString(), data);
      // if (exception == forcePeopleSignOutException) {
      //   GlobalErrorHandler.showForcePeopleSignOuErrorDialog(exception.toString());
      // }
      //
      // if (exception == tokenExpiredException || exception == accessDenied) {
      //   GlobalErrorHandler.showTokenExpiredErrorDialog(exception.toString());
      // }

      rethrow;
    } finally {
      client.close();
    }
  }

  @override
  Future<ApiResponse> httpPut(String url, data) async {
    // await checkNetworkConnection();
    HttpClient client = HttpClient();
    client.connectionTimeout = _timeout;
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    int? statusCode = 0;
    String? jsonString;

    try {
      HttpClientRequest request = await client.putUrl(Uri.parse(ipAddress + url));

      if (stringError(token)) {
        //request.headers.set('Authorization', 'Token $token');
        request.headers.set('Authorization', '$tokenType $token');
        //print("token is not null $token");
      } else {
        print("token is null");
      }
      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      //print(request.toString());

      if (data != null) {
        List<int> bodyBytes = utf8.encode(data);
        request.contentLength = bodyBytes.length;
        request.add(bodyBytes);
        //print(data);
      }
      debugPrint('[HTTP Put] ${ipAddress + url} body ${data.toString()}');
      HttpClientResponse response = await request.close();
      jsonString = await response.transform(utf8.decoder).join();
      statusCode = response.statusCode;
      client.findProxy = null;
      debugPrint('[HTTP Put] response ${response.statusCode}, and body is $jsonString header $requestHeader');
      // if (response.statusCode == 401) {
      //   throw forcePeopleSignOutException;
      // } else if (response.statusCode == 403) {
      //   //statusCode = response.statusCode;
      //   Map<String, dynamic> resMap = jsonDecode(jsonString.toString());
      //   if (resMap['code'] == cloudErrorCodeC014) {
      //     throw accessDenied;
      //   } else
      //     throw tokenExpiredException;
      // }
      // if (response.statusCode == 500) {
      //   throw serverErrorException;
      // } else if (response.statusCode == 404) {
      //   throw serverErrorException;
      // }
      return ApiResponse(response.statusCode, jsonString);
    } on SocketException {
      // throw networkErrorException;
      rethrow;
    } on FormatException {
      // transform
      print("FormatException");
      // throw networkErrorException;
      rethrow;

      // } on Not200ErrorException catch (exception, stackTrace) {
      //   print(exception.toString());
      //   // String userID = Factory.Instance.username;
      //   // String serverUrl = LocalDb.Instance.serverUrl;
      //   // Sentry.captureException('UserID : $userID,\n'
      //   //     'ServerURL : $serverUrl,\n'
      //   //     'StatusCode : $statusCode,\n'
      //   //     'URL : $url,\n'
      //   //     'Method : HttpPOST,\n'
      //   //     'stacktrace\n$stackTrace');
      //   if (statusCode == 401) {
      //     throw TokenExpiredException('url:$url');
      //   } else if (statusCode == 404) {
      //     throw Exception('http 404');
      //   }
      //   return ApiResponse(statusCode!, jsonString!);
    } catch (exception, stackTrace) {
      // print("httpPut Error");
      // logProviderException((ipAddress + url), statusCode, jsonString, exception, stackTrace.toString(), data);
      // if (exception == forcePeopleSignOutException) {
      //   GlobalErrorHandler.showForcePeopleSignOuErrorDialog(exception.toString());
      // }
      // if (exception == tokenExpiredException || exception == accessDenied) {
      //   GlobalErrorHandler.showTokenExpiredErrorDialog(exception.toString());
      // }

      rethrow;
    } finally {
      client.close();
    }
  }

  Future<bool> checkNetworkConnection({int retries = 3}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        List<ConnectivityResult> conn = await Connectivity().checkConnectivity();
        // if (conn.contains(ConnectivityResult.none)) throw networkDisconnectException;
        final result = await InternetAddress.lookup(serverUrl);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        } else {
          return false;
          // throw networkDisconnectException;
        }
      } catch (e, s) {
        //debugPrint("Attempt ${attempt + 1} failed: $e");
      }
      // Delay before retrying, if more attempts remain
      if (attempt < retries - 1) {
        /// 사람이 기다릴수 있는 시간 3초이므로 최대 2.4초로 설정
        await Future.delayed(Duration(milliseconds: 800));
      }
    }
    debugPrint("checkNetworkConnection error 3retry error ");
    // throw networkDisconnectException;
    return false;
  }
}

// ------------------------------------------ //
String strFormat(String string, List<String> params) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('%{${i + 1}}', params[i]);
  }

  return result;
}
