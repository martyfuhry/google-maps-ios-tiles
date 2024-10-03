// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class TileOverlayPage extends GoogleMapExampleAppPage {
  const TileOverlayPage({Key? key})
      : super(const Icon(Icons.map), 'Tile overlay', key: key);

  @override
  Widget build(BuildContext context) {
    return const TileOverlayBody();
  }
}

class TileOverlayBody extends StatefulWidget {
  const TileOverlayBody({super.key});

  @override
  State<TileOverlayBody> createState() => _TileOverlayBodyState();
}

class _TileOverlayBodyState extends State<TileOverlayBody> {
  final ValueNotifier<TileOverlay?> _tileOverlay =
      ValueNotifier<TileOverlay?>(null);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TileOverlay?>(
      valueListenable: _tileOverlay,
      builder: (BuildContext context, TileOverlay? overlay, Widget? child) {
        final Set<TileOverlay> overlays =
            overlay == null ? <TileOverlay>{} : <TileOverlay>{overlay};

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 350.0,
                height: 300.0,
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(59.935460, 30.325177),
                    zoom: 7.0,
                  ),
                  tileOverlays: overlays,
                ),
              ),
            ),
            TextButton.icon(
              icon: Image.asset('assets/working_transparent_tile.png', height: 50,),
              onPressed: () {
                _tileOverlay.value =
                    _getOverlay('assets/working_transparent_tile.png');
              },
              label: const Text(
                'Use shaped transparent',
              ),
            ),
            TextButton.icon(
              icon: Image.asset('assets/not_working_transparent_tile.png', height: 50,),
              onPressed: () {
                _tileOverlay.value =
                    _getOverlay('assets/not_working_transparent_tile.png');
              },
              label: const Text(
                'Use solid (BROKEN)',
              ),
            ),
            TextButton.icon(
              icon: Image.asset('assets/working_opaque_tile.png', height: 50,),
              onPressed: () {
                _tileOverlay.value = _getOverlay(
                  'assets/working_opaque_tile.png',
                  transparency: 0.75,
                );
              },
              label: const Text(
                'Use shaped opaque with 75% transparency',
              ),
            ),
            TextButton.icon(
              icon: Image.asset('assets/not_working_opaque_tile.png', height: 50,),
              onPressed: () {
                _tileOverlay.value = _getOverlay(
                  'assets/not_working_opaque_tile.png',
                  transparency: 0.75,
                );
              },
              label: const Text(
                'Use solid opaque with 75% transpancy',
              ),
            ),
          ],
        );
      },
    );
  }

  TileOverlay _getOverlay(String filePath, {double transparency = 0}) {
    return TileOverlay(
      tileOverlayId: TileOverlayId('$transparency$filePath'),
      tileProvider: _ImageTileProvider(filePath),
      transparency: transparency,
    );
  }
}

class _ImageTileProvider implements TileProvider {
  const _ImageTileProvider(this.imagePath);

  final String imagePath;

  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final ByteData tileImage = await rootBundle.load(imagePath);
    return Tile(512, 512, tileImage.buffer.asUint8List());
  }
}
