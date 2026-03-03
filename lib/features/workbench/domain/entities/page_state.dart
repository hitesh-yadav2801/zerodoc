import 'package:flutter/foundation.dart';

@immutable
class PageState {
  const PageState({
    required this.originalIndex,
    this.rotation = 0,
    this.isSelected = false,
    this.thumbnail,
  });

  final int originalIndex;
  final int rotation;
  final bool isSelected;
  final Uint8List? thumbnail;

  PageState copyWith({
    int? originalIndex,
    int? rotation,
    bool? isSelected,
    Uint8List? thumbnail,
  }) {
    return PageState(
      originalIndex: originalIndex ?? this.originalIndex,
      rotation: rotation ?? this.rotation,
      isSelected: isSelected ?? this.isSelected,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  PageState rotateBy(int degrees) {
    return copyWith(rotation: (rotation + degrees) % 360);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageState &&
          runtimeType == other.runtimeType &&
          originalIndex == other.originalIndex &&
          rotation == other.rotation &&
          isSelected == other.isSelected;

  @override
  int get hashCode =>
      originalIndex.hashCode ^ rotation.hashCode ^ isSelected.hashCode;
}
