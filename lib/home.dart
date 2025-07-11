import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/notifier.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3333/notes'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List data = json['notes'] ?? [];

        if (mounted) {
          setState(() {
            notes = data
                .map<Map<String, String>>(
                  (note) => {
                    'id': note['id'] ?? '',
                    'title': note['title'] ?? '',
                    'note': note['content'] ?? '',
                  },
                )
                .toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void onNoteCreated() {
    setState(() {
      isLoading = true;
    });
    fetchNotes();
  }

  void editNoteLocally(int index, Map<String, String> updatedNote) {
    fetchNotes();
  }

  void deleteNoteLocally(int index) async {
    final note = notes[index];

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3333/notes/${note["id"]}'),
      );

      if (response.statusCode == 204) {
        if (mounted) {
          showSuccessNotification(context, 'Anotação deletada com sucesso');
        }
        fetchNotes();
      } else {
        if (mounted) {
          showErrorNotification(context, 'Erro ao deletar anotação');
        }
      }
    } catch (_) {
      if (mounted) {
        showErrorNotification(context, 'Falha na conexão com o servidor');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          PreferredSize(
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
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.73,
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(
                            color: const Color(0xFF23636C),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Color(0xFF2E808C)),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Pesquise...',
                            hintStyle: TextStyle(color: Color(0xFF2E808C)),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/add',
                          );
                          if (result != null &&
                              result is Map<String, dynamic> &&
                              result['success'] == true) {
                            onNoteCreated();
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/add.svg',
                          width: 41,
                          height: 41,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              return Align(
                                alignment: Alignment.center,
                                child: NoteCard(
                                  title: notes[index]['title']!,
                                  note: notes[index]['note']!,
                                  onDelete: () => deleteNoteLocally(index),
                                  onEdit: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      '/edit',
                                      arguments: {
                                        'id':
                                            notes[index]['id']!, // Adicione o id aqui
                                        'initialTitle': notes[index]['title']!,
                                        'initialNote': notes[index]['note']!,
                                      },
                                    );
                                    if (result != null &&
                                        result is Map<String, String>) {
                                      editNoteLocally(index, {
                                        'id':
                                            notes[index]['id']!, // Mantenha o id ao editar localmente
                                        'title': result['title']!,
                                        'note': result['note']!,
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String note;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const NoteCard({
    super.key,
    required this.title,
    required this.note,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: const Color(0xFF23636C), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: SvgPicture.asset(
                      'assets/edit.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: SvgPicture.asset(
                      'assets/delete.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 1.5,
            width: double.infinity,
            color: const Color(0xFF23636C),
          ),
          const SizedBox(height: 8),
          Text(note, style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
