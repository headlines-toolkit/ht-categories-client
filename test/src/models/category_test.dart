//
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values, lines_longer_than_80_chars

import 'package:ht_categories_client/src/models/models.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Category Model', () {
    const id = 'test-id-123';
    const name = 'Technology';
    const description = 'Latest tech news and trends';
    const iconUrl = 'https://example.com/icon.png';

    Category createSubject({
      String? idOverride,
      String nameOverride = name,
      String? descriptionOverride = description,
      String? iconUrlOverride = iconUrl,
    }) {
      return Category(
        id: idOverride ?? id,
        name: nameOverride,
        description: descriptionOverride,
        iconUrl: iconUrlOverride,
      );
    }

    Category createSubjectWithGeneratedId({
      String nameOverride = name,
      String? descriptionOverride = description,
      String? iconUrlOverride = iconUrl,
    }) {
      // Call constructor without id to trigger UUID generation
      return Category(
        name: nameOverride,
        description: descriptionOverride,
        iconUrl: iconUrlOverride,
      );
    }

    test('constructor assigns values correctly', () {
      final category = createSubject();
      expect(category.id, equals(id));
      expect(category.name, equals(name));
      expect(category.description, equals(description));
      expect(category.iconUrl, equals(iconUrl));
    });

    test('constructor generates UUID when id is null', () {
      final category = createSubjectWithGeneratedId();
      expect(category.id, isNotNull);
      expect(category.id, isNotEmpty);
      // Basic check if it looks like a UUID v4
      expect(
        Uuid.isValidUUID(
          fromString: category.id,
          validationMode: ValidationMode.strictRFC4122,
        ),
        isTrue,
      );
    });

    test('supports value equality', () {
      final category1 = createSubject();
      final category2 = createSubject();
      expect(category1, equals(category2));
    });

    test('props are correct', () {
      final category = createSubject();
      expect(category.props, equals([id, name, description, iconUrl]));
    });

    test('copyWith creates a copy with updated values', () {
      final category = createSubject();
      final categoryCopy = category.copyWith(
        name: 'Science',
        description: null, // Test setting optional field to null
      );

      expect(categoryCopy.id, equals(id)); // ID should remain the same
      expect(categoryCopy.name, equals('Science'));
      // With the simpler copyWith using ??, passing null won't override an existing non-null value.
      expect(categoryCopy.description, equals(description));
      expect(categoryCopy.iconUrl, equals(iconUrl)); // Unchanged field
    });

    test('copyWith creates a copy with no changes when no args provided', () {
      final category = createSubject();
      final categoryCopy = category.copyWith();
      expect(categoryCopy, equals(category));
    });

    group('JSON Serialization/Deserialization', () {
      test('fromJson creates correct object', () {
        final json = {
          'id': id,
          'name': name,
          'description': description,
          'icon_url': iconUrl,
        };
        final category = Category.fromJson(json);
        expect(category, equals(createSubject()));
      });

      test('fromJson handles missing optional fields', () {
        final json = {
          'id': id,
          'name': name,
          // description and icon_url are missing
        };
        final category = Category.fromJson(json);
        expect(category.id, equals(id));
        expect(category.name, equals(name));
        expect(category.description, isNull);
        expect(category.iconUrl, isNull);
      });

      test('toJson produces correct map', () {
        final category = createSubject();
        final json = category.toJson();
        expect(
          json,
          equals({
            'id': id,
            'name': name,
            'description': description,
            'icon_url': iconUrl,
          }),
        );
      });

      test('toJson omits null optional fields', () {
        final category =
            createSubject(descriptionOverride: null, iconUrlOverride: null);
        final json = category.toJson();
        expect(
          json,
          equals({
            'id': id,
            'name': name,
            // description and icon_url should be omitted due to includeIfNull: false
          }),
        );
      });
    });
  });
}
