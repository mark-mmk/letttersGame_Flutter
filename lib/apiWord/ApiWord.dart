// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class Apiservice {
//   Future<Letters?> getLetters() async {
//     var url = "https://mocki.io/v1/92bff7d3-8ce3-43d9-b219-3ef090b09664";
//     var res = await http.get(Uri.parse(url));
//     if (res.statusCode == 200) {
//       var decodeResponse = jsonDecode(res.body);
//       return Letters.fromJson(decodeResponse);
//     } else {
//       print("Failed to load letters data");
//       return null;
//     }
//   }
// }