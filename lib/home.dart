import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/notifier.dart';
import 'utils/theme-provider.dart';
import 'add.dart';
import 'edit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> notes = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                    'createdAt': note['createdAt'] ?? '',
                  },
                )
                .toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void fetchNotesByDate(String date) async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3333/notes/search/date?date=$date'),
      );
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
                    'createdAt': note['createdAt'] ?? '',
                  },
                )
                .toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
          showErrorNotification(context, 'Erro ao buscar anotações por data');
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        showErrorNotification(context, 'Falha na conexão com o servidor');
      }
    }
  }

  void searchNotes(String query) async {
    if (query.trim().isEmpty) {
      fetchNotes();
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:3333/notes/search?query=${Uri.encodeComponent(query)}',
        ),
      );
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
                    'createdAt': note['createdAt'] ?? '',
                  },
                )
                .toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() => isLoading = false);
          showErrorNotification(context, 'Erro ao buscar anotações');
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => isLoading = false);
        showErrorNotification(context, 'Falha na conexão com o servidor');
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2E808C),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final String formattedDate =
          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      fetchNotesByDate(formattedDate);
    }
  }

  void onNoteCreated() {
    setState(() => isLoading = true);
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
        if (mounted)
          showSuccessNotification(context, 'Anotação deletada com sucesso');
        fetchNotes();
      } else {
        if (mounted) showErrorNotification(context, 'Erro ao deletar anotação');
      }
    } catch (_) {
      if (mounted)
        showErrorNotification(context, 'Falha na conexão com o servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    Color backgroundColorState = isDarkMode
        ? backgroundColor
        : const Color(0xFF2E808C);
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color borderColor = isDarkMode ? const Color(0xFF23636C) : Colors.black;
    String logoAsset = isDarkMode
        ? 'assets/safe-dark.svg'
        : 'assets/safe-light.svg';

    return Scaffold(
      backgroundColor: backgroundColorState,
      body: Column(
        children: [
          PreferredSize(
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
                        onPressed: themeProvider.toggleTheme,
                      ),
                      IconButton(
                        icon: Icon(EvaIcons.logOut, color: textColor),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Login(),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
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
                          color: backgroundColorState,
                          border: Border.all(color: borderColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(color: textColor),
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  hintText: 'Pesquise...',
                                  hintStyle: TextStyle(
                                    color: textColor.withOpacity(0.6),
                                  ),
                                  border: InputBorder.none,
                                  isCollapsed: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  searchNotes(value);
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: _selectDate,
                              child: SvgPicture.asset(
                                'assets/calendar.svg',
                                width: 20,
                                height: 20,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                searchNotes(_searchController.text);
                              },
                              child: SvgPicture.asset(
                                'assets/search.svg',
                                width: 20,
                                height: 20,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const AddScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
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
                          color: textColor,
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
                                  createdAt: notes[index]['createdAt']!,
                                  onDelete: () => deleteNoteLocally(index),
                                  onEdit: () async {
                                    final result = await Navigator.of(context)
                                        .push(
                                          PageRouteBuilder(
                                            pageBuilder: (_, __, ___) =>
                                                EditScreen(
                                                  id: notes[index]['id']!,
                                                  initialTitle:
                                                      notes[index]['title']!,
                                                  initialNote:
                                                      notes[index]['note']!,
                                                ),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                          ),
                                        );
                                    if (result != null &&
                                        result is Map<String, String>) {
                                      editNoteLocally(index, {
                                        'id': notes[index]['id']!,
                                        'title': result['title']!,
                                        'note': result['note']!,
                                      });
                                    }
                                  },
                                  textColor: textColor,
                                  borderColor: borderColor,
                                  backgroundColor: backgroundColorState,
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
  final String createdAt;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;

  const NoteCard({
    super.key,
    required this.title,
    required this.note,
    required this.createdAt,
    this.onDelete,
    this.onEdit,
    required this.textColor,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.87,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                createdAt.split('T').first,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: SvgPicture.asset(
                      'assets/edit.svg',
                      width: 20,
                      height: 20,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: SvgPicture.asset(
                      'assets/delete.svg',
                      width: 20,
                      height: 20,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1.5, width: double.infinity, color: borderColor),
          const SizedBox(height: 8),
          Text(note, style: TextStyle(color: textColor, fontSize: 16)),
        ],
      ),
    );
  }
}
