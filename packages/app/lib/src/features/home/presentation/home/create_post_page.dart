import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage(deferredLoading: true)
class CreatePostPage extends HookConsumerWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use similar code to login page

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Bar'),
      ),
      body: const Text('i work'),
    );
  }
}
