import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Character {
  final String id;
  final String name;
  final String fromWhere;

  Character({required this.id, required this.name, required this.fromWhere});
}

void main() {
  runApp(MaterialApp(home: CharacterListScreen()));
}

class CharacterListScreen extends StatefulWidget {
  @override
  _CharacterListScreenState createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  List<Character> characters = [];

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    final response = await http.get(Uri.parse('http://localhost:5010/characters'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        characters = data.map((characterData) {
          return Character(
            id: characterData['id'],
            name: characterData['name'],
            fromWhere: characterData['from_where'],
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character List')),
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return ListTile(
            title: Text(character.name),
            subtitle: Text(character.fromWhere),
          );
        },
      ),
    );
  }
}
