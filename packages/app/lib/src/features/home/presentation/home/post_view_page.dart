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

/// {@template harvest_hub.features.home.presentation.home.post_view_page}
/// A page that contains full post information.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class PostViewPage extends ConsumerWidget {
  /// {@macro harvest_hub.features.home.presentation.home.post_view_page}
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
      floatingActionButton: Consumer(
        builder:
            (context, ref, _) => FloatingActionButton(
              onPressed: () async {
                final post = ref.read(postServiceProvider(_postId)).valueOrNull;
                if (post == null) {
                  return;
                }

                await showDialog<void>(
                  context: context,
                  builder: (context) => CreateComment(post: post),
                );

                ref.invalidate(singlePostProvider(_postId));
              },
              child: const Icon(Icons.add_comment),
            ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(singlePostProvider(_postId));
          final _ = await ref.read(postServiceProvider(_postId).future);
        },
        child: ListView(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Consumer(
                  builder: (context, ref, _) {
                    final response = ref.watch(postServiceProvider(_postId));

                    return switch (response) {
                      AsyncError(
                        :final error,
                        :final stackTrace,
                        hasError: true,
                      ) =>
                        Center(
                          child: Text(
                            'Error: $error\n$stackTrace',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      AsyncValue(:final value?, hasValue: true) => Column(
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
                      AsyncValue(hasValue: true) => const Center(
                        child: Text('Post not found'),
                      ),
                      _ => const Center(child: CircularProgressIndicator()),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
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
    return Column(
      children: [for (final comment in comments) Comment(comment: comment)],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<CommentEntity>('comments', comments));
  }
}
