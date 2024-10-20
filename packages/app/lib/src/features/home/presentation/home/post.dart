// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
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
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 150, // TODO(MattsAttack): Scale based on required height.
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        child: Column(
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
    print(DateTime.now());
    final timeSincePost = DateTime.now().difference(post.timestamp);
    print(timeSincePost);
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
      timeValue = timeSincePost.inDays;
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
        CircleAvatar(
          backgroundImage: AssetImage(Assets.pictures.kid.path),
        ), // Possible bug here,
        const Padding(padding: EdgeInsets.all(4)),
        Text(post.author), // Get user name instead of id
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
    return Expanded(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          ),
        ],
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
