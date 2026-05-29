
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  unknown,
  authorized,
  unauthorized,
}

final authStatusProvider = StateProvider<AuthStatus>((ref) => AuthStatus.unknown);


void handleUnauthorizedException(Ref ref) {
  ref.read(authStatusProvider.notifier).state = AuthStatus.unauthorized;
}