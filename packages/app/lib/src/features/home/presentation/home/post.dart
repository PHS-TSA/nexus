// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/avatar_service.dart';
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
        constraints: const BoxConstraints(minHeight: 220, maxHeight: 300),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Have sections of post in here. Poster info and post content
            _PosterInfo(post: post),
            const Divider(color: Colors.white), //TODObase on theme
            _PostBody(post: post),
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
        _PostAvatar(post: post),
        const Padding(padding: EdgeInsets.all(4)),
        Text(post.authorName), // Get user name instead of id
        // Text(post.author), // Get user name instead of id
        const Padding(padding: EdgeInsets.all(4)),
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
