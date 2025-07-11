import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'package:http/http.dart' as http;
import 'utils/notifier.dart';
import 'dart:convert';
import 'utils/theme-provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();

    if (title.isEmpty || note.isEmpty) {
      showErrorNotification(context, 'Título e anotação não podem ser vazios');
      return;
    }

    final url = Uri.parse('http://localhost:3333/notes');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'content': note}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          showSuccessNotification(context, 'Anotação salva com sucesso');
          Navigator.pop(context, {'success': true});
        }
      } else {
        if (mounted) {
          showErrorNotification(context, 'Erro ao adicionar anotação.');
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification(context, 'Falha na conexão com o servidor.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final backgroundColorState =
        isDarkMode ? backgroundColor : const Color(0xFF2E808C);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? const Color(0xFF23636C) : Colors.black;
    final logoAsset =
        isDarkMode ? 'assets/safe-dark.svg' : 'assets/safe-light.svg';

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColorState,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(121),
        child: Container(
          height: 121,
          decoration: BoxDecoration(
            color: backgroundColorState,
            border: Border(
              bottom: BorderSide(color: borderColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.only(left: 21, top: 40, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SafeLogo(asset: logoAsset),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.brightness_6, color: textColor),
                    onPressed: () => themeProvider.toggleTheme(),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.87,
                child: TextField(
                  controller: _titleController,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Título',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.54)),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    filled: true,
                    fillColor: backgroundColorState,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth * 0.87,
                height: screenHeight * (302 / 896),
                child: TextField(
                  controller: _noteController,
                  maxLines: null,
                  expands: true,
                  style: TextStyle(color: textColor, fontSize: 16),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Escreva uma notação',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.54)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    filled: true,
                    fillColor: backgroundColorState,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: screenWidth * 0.87,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: screenWidth * 0.27,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColorState,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: BorderSide(color: borderColor, width: 1),
                      ),
                      onPressed: _addNote,
                      child: Text(
                        'Adicionar',
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                    ),
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
