import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_02/NoteApp/Model/NoteModel.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText('Nội dung', note.content, context),
              _buildText('Ưu tiên', _getPriorityText(note.priority), context),
              _buildText('Thời gian tạo', _formatDate(note.createdAt), context),
              _buildText('Thời gian sửa', _formatDate(note.modifiedAt), context),
              if (note.tags?.isNotEmpty ?? false)
                _buildText('Nhãn', note.tags!.join(', '), context),
              if (note.color != null)
                _buildText('Màu', note.color!, context),
              if (note.imagePath?.isNotEmpty ?? false)
                _buildImageSection(note.imagePath!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text('$label: $value', style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Thấp';
      case 2:
        return 'Trung bình';
      default:
        return 'Cao';
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Widget _buildImageSection(String imagePath) {
    return FutureBuilder<bool>(
      future: File(imagePath).exists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data == true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Ảnh đính kèm:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Image.file(
                File(imagePath),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Text('Không thể tải ảnh'),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
