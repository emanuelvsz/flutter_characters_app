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
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    final response = await http.get(Uri.parse('http://localhost:5010/characters?page=$currentPage'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        characters.addAll(data.map((characterData) {
          return Character(
            id: characterData['id'],
            name: characterData['name'],
            fromWhere: characterData['from_where'],
          );
        }));
      });
    }
  }

  void loadMoreCharacters() {
    setState(() {
      currentPage++;
    });
    fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character List')),
      body: ListView(
        children: [
          ...characters.map((character) => ListTile(
            title: Text(character.name),
            subtitle: Text(character.fromWhere),
          )),
          ElevatedButton(
            onPressed: loadMoreCharacters,
            child: Text('Mostrar Mais'),
          ),
        ],
      ),
    );
  }
}
