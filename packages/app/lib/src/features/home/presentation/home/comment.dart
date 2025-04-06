import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

import '../../domain/comment_entity.dart';

/// {@template nexus.features.home.presentation.home.comment}
/// View a comment.
/// {@endtemplate}
class Comment extends StatelessWidget {
  /// {@macro nexus.features.home.presentation.home.comment}
  ///
  /// Construct a new [Comment] widget for a [CommentEntity].
  const Comment({required this.comment, super.key});

  /// The [CommentEntity] to display.
  final CommentEntity comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: MemoryImage(comment.avatar)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.authorName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Timeago(
                      date: comment.timestamp,
                      builder:
                          (context, value) => Text(
                            value,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.comment,
                  style: Theme.of(context).textTheme.bodyMedium,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CommentEntity>('comment', comment));
  }
}
