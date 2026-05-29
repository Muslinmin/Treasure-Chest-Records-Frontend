import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_status.dart';
import '../state/providers.dart';


class KeySetupScreen extends ConsumerStatefulWidget {
  const KeySetupScreen({super.key});

  @override
  ConsumerState<KeySetupScreen> createState() => _KeySetupScreenState();
}


class _KeySetupScreenState extends ConsumerState<KeySetupScreen> {
  // 1. Declare the text editing controller
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    // 2. Memory management: Always clean up controllers to prevent leaks
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _saveKey() async {
    // 3. Extract and clean the input text
    final apiKey = _keyController.text.trim();

    // 4. Guard Clause: If the input is empty, exit early
    if (apiKey.isEmpty) return;

    // 5. Securely write the key using the infrastructure provider
    // Using 'write' matching the standard FlutterSecureStorage contract
    await ref.read(secureStorageProvider).write(
          key: 'api_key', // Using your storage identifier string
          value: apiKey,
        );

    // 6. Notify Riverpod that the status is now authorized
    // (This triggers the switch block in main.dart to swap out the screen)
    ref.read(authStatusProvider.notifier).state = AuthStatus.authorized;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter API Key'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Please paste your API access key below to securely connect your wallet environment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _keyController,
                obscureText: true, // Hides input characters for security
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  border: OutlineInputBorder(),
                  hintText: 'sk_live_...',
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _saveKey,
                child: const Text('Save and Connect'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}