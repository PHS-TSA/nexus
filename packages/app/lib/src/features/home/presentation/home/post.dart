// ignore_for_file: prefer_expression_function_bodies, prefer_const_constructors

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
        height: 100, // Todo edit to scale based on required height
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        child: Column(
          children: <Widget>[
            // Have sections of post in here. Poster info and post content
            _PosterInfo(post: post),
            Divider(color: Colors.white), //TODObase on theme
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
  const _PosterInfo({required this.post, super.key});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(Assets.pictures.kid.path),
          ), // Possible bug here,
          Padding(padding: EdgeInsets.all(4)),
          Text(post.author), // Get user name instead of id
          Padding(padding: EdgeInsets.all(4)),
          Text(post.timestamp.toString()),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({required this.post, super.key});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // final day = post.timestamp.day;
    // final month = post.timestamp.month;
    // final year = post.timestamp.year;
    // final time = DateFormat.Hms().format(post.timestamp);

    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(Assets.pictures.kid.path),
          ), // Possible bug here,
          Padding(padding: EdgeInsets.all(4)),
          Text(post.author), // Get user name instead of id
          Padding(padding: EdgeInsets.all(4)),
          // Text('$time , $month $day, $year'),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
}
//   // child: Row(
//   //   children: [
//   //     Image.network(
//   //       'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
//   //     ),
//   //     Column(
//   //       children: [
//   //         const Text(''),
//   //         Text(post.headline),
//   //         Text(post.description),
//   //       ],
//   //     ),
//   child: ListTile(
//     // leading: switch (post.image) {
//     //   // If the image is an BucketFile, figure out how to get the image from the API.
//     //   // Will need to be cached in Riverpod. Probably store it in the entity.
//     //   // But, deserialization shouldn't need to know about the API.
//     //   // This'll be tricky. For now, I think we make a dummy image.
//     //   final String _ => Image.network(
//     //       'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
//     //     ),
//     //   // final BucketFile image => Image.memory(image),
//     //   // Else, return null.
//     //   null => null,
//     // },
//     leading: Image.network(
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
//     ),
//     title: Text(post.headline),
//     subtitle: Text(post.description),
//     // isThreeLine: true,
//     // minVerticalPadding: 100,
//     // TODO(MattsAttack): add in on tap functionality to click on post
//   ),
//   // ],
//   // ),
