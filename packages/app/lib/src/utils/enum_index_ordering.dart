// Copyright 2019 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file or at https://developers.google.com/open-source/licenses/bsd.

/// Ripped from the Flutter Devtools.
///
/// Original: <https://github.com/flutter/devtools/blob/master/packages/devtools_app/lib/src/shared/primitives/enum_utils.dart>
library;

// These utilities are very general, docs wouldn't be very useful.
// ignore_for_file: public_member_api_docs

/// A mixin that adds ordering to an enum based on its index.
mixin EnumIndexOrdering<T extends Enum> on Enum implements Comparable<T> {
  @override
  int compareTo(T other) => index.compareTo(other.index);

  bool operator <(T other) {
    return index < other.index;
  }

  bool operator >(T other) {
    return index > other.index;
  }

  bool operator >=(T other) {
    return index >= other.index;
  }

  bool operator <=(T other) {
    return index <= other.index;
  }
}
