import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/util/input_converter.dart';
import 'package:number_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetConcreteNumberTrivia>()])
@GenerateNiceMocks([MockSpec<GetRandomNumberTrivia>()])
@GenerateNiceMocks([MockSpec<InputConverter>()])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConvreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpMockInputConverterSuccess() => when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Right(tNumberParsed));

    void setUpMockInputConverterFailure() => when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Left(InvalidInputFailure()));

    void setUpMockGetConcreteNumberTrivia() => when(
      mockGetConcreteNumberTrivia.call(Params(number: 1)),
    ).thenAnswer((_) async => Right(tNumberTrivia));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTrivia();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(
        mockInputConverter.stringToUnsignedInteger(any),
      ).thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        // The initial state is always emitted first
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected.skip(1)));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });
}
