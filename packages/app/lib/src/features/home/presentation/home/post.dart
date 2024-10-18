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
    print('trying to build post!');
    return Card(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 100, // TODO(MattsAttack): Scale based on required height.
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
    // TODO(MattsAttack): Implement build method.
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(Assets.pictures.kid.path),
          ), // Possible bug here,
          const Padding(padding: EdgeInsets.all(4)),
          Text(post.author), // Get user name instead of id
          const Padding(padding: EdgeInsets.all(4)),
          Text(post.timestamp.toString()),
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
    // TODO(MattsAttack): Implement build method.
    // final day = post.timestamp.day;
    // final month = post.timestamp.month;
    // final year = post.timestamp.year;
    // final time = DateFormat.Hms().format(post.timestamp);

    return Expanded(
      child: Column(
        children: [
          Text(post.headline),
          const Padding(padding: EdgeInsets.all(4)),
          Text(post.description), // Get user name instead of id
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
