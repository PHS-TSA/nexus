/// This library contains the UI for viewing a post.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../../../utils/format.dart';
import '../../../../utils/toast.dart';
import '../../../auth/application/auth_service.dart';
import '../../../auth/domain/user.dart';
import '../../application/avatar_service.dart';
import '../../application/feed_service.dart';
import '../../data/post_repository.dart';
import '../../domain/post_entity.dart';

/// {@template nexus.features.home.presentation.home.post}
/// View a post.
/// {@endtemplate}
class Post extends StatelessWidget {
  /// {@macro nexus.features.home.presentation.home.post}

  /// Construct a new [Post] widget for a [PostId].
  const Post({
    required this.postId,
    super.key,
  });

  /// [PostId] for this post.
  final PostId postId;

  @override
  Widget build(BuildContext context) {
    // TODO(MattsAttack): implement hero widget.
    return GestureDetector(
      onTap: () async {
        if (context.router.current.name == WrapperRoute.name) {
          // Prevents user from clicking on post in in post view.
          await context.router.push(PostViewRoute(postId: postId));
        }
      },
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // The post sections are in here, like poster info and post content.
              _PosterInfo(postId: postId),
              const Divider(),
              _PostBody(postId: postId),
              _PostInteractables(postId: postId),
            ],
          ),
        ),
      ),
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('postId', postId.id));
  }
  // coverage:ignore-end
}

class _PosterInfo extends ConsumerWidget {
  const _PosterInfo({
    required this.postId,
    super.key,
  });

  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(lishaduck): Better support async loading, to remove the need for non-null assertion.
    final post = ref.watch(wipPostProvider(postId))!;

    // TODO(MattsAttack): Show actual date and time of post when you click on it.

    // Have post info show how long ago in the bar.
    final durationSincePostCreated =
        DateTime.timestamp().difference(post.timestamp);
    final timeSincePost = formatDuration(durationSincePostCreated);

    return Row(
      spacing: 8,
      children: [
        _PostAvatar(authorName: post.authorName),
        Text(post.authorName),
        Text('$timeSincePost ago'),
        // TODO(MattsAttack): Could put flairs here.
      ],
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('postId', postId.id));
  }
  // coverage:ignore-end
}

class _PostAvatar extends ConsumerWidget {
  const _PostAvatar({
    required this.authorName,
    super.key,
  });

  final String authorName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarServiceProvider(authorName));

    return switch (avatar) {
      AsyncData(:final value) => CircleAvatar(
          backgroundImage: MemoryImage(value),
        ),
      AsyncError() => const Text('Error loading avatar'),
      _ => const CircularProgressIndicator()
    };
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('authorName', authorName));
  }
  // coverage:ignore-end
}

class _PostBody extends ConsumerWidget {
  const _PostBody({
    required this.postId,
    super.key,
  });

  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(wipPostProvider(postId))!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          post.headline,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 24,
          ), // TODO(MattsAttack): Need better text styling.
        ),
        Text(
          post.description,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('postId', postId.id));
  }
  // coverage:ignore-end
}

/// Given a list of likes and a user ID, return a new list of likes with the user ID toggled in or out of the list.
Likes toggleLike(Likes currentLikes, UserId userId) {
  // Toggle likes.
  if (!currentLikes.contains(userId)) {
    // User likes the post.
    return currentLikes.add(userId);
  } else {
    // User is removing like
    return currentLikes.remove(userId);
  }
}

class _PostInteractables extends HookConsumerWidget {
  const _PostInteractables({
    required this.postId,
    super.key,
  });

  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
     * How to save like state:
     * When reading in posts, check if users name is on likes list and set a boolean variable to it
     */

    // Get current user id.
    final userId = ref.watch(idProvider);

    final post = ref.watch(wipPostProvider(postId))!;

    return Row(
      children: [
        Text(post.likes.length.toString()),
        IconButton(
          onPressed: () async {
            if (userId == null) {
              throw Exception('Null user ID detected');
              // TODO(MattsAttack): Send user back to login page, perhaps?
            }

            final newLikes = toggleLike(post.likes, userId);

            // Toggle likes.
            ref
                .read(wipPostProvider(post.id).notifier)
                .setPost(post.copyWith(likes: newLikes));

            try {
              await ref
                  .read(postRepositoryProvider)
                  .toggleLikePost(post.id, userId, newLikes);
            } on Exception catch (e) {
              // Undo like.
              ref
                  .read(wipPostProvider(post.id).notifier)
                  .setPost(post); // This is still the old post.

              if (!context.mounted) return;
              context.showSnackBar(
                content: Text('Failed to like post: $e'),
              );
            }
          },
          icon: Icon(
            post.likes.contains(userId)
                ? Icons.thumb_up_sharp
                : Icons.thumb_up_outlined,
          ),
        ),
      ],
    );
  }

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('postId', postId.id));
  }
  // coverage:ignore-end
}
