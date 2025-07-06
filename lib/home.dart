import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login.dart';
import 'styles.dart';
import 'widgets/safe_logo.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                  bottom: BorderSide(color: Color(0xFF23636C), width: 1.5),
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
                          border: Border.all(color: const Color(0xFF23636C), width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          style: TextStyle(color: Color(0xFF2E808C)),
                          decoration: InputDecoration(
                            hintText: 'Pesquise...',
                            hintStyle: TextStyle(color: Color(0xFF2E808C)),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset('assets/add.svg', width: 41, height: 41),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView(
                      children: const [
                        Align(alignment: Alignment.center, child: NoteCard()),
                        Align(alignment: Alignment.center, child: NoteCard()),
                        Align(alignment: Alignment.center, child: NoteCard()),
                      ],
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
  final String text;

  const NoteCard({
    super.key,
    this.text = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
        'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
        'when an unknown printer took a galley of type and scrambled it to make a type specimen book. '
        'It has survived not only five centuries, but also the leap into electronic typesetting, '
        'remaining essentially unchanged.',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.87,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: const Color(0xFF23636C), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Note',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/edit.svg', width: 20, height: 20),
                    const SizedBox(width: 12),
                    SvgPicture.asset('assets/delete.svg', width: 20, height: 20),
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
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
