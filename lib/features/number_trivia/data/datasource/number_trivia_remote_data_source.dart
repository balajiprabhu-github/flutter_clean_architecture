
import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTrivia?>? getConcreteNumberTrivia(int number);
  Future<NumberTrivia?>? getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {

  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<NumberTrivia?>? getConcreteNumberTrivia(int number) async {
    final response = await httpClient.get(
      Uri.parse('https://numbersapi.com/$number'),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTrivia?>? getRandomNumberTrivia() async {
    final response = await httpClient.get(
      Uri.parse('https://numbersapi.com/random'),
      headers: {'Content-Type': 'application/json'},
    );

    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

}