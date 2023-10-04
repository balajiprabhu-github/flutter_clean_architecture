import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTrivia>? getLastCachedNumberTrivia();
  Future<bool> cacheNumberTrivia(NumberTriviaModel? numberTriviaModel);
}

const String cacheNumberTriviaConstant = "cache_number_trivia";

class NumberTriviaLocalDataSourcesImpl implements NumberTriviaLocalDataSource {

  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourcesImpl({required this.sharedPreferences});

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel? numberTriviaModel) {
    final jsonString = json.encode(numberTriviaModel?.toJson());
    return sharedPreferences.setString(cacheNumberTriviaConstant, jsonString);
  }

  @override
  Future<NumberTrivia>? getLastCachedNumberTrivia() {
    final jsonString = sharedPreferences.getString(cacheNumberTriviaConstant);
    if(jsonString != null ) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

}