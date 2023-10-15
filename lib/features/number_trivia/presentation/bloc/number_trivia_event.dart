part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String number;
  const GetTriviaForConcreteNumber(this.number);
  @override
  List<Object?> get props => [number];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}
