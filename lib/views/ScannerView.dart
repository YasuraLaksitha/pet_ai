import 'dart:io';
import 'package:flutter/material.dart';
import '../ScannerService.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final ScannerService _scannerService = ScannerService();
  File? _scannedImage;
  String? _petCategory;
  double? _confidence;
  bool _isPet = false;
  bool _isLoading = false;
  bool _initializationError = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    try {
      await _scannerService.initialize();
      if (mounted) {
        setState(() => _initializationError = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _initializationError = true);
      }
      _showError('Scanner initialization failed: ${e.toString()}');
    }
  }

  Future<void> _handleScan({bool useCamera = false}) async {
    if (_initializationError) {
      await _initializeScanner();
      if (_initializationError) return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _scannerService.scanPet(useCamera: useCamera);
      if (result != null && mounted) {
        setState(() {
          _scannedImage = result['image'];
          _petCategory = result['category'];
          _confidence = result['confidence'];
          _isPet = result['isPet'];
        });
      }
    } catch (e) {
      _showError('Scan failed: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Detector"),
        actions: [
          if (_initializationError)
            IconButton(
              icon: const Icon(Icons.error, color: Colors.red),
              onPressed: _initializeScanner,
              tooltip: 'Reinitialize Scanner',
            ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_scannedImage != null) ...[
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_scannedImage!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _isPet ? 'Detected Pet:' : 'Detected:',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      _petCategory ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _isPet ? Colors.green : Colors.orange,
                      ),
                    ),
                    if (_confidence != null)
                      Text(
                        'Confidence: ${_confidence!.toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 30),
                  ],
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _handleScan(useCamera: false),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Pick from Gallery'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _handleScan(useCamera: true),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Use Camera'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          backgroundColor: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scannerService.dispose();
    super.dispose();
  }
}
