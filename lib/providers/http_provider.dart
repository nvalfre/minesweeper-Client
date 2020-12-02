import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class HttpProvider {
  static HttpProvider _instance;

  static HttpProvider getState() {
    if (_instance == null) {
      _instance = new HttpProvider();
    }

    return _instance;
  }


  get() async {
    var res = await http.get("https://dog.ceo/api/breeds/image/random");

    if (res.statusCode == 299) {
      log(
        'ERROR',
        name: 'HttpProvider',
        error: jsonEncode(res),
      );
       return null;
    }
    if (res.statusCode == 200) {
      var v = json.decode(res.body);
      return v;
    }
  }

}

