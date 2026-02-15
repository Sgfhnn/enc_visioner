import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_key_board/volume_key_board.dart';

import 'translations.dart';
import 'app_theme.dart';

late List<CameraDescription> cameras;

// ══════════════════════════════════════════════════════════════════
//  ENTRY POINT
// ══════════════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const BanknoteRecognizerApp());
}

class BanknoteRecognizerApp extends StatelessWidget {
  const BanknoteRecognizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banknote Recognizer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  SPLASH SCREEN
// ══════════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LanguageSelectionScreen(),
            transitionsBuilder: (_, a, __, child) =>
                FadeTransition(opacity: a, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppTheme.captureButtonGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.currency_exchange_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Birr Vision', style: AppTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Ethiopian Banknote Recognizer',
                    style: AppTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  LANGUAGE SELECTION SCREEN
// ══════════════════════════════════════════════════════════════════
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final codes = AppTranslations.supportedCodes;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Header
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppTheme.captureButtonGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.currency_exchange_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text('Choose Language', style: AppTheme.headlineLarge),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Select your preferred language',
                    style: AppTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: 36),

                // Language cards
                Expanded(
                  child: ListView.separated(
                    itemCount: codes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final code = codes[index];
                      return _LanguageCard(languageCode: code);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final String languageCode;
  const _LanguageCard({required this.languageCode});

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final name = AppTranslations.name(widget.languageCode);
    final flag = AppTranslations.flag(widget.languageCode);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // Speak intro in selected language
        final tts = FlutterTts();
        tts.setLanguage(widget.languageCode);
        tts.speak(AppTranslations.intro(widget.languageCode));

        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                CameraScreen(languageCode: widget.languageCode),
            transitionsBuilder: (_, a, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: a, curve: Curves.easeOutCubic),
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: AppTheme.glassCard(),
          child: Row(
            children: [
              // Flag
              Text(flag, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 20),
              // Label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      widget.languageCode,
                      style: AppTheme.bodyLarge.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
              // Arrow
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppTheme.primary,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  CAMERA SCREEN
// ══════════════════════════════════════════════════════════════════
class CameraScreen extends StatefulWidget {
  final String languageCode;
  const CameraScreen({super.key, required this.languageCode});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  late FlutterTts flutterTts;

  bool _isProcessing = false;
  bool _autoDetectMode = false;
  String? _lastResult;
  Timer? _autoDetectTimer;

  // Capture button animation
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initializeCamera();

    // Pulse animation for the capture button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Volume key listener
    VolumeKeyBoard.instance.addListener(_onVolumeKeyPressed);
  }

  void _onVolumeKeyPressed(VolumeKey event) {
    if (!_isProcessing) {
      _captureImage();
    }
  }

  Future<void> _initializeCamera() async {
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _autoDetectTimer?.cancel();
    _controller?.dispose();
    _pulseController.dispose();
    VolumeKeyBoard.instance.removeListener();
    super.dispose();
  }

  // ── Manual capture ─────────────────────────────────────────────
  Future<void> _captureImage() async {
    if (_isProcessing) return;
    if (!(_controller?.value.isInitialized ?? false)) return;

    setState(() {
      _isProcessing = true;
      _lastResult = null;
    });

    try {
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final file = await _controller!.takePicture();
      await file.saveTo(path);
      await _classifyImage(File(path));
    } catch (e) {
      setState(() => _isProcessing = false);
      await flutterTts.setLanguage(widget.languageCode);
      await flutterTts
          .speak(AppTranslations.noDetection(widget.languageCode));
    }
  }

  // ── Classify via Roboflow ──────────────────────────────────────
  Future<void> _classifyImage(File imageFile) async {
    try {
      final base64Image = base64Encode(await imageFile.readAsBytes());
      final response = await http.post(
        Uri.parse(
          'https://serverless.roboflow.com/my-first-project-pv6jr/2?api_key=97osXVxna9rvKDAKRB7o',
        ),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: base64Image,
      );

      final responseData = jsonDecode(response.body);
      final predictions = responseData['predictions'] as List?;

      if (predictions != null && predictions.isNotEmpty) {
        final label = predictions[0]['class'] as String;


        setState(() => _lastResult = label);

        // Vibrate for confirmation
        if (await Vibration.hasVibrator() == true) {
          Vibration.vibrate(duration: 300);
        }

        // Speak the result in the selected language — repeat 2 times
        await flutterTts.setLanguage(widget.languageCode);
        for (int i = 0; i < 2; i++) {
          await flutterTts.speak(
            AppTranslations.result(widget.languageCode, label),
          );
          await flutterTts.awaitSpeakCompletion(true);
        }
      } else {
        await flutterTts.setLanguage(widget.languageCode);
        await flutterTts
            .speak(AppTranslations.noDetection(widget.languageCode));
      }
    } catch (e) {
      await flutterTts.setLanguage(widget.languageCode);
      await flutterTts
          .speak(AppTranslations.noDetection(widget.languageCode));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // ── Auto-detect toggle ────────────────────────────────────────
  void _toggleAutoDetect() async {
    setState(() => _autoDetectMode = !_autoDetectMode);

    await flutterTts.setLanguage(widget.languageCode);

    if (_autoDetectMode) {
      await flutterTts
          .speak(AppTranslations.autoModeOn(widget.languageCode));
      _startAutoDetect();
    } else {
      await flutterTts
          .speak(AppTranslations.autoModeOff(widget.languageCode));
      _autoDetectTimer?.cancel();
    }
  }

  void _startAutoDetect() {
    // Periodically capture & classify every 3 seconds
    _autoDetectTimer?.cancel();
    _autoDetectTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!_autoDetectMode || _isProcessing) return;
      if (!(_controller?.value.isInitialized ?? false)) return;

      setState(() => _isProcessing = true);

      try {
        final directory = await getTemporaryDirectory();
        final path =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
        final file = await _controller!.takePicture();
        await file.saveTo(path);

        // Quick classify
        final base64Image =
            base64Encode(await File(path).readAsBytes());
        final response = await http.post(
          Uri.parse(
            'https://serverless.roboflow.com/my-first-project-pv6jr/2?api_key=97osXVxna9rvKDAKRB7o',
          ),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: base64Image,
        );

        final responseData = jsonDecode(response.body);
        final predictions = responseData['predictions'] as List?;

        if (predictions != null && predictions.isNotEmpty) {
          final confidence =
              (predictions[0]['confidence'] as num).toDouble();

          // Only auto-announce if confidence is high enough
          if (confidence >= 0.7) {
            final label = predictions[0]['class'] as String;
            setState(() => _lastResult = label);

            if (await Vibration.hasVibrator() == true) {
              Vibration.vibrate(duration: 300);
            }

            await flutterTts.setLanguage(widget.languageCode);
            await flutterTts.speak(
              AppTranslations.result(widget.languageCode, label),
            );
            await flutterTts.awaitSpeakCompletion(true);
          }
        }
      } catch (_) {
        // silently retry next cycle
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    });
  }

  // ── BUILD ──────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (!(_controller?.value.isInitialized ?? false)) {
      return Scaffold(
        body: Container(
          decoration:
              const BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primary.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Initialising camera…', style: AppTheme.bodyLarge),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Camera preview ─────────────────────────────────
          CameraPreview(_controller!),

          // ── Auto-detect scanning overlay ────────────────────
          if (_autoDetectMode)
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isProcessing
                        ? AppTheme.accent.withValues(alpha: 0.6)
                        : AppTheme.primary.withValues(alpha: 0.4),
                    width: 4,
                  ),
                ),
              ),
            ),

          // ── Top bar ────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Back
                  _GlassIconButton(
                    icon: Icons.arrow_back_ios_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppTranslations.name(widget.languageCode),
                      style: AppTheme.titleMedium,
                    ),
                  ),
                  // Auto-detect toggle
                  _AutoDetectChip(
                    active: _autoDetectMode,
                    onTap: _toggleAutoDetect,
                  ),
                ],
              ),
            ),
          ),

          // ── Result banner ──────────────────────────────────
          if (_lastResult != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 72,
              left: 24,
              right: 24,
              child: _ResultBanner(label: _lastResult!),
            ),

          // ── Bottom controls ────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 24,
                top: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status text
                  if (_isProcessing)
                    Text(
                      AppTranslations.scanning(widget.languageCode),
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      _autoDetectMode
                          ? AppTranslations.autoModeOn(widget.languageCode)
                          : 'Tap or press volume to capture',
                      style: AppTheme.bodyLarge,
                    ),
                  const SizedBox(height: 18),

                  // Capture button
                  GestureDetector(
                    onTap: _isProcessing ? null : _captureImage,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _isProcessing ? 1.0 : _pulseAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _isProcessing
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF455A64),
                                    Color(0xFF607D8B),
                                  ],
                                )
                              : AppTheme.captureButtonGradient,
                          boxShadow: [
                            BoxShadow(
                              color: (_isProcessing
                                      ? Colors.grey
                                      : AppTheme.primary)
                                  .withValues(alpha: 0.4),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: _isProcessing
                            ? const Padding(
                                padding: EdgeInsets.all(22),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ══════════════════════════════════════════════════════════════════

/// Glass-effect icon button used in the top bar.
class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: AppTheme.glassCard(borderRadius: 14),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

/// Auto-detect mode chip toggle.
class _AutoDetectChip extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _AutoDetectChip({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: active ? AppTheme.autoDetectGradient : null,
          color: active ? null : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? AppTheme.accent
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active ? Icons.auto_awesome : Icons.auto_awesome_outlined,
              size: 16,
              color: active ? Colors.black87 : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              'Auto',
              style: AppTheme.labelLarge.copyWith(
                color: active ? Colors.black87 : Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated result banner shown when a banknote is recognized.
class _ResultBanner extends StatelessWidget {
  final String label;
  const _ResultBanner({required this.label});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppTheme.captureButtonGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                '$label Birr',
                style: AppTheme.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}