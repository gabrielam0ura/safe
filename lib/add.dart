import 'package:flutter/material.dart';
import 'home.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';

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

  void _addNote() {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();

    if (title.isEmpty || note.isEmpty) {
      showErrorNotification(context, 'Título e anotação não podem ser vazios');
      return;
    }

    Navigator.pop(context, {'title': title, 'note': note});
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
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: 'Título',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF23636C), width: 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF23636C), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF23636C), width: 1),
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
                    hintText: 'Escreva uma notação',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF23636C), width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF23636C), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                          color: Color(0xFF23636C), width: 1),
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
                        side: const BorderSide(color: Color(0xFF23636C), width: 1),
                      ),
                      onPressed: _addNote,
                      child: const Text(
                        'Adicionar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
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

void showErrorNotification(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
