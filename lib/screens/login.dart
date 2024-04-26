import 'package:bookhub/components/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/objects/user.dart';
import 'package:bookhub/scripts/database.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _email = "";
  var _password = "";
  User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Login",
            style: TextStyle(color: Colors.white, fontSize: 24.0)),
        elevation: 3.0,
        shadowColor: Colors.black,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Logo(fontSize: 50),
              const SizedBox(height: 50),
              const Text("Email:"),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                ),
                onChanged: (value) => _email = value,
              ),
              const Text("Password:"),
              const SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                ),
                onChanged: (value) => _password = value,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(500, 50),
                ),
                onPressed: () async {
                  User? user = await DatabaseConnector.login(_email, _password);
                  print("User: $user");
                  if (user != null) {
                    if (context.mounted) {
                      context.read<AuthManager>().setUser(user);

                      Navigator.popAndPushNamed(context, '/');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Invalid email or password!')),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(500, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
