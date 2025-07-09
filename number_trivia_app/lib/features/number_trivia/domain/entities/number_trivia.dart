import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  const NumberTrivia({required this.text, required this.number});

  final String text;
  final int number;

  @override
  List<Object?> get props => throw UnimplementedError();
}

// import 'package:equatable/equatable.dart';

// class NumberTrivia extends Equatable {
//     NumberTrivia({
//         required this.text,
//         required this.number,
//     });

//     final String? text;
//     final int? number;

//     NumberTrivia copyWith({
//         String? text,
//         int? number,
//     }) {
//         return NumberTrivia(
//             text: text ?? this.text,
//             number: number ?? this.number,
//         );
//     }

//     factory NumberTrivia.fromJson(Map<String, dynamic> json){
//         return NumberTrivia(
//             text: json["text"],
//             number: json["number"],
//         );
//     }

//     Map<String, dynamic> toJson() => {
//         "text": text,
//         "number": number,
//     };

//     @override
//     String toString(){
//         return "$text, $number, ";
//     }

//     @override
//     List<Object?> get props => [
//     text, number, ];
// }
