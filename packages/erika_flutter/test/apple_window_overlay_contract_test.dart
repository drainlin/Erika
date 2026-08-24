import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final platform in <String>['ios', 'tvos']) {
    test('$platform makes the Flutter render surface transparent for overlays',
        () {
      final plugin = File(
        '$platform/Classes/ErikaFlutterPlugin.swift',
      ).readAsStringSync();

      expect(plugin, contains('flutterViewController.isViewOpaque = false'));
      expect(plugin, contains('view.isOpaque = false'));
      expect(plugin, contains('view.layer.isOpaque = false'));
    });

    test('$platform hides reused overlays until the new first frame', () {
      final plugin = File(
        '$platform/Classes/ErikaFlutterPlugin.swift',
      ).readAsStringSync();

      expect(plugin, contains('beginPlayerAttachment(playerId: id)'));
      expect(
        plugin,
        contains(
          'overlayAwaitingFirstFrame && stats.renderedVideoFrames > 0',
        ),
      );
      expect(plugin, contains('revealAfterFirstFrame(playerId: self.id)'));
      expect(plugin, contains('isHidden = !presentationReady'));
      expect(
        plugin,
        contains('otherHost.detach(viewId: overlay.platformViewId)'),
      );
    });
  }

  test('macOS hides reused overlays until the new first frame', () {
    final plugin = File(
      'macos/Classes/ErikaFlutterPlugin.swift',
    ).readAsStringSync();

    expect(plugin, contains('beginPlayerAttachment(playerId: id)'));
    expect(
      plugin,
      contains('overlayAwaitingFirstFrame && stats.renderedVideoFrames > 0'),
    );
    expect(plugin, contains('revealAfterFirstFrame(playerId: self.id)'));
    expect(plugin, contains('isHidden = !presentationReady'));
    expect(
        plugin, contains('otherHost.detach(viewId: overlay.platformViewId)'));
  });

  test('Windows hides reused overlays until the new first frame', () {
    final plugin = File(
      'windows/erika_flutter_plugin.cpp',
    ).readAsStringSync();

    expect(plugin, contains('overlay.BeginPlayerAttachment(host.id)'));
    expect(plugin, contains('HasRenderedVideoFrame()'));
    expect(plugin, contains('RevealAfterFirstFrame(entry.first)'));
    expect(plugin, contains('!visible || !presentation_ready'));
    expect(plugin, contains('entry.second->Detach(kWindowOverlayViewId)'));
  });
}
