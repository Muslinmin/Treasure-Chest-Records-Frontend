// Thrown when the API returns 401 or 403.
// Means the stored key is missing or wrong — there is nothing to retry.
// The layer above must route the user back to the key setup screen.

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException([this.message = 'Unauthorized access. Please check your credentials.']);

  @override
  String toString() => 'UnauthorizedException: $message';
}