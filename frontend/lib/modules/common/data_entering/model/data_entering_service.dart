import 'dart:convert';
import 'dart:io';

import 'package:finance/main_const.dart';
import 'package:finance/modules/common/data_entering/model/item.dart';

class DataEnteringService {
  static Future<List<Item>> getItems(String text) async {
    final url = Uri.parse("http://172.20.10.12:8080/api/process_receipt_text");

    final client = HttpClient();
    final request = await client.postUrl(url);

    // Set content type to JSON
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

    // Create request body
    final body = jsonEncode({"text": text});

    // Write body to the request
    request.write(body);

    final response = await request.close();

    final responseBody = await response.transform(utf8.decoder).join();
    print("Status code: ${response.statusCode}");
    print("Response body: $responseBody");

    if (response.statusCode == 200) {
      return List<Item>.from(
        json.decode(responseBody).map((item) => Item.fromJson(item)),
      );
    } else {
      return [];
    }
  }

  static Future<List<Item>> uploadImage(File image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);

    final url = Uri.parse("http://172.20.10.12:8080/api/process_receipt");

    final client = HttpClient();
    final request = await client.postUrl(url);

    // Set content type to JSON
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

    // Create request body
    final body = jsonEncode({"image_base64": base64String});

    // Write body to the request
    request.write(body);

    final response = await request.close();

    final responseBody = await response.transform(utf8.decoder).join();
    print("Status code: ${response.statusCode}");
    print("Response body: $responseBody");

    if (response.statusCode == 200) {
      return List<Item>.from(
        json.decode(responseBody).map((item) => Item.fromJson(item)),
      );
    } else {
      return [];
    }
  }
}
