/// This library contains the UI for viewing the details of a post.
library;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/post_entity.dart';
import 'post.dart';

/// {@template nexus.features.home.presentation.home.post_view_page}
/// A page that contains full post information.
/// {@endtemplate}
@RoutePage(deferredLoading: true)
class PostViewPage extends StatelessWidget {
  /// {@macro nexus.features.home.presentation.home.post_view_page}
  ///
  /// Construct a new [PostViewPage] widget.
  const PostViewPage({
    required this.post,
    super.key,
  });

  /// [PostEntity] that contains data displayed in this post.
  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TODO(MattsAttack): Could update this to be more intresting.
        title: const Text('Post View'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Post(post: post),
              // TODO(MattsAttack): Comments will go here.
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
