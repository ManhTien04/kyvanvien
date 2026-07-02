// TokenHandler.dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

Future<String?> getToken() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/token.json');
  if (await file.exists()) {
    final Map<String, dynamic> jsonFileContent = jsonDecode(await file.readAsString());
    String token = jsonFileContent['token'];
    if (token.isNotEmpty) {
      return token;
    }
  }
  return null;
}

Future<void> logout() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/token.json');
  if (await file.exists()) {
    await file.delete();
  }
}