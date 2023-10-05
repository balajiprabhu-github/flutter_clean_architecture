import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInteger', () {

    test('should return an integer when the string represents an unsigned integer', () {
      // arrange
      const string = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(string);
      // assert
      expect(result, const Right(123));
    });

    test('should throw an InputFailureException when the string represents an invalid integer', () {
      // arrange
      const string = 'abc';
      // act
      final result = inputConverter.stringToUnsignedInteger(string);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should throw an InputFailureException when the string represents an negative integer', () {
      // arrange
      const string = '-123';
      // act
      final result = inputConverter.stringToUnsignedInteger(string);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

  });

}