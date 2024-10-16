/// This library contains a widget that displays a feed of posts.
// ignore_for_file: prefer_expression_function_bodies

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
import '../../data/post_repository.dart';
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
    // Maybe change to scaffold with floating action button and list view as child
    return ListView.builder(
      shrinkWrap: true,
      prototypeItem: _Post(
        post: PostEntity(
          headline: '',
          description: '',
          lat: 0,
          lng: 0,
          timestamp: DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true),
          author: '',
        ),
      ),
      itemBuilder: (context, index) {
        // Calculate the page and index in the page.
        final page = index ~/ pageSize + 1;
        final indexInPage = index % pageSize;

        final response = ref.watch(feedServiceProvider(feed, page));

        return switch (response) {
          AsyncData(:final value) when indexInPage < value.posts.length =>
            _Post(post: value.posts[indexInPage]),

          // If we run out of items, return null.
          AsyncData() => null,

          // If there's an error, display it as another post.
          AsyncError(:final error) => _Post(
              post: PostEntity(
                headline: 'Error',
                description: error.toString(),
                author: '',
                lat: 0,
                lng: 0,
                timestamp: DateTime.timestamp(),
              ),
            ),
          // If we're loading, display a loading indicator.
          _ => const CircularProgressIndicator(),
        };
      },
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FeedEntity>('feed', feed));
  }
  // coverage:ignore-end
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
          // If the image is an BucketFile, figure out how to get the image from the API.
          // Will need to be cached in Riverpod. Probably store it in the entity.
          // But, deserialization shouldn't need to know about the API.
          // This'll be tricky. For now, I think we make a dummy image.
          final String _ => Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
            ),
          // final BucketFile image => Image.memory(image),
          // Else, return null.
          null => null,
        },
        title: Text(post.headline),
        subtitle: Text(post.description),
        // isThreeLine: true,
        // minVerticalPadding: 100,
        // TODO(MattsAttack): add in on tap functionality to click on post
      ),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
  // coverage:ignore-end
}
