// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/avatar_service.dart';
import '../../domain/post_entity.dart';

/// Post Widget UI
class Post extends StatelessWidget {
  /// Post Widget UI Constructor
  const Post({
    required this.post,
    // Temporary ignore, see <dart-lang/sdk#49025>.
    // ignore: unused_element
    super.key,
  });

  /// PostEntity variable with values of current post
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(16),
      height: _textSize(post.description, const TextStyle()).height +
          _textSize(post.headline, const TextStyle(fontSize: 24)).height +
          150,
      child: Card(
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

  Size _textSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 600);
    print(textPainter.height);
    return textPainter.size;
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
        Flexible(
          child: Text(
            post.headline,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 24),
          ),
        ), // Need text styling
        const Padding(padding: EdgeInsets.all(4)),
        Flexible(
          child: Text(
            post.description,
            textAlign: TextAlign.left,
            // style: const TextStyle(),
          ),
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
