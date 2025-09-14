import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyattend/core/widgets/custom_snack_bar.dart';
import 'package:easyattend/modules/generate/data/firebase/lectures_service.dart';
import 'package:easyattend/modules/home/ui/controllers/home_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide GeoPoint;

class QrScanner extends ConsumerStatefulWidget {
  final MobileScannerController controller;
  const QrScanner({super.key, required this.controller});

  @override
  ConsumerState<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends ConsumerState<QrScanner>
    with WidgetsBindingObserver {
  late final MobileScannerController controller;
  late final lecturesService = ref.read(lecturesServiceProvider);

  StreamSubscription<Object?>? _subscription;
  bool _isProcessing = false;
  final Set<String> _processedBarcodes = {};
  Timer? _resetProcessedBarcodesTimer;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);
    controller = widget.controller;

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Set up a timer to periodically clear the processed barcodes set
    // This allows rescanning the same code after some time
    _resetProcessedBarcodesTimer = Timer.periodic(const Duration(seconds: 5), (
      _,
    ) {
      _processedBarcodes.clear();
    });

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Cancel the reset timer
    _resetProcessedBarcodesTimer?.cancel();
    // Dispose the widget itself.
    super.dispose();
  }

  // Show success snackbar
  void _showSuccessSnackbar() {
    if (!mounted) return;

    CustomSnackBar.show(
      context: context,
      message: 'Attendance recorded successfully!',
      type: SnackBarType.success,
    );
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    CustomSnackBar.show(
      context: context,
      message: message,
      type: SnackBarType.error,
    );
  }

  void _showLocationPermissionModal() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
            'EasyAttend needs location permission to verify your attendance. '
            'Please enable location services in your device settings.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  // Navigate to history screen
  void _navigateToHistoryScreen() {
    ref.read(homeIndexProvider.notifier).setIndex(HomeIndex.history);
  }

  Future<void> _handleBarcode(BarcodeCapture event) async {
    if (_isProcessing || event.barcodes.isEmpty) return;

    final barcode = event.barcodes.first.rawValue;
    if (barcode == null) return;

    // Check if we've already processed this barcode recently
    if (_processedBarcodes.contains(barcode)) {
      log("Duplicate barcode ignored: $barcode");
      return;
    }

    // Mark as processing to prevent concurrent processing
    _isProcessing = true;
    // Add to processed set to prevent duplicates
    _processedBarcodes.add(barcode);

    log("Processing barcode: $barcode");

    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition();
        final GeoPoint geoPoint = GeoPoint(
          position.latitude,
          position.longitude,
        );

        final success = await lecturesService
            .attendLecture(barcode, geoPoint)
            .onError((error, stackTrace) {
              log("Error attending lecture: ${error.toString()}");
              _showErrorSnackbar(error.toString());
              return false;
            });

        // If attendance was successful, show snackbar and navigate to history
        if (success) {
          _showSuccessSnackbar();
          _navigateToHistoryScreen();
        }
      } else {
        _showLocationPermissionModal();
      }
    } catch (e) {
      log("Exception in QR processing: ${e.toString()}");
    } finally {
      // Mark as no longer processing
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(controller: controller);
  }
}
