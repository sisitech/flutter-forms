library flutter_form;

import 'package:flutter/foundation.dart';

dprint(dynamic value) {
  if (kDebugMode) {
    print(value);
  }
}

extension MyStringExt on String {
  String toUrlNoSlash() {
    if (this.endsWith("/")) {
      return this.substring(0, this.length - 1);
    }
    return this;
  }

  String toUrlWithSlash() {
    return "${this.toUrlNoSlash()}/";
  }
}
