import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

// ignore: camel_case_types
class httpUtil {
  String baseUrl;

  httpUtil({
    this.baseUrl,
  });

  Future<Map<String, dynamic>> Get(url, Map<String, String> header) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"ok": false, "err": response.body};
    }
  }

  Future<Map<String, dynamic>> Post(url, Map<String, String> header, Map body) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var response = await http.post(url, headers: header, body: json.encode(body), encoding: utf8);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      if (response.statusCode == 401) {

      }
      return {"ok": false, "err": response.body};
    }
  }

  Future<Map<String, dynamic>> PostStream(url, Map<String, String> header,String fileName, bool ec, List<int> body) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var digest = md5.convert(body);
    url += hex.encode(digest.bytes);
    url += "?fn=" + fileName + "&ec=" + ec.toString();

    HttpClient httpClient = new HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = new IOClient(httpClient);
    var res = await ioClient.post(url, headers: header, body: body, encoding: utf8);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return {"ok": false, "err": res.body};
    }
  }

  Future<Map<String, dynamic>> PostString(url, Map<String, String> header, String body) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var response = await http.post(url, headers: header, body: body, encoding: utf8);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"ok": false, "err": response.body};
    }
  }

  Future<Map<String, dynamic>> Put(url, Map<String, String> header, Map body) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var response = await http.put(url, headers: header, body: body, encoding: utf8);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"ok": false, "err": response.body};
    }
  }

  Future<Map<String, dynamic>> PutString(url, Map<String, String> header, String body) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var response = await http.put(url, headers: header, body: body, encoding: utf8);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"ok": false, "err": response.body};
    }
  }

  Future<Map<String, dynamic>> Delete(url, Map<String, String> header) async {
    if (url != "") {
      url = this.baseUrl + url;
    }
    var response = await http.delete(url, headers: header);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {"ok": false, "err": response.body};
    }
  }

}
