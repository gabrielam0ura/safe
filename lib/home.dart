import 'package:flutter/material.dart';
import 'styles.dart';
import 'login.dart';
import 'widgets/safe_logo.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        titleSpacing: 0,
        toolbarHeight: 130,
        title: const Padding(
          padding: EdgeInsets.only(left: 21, top: 51),
          child: SafeLogo(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Login()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Bem-vindo ao Diário Pessoal!',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
