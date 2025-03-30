/// This library contains a widget that displays a feed of posts.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../application/feed_service.dart';
import '../../application/post_service.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_model_entity.dart';
import 'post.dart';

/// {@template harvest_hub.features.home.presentation.home.feed}
/// An infinite loading list of posts.
/// {@endtemplate}
class Feed extends ConsumerWidget {
  /// {@macro harvest_hub.features.home.presentation.home.feed}
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
            final _ = await ref.refresh(feedPostProvider(feed, 0).future);
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final id = ref.watch(feedPostProvider(feed, index));
              final lastIsLoading =
                  index > 0 &&
                  ref.watch(feedPostProvider(feed, index - 1)).isLoading;

              final AsyncValue<PostModelEntity?> response = switch (id) {
                AsyncData(:final value?) => ref.watch(
                  postServiceProvider(value),
                ),
                AsyncData() => const AsyncData(null),
                AsyncError(:final error, :final stackTrace) => AsyncError(
                  error,
                  stackTrace,
                ),
                _ => const AsyncLoading(),
              };

              return switch (response) {
                // If there's an error, display it as another post.
                AsyncValue(:final error, :final stackTrace, hasError: true) =>
                  Card(
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
                          Text(
                            '$error\n$stackTrace',
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),

                AsyncValue(:final value, hasValue: true) when value != null =>
                  GestureDetector(
                    onTap: () async {
                      await context.router.push(PostViewRoute(id: value.id.id));
                    },
                    child: Card(
                      margin: const EdgeInsets.all(4),
                      child: ProviderScope(
                        overrides: [
                          currentPostProvider.overrideWithValue(value),
                        ],
                        child: Post(key: ValueKey(value)),
                      ),
                    ),
                  ),

                // If we have none, return a placeholder.
                AsyncValue(hasValue: true) when index == 0 => const Center(
                  child: Text('No posts yet. Make the first!'),
                ),
                // If we run out of items, return null.
                AsyncValue(hasValue: true) => null,

                // If we're loading, display a loading indicator.
                AsyncLoading() when !lastIsLoading => const Center(
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: CircularProgressIndicator(),
                  ),
                ),
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
