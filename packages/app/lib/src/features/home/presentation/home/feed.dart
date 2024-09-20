import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_entity.dart';

/// {@template our_democracy.features.home.presentation.feed}
/// An infinite loading list of posts.
/// {@endtemplate}
class Feed extends ConsumerWidget {
  /// {@macro our_democracy.features.home.presentation.feed}
  const Feed({required this.feed, super.key});

  final FeedEntity feed;

  static const _pageSize = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      prototypeItem: const _Post(post: PostEntity(body: '', image: null)),
      itemBuilder: (context, index) {
        final page = index ~/ _pageSize + 1;
        final indexInPage = index % _pageSize;
        final response = ref.watch(feedServiceProvider(feed, page));

        return switch (response) {
          AsyncData(:final value) => indexInPage >= value.posts.length
              ? null
              : _Post(post: value.posts[indexInPage]),
          AsyncError(:final error) => _Post(
              post: PostEntity(body: error.toString(), image: null),
            ),
          _ => const CircularProgressIndicator(),
        };
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FeedEntity>('feed', feed))
      ..add(IntProperty('pageSize', _pageSize));
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
