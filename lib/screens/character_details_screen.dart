import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterDetailsScreen extends StatefulWidget {
  final String characterID;

  CharacterDetailsScreen(this.characterID);

  @override
  _CharacterDetailsScreenState createState() => _CharacterDetailsScreenState();
}

class _CharacterDetailsScreenState extends State<CharacterDetailsScreen> {
  late Future<Character> _characterFuture;
  late Character _character;

  @override
  void initState() {
    super.initState();
    _characterFuture = fetchCharacterDetails();
  }

  Future<Character> fetchCharacterDetails() async {
    final response = await http.get(Uri.parse('http://localhost:5010/characters/${widget.characterID}'));
    if (response.statusCode == 200) {
      final characterData = json.decode(response.body);
      return Character(
        id: characterData['id'],
        name: characterData['name'],
        fromWhere: characterData['from_where'],
      );
    } else {
      throw Exception('Failed to load character details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: _characterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData || _character != null) {
          final character = snapshot.data ?? _character;
          return Scaffold(
            appBar: AppBar(title: Text('Character Details')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${character.name}'),
                  Text('From Where: ${character.fromWhere}'),
                  // Adicione mais detalhes conforme necessário
                ],
              ),
            ),
          );
        } else {
          return Text('No data available'); // Caso não haja dados
        }
      },
    );
  }
}
