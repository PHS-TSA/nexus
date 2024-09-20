/// This library contains a widget that displays a feed of posts.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_entity.dart';

/// {@template our_democracy.features.home.presentation.home.feed}
/// An infinite loading list of posts.
/// {@endtemplate}
class Feed extends ConsumerWidget {
  /// {@macro our_democracy.features.home.presentation.home.feed}
  ///
  /// Construct a new [Feed] widget.
  const Feed({required this.feed, super.key});

  /// The feed to fetch the posts from.
  final FeedEntity feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      prototypeItem: const _Post(post: PostEntity(body: '', image: null)),
      itemBuilder: (context, index) {
        // Calculate the page and index in the page.
        final page = index ~/ pageSize + 1;
        final indexInPage = index % pageSize;

        final response = ref.watch(feedServiceProvider(feed, page));

        return switch (response) {
          AsyncData(:final value) => indexInPage >= value.posts.length
              // If we run out of items, return null.
              ? null
              // Otherwise, return the post.
              : _Post(post: value.posts[indexInPage]),
          // If there's an error, display it as another post.
          AsyncError(:final error) => _Post(
              post: PostEntity(
                body: error.toString(),
                image: null,
              ),
            ),
          // If we're loading, display a loading indicator.
          _ => const CircularProgressIndicator(),
        };
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FeedEntity>('feed', feed));
  }
}

class _Post extends StatelessWidget {
  const _Post({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: switch (post.image) {
          // If the image is an ImageProvider, use the image.
          final ImageProvider image => Image(image: image),
          // Else, return null.
          null => null,
        },
        title: Text(post.body),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
}
