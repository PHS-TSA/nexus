/// This library contains the UI for viewing a post.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../app/router.gr.dart';
import '../../../../utils/format.dart';
import '../../../auth/application/auth_service.dart';
import '../../application/avatar_service.dart';
import '../../data/post_repository.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_entity.dart';

/// {@template nexus.features.home.presentation.home.post}
/// View a post.
/// {@endtemplate}
class Post extends StatelessWidget {
  /// {@macro nexus.features.home.presentation.home.post}

  /// Construct a new [Post] widget from a [PostEntity].
  const Post({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  /// [PostEntity] that contains data displayed in this post.
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    // TODO(MattsAttack): implement hero widget.
    return GestureDetector(
      onTap: () async {
        if (context.router.current.name == WrapperRoute.name) {
          // Prevents user from clicking on post in in post view.
          await context.router.push(PostViewRoute(post: post));
        }
      },
      child: Card(
        margin: const EdgeInsets.all(4),
        child: Container(
          // constraints: const BoxConstraints(minHeight: 220, maxHeight: 300),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // The post sections are in here, like poster info and post content.
              _PosterInfo(post: post),
              const Divider(
                color: Colors.white, // TODO(MattsAttack): base color on theme.
              ),
              _PostBody(post: post),
              _PostInteractables(post: post),
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
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
  // coverage:ignore-end
}

class _PosterInfo extends StatelessWidget {
  const _PosterInfo({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    // TODO(MattsAttack): Show actual date and time of post when you click on it.

    // Have post info show how long ago in the bar.
    final timeSincePost = DateTime.timestamp().difference(post.timestamp);
    final timePostValue = formatDuration(timeSincePost);

    return Row(
      children: [
        _PostAvatar(post: post),
        const SizedBox(width: 8),
        Text(post.authorName), // Get user name instead of id
        // Text(post.author), // Get user name instead of id
        const SizedBox(width: 8),
        Text('$timePostValue ago'),
        // TODO(MattsAttack): Could put flairs here.
      ],
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

class _PostAvatar extends ConsumerWidget {
  const _PostAvatar({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  final PostEntity post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = ref.watch(avatarServiceProvider(post.authorName));

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
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
  // coverage:ignore-end
}

class _PostBody extends StatelessWidget {
  const _PostBody({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          post.headline,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 24),
        ), // Need text styling
        const Padding(padding: EdgeInsets.all(4)),
        Text(
          post.description,
          textAlign: TextAlign.left,
        ), // Get user name instead of id
      ],
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

class _PostInteractables extends HookConsumerWidget {
  const _PostInteractables({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
     * How to save like state:
     * When reading in posts, check if users name is on likes list and set a boolean variable to it
     */

    // Gets current user id and username
    final userId = ref.watch(idProvider);
    final username = ref.watch(usernameProvider);

    final currentLikes = useState(
      // Create a copy of the likes list.
      List<String>.from(post.likes),
    );

    return Row(
      children: [
        Text(currentLikes.value.length.toString()),
        IconButton(
          onPressed: () async {
            // Toggle likes.
            if (userId != null) {
              if (!currentLikes.value.contains(userId)) {
                // User likes the post.
                currentLikes.value.add(userId);
              } else {
                // User is removing like
                currentLikes.value.remove(userId);
              }
              await ref
                  .read(
                    postRepositoryProvider(
                      userId,
                      username,
                      const FeedEntity.world(),
                    ),
                  )
                  .toggleLikePost(
                    post.id!, // TODO(MattsAttack): find alternative to `!`.
                    userId,
                    currentLikes.value,
                  );
            } else {
              throw Exception('Null user ID detected');
              // TODO(MattsAttack): Send user back to login page, perhaps?
            }
          },
          icon: Icon(
            currentLikes.value.contains(userId)
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
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
  // coverage:ignore-end
}
