import 'dart:convert';

import 'package:ht_categories_client/src/models/category.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Category', () {
    const uuid = Uuid();
    final testId = uuid.v4();
    const testName = 'Technology';
    const testDescription = 'Latest tech news';
    const testIconUrl = 'http://example.com/icon.png';

    Category createSubject({
      String? id,
      String name = testName,
      String? description = testDescription,
      String? iconUrl = testIconUrl,
    }) {
      return Category(
        id: id,
        name: name,
        description: description,
        iconUrl: iconUrl,
      );
    }

    test('constructor generates id if not provided', () {
      final category = createSubject();
      expect(category.id, isA<String>());
      expect(category.id, isNotEmpty);
      // Basic check for UUID format (8-4-4-4-12)
      expect(
        category.id,
        matches(
          //
          // ignore: lines_longer_than_80_chars
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ),
      );
    });

    test('constructor uses provided id', () {
      final category = createSubject(id: testId);
      expect(category.id, equals(testId));
    });

    test('supports value equality', () {
      final category1 = createSubject(id: testId);
      final category2 = createSubject(id: testId);
      expect(category1, equals(category2));
    });

    test('props are correct', () {
      final category = createSubject(id: testId);
      expect(
        category.props,
        equals([testId, testName, testDescription, testIconUrl]),
      );
    });

    test('copyWith creates a copy with updated values', () {
      final category = createSubject(id: testId);
      final newId = uuid.v4();
      const newName = 'Science';
      const newDescription = 'Discoveries and research';
      const newIconUrl = 'http://example.com/science.png';

      final copyWithId = category.copyWith(id: newId);
      final copyWithName = category.copyWith(name: newName);
      final copyWithDescription = category.copyWith(
        description: newDescription,
      );
      final copyWithIconUrl = category.copyWith(iconUrl: newIconUrl);
      final copyWithNullDescription = category.copyWith();
      final copyWithNullIconUrl = category.copyWith();
      final fullCopy = category.copyWith(
        id: newId,
        name: newName,
        description: newDescription,
        iconUrl: newIconUrl,
      );

      expect(copyWithId.id, equals(newId));
      expect(copyWithId.name, equals(testName)); // Original value

      expect(copyWithName.name, equals(newName));
      expect(copyWithName.id, equals(testId)); // Original value

      expect(copyWithDescription.description, equals(newDescription));
      expect(copyWithDescription.id, equals(testId)); // Original value

      expect(copyWithIconUrl.iconUrl, equals(newIconUrl));
      expect(copyWithIconUrl.id, equals(testId)); // Original value

      // Verify that passing null to copyWith preserves the original value
      expect(
        copyWithNullDescription.description,
        equals(testDescription),
      ); // Original value was testDescription
      expect(
        copyWithNullIconUrl.iconUrl,
        equals(testIconUrl),
      ); // Original value was testIconUrl

      // Verify setting to null works if original was null
      final categoryWithNulls = createSubject(
        id: testId,
        description: null,
        iconUrl: null,
      );
      final copyWithNullsPreserved = categoryWithNulls.copyWith();
      expect(copyWithNullsPreserved.description, isNull);
      expect(copyWithNullsPreserved.iconUrl, isNull);

      expect(fullCopy.id, equals(newId));
      expect(fullCopy.name, equals(newName));
      expect(fullCopy.description, equals(newDescription));
      expect(fullCopy.iconUrl, equals(newIconUrl));
    });

    group('JSON serialization/deserialization', () {
      final fullJson = {
        'id': testId,
        'name': testName,
        'description': testDescription,
        'icon_url': testIconUrl,
      };

      final minimalJson = {
        'id': testId,
        'name': testName,
        // description and icon_url are omitted
      };

      test('fromJson creates correct object (full)', () {
        final category = Category.fromJson(fullJson);
        expect(category.id, equals(testId));
        expect(category.name, equals(testName));
        expect(category.description, equals(testDescription));
        expect(category.iconUrl, equals(testIconUrl));
      });

      test('fromJson creates correct object (minimal)', () {
        final category = Category.fromJson(minimalJson);
        expect(category.id, equals(testId));
        expect(category.name, equals(testName));
        expect(category.description, isNull);
        expect(category.iconUrl, isNull);
      });

      test('fromJson generates ID if missing', () {
        final jsonWithoutId = {
          'name': testName,
          'description': testDescription,
          'icon_url': testIconUrl,
        };
        final category = Category.fromJson(jsonWithoutId);
        expect(category.id, isA<String>());
        expect(category.id, isNotEmpty);
        expect(category.name, equals(testName));
      });

      test('fromJson throws FormatException if name is missing', () {
        final invalidJson = {
          'id': testId,
          // 'name': testName, // Missing name
          'description': testDescription,
        };
        expect(
          () => Category.fromJson(invalidJson),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains('Missing required field: "name"'),
            ),
          ),
        );
      });

      test('toJson produces correct map (full)', () {
        final category = createSubject(id: testId);
        expect(category.toJson(), equals(fullJson));
      });

      test('toJson produces correct map (minimal)', () {
        final category = createSubject(
          id: testId,
          description: null,
          iconUrl: null,
        );
        // Use minimalJson but ensure id and name match the created subject
        final expectedMinimalJson = {
          'id': category.id, // Use the actual ID from the subject
          'name': testName,
        };
        expect(category.toJson(), equals(expectedMinimalJson));
      });

      test('toJsonString produces correct JSON string (full)', () {
        final category = createSubject(id: testId);
        // Encode the expected map to ensure consistent key order etc.
        expect(category.toJsonString(), equals(jsonEncode(fullJson)));
      });

      test('toJsonString produces correct JSON string (minimal)', () {
        final category = createSubject(
          id: testId,
          description: null,
          iconUrl: null,
        );
        // Use minimalJson but ensure id and name match the created subject
        final expectedMinimalJson = {
          'id': category.id, // Use the actual ID from the subject
          'name': testName,
        };
        expect(
          category.toJsonString(),
          equals(jsonEncode(expectedMinimalJson)),
        );
      });
    });
  });
}
