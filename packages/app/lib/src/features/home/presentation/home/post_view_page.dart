import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/post_entity.dart';
import 'post.dart';

@RoutePage()

/// Widget displayed when a user clicks on a post.
/// Contains the post
class PostViewPage extends StatelessWidget {
  /// Widget displayed when a user clicks on a post.
  /// Contains the post
  const PostViewPage({required this.post, super.key});

  /// PostEntity of clicked post
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Post View'), // Could update this to be more intresting
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Post(post: post),
              // Implement comments here
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
