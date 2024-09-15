import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_entity.dart';

class Feed extends ConsumerWidget {
  const Feed({required this.feed, super.key});

  final FeedEntity feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolvedFeed = ref.watch(feedServiceProvider(feed));

    return ListView.builder(
      prototypeItem: _Post(post: resolvedFeed.posts.first),
      itemBuilder: (context, index) {
        return _Post(post: resolvedFeed.posts[index]);
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
        leading: Image(image: post.image),
        title: const Text('This works'),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
}
