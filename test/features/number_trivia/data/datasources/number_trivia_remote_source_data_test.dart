import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {

  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  const tNumber = 1;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(httpClient: mockHttpClient);
  });

  void setUpNumberTriviaConcreteSuccess() {
    when(() => mockHttpClient.get(Uri.parse('https://numbersapi.com/$tNumber'),headers: {
      'Content-Type' : 'application/json'
    }))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpNumberTriviaConcreteFailure() {
    when(() => mockHttpClient.get(Uri.parse('https://numbersapi.com/$tNumber'),headers: {
      'Content-Type' : 'application/json'
    }))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  void setUpNumberTriviaRandomSuccess() {
    when(() => mockHttpClient.get(Uri.parse('https://numbersapi.com/random'),headers: {
      'Content-Type' : 'application/json'
    }))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpNumberTriviaRandomFailure() {
    when(() => mockHttpClient.get(Uri.parse('https://numbersapi.com/random'),headers: {
      'Content-Type' : 'application/json'
    }))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform the GET request on a URL with number 
    being the endpoint and with application/json''', () async {
      // arrange
      setUpNumberTriviaConcreteSuccess();
      // act
      await dataSource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() =>
        mockHttpClient.get(Uri.parse('https://numbersapi.com/$tNumber'),headers: {
          'Content-Type' : 'application/json'
        })
      );
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // arrange
      setUpNumberTriviaConcreteSuccess();
      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the response code is 404 or other', () async {
      // arrange
      setUpNumberTriviaConcreteFailure();
      // act
      final call = dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(() => call, throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform the GET request on a URL with number 
    being the endpoint and with application/json''', () async {
      // arrange
      setUpNumberTriviaRandomSuccess();
      // act
      await dataSource.getRandomNumberTrivia();
      // assert
      verify(() =>
          mockHttpClient.get(Uri.parse('https://numbersapi.com/random'),headers: {
            'Content-Type' : 'application/json'
          })
      );
    });

    test('should return NumberTrivia when the response code is 200', () async {
      // arrange
      setUpNumberTriviaRandomSuccess();
      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the response code is 404 or other', () async {
      // arrange
      setUpNumberTriviaRandomFailure();
      // act
      final call = dataSource.getRandomNumberTrivia();

      // assert
      expect(() => call, throwsA(const TypeMatcher<ServerException>()));
    });
  });

}