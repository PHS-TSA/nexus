/// This library contains a widget that displays a feed of posts.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/feed_service.dart';
import '../../domain/feed_entity.dart';
import 'post.dart';

/// {@template nexus.features.home.presentation.home.feed}
/// An infinite loading list of posts.
/// {@endtemplate}
class Feed extends ConsumerWidget {
  /// {@macro nexus.features.home.presentation.home.feed}
  ///
  /// Construct a new [Feed] widget.
  const Feed({required this.feed, super.key});

  /// The feed to fetch the posts from.
  final FeedEntity feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(MattsAttack): Maybe change to scaffold with floating action button and list view as child.
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 600),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          dragDevices: Set.from(PointerDeviceKind.values),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(feedServiceProvider(feed));
            return await ref.refresh(feedPostProvider(feed, 0).future);
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final response = ref.watch(feedPostProvider(feed, index));

              return switch (response) {
                AsyncData(:final value) when value != null => Post(
                  postId: value,
                ),

                // If we have none, return a placeholder.
                AsyncData() when index == 0 => const Expanded(
                  child: Center(child: Text('No posts yet. Make the first!')),
                ),
                // If we run out of items, return null.
                AsyncData() => null,

                // If there's an error, display it as another post.
                AsyncError(:final error, :final stackTrace) => Card(
                  margin: const EdgeInsets.all(4),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        const Text(
                          'Error',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 24,
                          ), // TODO(MattsAttack): Need better text styling.
                        ),
                        Text('$error\n$stackTrace', textAlign: TextAlign.left),
                      ],
                    ),
                  ),
                ),

                // If we're loading, display a loading indicator.
                _ => null,
              };
            },
          ),
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
