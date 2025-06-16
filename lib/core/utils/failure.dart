class Failure {
  const Failure([this.message = 'An unexpected error occurred.']);

  final String message;

  @override
  String toString() => 'Failure: $message';
}
