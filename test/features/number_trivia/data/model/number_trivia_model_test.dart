
import 'dart:convert';
import 'package:flutter_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {

  const tNumberTriviaModel = NumberTriviaModel(number: 1,text:"Testing");
  test("should be a sub class of NumberTrivia entity", () => {
    expect(tNumberTriviaModel,isA<NumberTrivia>())
  });
  
  group("fromJson", () {
    
    test("should return a valid model when json number is an integer", () {
      // arrange
      final Map<String, dynamic> response = json.decode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(response);

      // assert
      expect(result, tNumberTriviaModel);

    });

    test("should return a valid model when json number is an double", () {
      // arrange
      final Map<String, dynamic> response = json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(response);

      // assert
      expect(result, tNumberTriviaModel);

    });
  });

  group("toJson", () {

    test("should return valid json with proper content", () {
      // act
      final result = tNumberTriviaModel.toJson();
      final responseMap = {
        "text": "Testing",
        "number": 1
      };
      // assert
      expect(result, responseMap);

    });

  });
  
}