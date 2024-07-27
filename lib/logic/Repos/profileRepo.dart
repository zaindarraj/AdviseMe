import 'dart:convert';

import 'package:advise_me/logic/classes/consts.dart';
import 'package:http/http.dart' as http;

import '../../strings.dart';
import '../classes/porfile.dart';
import '../data center/data_center.dart';

class ProfileRepo {
  static Future<dynamic> getProfile(String id) async {
    http.StreamedResponse response = await DataCenter.contactCenter(
        "$mainUrl/getProfile.php", {"user_id": id});
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      print(worked);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      print(result);
      if (result["code"].toString() == "1") {
        return ProfileModel.fromJson(result);
      } else {
        return result["message"];
      }
    } else {
      return error;
    }
  }

  static Future<dynamic> deleteProfile(String id) async {
    http.StreamedResponse response = await DataCenter.contactCenter(
        "$mainUrl/getProfile.php", {"user_id": id});
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      if (result["code"].toString() == "1") {
        return result["message"];
      } else {
        return result["message"];
      }
    } else {
      return error;
    }
  }

  static Future<dynamic> editProfile(Map<String, dynamic> changes) async {
    print(changes);
    http.StreamedResponse response =
        await DataCenter.contactCenter("$mainUrl/editProfile.php", changes);
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      print(result);
      if (result["code"].toString() == "1") {
        return ProfileModel.fromJson(result);
      } else {
        return result["message"];
      }
    } else {
      return error;
    }
  }
}
