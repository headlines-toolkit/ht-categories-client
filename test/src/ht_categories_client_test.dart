//
// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars
import 'package:ht_categories_client/ht_categories_client.dart';
import 'package:test/test.dart';

void main() {
  group('HtCategoriesClient', () {
    // Abstract class cannot be tested directly.
    // Tests should be added for concrete implementations.
    test('placeholder test', () {
      expect(true, isTrue); // Add a dummy test to avoid empty group
    });
  });

  group('Category Exceptions', () {
    final error = Exception('Test error');
    final stackTrace = StackTrace.current;
    const categoryId = 'cat-123';

    test('CategoryException can be instantiated and has correct toString', () {
      final exception = CategoryException(error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.toString(), equals('CategoryException: $error'));
    });

    test('GetCategoriesFailure can be instantiated', () {
      final exception = GetCategoriesFailure(error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(
        exception.toString(),
        startsWith('CategoryException:'),
      ); // Inherits base toString
    });

    test('GetCategoryFailure can be instantiated', () {
      final exception = GetCategoryFailure(error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.toString(), startsWith('CategoryException:'));
    });

    test('CreateCategoryFailure can be instantiated', () {
      final exception = CreateCategoryFailure(error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.toString(), startsWith('CategoryException:'));
    });

    test('UpdateCategoryFailure can be instantiated', () {
      final exception = UpdateCategoryFailure(error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.toString(), startsWith('CategoryException:'));
    });

    test('DeleteCategoryFailure can be instantiated', () {
      final exception = DeleteCategoryFailure(error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(exception.toString(), startsWith('CategoryException:'));
    });

    test('CategoryNotFoundFailure can be instantiated and has correct toString',
        () {
      final exception = CategoryNotFoundFailure(categoryId, error, stackTrace);
      expect(exception, isNotNull);
      expect(exception.id, equals(categoryId));
      expect(exception.error, equals(error));
      expect(exception.stackTrace, equals(stackTrace));
      expect(
        exception.toString(),
        equals(
          'CategoryNotFoundFailure: Category with ID "$categoryId" not found. Error: $error',
        ),
      );
    });
  });
}
