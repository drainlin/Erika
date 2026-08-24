import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final platform in <String>['ios', 'tvos']) {
    test('$platform makes the Flutter render surface transparent for overlays', () {
      final plugin = File(
        '$platform/Classes/ErikaFlutterPlugin.swift',
      ).readAsStringSync();

      expect(plugin, contains('flutterViewController.viewOpaque = false'));
      expect(plugin, contains('view.isOpaque = false'));
      expect(plugin, contains('view.layer.isOpaque = false'));
    });
  }
}
