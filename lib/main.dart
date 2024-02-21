import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Adjust path if necessary

void main() {
  runApp(MyApp());
  // testLogin();
}

login(id, pwd) async {
  ApiService apiService = ApiService();
  return await apiService.login(id, pwd);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: const Text('Login Form')), body: LoginForm()),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logging in...')),
      );
      var result = login(_username, _password);
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onSaved: (value) => _username = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) => _password = value ?? '',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
