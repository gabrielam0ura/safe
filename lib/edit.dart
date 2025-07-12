import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'utils/notifier.dart';
import 'utils/theme-provider.dart';

class EditScreen extends StatefulWidget {
  final String id;
  final String initialTitle;
  final String initialNote;

  const EditScreen({
    super.key,
    required this.id,
    required this.initialTitle,
    required this.initialNote,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _noteController = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
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
                    hintText: 'Anotação',
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
                      onPressed: () async {
                        final updatedTitle = _titleController.text.trim();
                        final updatedNote = _noteController.text.trim();

                        if (updatedTitle.isEmpty || updatedNote.isEmpty) {
                          showErrorNotification(
                            context,
                            'Título e anotação não podem ser vazios',
                          );
                          return;
                        }

                        final response = await http.put(
                          Uri.parse('http://localhost:3333/notes/${widget.id}'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'title': updatedTitle,
                            'content': updatedNote,
                          }),
                        );

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          showSuccessNotification(
                            context,
                            'Anotação editada com sucesso',
                          );
                          Navigator.pop(context, {
                            'title': updatedTitle,
                            'note': updatedNote,
                          });
                        } else {
                          showErrorNotification(
                            context,
                            'Erro ao editar anotação.',
                          );
                        }
                      },
                      child: Text(
                        'Salvar',
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
