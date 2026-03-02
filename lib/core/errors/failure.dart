import 'package:flutter/foundation.dart';

@immutable
class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => 'Failure($message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
