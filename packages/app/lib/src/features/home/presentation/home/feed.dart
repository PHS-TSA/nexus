/// This library contains a widget that displays a feed of posts.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
import '../../data/post_repository.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_entity.dart';
import 'post.dart';

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
      prototypeItem: Post(
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
            Post(post: value.posts[indexInPage]),

          // If we run out of items, return null.
          AsyncData() => null,

          // If there's an error, display it as another post.
          AsyncError(:final error) => Post(
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
