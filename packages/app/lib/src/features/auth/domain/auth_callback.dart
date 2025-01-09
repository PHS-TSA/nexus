/// This library prevents import cycles and code-splitting issues.
library;

/// A callback that is called when the user logs in.
typedef AuthCallback = void Function({bool didLogIn});
