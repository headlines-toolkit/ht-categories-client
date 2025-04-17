import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template category}
/// Represents a news category.
///
/// Contains details like ID, name, description, and an optional icon URL.
/// The [id] is automatically generated using UUID v4 if not provided.
/// {@endtemplate}
@immutable
class Category extends Equatable {
  /// {@macro category}
  ///
  /// If an [id] is not provided, a UUID v4 will be generated.
  Category({required this.name, String? id, this.description, this.iconUrl})
    : id = id ?? const Uuid().v4();

  /// Creates a Category instance from a JSON map.
  ///
  /// Throws a [FormatException] if the JSON map is invalid.
  factory Category.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final name = json['name'] as String?;
    final description = json['description'] as String?;
    final iconUrl = json['icon_url'] as String?;

    if (name == null) {
      throw const FormatException('Missing required field: "name"');
    }

    return Category(
      id: id, // Constructor handles null ID generation
      name: name,
      description: description,
      iconUrl: iconUrl,
    );
  }

  /// The unique identifier of the category.
  final String id;

  /// The display name of the category.
  final String name;

  /// An optional description for the category.
  final String? description;

  /// An optional URL for an icon representing the category.
  final String? iconUrl;

  /// Converts this Category instance to a JSON map.
  ///
  /// Optional fields ([description], [iconUrl]) are included only if they
  /// are not null.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (iconUrl != null) 'icon_url': iconUrl,
    };
  }

  /// Converts this Category instance to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Creates a copy of this Category but with the given fields replaced with
  /// the new values.
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, description, iconUrl];

  @override
  bool get stringify => true;
}
