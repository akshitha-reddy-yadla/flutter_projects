import 'package:equatable/equatable.dart';

class NumberTriviaModel extends Equatable {
  const NumberTriviaModel({required this.text, required this.number});

  final String text;
  final int number;

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  @override
  List<Object?> get props => [text, number];
}
