// import 'package:dartz/dartz.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
// import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
// import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}

// void main() {
//   late GetConcreteNumberTrivia usecase;
//   late MockNumberTriviaRepository mockNumberTriviaRepository;

//   setUp(() {
//     mockNumberTriviaRepository = MockNumberTriviaRepository();
//     usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
//   });

//   final tNumber = 1;
//   final tNumberTrivia = NumberTrivia(text: "test", number: tNumber);

//   test('should get trivia for the number from the repository', () async {
//     // arrange
//     when(
//       mockNumberTriviaRepository.getConcreteNumberTrivia(any),
//     ).thenAnswer((_) async => Right(tNumberTrivia));

//     // act
//     final result = await usecase.execute(number: tNumber);

//     //assert
//     expect(result, Right(tNumberTrivia));
//     verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
//   });

//   // test('should', () async {
//   //   // arrange

//   //   // act

//   //   //assert
//   // });
// }

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia for the number from the repository', () async {
    // "On the fly" implementation of the Repository using the Mockito package.
    // When getConcreteNumberTrivia is called with any argument, always answer with
    // the Right "side" of Either containing a test NumberTrivia object.

    when(
      mockNumberTriviaRepository.getConcreteNumberTrivia(1),
    ).thenAnswer((_) async => Right(tNumberTrivia));
    // The "act" phase of the test. Call the not-yet-existent method.
    final result = await usecase.execute(number: tNumber);
    // UseCase should simply return whatever was returned from the Repository
    expect(result, Right(tNumberTrivia));
    // Verify that the method has been called on the Repository
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    // Only the above method should be called and nothing more.
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
