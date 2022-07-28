library api_service;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saberion_assesment/config/url_config.dart' as config;
import 'package:saberion_assesment/services/shared_preferences_services.dart'
    as shared_preferences;

/// create http header
Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

/// create http get request and fetching data from the server
Future<http.Response> fetchGet(String path) async {
  var token = await shared_preferences.getToken();
  if (token != null && token != "") {
    headers['Authorization'] = "$token";
  }
  final response =
      await http.get(Uri.parse(config.apiPath + path), headers: headers);
  return response;
}

/// create http post request and post data to the server
Future<http.Response> fetchPost(String path, Object body) async {
  var encodeBody = json.encode(body);
  var token = await shared_preferences.getToken();
  if (token != null && token != "") {
    headers['Authorization'] = "$token";
  }
  final response = await http.post(Uri.parse(config.apiPath + path),
      body: encodeBody, headers: headers);
  return response;
}

/// create http put request and update data in server
Future<http.Response> fetchPut(String path, Object body) async {
  var encodeBody = json.encode(body);

  var token = await shared_preferences.getToken();
  if (token != null && token != "") {
    headers['Authorization'] = "$token";
  }
  final response = await http.put(Uri.parse(config.apiPath + path),
      body: encodeBody, headers: headers);

  return response;
}

/// create http put request and delete data from the server
Future<http.Response> fetchDelete(String params) async {
  var token = await shared_preferences.getToken();
  if (token != null && token != "") {
    headers['Authorization'] = "$token";
  }
  final response =
      await http.delete(Uri.parse(config.apiPath + params), headers: headers);
  return response;
}

// Future filterTags(String patten) async {
//   var token = await shared_preferences.getToken();
//   if (token != null && token != "") {
//     headers['Authorization'] = "Token $token";
//   }
//   var params = "tags?limit=10&page=1&search=" + patten;
//   final response =
//       await http.get(Uri.parse(config.apiPath + params), headers: headers);
//   if (response.statusCode == 200) {
//     var res = json.decode(response.body);
//     return res['data'];
//   } else {
//     // var res = json.decode(response.body);
//     return [];
//   }
// }
