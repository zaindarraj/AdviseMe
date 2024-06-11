
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();





Future<void> insert (String key, String value)async{
      await flutterSecureStorage.write(key: key, value: value);
}

Future<String?> read(String key)async{
  return await flutterSecureStorage.read(key: key);
}

