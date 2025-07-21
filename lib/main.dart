import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_watcher/volume_watcher.dart';

void main() => runApp(const BanknoteRecognizerApp());

class BanknoteRecognizerApp extends StatelessWidget {
  const BanknoteRecognizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banknote Recognizer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LanguageSelectionScreen(),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  void _speakIntro(String language, FlutterTts flutterTts) async {
    await flutterTts.setLanguage(language);
    await flutterTts.speak(
      "Please point the camera to the banknote and capture it using the volume buttons.",
    );
  }

  @override
  Widget build(BuildContext context) {
    FlutterTts flutterTts = FlutterTts();
    return Scaffold(
      appBar: AppBar(title: const Text("Select Language")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Amharic"),
            onTap: () {
              _speakIntro("am-ET", flutterTts);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraScreen(languageCode: "am-ET"),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Oromo"),
            onTap: () {
              _speakIntro("om-ET", flutterTts);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraScreen(languageCode: "om-ET"),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("English"),
            onTap: () {
              _speakIntro("en-US", flutterTts);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraScreen(languageCode: "en-US"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final String languageCode;
  const CameraScreen({super.key, required this.languageCode});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late FlutterTts flutterTts;
  late StreamSubscription<dynamic> _volumeSubscription;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initializeCamera();
     VolumeWatcher.addListener((volume) {
      _captureImage();
    });
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _volumeSubscription.cancel();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (!_controller!.value.isInitialized) return;
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    await _controller!.takePicture().then((file) => file.saveTo(path));
    await _classifyImage(File(path));
  }

  Future<void> _classifyImage(File imageFile) async {
    final base64Image = base64Encode(await imageFile.readAsBytes());
    final response = await http.post(
      Uri.parse("https://serverless.roboflow.com/my-first-project-pv6jr/2?api_key=YOUR_API_KEY"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: base64Image,
    );

    final responseData = jsonDecode(response.body);
    String label = responseData['predictions'][0]['class'];

    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 300);
    }

    await flutterTts.setLanguage(widget.languageCode);
    await flutterTts.speak("This is $label Ethiopian birr.");
  }

  @override
  Widget build(BuildContext context) {
    if (!(_controller?.value.isInitialized ?? false)) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              "Volume Button to Capture",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

