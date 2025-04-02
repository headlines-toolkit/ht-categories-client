//
// ignore_for_file: lines_longer_than_80_chars

import 'package:ht_categories_client/src/models/models.dart';
// --- Exceptions ---

/// {@template category_exception}
/// Base exception for errors encountered during category operations.
/// {@endtemplate}
class CategoryException implements Exception {
  /// {@macro category_exception}
  const CategoryException(this.error, [this.stackTrace]);

  /// The underlying error that occurred.
  final Object error;

  /// The stack trace associated with the error, if available.
  final StackTrace? stackTrace;

  @override
  String toString() => 'CategoryException: $error';
}

/// {@template get_categories_failure}
/// Thrown when fetching all categories fails.
/// {@endtemplate}
class GetCategoriesFailure extends CategoryException {
  /// {@macro get_categories_failure}
  const GetCategoriesFailure(super.error, [super.stackTrace]);
}

/// {@template get_category_failure}
/// Thrown when fetching a single category fails for reasons other than not found.
/// {@endtemplate}
class GetCategoryFailure extends CategoryException {
  /// {@macro get_category_failure}
  const GetCategoryFailure(super.error, [super.stackTrace]);
}

/// {@template create_category_failure}
/// Thrown when creating a category fails.
/// {@endtemplate}
class CreateCategoryFailure extends CategoryException {
  /// {@macro create_category_failure}
  const CreateCategoryFailure(super.error, [super.stackTrace]);
}

/// {@template update_category_failure}
/// Thrown when updating a category fails for reasons other than not found.
/// {@endtemplate}
class UpdateCategoryFailure extends CategoryException {
  /// {@macro update_category_failure}
  const UpdateCategoryFailure(super.error, [super.stackTrace]);
}

/// {@template delete_category_failure}
/// Thrown when deleting a category fails for reasons other than not found.
/// {@endtemplate}
class DeleteCategoryFailure extends CategoryException {
  /// {@macro delete_category_failure}
  const DeleteCategoryFailure(super.error, [super.stackTrace]);
}

/// {@template category_not_found_failure}
/// Thrown specifically when a category operation fails because the category
/// with the specified ID could not be found.
/// {@endtemplate}
class CategoryNotFoundFailure extends CategoryException {
  /// {@macro category_not_found_failure}
  const CategoryNotFoundFailure(this.id, super.error, [super.stackTrace]);

  /// The ID of the category that was not found.
  final String id;

  @override
  String toString() =>
      'CategoryNotFoundFailure: Category with ID "$id" not found. Error: $error';
}

// --- Abstract Client ---

/// {@template ht_categories_client}
/// An abstract interface defining the contract for managing news categories.
///
/// Implementations of this class are responsible for the actual data fetching
/// and manipulation logic (e.g., from an API, local database).
/// {@endtemplate}
abstract class HtCategoriesClient {
  /// {@macro ht_categories_client}
  const HtCategoriesClient();

  /// Fetches all available news categories.
  ///
  /// Returns a list of [Category] objects.
  ///
  /// Throws a [GetCategoriesFailure] if an unexpected error occurs during fetching.
  Future<List<Category>> getCategories();

  /// Fetches a single news category by its unique [id].
  ///
  /// Returns the [Category] object if found.
  ///
  /// Throws a [GetCategoryFailure] if an unexpected error occurs.
  /// Throws a [CategoryNotFoundFailure] if no category with the given [id] exists.
  Future<Category> getCategory(String id);

  /// Creates a new news category with the provided details.
  ///
  /// Takes the required [name] and optional [description] and [iconUrl].
  /// The implementing service is responsible for generating the unique ID.
  /// Returns the newly created [Category] object, including its assigned ID.
  ///
  /// Throws a [CreateCategoryFailure] if an unexpected error occurs during creation.
  Future<Category> createCategory({
    required String name,
    String? description,
    String? iconUrl,
  });

  /// Updates an existing news category identified by its [Category.id].
  ///
  /// The [category] object must contain the [Category.id] to update,
  /// along with the new values for the fields to be modified.
  /// Returns the updated [Category] object.
  ///
  /// Throws an [UpdateCategoryFailure] if an unexpected error occurs during the update.
  /// Throws a [CategoryNotFoundFailure] if no category with the given `category.id` exists.
  Future<Category> updateCategory(Category category);

  /// Deletes a news category by its unique [id].
  ///
  /// Returns normally if the deletion is successful.
  ///
  /// Throws a [DeleteCategoryFailure] if an unexpected error occurs during deletion.
  /// Throws a [CategoryNotFoundFailure] if no category with the given [id] exists.
  Future<void> deleteCategory(String id);
}
