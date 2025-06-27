import 'package:flutter/material.dart';
import 'home.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'utils/notifier.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _userError = false;
  bool _passwordError = false;
  String? _errorMessage;

  void _tryLogin() {
    final isEmptyUser = _usernameController.text.isEmpty;
    final isEmptyPass = _passwordController.text.isEmpty;

    if (isEmptyUser || isEmptyPass) {
      showErrorNotification(context, 'Preencha todos os campos.');
      return;
    }

    if (_usernameController.text == correctUsername &&
        _passwordController.text == correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else {
      showErrorNotification(context, 'Usuário ou senha incorretos.');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, bool isError) {
    return inputDecoration.copyWith(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: isError ? Colors.redAccent : inputBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: isError ? Colors.redAccent : inputBorderColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        toolbarHeight: 130,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 21, top: 51),
          child: SafeLogo(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 258,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Usuário', _userError),
                      onChanged: (_) {
                        if (_userError) setState(() => _userError = false);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Senha', _passwordError),
                      onChanged: (_) {
                        if (_passwordError) setState(() => _passwordError = false);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    width: 258,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: _tryLogin,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: buttonTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
