import 'package:flutter/material.dart';

class ListaCard extends StatefulWidget {
  const ListaCard({super.key});

  @override
  State<ListaCard> createState() => _ListaCardState();
}

class _ListaCardState extends State<ListaCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Cards')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Cabeçalho do drawer'),
            ),
            ListTile(title: const Text('Tela 1')),
            ListTile(title: const Text('Tela 2')),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsGeometry.all(8.0),
            child: Card(
              child: Row(
                children: [
                  Container(width: 80, height: 80, color: Colors.blue[200]),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 16,
                        color: Colors.blue[400],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        color: Colors.blue[100],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
