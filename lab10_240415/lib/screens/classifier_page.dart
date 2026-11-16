import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/classification_record.dart';
import '../services/flower_classifier.dart';
import '../theme/app_theme.dart';
import 'result_page.dart';

class ClassifierPage extends StatefulWidget {
  const ClassifierPage({
    required this.classifier,
    required this.onClassified,
    super.key,
  });

  final FlowerClassifier classifier;
  final ValueChanged<ClassificationRecord> onClassified;

  @override
  State<ClassifierPage> createState() => _ClassifierPageState();
}

class _ClassifierPageState extends State<ClassifierPage> {
  final ImagePicker _picker = ImagePicker();
  bool _classifying = false;
  String? _error;

  Future<void> _chooseImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 92);
      if (picked == null || !mounted) return;
      await _classifyFile(File(picked.path),
          source == ImageSource.camera ? 'Camera' : 'Gallery');
    } catch (error) {
      if (mounted) {
        setState(() => _error =
            'Could not open that image. Check the camera or photo permission and try again.\n$error');
      }
    }
  }

  Future<void> _chooseImageFromUrl() async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => const _ImageUrlDialog(),
    );
    if (url == null || url.trim().isEmpty || !mounted) return;

    File? downloadedFile;
    try {
      final uri = Uri.parse(url.trim());
      if (uri.scheme != 'https' && uri.scheme != 'http') {
        throw const FormatException('Use an http or https image URL.');
      }
      setState(() {
        _error = null;
        _classifying = true;
      });
      final response = await http.get(uri).timeout(const Duration(seconds: 25));
      final contentType = response.headers['content-type']
          ?.split(';')
          .first
          .trim()
          .toLowerCase();
      if (response.statusCode != 200) {
        throw HttpException(
            'The image server returned ${response.statusCode}.');
      }
      if (contentType == null || !contentType.startsWith('image/')) {
        throw const FormatException('That URL did not return an image.');
      }
      if (response.bodyBytes.isEmpty ||
          response.bodyBytes.length > 15 * 1024 * 1024) {
        throw const FormatException('Choose an image smaller than 15 MB.');
      }
      final extension = switch (contentType) {
        'image/png' => 'png',
        'image/webp' => 'webp',
        'image/gif' => 'gif',
        _ => 'jpg',
      };
      downloadedFile = File(
        '${Directory.systemTemp.path}/bloom_${DateTime.now().microsecondsSinceEpoch}.$extension',
      );
      await downloadedFile.writeAsBytes(response.bodyBytes, flush: true);
      await _classifyFile(downloadedFile, 'URL');
    } catch (error) {
      if (mounted) {
        setState(() {
          _classifying = false;
          _error =
              'Could not import that image URL. Check the link and try again.\n$error';
        });
      }
      if (downloadedFile != null && await downloadedFile.exists()) {
        await downloadedFile.delete();
      }
    }
  }

  Future<void> _classifyFile(File file, String source) async {
    setState(() {
      _classifying = true;
      _error = null;
    });
    try {
      final predictions = await widget.classifier.classify(file);
      if (!mounted) return;
      final record = ClassificationRecord(
        image: file,
        source: source,
        predictions: predictions,
        createdAt: DateTime.now(),
        modelInferenceTime: widget.classifier.lastInferenceTime,
      );
      widget.onClassified(record);
      await Navigator.of(context).push<void>(MaterialPageRoute(
        builder: (_) => ResultPage(record: record),
      ));
    } catch (error) {
      if (mounted) {
        setState(() => _error =
            'Could not classify this image. Please choose another photo.\n$error');
      }
    } finally {
      if (mounted) setState(() => _classifying = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Identify a flower')),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
            children: [
              Text('Choose a photo source',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      )),
              const SizedBox(height: 8),
              const Text(
                'Take a new picture, pick one from your gallery, or paste an image link.',
                style: TextStyle(color: Color(0xFF65766C), height: 1.45),
              ),
              const SizedBox(height: 22),
              Container(
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE7EEDF), Color(0xFFD9E8D9)],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.local_florist_rounded,
                        size: 112,
                        color: AppTheme.green.withValues(alpha: .76)),
                    const Positioned(
                      top: 25,
                      right: 37,
                      child: Icon(Icons.auto_awesome_rounded,
                          color: Color(0xFFE4A554), size: 28),
                    ),
                    if (_classifying)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: .28),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _classifying
                    ? null
                    : () => _chooseImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_outlined),
                label: const Text('Take a photo'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _classifying
                    ? null
                    : () => _chooseImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Choose from gallery'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _classifying ? null : _chooseImageFromUrl,
                icon: const Icon(Icons.link_rounded),
                label: const Text('Import from URL'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
              ),
              if (_classifying) ...[
                const SizedBox(height: 14),
                const Text('Looking closely at your photo…',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppTheme.green)),
              ],
              if (_error != null) ...[
                const SizedBox(height: 16),
                _ErrorCard(message: _error!),
              ],
              const SizedBox(height: 22),
              const Row(children: [
                Icon(Icons.lock_outline_rounded,
                    size: 17, color: AppTheme.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Photo classification runs on-device. URL images are downloaded temporarily.',
                    style: TextStyle(
                        color: Color(0xFF728176), fontSize: 12, height: 1.35),
                  ),
                ),
              ]),
            ],
          ),
        ),
      );
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.info_outline, color: Color(0xFFAA4646)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style: const TextStyle(color: Color(0xFF7A3636), height: 1.4)),
          ),
        ]),
      );
}

class _ImageUrlDialog extends StatefulWidget {
  const _ImageUrlDialog();

  @override
  State<_ImageUrlDialog> createState() => _ImageUrlDialogState();
}

class _ImageUrlDialogState extends State<_ImageUrlDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Import a flower photo'),
        content: TextField(
          controller: _controller,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.go,
          decoration: const InputDecoration(
            hintText: 'https://example.com/flower.jpg',
            labelText: 'Image URL',
          ),
          onSubmitted: (_) => Navigator.pop(context, _controller.text),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, _controller.text),
              child: const Text('Import')),
        ],
      );
}
