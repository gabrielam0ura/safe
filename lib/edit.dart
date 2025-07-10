import 'package:flutter/material.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'dart:convert'; // Added for jsonEncode
import 'package:http/http.dart' as http; // Added for http
import 'utils/notifier.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(121),
        child: Container(
          height: 121,
          decoration: const BoxDecoration(
            color: backgroundColor,
            border: Border(
              bottom: BorderSide(color: Color(0xFF23636C), width: 1),
            ),
          ),
          padding: const EdgeInsets.only(left: 21, top: 40, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SafeLogo(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Título',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF23636C),
                        width: 1,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF23636C),
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF23636C),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Color(0xFF00252D),
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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Anotação',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF23636C),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF23636C),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Color(0xFF23636C),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF00252D),
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
                        backgroundColor: const Color(0xFF00252D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF23636C),
                          width: 1,
                        ),
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
                      child: const Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white, fontSize: 14),
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
