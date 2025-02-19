/// Format a duration in a human-friendly way.
String formatDuration(Duration timeSincePost) {
  return switch (timeSincePost) {
    final d when d.inDays > 364 => switch ((d.inDays / 364).round()) {
      1 => '1 year',
      final timeValue => '$timeValue years',
    },
    final d when d.inDays >= 1 => switch (d.inDays) {
      1 => '1 day',
      final timeValue => '$timeValue days',
    },
    final d when d.inHours >= 1 => switch (d.inHours) {
      1 => '1 hour',
      final timeValue => '$timeValue hours',
    },
    final d when d.inMinutes >= 1 => switch (d.inMinutes) {
      1 => '1 minute',
      final timeValue => '$timeValue minutes',
    },
    final d when d.inSeconds >= 1 => switch (d.inSeconds) {
      1 => '1 second',
      final timeValue => '$timeValue seconds',
    },

    // In case the post was made milliseconds ago.
    _ => 'now',
  };
}
