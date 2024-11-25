/// This library contains a widget that displays a feed of posts.
// ignore_for_file: prefer_expression_function_bodies

library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
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
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final response = ref.watch(singlePostProvider(feed, index));

            return switch (response) {
              AsyncData(:final value) when value != null => Post(post: value),

              // If we run out of items, return null.
              AsyncData() => null,

              // If there's an error, display it as another post.
              AsyncError(:final error) => Post(
                  post: PostEntity(
                    headline: 'Error',
                    description: error.toString(),
                    author: '',
                    authorName: '',
                    lat: 0,
                    lng: 0,
                    likes: const [],
                    numberOfLikes: 0,
                    timestamp: DateTime.timestamp(),
                  ),
                ),

              // If we're loading, display a loading indicator.
              _ => null,
            };
          },
        ),
      ),
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
