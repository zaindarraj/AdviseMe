import 'dart:convert';

import 'package:advise_me/logic/classes/consts.dart';
import 'package:http/http.dart' as http;

import '../../strings.dart';
import '../classes/user.dart';
import '../data center/data_center.dart';

class UserRepo {
  static Future<dynamic> signIn(String email, String password) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "${mainUrl}signin.php", {"email": email, "password": password});

      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        final result = jsonDecode(worked.body) as Map<String, dynamic>;
        print(result);
        if (result["code"].toString() == "1") {
          return UserModel.fromJson(result);
        } else {
          return result["message"];
        }
      } else {
        return error;
      }
    } catch (e) {
      print(e);
      return error;
    }
  }

  static Future<dynamic> verify(String id, String pin) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "${mainUrl}verification_code.php", {"userID": id, "pin": pin});

      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as Map<String, dynamic>;
        if (result["code"].toString() == "1") {
          return UserModel.fromJson(result);
        } else {
          return result["message"];
        }
      } else {
        return error;
      }
    } catch (e) {
      return error;
    }
  }

  static Future<Map<String, dynamic>> deletAccount(String id) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "${mainUrl}deleteAccount.php", {"user_id": id});
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        final result = jsonDecode(worked.body) as Map<String, dynamic>;
        return result;
      } else {
        return {"message": error, "code": "-1"};
      }
    } catch (e) {
      return {"message": error, "code": "-1"};
    }
  }

  static Future<dynamic> signUp(Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}signup.php", args);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      print(result);
      if (result["code"].toString() == "1") {
        return UserModel.fromJson(result);
      } else {
        return result["message"];
      }
    } else {
      return error;
    }
  }

  static Future<Map<String, dynamic>> bookSession(
      Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}bookSession.php", args);

    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      return result;
    } else {
      return {"message": error, "code": "-1"};
    }
  }

  static Future<String> setSechdule(Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}setSchedual.php", args);
    print(args);

    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      return result["message"];
    } else {
      return error;
    }
  }

  static Future<Map<String, dynamic>> setRate(Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}setRate.php", args);
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      print(args);
      return result;
    } else {
      return {"code": "-1", "message": error};
    }
  }

  static Future<int> reset(Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}reset.php", args);
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      return result["code"];
    } else {
      return -1;
    }
  }

  static Future<dynamic> joinSession(Map<String, dynamic> args) async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("${mainUrl}joinSession.php", args);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        final result = jsonDecode(worked.body);
        print(result);
        if (result["messages"].runtimeType == List<dynamic>) {
          return result["messages"];
        } else {
          if (result["code"].toString() == "1") {
            return [];
          } else {
            return result["message"];
          }
        }
      } else {
        return error;
      }
    } catch (e) {
      return error;
    }
  }

  static Future<List> newMessages(Map<String, dynamic> args) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "${mainUrl}recievedMessages.php", args);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        final result = jsonDecode(worked.body);
        if (result.runtimeType == List<dynamic>) {
          return result;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>> cancelSession(
      Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}cancelSession.php", args);
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      return result;
    } else {
      return {"message": error, "code": "-1"};
    }
  }

  static Future<Map<String, dynamic>> sendMessage(
      Map<String, dynamic> args) async {
    http.StreamedResponse response =
        await DataCenter.contactCenter("${mainUrl}sendMessage.php", args);
    if (response.statusCode == 200) {
      var worked = await http.Response.fromStream(response);
      final result = jsonDecode(worked.body) as Map<String, dynamic>;
      return result;
    } else {
      return {"message": error, "code": "-1"};
    }
  }

  static Future<List<Map<String, dynamic>>> getAllConsultants() async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("${mainUrl}getAllConsultants.php", {});
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        final result = jsonDecode(worked.body);

        List<Map<String, dynamic>> list = [];
        if (result is List<dynamic>) {
          for (var element in result) {
            print(element);
            list.add(Map.from(element));
          }
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

  static Future<List<Map<String, dynamic>>> getUpComingSessions(
      Map<String, dynamic> args) async {
    try {
      print(args);
      http.StreamedResponse response =
          await DataCenter.contactCenter("$mainUrl/upComingSessions.php", args);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body);
        List<Map<String, dynamic>> list = [];
        for (var element in result) {
          list.add(Map.from(element));
        }
        return list;
      } else {
        return [];
      }
    } on TypeError catch (e) {
      print(e);
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getSchdules(
      Map<String, dynamic> args) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "$mainUrl/getSchedualesByCon.php", args);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);
        print(worked.body);
        final result = jsonDecode(worked.body);
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

  static Future<List<Map<String, dynamic>>> getByCat(String name) async {
    try {
      http.StreamedResponse response = await DataCenter.contactCenter(
          "$mainUrl/getByCat.php", {"category": name});
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body);
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
}
