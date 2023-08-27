import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/character.dart';
import 'add_character_screen.dart';
import 'character_details_screen.dart';

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterDetailsScreen(character.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCharacter = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCharacterScreen()),
          );

          if (newCharacter != null) {
            setState(() {
              characters.add(newCharacter);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
