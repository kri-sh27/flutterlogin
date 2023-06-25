import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> _resetPassword() async {
    final url = Uri.https(
      'expenseapp-25cd7-default-rtdb.firebaseio.com',
      'signup.json',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      bool emailMatch = false;
      String? userId;

      data.forEach((key, value) {
        if (value['email'] == emailController.text) {
          emailMatch = true;
          userId = key;
          return;
        }
      });

      if (emailMatch) {
        final updateUrl = Uri.https(
          'expenseapp-25cd7-default-rtdb.firebaseio.com',
          'signup/$userId.json',
        );
        final updateResponse = await http.patch(
          updateUrl,
          body: json.encode({
            'password': passwordController.text,
          }),
        );

        if (updateResponse.statusCode == 200) {
          print('Password updated successfully');
          Navigator.pop(context); // Navigate back to the login screen
        } else {
          print('Failed to update password');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[700],
            content: const Text(
              "Invali Email",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        );
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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Reset Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter Your Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'New Password',
                hintText: 'Enter Your New Password',
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _resetPassword();
                  },
                  child: Text('Reset'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
