class ApiException implements Exception {
  const ApiException({required this.code, this.message, this.status, this.attemptsLeft});

  final String code;
  final String? message;
  final int? status;
  final int? attemptsLeft;

  @override
  String toString() => 'ApiException($code, $status)';
}
