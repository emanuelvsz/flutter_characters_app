import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCharacterScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fromWhereController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Character')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController, // Associe o controlador ao campo
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: fromWhereController, // Associe o controlador ao campo
              decoration: InputDecoration(labelText: 'From Where'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text;
                final newFromWhere = fromWhereController.text;

                final response = await http.post(
                  Uri.parse('http://localhost:5010/characters/new'),
                  body: jsonEncode({
                    'name': newName,
                    'from_where': newFromWhere,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 201) {
                  Navigator.pop(context); // Volta para a lista de personagens
                } else {
                  // Lógica para lidar com erro
                }
              },
              child: Text('Add Character'),
            ),
          ],
        ),
      ),
    );
  }
}

