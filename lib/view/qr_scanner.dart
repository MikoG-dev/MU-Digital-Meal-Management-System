import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mu_meal/controller/qrScannerController.dart';
import 'package:mu_meal/util/db.dart';
// Updated Import
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScanner extends StatefulWidget {
  final String mealType; // Made final for better practice
  QrScanner({Key? key, required this.mealType}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  late QrScannerController qrScannerController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
    qrScannerController = Get.put(QrScannerController());
  }

  // To ensure the camera works properly after hot reload or app resume
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose(); // Added dispose to free up camera resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.blue,
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.yellow,
                    borderRadius: 10,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white, // Improved UI visibility for buttons
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.flashlight_on_outlined,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /* Loading Overlay */
        Obx(
          () => Visibility(
            visible: qrScannerController.isLoading.value,
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.65)),
              child: const Center(
                child: SpinKitWave(color: Colors.orange, size: 40.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      // Prevent multiple scans while processing
      if (qrScannerController.isLoading.value) return;

      if (scanData.code != null && scanData.code!.isNotEmpty) {
        await controller.pauseCamera(); // Pause immediately

        qrScannerController.isLoading.value = true;

        try {
          // Process the QR Data
          await DatabaseHelper.verifyAndLogMeal(
            scanData.code!,
            widget.mealType,
            isQr: true,
          );
        } catch (e) {
          debugPrint("Error processing scan: $e");
        } finally {
          qrScannerController.isLoading.value = false;
          await controller.resumeCamera(); // Resume after processing
        }
      }
    });
  }
}
