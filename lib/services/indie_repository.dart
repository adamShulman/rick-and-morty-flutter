
import 'dart:convert';
import 'package:indieflow/models/character.dart';
import 'package:indieflow/models/episode.dart';
import 'package:indieflow/models/list_item.dart';
import 'package:indieflow/services/remote_service.dart';
import 'package:indieflow/utils/shared_prefs_wrapper.dart';

class IndieRepository {

  final RemoteService remoteService;
  final SharedPrefsWrapper sharedPrefs;
  
  IndieRepository({
    required this.remoteService,
    required this.sharedPrefs,
  });

  Future<Result<List<Episode>, NetworkException>> getMultipleEpisodes({List<int>? ids = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]}) async {
    try {
      final apiResult = await remoteService.getMultipleEpisodes(ids: ids);
      return apiResult;
    } catch (error) {
      return Failure(NetworkException('Error, something went wrong'));
    }
  }

  Future<Result<List<Character>, NetworkException>> getCharacters() async {
    try {
      final apiResult = await remoteService.getCharacters();
      switch (apiResult) {
        case Success():
          return apiResult;
        case Failure(exception: final error):
          return _getCharactersFromCache(error);
      }
    } catch (error) {
      return _getCharactersFromCache(NetworkException('Error, something went wrong'));
    }
  }

  Future<Result<List<ListItem>, NetworkException>> getListItems() async {
    final result = await getCharacters();
    switch (result) {
      case Success(value: final characters):
        List<ListItem> listItems = characters.map((character) => ListItem.colored(character)).toList();
        return Success(listItems);
      case Failure(exception: final error):
        return Failure(error);
    }
  }

  Future<Result<List<Character>, NetworkException>> _getCharactersFromCache(NetworkException networkError) async {
    final String? jsonData = await sharedPrefs.getDataFor('characters');
    if (jsonData != null) {
      List<Character> characters = (json.decode(jsonData)["results"] as List).map((char) => Character.fromJson(char)).toList();
      return Success(characters);
    } else {
      return Failure(networkError);
    }
  } 
}