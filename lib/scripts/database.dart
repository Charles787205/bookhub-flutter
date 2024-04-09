import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookhub/objects/user.dart';

class DatabaseConnector {
  static String url = "10.0.2.2";

  static Future<User?> login(String email, String password) async {
    var response = await http.post(Uri.http(url, "/bookhub/api/user/login.php"),
        body: jsonEncode(<String, String>{
          'password': password,
          'email': email,
        }));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      if (jsonDecode(response.body) == "null") {
        return null;
      }
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<User?> register(User user) async {
    var response =
        await http.post(Uri.http(url, "/bookhub/api/user/register.php"),
            body: jsonEncode(<String, String>{
              'first_name': user.firstName,
              'middle_name': user.middleName,
              'last_name': user.lastName,
              'email': user.email,
              'password': user.password!,
            }));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      if (jsonDecode(response.body) == "null") {
        return null;
      }
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
