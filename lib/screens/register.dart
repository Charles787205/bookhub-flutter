import 'package:bookhub/components/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/scripts/database.dart';
import 'package:bookhub/objects/user.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/widgets/logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _email = "";
  var _password = "";
  var _password1 = "";
  var _firstName = "";
  var _lastName = "";
  var _middleName = "";

  Future<void> register() async {
    if (_password != _password1) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")));
    } else {
      var userInput = User(
          email: _email,
          firstName: _firstName,
          lastName: _lastName,
          middleName: _middleName,
          password: _password);
      User? user = await DatabaseConnector.register(userInput);
      if (user == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("An error occurred")));
      } else {
        if (context.mounted) {
          context.read<AuthManager>().setUser(user);
          Navigator.popAndPushNamed(context, "/");
        }
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User registered successfully")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register",
              style: TextStyle(color: Colors.white, fontSize: 24.0)),
          elevation: 3.0,
          shadowColor: Colors.black,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                Logo(fontSize: 50),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your first name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  onChanged: (value) => _firstName = value,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your middle name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  onChanged: (value) => _middleName = value,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your last name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  onChanged: (value) => _lastName = value,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your email',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  onChanged: (value) => _email = value,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your password',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  onChanged: (value) => _password = value,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Re-enter your password',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  onChanged: (value) => _password1 = value,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(500, 50),
                  ),
                  onPressed: () {
                    register();
                  },
                  child: const Text("Register"),
                )
              ])),
        ));
  }
}
