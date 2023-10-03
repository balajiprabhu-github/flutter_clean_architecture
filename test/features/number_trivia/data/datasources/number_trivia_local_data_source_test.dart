import 'dart:async';
import 'dart:convert';

import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

@GenerateMocks([SharedPreferences])
void main() {

  late NumberTriviaLocalDataSourcesImpl numberTriviaLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourcesImpl(sharedPreferences: mockSharedPreferences);
  });


  group('getLastNumberTrivia', () {

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should return cached number trivia from shared preferences when there is at least one data', () async {
      // arrange
      when(mockSharedPreferences.getString("cache_number_trivia")).thenReturn(fixture('trivia_cached.json'));
      // act
      final result = await numberTriviaLocalDataSourceImpl.getLastCachedNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString("cache_number_trivia"));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw cache exception when there is no cache value', (){
      // arrange
      when(mockSharedPreferences.getString("cache_number_trivia")).thenReturn(null);

      // assert
      expect(() => numberTriviaLocalDataSourceImpl.getLastCachedNumberTrivia(), throwsA(const TypeMatcher<CacheException>()));
    });

  });
  
  // group('cacheNumberTrivia', () {
  //
  //   const tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Testing");
  //
  //   test('should call shared preferences to cache the data', () async {
  //     // arrange
  //     when( mockSharedPreferences.setString("","")).thenAnswer((_)  => Future.value(true));
  //     // act
  //     numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
  //     // assert
  //     verify(mockSharedPreferences.setString("cache_number_trivia",json.encode(tNumberTriviaModel.toJson())));
  //   });
  // });


}