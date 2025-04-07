import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/hooks.dart';
import '../../../../utils/responsive.dart';
import '../../../auth/application/auth_service.dart';
import '../../data/post_repository.dart';
import '../../domain/comment_dto_entity.dart';
import '../../domain/post_model_entity.dart';

/// {@template nexus.app.create_comment}
/// A dialog that allows for a user to create a new comment.
/// {@endtemplate}
class CreateComment extends HookConsumerWidget {
  /// {@macro nexus.app.create_comment}
  ///
  /// Construct a new [CreateComment] widget.
  const CreateComment({required this.post, super.key});

  /// The post to be updating.
  final PostModelEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useGlobalKey<FormState>();
    final commentContent = useState('');

    final handleSubmit = useCallback(() async {
      final userId = ref.read(idProvider)!;
      final userName = ref.read(userNameProvider)!;

      if (!(formKey.currentState?.validate() ?? false)) return;

      formKey.currentState?.save();

      // Create a list of all uploaded images ids
      await ref.read(postRepositoryProvider).updatePost(post.id, {
        'comments': [
          CommentDtoEntity(
            comment: commentContent.value,
            author: userId,
            authorName: userName,
            timestamp: DateTime.timestamp(),
          ).toJson(),
        ],
      });

      if (!context.mounted) return;
      await context.router.maybePop();

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment Created!')));
    }, [formKey]);

    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 16.0,
        ),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal:
            context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 64.0,
        vertical:
            context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 48.0,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          context.sizeClass == MaterialWindowSizeClass.compact ? 0.0 : 16.0,
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (context.sizeClass == MaterialWindowSizeClass.compact)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await context.router.maybePop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Text(
                        'Write a comment',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  )
                else
                  Text(
                    'Write a comment',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                const SizedBox(height: 16),

                // TODO(MattsAttack): guard against creating empty comments.
                TextFormField(
                  initialValue: commentContent.value,
                  maxLength: 200,
                  maxLengthEnforcement:
                      MaxLengthEnforcement.truncateAfterCompositionEnds,
                  onSaved: (value) {
                    if (value == null) return;

                    commentContent.value = value;
                  },
                  decoration: const InputDecoration(
                    label: Text('Comment content'),
                  ),
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: handleSubmit,
                  child: const Text('Post Comment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<PostModelEntity>('post', post));
  }
}
