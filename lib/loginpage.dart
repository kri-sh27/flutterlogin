import 'package:flutter/material.dart';
import 'package:flutterlogin/main.dart';
import 'package:flutterlogin/resetpassword.dart';
import 'package:flutterlogin/signuppage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPAge extends StatefulWidget {
  LoginPAge({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPAge();
}

class _LoginPAge extends State<LoginPAge> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final url = Uri.https(
        'expenseapp-25cd7-default-rtdb.firebaseio.com', 'signup.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      bool credentialsMatch = false;

      data.values.forEach((value) {
        if (value['email'] == emailController.text &&
            value['password'] == passwordController.text) {
          credentialsMatch = true;
        } else {
          print('Invalid or null amount value');
        }
      });
      if (credentialsMatch) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: "Myhomepage"),
          ),
        );
      } else {
        print('invalid credentials');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Error response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("LoginScreen"),
      ),
      body: Container(
        child: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter Your Name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Your Password',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _getData();
                        },
                        child: const Text("Login"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: const Text("SignUp"),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                              ),
                            );
                          },
                          child: Text("Forgot password"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
