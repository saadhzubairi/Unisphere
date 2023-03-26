import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:unione/unisphere_theme.dart';

class MediaQuerry extends ChangeNotifier {
  late Size mq;

  Size getMq() {
    return mq;
  }
}
