import 'dart:convert';

import 'package:advise_me/logic/classes/consts.dart';
import 'package:advise_me/logic/data%20center/data_center.dart';
import 'package:advise_me/strings.dart';
import 'package:http/http.dart' as http;

class AdminRepo {
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("$mainUrl/getAllUsers.php", {});
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as List<dynamic>;
        List<Map<String, dynamic>> list = [];
        for (var element in result) {
          list.add(Map.from(element));
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingConsultants() async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "$mainUrl/getPendingConsultant.php", {});
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as List<dynamic>;
        List<Map<String, dynamic>> list = [];
        for (var element in result) {
          list.add(Map.from(element));
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingChanges() async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("${mainUrl}getPindingChanges.php", {});
      print("ddddddddddddddddddddddddddddddd");
      print(response.statusCode);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        print(worked.body);
        final result = jsonDecode(worked.body);
        List<Map<String, dynamic>> list = [];
        for (var element in result[0]) {
          list.add(Map.from(element));
        }
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<Map<String, dynamic>> addCategory(
      String name, String image, String bio) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "$mainUrl/addCategory.php",
          {"cat_bio": bio, "cat_name": name, "img": image});
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as Map<String, dynamic>;
        return result;
      }
      return {"code": "-1", "message": error};
    } catch (e) {
      return {"code": "-1", "message": error};
    }
  }

  static Future<Map<String, dynamic>> approveCon(
      Map<String, dynamic> args) async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("$mainUrl/approveRegister.php", args);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as Map<String, dynamic>;
        return result;
      }
      return {"code": "-1", "message": error};
    } catch (e) {
      return {"code": "-1", "message": error};
    }
  }

  static Future<Map<String, dynamic>> approveChanges(
      Map<String, dynamic> args) async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("${mainUrl}approveChanges.php", args);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as Map<String, dynamic>;
        print(result);
        return result;
      }
      return {"code": "-1", "message": error};
    } catch (e) {
      return {"code": "-1", "message": error};
    }
  }
}
