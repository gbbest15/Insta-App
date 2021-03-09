import 'package:flutter/material.dart';
import 'package:instaapp/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final userKey = GlobalKey<FormState>();
  final accountController = TextEditingController();

  submit() {
    final val = userKey.currentState;
    if (val.validate()) {
      Navigator.pop(context, accountController.text.trim());
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context, titleString: 'Setup your Profile'),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Create a Username',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                child: Form(
                  key: userKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) => val.trim().length < 5 || val.isEmpty
                        ? 'It must be 6 above'
                        : null,
                    controller: accountController,
                    decoration: InputDecoration(
                      hintText: 'Username must be above 5',
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 50.0,
                width: 350,
                child: TextButton(
                  onPressed: submit,
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
