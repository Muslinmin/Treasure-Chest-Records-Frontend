import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/auth_status.dart';
import 'ui/key_setup_screen.dart';
import  'state/providers.dart';
import 'ui/dashboard_screen.dart';
import 'ui/authenticated_shell.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TreasureChestApp(),
    ),
  );
}

class TreasureChestApp extends ConsumerStatefulWidget {
  const TreasureChestApp({super.key});

  @override
  ConsumerState<TreasureChestApp> createState() => _TreasureChestAppState();
}

class _TreasureChestAppState extends ConsumerState<TreasureChestApp> {

  @override
  void initState() {
    super.initState();
    _checkStoredKey();
  }

  Future<void> _checkStoredKey() async {
    final apiKey = await ref.read(secureStorageProvider).read(key: 'api_key');

    if (apiKey != null && apiKey.trim().isNotEmpty) {
      ref.read(authStatusProvider.notifier).state = AuthStatus.authorized;
    } else {
      ref.read(authStatusProvider.notifier).state = AuthStatus.unauthorized;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = ref.watch(authStatusProvider);

    return MaterialApp(
      title: 'Treasure Chest',
      home: switch (authStatus) {
        AuthStatus.unknown => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        AuthStatus.authorized => const AuthenticatedShell(),
        AuthStatus.unauthorized => const KeySetupScreen(),
      },
    );
  }
}