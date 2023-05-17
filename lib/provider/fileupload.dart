import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer/constants/globals_constants.dart';
import 'package:musicplayer/controllers/query_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:http/http.dart' as http;

class FileUploader with ChangeNotifier {
  final String _fileUpload =
      '$URI/file/upload'; // Replace with your Node.js endpoint

  var queryController = AudioQuery();
  Future<void> getEverything() async {
    await queryController.getArtists();
    await queryController.getFolders(recheck: true);
    await queryController.getSongs(recheck: true);
  }

  Future<void> uploadFiles(BuildContext context) async {
    List<SongModel> songs = await queryController.getSongs(recheck: true);
    await getEverything();
    var token = Hive.box('user').get('token');
    final fileResponse = await http.get(Uri.parse("$URI/file/files"),
        headers: {"Authorization": 'Bearer $token'});
    final fileData = jsonDecode(fileResponse.body);
    List<String> filePaths = [];
    for (var element in fileData) {
      // if element['path'] is in songs, then remove it from songs
      for (var i = 0; i < songs.length; i++) {
        if (songs[i].data.split('/').last == element['name']) {
          // add removed songes to hive
          filePaths.add(songs[i].data);
          songs.removeAt(i);
        }
      }
    }

    for (var i = 0; i < songs.length; i++) {
      final song = songs[i];
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_fileUpload),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['mainFolder'] = 'Download';
      List<String> folders = [song.data];
      request.fields['subFolder'] = jsonEncode(folders);

      final multipartFile = await http.MultipartFile.fromPath(
        'files',
        song.data,
      );
      request.files.add(multipartFile);

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          debugPrint('File uploaded successfully: ${song.data}');
        } else {
          debugPrint(
              'Error uploading file ${i + 1}/${songs.length}: ${response.statusCode} ${response.reasonPhrase}');
        }
      } catch (e) {
        debugPrint('Error uploading file ${i + 1}/${songs.length}: $e');
      }
      // show snackbar
      SnackBar snackBar = SnackBar(
        content: Text('File uploaded successfully: ${song.data}'),
        duration: const Duration(seconds: 1),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
