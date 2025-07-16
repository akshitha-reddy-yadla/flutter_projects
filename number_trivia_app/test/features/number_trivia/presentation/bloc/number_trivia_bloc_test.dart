import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_app/core/error/failures.dart';
import 'package:number_trivia_app/core/usecases/usecase.dart';
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
  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() => when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Right(tNumberParsed));

    void setUpMockGetTriviaForConcreteNumber() => when(
      mockGetConcreteNumberTrivia(any),
    ).thenAnswer((_) async => Right(tNumberTrivia));

    void setUpMockInputConvertFailure() => when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Left(InvalidInputFailure()));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetTriviaForConcreteNumber();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      setUpMockInputConvertFailure();

      // Assert initial state
      expect(bloc.state, equals(Empty()));

      // Assert expected emitted states
      expectLater(
        bloc.stream,
        emitsInOrder([Error(message: INVALID_INPUT_FAILURE_MESSAGE)]),
      );

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(
        mockGetConcreteNumberTrivia(any),
      ).thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetTriviaForConcreteNumber();
        // assert later

        // assert initial state
        expect(bloc.state, equals(Empty())); // check initial state separately

        // assert stream emissions
        final expected = [Loading(), Loaded(trivia: tNumberTrivia)];

        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(
        mockGetConcreteNumberTrivia(any),
      ).thenAnswer((_) async => Left(ServerFailure()));

      expect(bloc.state, equals(Empty()));
      // assert later
      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));

        expect(bloc.state, Empty());

        // assert later
        final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      // arrange
      when(
        mockGetRandomNumberTrivia(any),
      ).thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        expect(bloc.state, Empty());
        // assert later
        final expected = [Loading(), Loaded(trivia: tNumberTrivia)];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(
        mockGetRandomNumberTrivia(any),
      ).thenAnswer((_) async => Left(ServerFailure()));
      expect(bloc.state, Empty());
      // assert later
      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
        expect(bloc.state, Empty());
        // assert later
        final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
