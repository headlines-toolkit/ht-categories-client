# HT Categories Client

A Dart client interface package for managing news categories. This package defines the abstract client contract (`HtCategoriesClient`), data models (`Category`), and specific exceptions for category operations.

It is designed to be implemented by concrete clients that interact with different data sources (e.g., APIs, local databases).

## Features

*   **Abstract Client:** Defines a clear CRUD interface (`HtCategoriesClient`) for category management.
*   **Data Model:** Provides an immutable `Category` model with JSON serialization support (`json_serializable`) and value equality (`equatable`). Includes automatic UUID generation for new categories.
*   **Custom Exceptions:** Defines specific exceptions for granular error handling during category operations (e.g., `GetCategoriesFailure`, `CategoryNotFoundFailure`).

## Getting Started

### Prerequisites

*   Dart SDK: "^3.5.0" or higher.
*   Flutter SDK (if using in a Flutter project).

### Installation

Since this package is hosted on GitHub and not published on pub.dev, add it to your `pubspec.yaml` dependencies using a Git reference:

```yaml
dependencies:
  ht_categories_client:
    git:
      url: https://github.com/headlines-toolkit/ht-categories-client.git
      # Optionally specify a ref (branch, tag, or commit hash):
      # ref: main
```

Then, run `flutter pub get` or `dart pub get`.

## Usage

1.  **Import the package:**

    ```dart
    import 'package:ht_categories_client/ht_categories_client.dart';
    ```

2.  **Implement the client:** Create a concrete class that implements `HtCategoriesClient` and provides the logic to interact with your specific data source.

    ```dart
    class MyApiCategoriesClient implements HtCategoriesClient {
      // Replace with your actual API client/database logic
      final _apiClient = YourApiClient();

      @override
      Future<List<Category>> getCategories() async {
        try {
          // Fetch data from your source
          final apiData = await _apiClient.fetchCategories();
          // Map API data to Category models
          return apiData.map((data) => Category.fromJson(data)).toList();
        } catch (e, s) {
          // Handle errors and throw specific exceptions
          throw GetCategoriesFailure(e, s);
        }
      }

      @override
      Future<Category> getCategory(String id) async {
        try {
          final apiData = await _apiClient.fetchCategory(id);
          if (apiData == null) {
            throw CategoryNotFoundFailure(id, 'Category not found via API', StackTrace.current);
          }
          return Category.fromJson(apiData);
        } catch (e, s) {
          if (e is CategoryNotFoundFailure) rethrow; // Allow specific exception
          throw GetCategoryFailure(e, s);
        }
      }

      // Implement createCategory, updateCategory, deleteCategory similarly...
      @override
      Future<Category> createCategory({
        required String name,
        String? description,
        String? iconUrl,
      }) async {
        // ... implementation ...
        throw UnimplementedError(); // Replace with actual implementation
      }

      @override
      Future<Category> updateCategory(Category category) async {
        // ... implementation ...
        throw UnimplementedError(); // Replace with actual implementation
      }

      @override
      Future<void> deleteCategory(String id) async {
        // ... implementation ...
        throw UnimplementedError(); // Replace with actual implementation
      }
    }
    ```

3.  **Use the implementation:** Inject your concrete client implementation where needed (e.g., using a dependency injection framework) and call its methods.

    ```dart
    // Example: Using the client (assuming 'client' is an instance of MyApiCategoriesClient)
    try {
      final categories = await client.getCategories();
      print('Fetched ${categories.length} categories.');

      final newCategory = await client.createCategory(name: 'Sports');
      print('Created category: ${newCategory.name} (ID: ${newCategory.id})');

    } on CategoryException catch (e) {
      print('An error occurred: $e');
      // Handle specific category errors
    }
    ```

