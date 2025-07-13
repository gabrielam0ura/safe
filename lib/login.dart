import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'utils/notifier.dart';
import 'utils/theme-provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

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

  InputDecoration _inputDecoration(
    String hint,
    bool isError,
    Color borderColor,
  ) {
    return inputDecoration.copyWith(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: isError ? Colors.redAccent : borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: isError ? Colors.redAccent : borderColor,
          width: 2,
        ),
      ),
    );
  }

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
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Home(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bool isDarkMode = themeProvider.isDarkMode;

    final backgroundColorState = isDarkMode
        ? backgroundColor
        : const Color(0xFF2E808C);
    final inputBorderColorState = isDarkMode
        ? inputBorderColor
        : const Color(0xFF00252D);
    final buttonColorState = isDarkMode ? buttonColor : const Color(0xFF00252D);
    final logoAsset = isDarkMode
        ? 'assets/safe-dark.svg'
        : 'assets/safe-light.svg';
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColorState,
      appBar: AppBar(
        backgroundColor: backgroundColorState,
        elevation: 0,
        toolbarHeight: 130,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 21, top: 51),
          child: SafeLogo(asset: logoAsset),
        ),
      ),
      body: Stack(
        children: [
          Center(
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
                          style: TextStyle(color: textColor),
                          decoration: _inputDecoration(
                            'Usuário',
                            _userError,
                            inputBorderColorState,
                          ),
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
                          style: TextStyle(color: textColor),
                          decoration: _inputDecoration(
                            'Senha',
                            _passwordError,
                            inputBorderColorState,
                          ),
                          onChanged: (_) {
                            if (_passwordError)
                              setState(() => _passwordError = false);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        width: 258,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColorState,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: _tryLogin,
                          child: Text(
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
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              onPressed: () => themeProvider.toggleTheme(),
              icon: Icon(Icons.brightness_6, color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
