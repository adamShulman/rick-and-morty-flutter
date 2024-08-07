
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:indieflow/models/episode.dart';
import 'package:indieflow/models/character.dart';
import 'package:indieflow/utils/shared_prefs_wrapper.dart';

sealed class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}

class NetworkException implements Exception {
  
  final dynamic message;

  NetworkException(this.message);

  String description() {
    Object? message = this.message;
    if (message == null) return "Error, something went wrong";
    return "$message";
  }
}

class RemoteService {

  final SharedPrefsWrapper sharedPrefs;

  RemoteService(this.sharedPrefs);

  static const String baseUrl = "rickandmortyapi.com/api";

  Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<Result<List<Character>, NetworkException>> getCharacters() async {
    try {
      // final url = Uri(scheme: "https", host: baseUrl, path: "character");
      final response = await http.get(Uri.parse('https://$baseUrl/character')).timeout(const Duration(seconds: 5));
      // final response = await http.get(url, headers: requestHeaders);


      switch (response.statusCode) {
        case 200:
          List<Character> characters = (json.decode(response.body)["results"] as List).map((char) => Character.fromJson(char)).toList();
          await sharedPrefs.saveDataFor('characters', response.body);
          return Success(characters);
        default:
          return Failure(NetworkException(response.reasonPhrase));
      }
    } on NetworkException catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<Episode>, NetworkException>> getMultipleEpisodes({List<int>? ids = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}) async {
    try {
      // final url = Uri(scheme: "https", host: baseUrl, path: "character");
      final response = await http.get(Uri.parse('https://$baseUrl/episode/$ids')).timeout(const Duration(seconds: 5));
      // final response = await http.get(url, headers: requestHeaders);
      switch (response.statusCode) {
        case 200:
          List<Episode> episodes = (json.decode(response.body) as List).map((episode) => Episode.fromJson(episode)).toList();
          return Success(episodes);
        default:
          return Failure(NetworkException(response.reasonPhrase));
      }
    } on NetworkException catch (e) {
      return Failure(e);
    }
  }
}

