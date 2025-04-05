/// This library contains the UI for viewing the details of a post.
library;

import 'package:auto_route/auto_route.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../application/feed_service.dart';
import '../../application/post_service.dart';
import '../../domain/comment_entity.dart';
import '../../domain/post_id.dart';
import 'comment.dart';
import 'create_comment.dart';
import 'post.dart';

/// {@template nexus.features.home.presentation.home.post_view_page}
/// A page that contains full post information.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class PostViewPage extends ConsumerWidget {
  /// {@macro nexus.features.home.presentation.home.post_view_page}
  ///
  /// Construct a new [PostViewPage] widget.
  const PostViewPage({@PathParam('id') required this.id, super.key});

  /// [PostId] for this post.
  final String id;

  PostId get _postId => PostId(id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = RouterScope.of(context, watch: true);

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () async {
            if (scope.controller.canPop()) {
              await scope.controller.maybePopTop();
            } else {
              await context.router.replace(const FeedRoutingRoute());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (context) => const CreateComment(),
          );

          ref.invalidate(singlePostProvider(_postId));
        },
        child: const Icon(Icons.add_comment),
      ),
      body: ListView(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Consumer(
                builder: (context, ref, child) {
                  final response = ref.watch(postServiceProvider(_postId));

                  return switch (response) {
                    AsyncData(:final value?) => Column(
                      children: [
                        ProviderScope(
                          overrides: [
                            currentPostProvider.overrideWithValue(value),
                          ],
                          child: const Post(),
                        ),

                        const Divider(),

                        if (value.comments.isNotEmpty)
                          _Comments(comments: value.comments),
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
    properties.add(StringProperty('postId', _postId.id));
  }

  // coverage:ignore-end
}

class _Comments extends StatelessWidget {
  const _Comments({required this.comments, super.key});

  final IList<CommentEntity> comments;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [for (final comment in comments) Comment(comment: comment)],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<CommentEntity>('comments', comments));
  }
}
