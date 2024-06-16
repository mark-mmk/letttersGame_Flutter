import 'dart:convert';
import 'package:http/http.dart' as http;

import 'letters.dart';

class Apiservice {
  Future<Letters?> getLetters() async {
    var url = "https://mocki.io/v1/f6557703-eaf9-4264-9dbd-99e932166148";
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var decodeResponse = jsonDecode(res.body);
      return Letters.fromJson(decodeResponse);
    } else {
      print("Failed to load letters data");
      return null;
    }
  }
}