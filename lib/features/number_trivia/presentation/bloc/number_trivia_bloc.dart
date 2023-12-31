import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConvertor;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required  this.inputConvertor
  }) : super(NumberTriviaInitial()) {

    on<NumberTriviaEvent>((event, emit) {

    });

  }
}
