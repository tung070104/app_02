// File: lib/NoteApp/UI/NoteItem.dart

import 'package:flutter/material.dart';
import 'package:app_02/NoteApp/Model/NoteModel.dart'; // Đảm bảo NoteModel đã được định nghĩa ở đây

class NoteItem extends StatelessWidget {
  final Note note; // Ghi chú
  final VoidCallback onDelete; // Hàm gọi lại khi xóa

  const NoteItem({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          note.title,
          style: Theme.of(context).textTheme.titleLarge, // Thay headline6 bằng titleLarge
        ),
        subtitle: Text(note.content),
        trailing: IconButton(
          icon: const Icon(Icons.delete), // Icon xóa ghi chú
          onPressed: onDelete, // Gọi hàm xóa khi nhấn
        ),
      ),
    );
  }
}
