import 'dart:io';
import 'package:camera/camera.dart';
import 'package:finance/core/router/routes_name.dart';
import 'package:finance/modules/common/data_entering/ui/camera_data_checking_page.dart';
import 'package:finance/modules/common/data_entering/ui/data_checking_page.dart';
import 'package:finance/modules/common/data_entering/ui/siri_animation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _capturedImage;
  bool _noCamera = false;
  bool _noMic = false;

  // Speech to Text variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _checkPermissionsAndInitialize();
  }

  Future<void> _checkPermissionsAndInitialize() async {
    // Request camera permission
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      setState(() => _noCamera = true);
      return;
    } else {
      setState(() => _noCamera = false);
    }

    // Request microphone permission
    final micStatus = await Permission.microphone.request();
    setState(() => _noMic = !micStatus.isGranted);

    // Initialize camera if available
    if (!_noCamera) {
      await _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _noCamera = true;
        });
        return;
      }

      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      if (mounted) setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
      setState(() {
        _noCamera = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) return;

      final directory = await getTemporaryDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final imagePath = join(directory.path, fileName);

      final picture = await _controller!.takePicture();
      final savedFile = await File(picture.path).copy(imagePath);

      setState(() {
        _capturedImage = savedFile;
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void _confirmAndSendToBackend(BuildContext context) {
    if (_capturedImage == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraDataCheckingPage(file: _capturedImage),
        settings: const RouteSettings(name: RoutesName.cameraDataCheckingPage),
      ),
    );
  }

  void _cancelPreview() {
    setState(() {
      _capturedImage = null;
    });
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('Speech status: $val'),
        onError: (val) => print('Speech error: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _recognizedText = val.recognizedWords;
            });
          },
        );
      } else {
        setState(() {
          _noMic = true;
        });
      }
    } else {
      setState(() => _isListening = false);
      await _speech.stop();

      // Just print recognized text to console when stopping
      if (_recognizedText.isNotEmpty) {
        print('Recognized speech: $_recognizedText');
      }
    }
  }

  Widget _buildPreviewArea() {
    Widget previewContent;

    if (_capturedImage != null) {
      previewContent = Image.file(
        _capturedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (_noCamera) {
      previewContent = const Center(
        child: Text(
          'No camera detected on this device.',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    } else if (_controller != null && _initializeControllerFuture != null) {
      previewContent = FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      previewContent = const Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        previewContent,
        if (_isListening)
          Container(
            color: Colors.black45, // dim background when listening
            child: Center(child: SiriWaveAnimation(text: _recognizedText)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPreviewing = _capturedImage != null;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _buildPreviewArea()),

            // Bottom buttons
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child:
                  isPreviewing
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _cancelPreview,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retake'),
                            style: _actionButtonStyle(),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_capturedImage != null) {
                                _confirmAndSendToBackend(context);
                              }
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('Send'),
                            style: _actionButtonStyle(),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Tooltip(
                            message: "Enter Manually",
                            child: IconButton(
                              iconSize: 40,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const DataCheckingPage(
                                          headerName: "Enter Manually",
                                        ),
                                    settings: const RouteSettings(
                                      name: RoutesName.dataCheckingPage,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_note,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Tooltip(
                            message:
                                _noCamera
                                    ? "Camera not available"
                                    : "Take Picture",
                            child: FloatingActionButton(
                              onPressed: _noCamera ? null : _takePicture,
                              backgroundColor:
                                  _noCamera ? Colors.grey : Colors.white,
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Tooltip(
                            message:
                                _noMic
                                    ? "Microphone not available"
                                    : (_isListening
                                        ? "Stop Listening"
                                        : "Record Voice"),
                            child: GestureDetector(
                              onLongPress: () {
                                if (!_noMic && !_isListening) {
                                  _listen(); // Start listening
                                }
                              },
                              onLongPressUp: () async {
                                if (!_noMic && _isListening) {
                                  await _listen();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const DataCheckingPage(
                                            headerName: "Enter Manually",
                                          ),
                                      settings: const RouteSettings(
                                        name: RoutesName.dataCheckingPage,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _noMic ? Colors.grey : Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _sideButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  ButtonStyle _actionButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
    );
  }
}
