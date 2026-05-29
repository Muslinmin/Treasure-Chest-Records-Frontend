
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  authorized,
  unauthorized,
}

final authStatusProvider = StateProvider<AuthStatus>((ref) => AuthStatus.authorized);


void handleUnauthorizedException(Ref ref) {
  ref.read(authStatusProvider.notifier).state = AuthStatus.unauthorized;
}