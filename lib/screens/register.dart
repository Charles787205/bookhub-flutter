import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/widgets/logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseHandler firebaseHandler = Provider.of<FirebaseHandler>(context);
    const yearDropdown = [
      'First Year',
      'Second Year',
      'Third Year',
      'Fourth Year'
    ];
    String yearDropdownVal = 'First Year';
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const Logo(fontSize: 50),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'First name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    controller: firstNameController,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Last name',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                    controller: lastNameController,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    items: yearDropdown
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        yearDropdownVal = value!;
                      });
                    },
                    value: yearDropdownVal,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(500, 50),
                    ),
                    onPressed: () async {
                      if (await firebaseHandler.registerUser(
                          firstNameController.text,
                          lastNameController.text,
                          yearDropdownVal)) {
                        Navigator.of(context).pushNamed("/home");
                      }
                    },
                    child: const Text("Register"),
                  )
                ]),
              )),
        ));
  }
}
