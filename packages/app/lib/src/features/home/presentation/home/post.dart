import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      child: Row(
        children: [
          Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
          ),
          Column(
            children: [
              const Text(''),
              Text(post.headline),
              Text(post.description),
            ],
          ),
          ListTile(
            leading: switch (post.image) {
              // If the image is an BucketFile, figure out how to get the image from the API.
              // Will need to be cached in Riverpod. Probably store it in the entity.
              // But, deserialization shouldn't need to know about the API.
              // This'll be tricky. For now, I think we make a dummy image.
              final String _ => Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/991px-Placeholder_view_vector.svg.png',
                ),
              // final BucketFile image => Image.memory(image),
              // Else, return null.
              null => null,
            },
            title: Text(post.headline),
            subtitle: Text(post.description),
            // isThreeLine: true,
            // minVerticalPadding: 100,
            // TODO(MattsAttack): add in on tap functionality to click on post
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
