/// This library contains the UI for viewing the details of a post.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/post_service.dart';
import '../../domain/post_id.dart';
import 'post.dart';

/// {@template nexus.features.home.presentation.home.post_view_page}
/// A page that contains full post information.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class PostViewPage extends ConsumerWidget {
  /// {@macro nexus.features.home.presentation.home.post_view_page}
  ///
  /// Construct a new [PostViewPage] widget.
  const PostViewPage({required this.postId, super.key});

  /// ID for this post.
  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // TODO(MattsAttack): Could update this to be more interesting.
        title: const Text('Post View'),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Consumer(
                builder: (context, ref, child) {
                  final response = ref.watch(postServiceProvider(postId));

                  return switch (response) {
                    AsyncData(:final value?) => Column(
                      children: [
                        ProviderScope(
                          overrides: [
                            currentPostProvider.overrideWithValue(value),
                          ],
                          child: const Post(),
                        ),
                        // TODO(MattsAttack): Comments will go here.
                      ],
                    ),
                    AsyncData() => const Center(child: Text('Post not found')),
                    AsyncError(:final error, :final stackTrace) => Center(
                      child: Text(
                        'Error: $error\n$stackTrace',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    _ => const Center(child: CircularProgressIndicator()),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('postId', postId.id));
  }

  // coverage:ignore-end
}
