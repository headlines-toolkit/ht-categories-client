import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

/// {@template category}
/// Represents a news category.
///
/// Contains details like ID, name, description, and an optional icon URL.
/// The [id] is automatically generated using UUID v4 if not provided.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Category extends Equatable {
  /// {@macro category}
  ///
  /// If an [id] is not provided, a UUID v4 will be generated.
  Category({
    required this.name,
    String? id,
    this.description,
    this.iconUrl,
  }) : id = id ?? const Uuid().v4();

  /// Creates a Category from a JSON map.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// The unique identifier of the category.
  final String id;

  /// The display name of the category.
  final String name;

  /// An optional description for the category.
  @JsonKey(includeIfNull: false)
  final String? description;

  /// An optional URL for an icon representing the category.
  @JsonKey(name: 'icon_url', includeIfNull: false)
  final String? iconUrl;

  /// Converts this Category instance to a JSON map.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

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
