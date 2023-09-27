import 'package:flutter_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required number, required text}) : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> response) {
    return NumberTriviaModel(number: (response['number'] as num).toInt(), text: response['text']);
  }

  Map<String,dynamic> toJson() {
    return {
      "text" : text,
      "number" : number
    };
  }
}