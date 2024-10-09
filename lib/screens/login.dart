import 'package:bookhub/widgets/logo.dart';
import 'package:flutter/material.dart';

import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isLoggingIn = false;
  @override
  Widget build(BuildContext context) {
    final firebaseHandler = Provider.of<FirebaseHandler>(context);
    return Scaffold(
      body: !_isLoggingIn
          ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Logo(fontSize: 50),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      onPressed: () async {
                        setState(() {
                          _isLoggingIn = true;
                        });
                        firebaseHandler.signIn().then((userType) async {
                          setState(() {
                            _isLoggingIn = false;
                          });
                          if (userType == 1) {
                            //user is already registered
                            if (context.mounted) {
                              await Navigator.of(context).pushNamed("/home");
                            }
                          }
                          if (userType == 2) {
                            if (context.mounted) {
                              await Navigator.of(context)
                                  .pushNamed("/register");
                            }
                          }

                          if (userType == 0) {
                            if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                        actions: [],
                                        title: Text("Error on loggin in"));
                                  });
                            }
                          }
                        });
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login),
                          SizedBox(width: 10),
                          Text("Login with Google"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
