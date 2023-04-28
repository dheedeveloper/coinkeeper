import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


Future<http.Response> pushNotification(Map data) async {
  var headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    // HttpHeaders.cacheControlHeader: 'no-cache',
    "Authorization": "key=AAAAjlL_U-4:APA91bFoF64ruedVJc4mE--E3Y7wQVy6mx7OK-NPQWIWRQLGCcEcuLubl4CyZBuS3N0rRpEhNgDsiD3ZiEn_sF_LUxygO8xIm5FND40d1yahoHTVzLzegy5O40gXlFYFc0ApnOQn0jZS",
  };
  print(jsonEncode(headers));
  var client = new http.Client();
  var response =
  await client.post(Uri.parse("https://fcm.googleapis.com/fcm/send"), body: jsonEncode(data), headers: headers);

  print(response.statusCode);
  print(response.body);
  return response;
}