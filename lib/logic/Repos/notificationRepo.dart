import 'dart:convert';

import 'package:advise_me/logic/classes/consts.dart';
import 'package:http/http.dart' as http;

import '../data center/data_center.dart';

class NotificationRepo {
  static Future<String> getNotificationsNumber(String accountType) async {
    http.StreamedResponse response = await DataCenter.contactCenter(
        "$mainUrl/getNotification.php", {"accountType": accountType});
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      print(worked);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      if (result["code"].toString() == "1") {
        return result["notifications"].toString();
      } else {
        return "0";
      }
    } else {
      return "0";
    }
  }
}
