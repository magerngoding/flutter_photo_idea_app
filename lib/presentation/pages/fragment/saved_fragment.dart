import 'package:flutter/material.dart';

class SavedFragment extends StatefulWidget {
  const SavedFragment({super.key});

  @override
  State<SavedFragment> createState() => _SavedFragmentState();
}

class _SavedFragmentState extends State<SavedFragment> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Saved'),
      ),
    );
  }
}
