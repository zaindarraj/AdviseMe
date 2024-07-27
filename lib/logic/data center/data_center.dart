import 'dart:io';
import 'package:http/http.dart' as http;

class DataCenter {
  static Future<http.StreamedResponse> contactCenter(
      String url, Map<String, dynamic> args) async {
    var postUri = Uri.parse(url);
    var request = http.MultipartRequest("POST", postUri);
    args.forEach((key, value) {
      {
        request.fields[key] = value;
      }
    });
    if (args.containsKey("img")) {
      File file = File.fromUri(Uri.parse(args["img"]));
    
      request.files.add(await http.MultipartFile.fromPath('img', file.path));
    }
    if (args.containsKey("certificate")) {
      File file = File.fromUri(Uri.parse(args["certificate"]));

      request.files
          .add(await http.MultipartFile.fromPath('certificate', file.path));
    }
    if (args.containsKey("cv")) {
      File file = File.fromUri(Uri.parse(args["cv"]));

      request.files.add(await http.MultipartFile.fromPath('cv', file.path));
    }
    return await request.send();
  }
}
