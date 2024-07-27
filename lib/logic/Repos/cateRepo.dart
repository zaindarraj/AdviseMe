import 'dart:convert';

import 'package:advise_me/logic/classes/consts.dart';
import 'package:http/http.dart' as http;

import '../classes/category.dart';
import '../data center/data_center.dart';

class CateRepo {
  static Future<List<Category>> getCats() async {
    try {
      http.StreamedResponse response =
          await DataCenter.contactCenter("$mainUrl/getCategories.php", {});
      print(response.statusCode);
      if (response.statusCode == 200) {
        var worked = await http.Response.fromStream(response);

        final result = jsonDecode(worked.body) as List<dynamic>;
        print(result);
        List<Category> list = [];
        for (var element in result) {
          list.add(Category.fromJson(element));
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
