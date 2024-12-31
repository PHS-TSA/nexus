import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/post_entity.dart';
import 'post.dart';

@RoutePage()
class PostViewPage extends StatelessWidget {
  const PostViewPage({required this.post, super.key});

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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostEntity>('post', post));
  }
}
