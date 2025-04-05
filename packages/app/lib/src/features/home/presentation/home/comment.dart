import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../../domain/comment_entity.dart';

// TODODOCUMENT
class Comment extends StatelessWidget {
  const Comment({required this.comment, super.key});

  final CommentEntity comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(backgroundImage: MemoryImage(comment.avatar)),
        // TODODOES THIS LOOK TRASH?
        Column(
          children: [
            Text(comment.authorName),
            Timeago(
              date: comment.timestamp,
              builder: (context, value) => Text(value),
            ),
          ],
        ),

        Text(comment.comment),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CommentEntity>('comment', comment));
  }
}
