import 'dart:convert';

class JsonHelper {
  static JsonDecoder jsonDecoder = JsonDecoder();
  static JsonEncoder jsonEncoder = JsonEncoder();

  static dynamic decode(String str) {
    return jsonDecoder.convert(str);
  }

  static String encode(dynamic data) {
    return jsonEncoder.convert(data);
  }
}
