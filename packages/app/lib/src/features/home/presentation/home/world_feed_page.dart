import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import '../../domain/feed_entity.dart';
import 'feed.dart';

@RoutePage()
class WorldFeedPage extends StatelessWidget {
  const WorldFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Feed(feed: const WorldFeed());
  }
}
