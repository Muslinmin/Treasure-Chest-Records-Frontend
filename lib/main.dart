import 'package:flutter/material.dart';

void main() {
  runApp(const TreasureChestApp());
}

class TreasureChestApp extends StatelessWidget {
  const TreasureChestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Treasure Chest Records',
      home: Scaffold(
        body: Center(
          child: Text('Treasure Chest Records'),
        ),
      ),
    );
  }
}
