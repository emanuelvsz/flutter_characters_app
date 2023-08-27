import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'screens/character_list_screen.dart';

void main() {
  runApp(MaterialApp(home: CharacterListScreen()));
}
