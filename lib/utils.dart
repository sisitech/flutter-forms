library flutter_form;

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

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

extension MyDateExtenson on DateTime {
  String toCustomString() {
    var format = DateFormat.yMd();
    return format.format(this);
  }
}

String dateToCustomString(DateTime? date) {
  if (date == null) {
    return "";
  }
  var format = DateFormat('EEE, MMM d, ' 'yyyy');
  return format.format(date);
}
