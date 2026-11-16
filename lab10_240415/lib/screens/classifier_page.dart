import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/flower_classifier.dart';

class ClassifierPage extends StatefulWidget {
  const ClassifierPage({super.key});
  @override
  State<ClassifierPage> createState() => _ClassifierPageState();
}

class _ClassifierPageState extends State<ClassifierPage> {
  final _picker = ImagePicker();
  FlowerClassifier? _classifier;
  File? _image;
  List<FlowerPrediction> _predictions = const [];
  bool _loadingModel = true;
  bool _classifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      final classifier = await FlowerClassifier.load();
      if (!mounted) return;
      setState(() { _classifier = classifier; _loadingModel = false; });
    } catch (error) {
      if (!mounted) return;
      setState(() { _loadingModel = false; _error = 'Could not load the flower model. Check that the model and labels are valid.\n$error'; });
    }
  }

  Future<void> _chooseImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 92);
      if (picked == null || !mounted) return;
      setState(() { _image = File(picked.path); _predictions = const []; _error = null; _classifying = true; });
      final predictions = await _classifier!.classify(File(picked.path));
      if (mounted) setState(() { _predictions = predictions; _classifying = false; });
    } catch (error) {
      if (mounted) setState(() { _classifying = false; _error = 'Could not classify this image. Please try another photo.\n$error'; });
    }
  }

  @override
  void dispose() { _classifier?.close(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
              sliver: SliverList.list(children: [
                _header(),
                const SizedBox(height: 34),
                const Text('A little closer to\nnature.', style: TextStyle(fontSize: 38, height: 1.08, fontWeight: FontWeight.w700, letterSpacing: -1.5)),
                const SizedBox(height: 12),
                Text('Snap a flower or choose a photo. Bloom will tell you what it is.', style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black.withValues(alpha: .58))),
                const SizedBox(height: 26),
                _photoCard(),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  _errorCard(_error!),
                ],
                if (_predictions.isNotEmpty) ...[
                  const SizedBox(height: 26),
                  _results(),
                ],
                const SizedBox(height: 28),
                Row(children: [
                  const Icon(Icons.eco_outlined, size: 18, color: Color(0xFF28745C)),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Private by nature · Images stay on your device', style: TextStyle(fontSize: 12, color: Colors.black.withValues(alpha: .52)))),
                ]),
              ]),
            ),
          ]),
        ),
      );

  Widget _header() => Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF28745C), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.local_florist_rounded, color: Colors.white)),
        const SizedBox(width: 11),
        const Text('bloom', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, letterSpacing: -.7)),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFFE5EEE8), borderRadius: BorderRadius.circular(30)), child: Row(children: [const Icon(Icons.circle, size: 8, color: Color(0xFF28745C)), const SizedBox(width: 7), Text(_loadingModel ? 'Starting' : _classifier != null ? 'Model ready' : 'Model issue', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF28745C)))])),
      ]);

  Widget _photoCard() => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: const Color(0xFFE8EDE4), borderRadius: BorderRadius.circular(28)),
        child: Column(children: [
          SizedBox(height: 245, width: double.infinity, child: _image == null
              ? Stack(fit: StackFit.expand, children: [
                  const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFE7EEDF), Color(0xFFD9E8D9)]))),
                  Positioned(right: 20, top: 16, child: _flower(Icons.local_florist, 34, const Color(0xFFE5A85B))),
                  Positioned(left: 25, bottom: 25, child: _flower(Icons.filter_vintage, 26, const Color(0xFFCF7C7B))),
                  Positioned(right: 80, bottom: 20, child: _flower(Icons.spa, 24, const Color(0xFF729D75))),
                  Center(child: Container(width: 116, height: 116, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .56), shape: BoxShape.circle), child: const Icon(Icons.add_photo_alternate_outlined, size: 47, color: Color(0xFF28745C)))),
                  const Positioned(left: 0, right: 0, bottom: 58, child: Text('Your next flower is waiting', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF355949)))),
                ])
              : Stack(fit: StackFit.expand, children: [Image.file(_image!, fit: BoxFit.cover), if (_classifying) Container(color: Colors.black.withValues(alpha: .35), child: const Center(child: CircularProgressIndicator(color: Colors.white))) ])),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [
            Expanded(child: FilledButton.icon(onPressed: _loadingModel || _classifier == null ? null : () => _chooseImage(ImageSource.camera), icon: const Icon(Icons.camera_alt_outlined), label: const Text('Take photo'), style: FilledButton.styleFrom(minimumSize: const Size(0, 52), backgroundColor: const Color(0xFF28745C), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(onPressed: _loadingModel || _classifier == null ? null : () => _chooseImage(ImageSource.gallery), icon: const Icon(Icons.photo_library_outlined), label: const Text('Choose photo'), style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52), foregroundColor: const Color(0xFF28745C), side: const BorderSide(color: Color(0xFFADC2B4)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
          ])),
        ]),
      );

  Widget _results() {
    final best = _predictions.first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('YOUR FLOWER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.6, color: Color(0xFF668071))),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE9ECE5))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Container(width: 54, height: 54, decoration: const BoxDecoration(color: Color(0xFFE5EEE8), shape: BoxShape.circle), child: const Icon(Icons.local_florist_rounded, color: Color(0xFF28745C), size: 28)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_title(best.label), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text('${(best.confidence * 100).round()}% match', style: const TextStyle(fontSize: 14, color: Color(0xFF668071)))]))]),
        const SizedBox(height: 22),
        const Text('OTHER POSSIBILITIES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.35, color: Color(0xFF87958A))),
        const SizedBox(height: 14),
        for (final prediction in _predictions.skip(1)) ...[
          Row(children: [Expanded(child: Text(_title(prediction.label), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))), Text('${(prediction.confidence * 100).round()}%', style: const TextStyle(fontSize: 12, color: Color(0xFF718177)))]),
          const SizedBox(height: 7),
          ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: prediction.confidence, minHeight: 5, backgroundColor: const Color(0xFFF0F2EC), color: const Color(0xFF8CAB91))),
          const SizedBox(height: 13),
        ],
      ])),
    ]);
  }

  String _title(String value) => value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
  Widget _flower(IconData icon, double size, Color color) => Icon(icon, size: size, color: color.withValues(alpha: .86));
  Widget _errorCard(String text) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEEEE),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFAA4646)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF7A3636),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      );
}
