import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

import 'config.dart';

Future<bool> SaveData(Map arrInsert, String urlPage, BuildContext context,
    Widget Function() movePage, String type) async {
  String url = path_api + "$urlPage?token=" + token;

  http.Response response = await http.post(url, body: arrInsert);
  if (json.decode(response.body)["code"] == "200") {
    if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    } else {
      Navigator.pop(context);
    }
    print("success");
    return true;
  } else {
    print("Failed");
    return false;
  }
}

Future<Map?> SaveDataList(
    Map arrInsert, String urlPage, BuildContext context, String type) async {
  String url = path_api + "$urlPage?token=" + token;

  http.Response response = await http.post(url, body: arrInsert);
  print(response.body);
  if (json.decode(response.body)["code"] == "200") {
    Map arr = json.decode(response.body)["message"];

    print("success");
    return arr;
  } else {
    print("Failed");
    return null;
  }
}

Future<bool> uploadFileWithData(
    dynamic imageFile,
    Map arrInsert,
    String urlPage,
    BuildContext context,
    Widget Function() movePage,
    String type) async {
  if (imageFile == null) {
    await SaveData(arrInsert, urlPage, context, movePage, type);
    return false;
  }
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

  var length = await imageFile.length();
  String url = path_api + "$urlPage?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile("file", stream, length,
      filename: basename(imageFile.path));
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }

  request.files.add(multipartFile);
  var response = await request.send();

  if (response.statusCode == 200) {
    print("Send successful");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    return true;
  } else {
    return false;
    print("not send");
  }
}

Future<List?> getData(
    int start, int end, String urlPage, String strSearch, String param) async {
  String url = path_api +
      "${urlPage}?${param}txtsearch=${strSearch}&start=${start}&end=${end}&token=" +
      token;
  print(url);
  http.Response response = await http.post(url);

  if (json.decode(response.body)["code"] == "200") {
    {
      List arr = (json.decode(response.body)["message"]);
      print(arr);
      return arr;
    }
  } else {
    return null;
  }
}

Future<bool> deleteData(String colId, String valId, String urlPage) async {
  String url = path_api + "${urlPage}?${colId}=${valId}&token=" + token;
  print(url);
  http.Response response = await http.post(url);

  if (json.decode(response.body)["code"] == "200") {
    return true;
  } else {
    return false;
  }
}
