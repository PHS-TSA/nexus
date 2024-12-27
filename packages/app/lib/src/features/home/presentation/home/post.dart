// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/application/auth_service.dart';
import '../../application/avatar_service.dart';
import '../../data/post_repository.dart';
import '../../domain/feed_entity.dart';
import '../../domain/post_entity.dart';

class Post extends StatelessWidget {
  const Post({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      child: Container(
        // constraints: const BoxConstraints(minHeight: 220, maxHeight: 300),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Have sections of post in here. Poster info and post content
            _PosterInfo(post: post),
            const Divider(color: Colors.white), //TODObase on theme
            _PostBody(post: post),
            _PostInteractables(post: post),
          ],
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
    // Have post info show how long ago in bar
    // Show actual date and time of post if you click on it
    final timeSincePost = DateTime.timestamp().difference(post.timestamp);
    int timeValue;
    String timePostValue;
    final avatar = _PostAvatar(post: post);
    if (timeSincePost.inDays > 364) {
      //TODOwrite more efficient code with variables
      timeValue = (timeSincePost.inDays / 364).round();
      switch (timeValue) {
        case 1:
          timePostValue = '$timeValue year ago';
        default:
          timePostValue = '$timeValue years ago';
      }
    } else if (timeSincePost.inDays >= 1) {
      timeValue = timeSincePost.inDays;
      switch (timeValue) {
        case 1:
          timePostValue = '$timeValue day ago';
        default:
          timePostValue = '$timeValue days ago';
      }
    } else if (timeSincePost.inHours >= 1) {
      timeValue = timeSincePost.inHours;
      switch (timeValue) {
        case 1:
          timePostValue = '$timeValue hour ago';
        default:
          timePostValue = '$timeValue hours ago';
      }
    } else if (timeSincePost.inMinutes >= 1) {
      timeValue = timeSincePost.inMinutes;
      switch (timeValue) {
        case 1:
          timePostValue = '$timeValue minute ago';
        default:
          timePostValue = '$timeValue minutes ago';
      }
    } else {
      timeValue = timeSincePost.inSeconds;
      if (timeValue < 1) {
        // In case post was made miliseconds ago
        timeValue = 1;
      }
      switch (timeValue) {
        case 1:
          timePostValue = '$timeValue second ago';
        default:
          timePostValue = '$timeValue seconds ago';
      }
    }
    return Row(
      children: [
        avatar,
        const SizedBox(width: 8),
        Text(post.authorName), // Get user name instead of id
        // Text(post.author), // Get user name instead of id
        const SizedBox(width: 8),
        Text(timePostValue),
        // Could add flair here
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
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
    How to do saving like state:
    When reading in posts, check if users name is on likes list and set a boolean variable to it
    */

    // Gets current users id and username
    final userId = ref.watch(idProvider);
    final username = ref.watch(usernameProvider);

    // maybe update to use a provider instead
    final currentLikes = useState(
      List<String>.from(post.likes),
    );
    //Like button logic
    final ValueNotifier<Icon> thumbsIcon;
    if (currentLikes.value.contains(userId)) {
      thumbsIcon = useState(const Icon(Icons.thumb_up_sharp));
    } else {
      thumbsIcon = useState(const Icon(Icons.thumb_up_outlined));
    }
    // Create a copy of the likes list
    return Row(
      children: [
        Text(currentLikes.value.length.toString()),
        IconButton(
          onPressed: () async {
            //User is liking the post
            if (userId != null) {
              if (thumbsIcon.value.icon == Icons.thumb_up_outlined) {
                //Modify likes
                currentLikes.value.add(userId);
                print('added user id to currentLikes\n$currentLikes');
                thumbsIcon.value = const Icon(Icons.thumb_up_sharp);
                await ref
                    .read(
                      postRepositoryProvider(
                        userId,
                        username,
                        const FeedEntity.world(),
                      ),
                    )
                    .toggleLikePost(
                      post.id!,
                      userId,
                      currentLikes.value,
                    ); //TODO find alternative to !
              } else {
                // User is removing like
                currentLikes.value.remove(userId);
                print('removed user id from currentLikes\n$currentLikes');
                thumbsIcon.value = const Icon(Icons.thumb_up_outlined);
                await ref
                    .read(
                      postRepositoryProvider(
                        // TODO(MattsAttack): Find a way to handle null here.
                        userId,
                        // TODO(lishaduck): This could be a whole lot less hacky.
                        username,
                        const FeedEntity.world(),
                      ),
                    )
                    .toggleLikePost(
                      post.id!,
                      userId,
                      currentLikes.value,
                    ); //TODO find alternative to !
              }
              //TODO add code change value of local likes
            } else {
              print('Null user ID detected');
              //maybe send user back to login page
            }
          },
          icon: thumbsIcon.value,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
}
