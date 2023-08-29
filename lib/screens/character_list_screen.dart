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

  Future<void> addCharacter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCharacterScreen()),
    );

    if (result == true) {
      setState(() {
        characters.clear();
        currentPage = 1;
        fetchCharacters();
      });
    }
  }

  void viewCharacterDetails(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CharacterDetailsScreen(character.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character List')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return InkWell(
                  onTap: () {
                    viewCharacterDetails(character);
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                character.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(character.fromWhere),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: loadMoreCharacters,
            child: Text('Mostrar Mais'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCharacter,
        child: Icon(Icons.add),
      ),
    );
  }
}