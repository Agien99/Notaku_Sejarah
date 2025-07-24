import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:typed_data';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      'Tingkatan 1',
      'Tingkatan 2',
      'Tingkatan 3',
      'Tingkatan 4',
      'Tingkatan 5',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: topics.map((topic) {
          return _buildTingkatanButton(context, topic);
        }).toList(),
      ),
    );
  }

  Widget _buildTingkatanButton(BuildContext context, String topic) {
    final bool isDisabled = topic == 'Tingkatan 4' || topic == 'Tingkatan 5';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: isDisabled
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(topic: topic),
                  ),
                );
              },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'images/buttons/Tingkatan.png',
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topic.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    topic.split(' ')[1],
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (isDisabled)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: const Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteDetailScreen extends StatefulWidget {
  final String topic;

  const NoteDetailScreen({super.key, required this.topic});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  String? _pdfPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final assetPath = 'notes/${widget.topic}.pdf';
      final ByteData bytes = await rootBundle.load(assetPath);
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${widget.topic}.pdf';
      final File file = File(tempPath);
      await file.writeAsBytes(list);

      setState(() {
        _pdfPath = tempPath;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfPath != null
              ? PDFView(filePath: _pdfPath!, fitPolicy: FitPolicy.BOTH,)
              : const Center(child: Text('Error loading PDF')),
    );
  }
}