import 'package:freezed_annotation/freezed_annotation.dart';

part 'library.freezed.dart';
part 'library.g.dart';

@freezed
abstract class Library with _$Library {
  const factory Library({
    required String id,
    required String name,
    String? coverImage,
  }) = _Library;

  factory Library.fromJson(Map<String, Object?> json) =>
      _$LibraryFromJson(json);
}
