/// This library contains the UI for viewing a post.
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../../../../utils/toast.dart';
import '../../../auth/application/auth_service.dart';
import '../../application/feed_service.dart';
import '../../application/post_service.dart';

/// {@template nexus.features.home.presentation.home.post}
/// View a post.
/// {@endtemplate}
class Post extends StatelessWidget {
  /// {@macro nexus.features.home.presentation.home.post}
  ///
  /// Construct a new [Post] widget for a [].
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(MattsAttack): implement hero widget.
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // The post sections are in here, like poster info and post content.
          _PosterInfo(),
          Divider(),
          _PostBody(),
          _PostInteractables(),
        ],
      ),
    );
  }
}

class _PosterInfo extends ConsumerWidget {
  const _PosterInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(lishaduck): Better support async loading, to remove the need for non-null assertion.
    final authorName = ref.watch(currentPostAuthorNameProvider);
    final timestamp = ref.watch(currentPostTimestampProvider);

    // TODO(MattsAttack): Show actual date and time of post when you click on it.

    return Row(
      spacing: 8,
      children: [
        const _PostAvatar(),
        Text(authorName),
        Timeago(date: timestamp, builder: (context, value) => Text(value)),
        // TODO(MattsAttack): Could put flairs here.
      ],
    );
  }
}

class _PostAvatar extends ConsumerWidget {
  const _PostAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(currentPostAvatarProvider);

    return CircleAvatar(backgroundImage: MemoryImage(avatar));
  }
}

class _PostBody extends ConsumerWidget {
  const _PostBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headline = ref.watch(currentPostHeadlineProvider);
    final description = ref.watch(currentPostDescriptionProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          headline,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 24,
          ), // TODO(MattsAttack): Need better text styling.
        ),
        Text(description, textAlign: TextAlign.left),
        // Call storage from in here so the rest of the post loads first
        const _PostImages(),
      ],
    );
  }
}

class _PostImages extends ConsumerWidget {
  const _PostImages({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(currentPostImagesProvider);

    if (images.isEmpty) {
      return const SizedBox(height: 0);
    }

    return SizedBox(
      height: 500,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.memory(images[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}

class _PostInteractables extends HookConsumerWidget {
  const _PostInteractables({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
     * How to save like state:
     * When reading in posts, check if users name is on likes list and set a boolean variable to it
     */

    // Get current user id.
    final userId = ref.watch(idProvider);
    final postId = ref.watch(currentPostIdProvider);
    final likes = ref.watch(currentPostLikesProvider);

    return Row(
      children: [
        Text('${likes.length}'),
        IconButton(
          onPressed: () async {
            if (userId == null) {
              throw Exception('Null user ID detected');
              // TODO(MattsAttack): Send user back to login page, perhaps?
            }

            final liked = await ref
                .read(singlePostProvider(postId).notifier)
                .toggleLike(userId);

            if (!liked || !context.mounted) return;
            context.showSnackBar(content: const Text('Failed to like post'));
          },
          icon: Icon(
            likes.contains(userId)
                ? Icons.thumb_up_sharp
                : Icons.thumb_up_outlined,
          ),
        ),
      ],
    );
  }
}
