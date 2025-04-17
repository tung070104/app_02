import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_02/NoteApp/DatabaseHelper/DatabaseHelper.dart';
import "package:app_02/NoteApp/Model/NoteModel.dart";
import "package:app_02/NoteApp/UI/NoteDetailScreen.dart";
import "package:app_02/NoteApp/UI/NoteForm.dart";
import "package:app_02/NoteApp/widgets/NoteItem.dart";
import "package:app_02/NoteApp/UI/NoteListScreen.dart";
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;
  const NoteFormScreen({super.key, this.note});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late String title, content, color;
  late int priority;
  List<String> tags = [];
  Color _selectedColor = Colors.white;
  String? imagePath;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    content = widget.note?.content ?? '';
    priority = widget.note?.priority ?? 1;
    tags = widget.note?.tags ?? [];
    color = widget.note?.color ?? '';
    imagePath = widget.note?.imagePath;
    if (color.isNotEmpty) {
      _selectedColor = Color(int.parse('0xff$color'));
    }
    if (imagePath != null && File(imagePath!).existsSync()) {
      _imageFile = File(imagePath!);
    }
  }

  void _pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn màu cho ghi chú'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _selectedColor,
            onColorChanged: (Color newColor) {
              setState(() {
                _selectedColor = newColor;
                color = newColor.value.toRadixString(16).padLeft(8, '0').substring(2);
              });
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Xong')),
        ],
      ),
    );
  }

  // Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imageName = 'note_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final imagePath = '${directory.path}/$imageName';
        final File newImage = await File(image.path).copy(imagePath);
        setState(() {
          _imageFile = newImage;
          this.imagePath = imagePath;
        });
      } else {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Không có ảnh được chọn')),
        );
      }
    } catch (e) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(title: Text(widget.note == null ? 'Thêm Ghi Chú' : 'Sửa Ghi Chú')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: 'Tiêu đề'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Tiêu đề không được để trống';
                    return null;
                  },
                  onSaved: (value) => title = value!,
                ),
                TextFormField(
                  initialValue: content,
                  decoration: const InputDecoration(labelText: 'Nội dung'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Nội dung không được để trống';
                    return null;
                  },
                  onSaved: (value) => content = value!,
                ),
                DropdownButtonFormField<int>(
                  value: priority,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Thấp')),
                    DropdownMenuItem(value: 2, child: Text('Trung bình')),
                    DropdownMenuItem(value: 3, child: Text('Cao')),
                  ],
                  onChanged: (value) => setState(() => priority = value!),
                  decoration: const InputDecoration(labelText: 'Mức độ ưu tiên'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Chọn màu: '),
                    GestureDetector(
                      onTap: () => _pickColor(context),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(color: _selectedColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Chọn ảnh'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_imageFile != null)
                  Column(
                    children: [
                      Image.file(_imageFile!, height: 200, width: double.infinity, fit: BoxFit.cover),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _imageFile = null;
                            imagePath = null;
                          });
                        },
                        child: const Text('Xóa ảnh'),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        final now = DateTime.now();
                        final note = Note(
                          id: widget.note?.id,
                          title: title,
                          content: content,
                          priority: priority,
                          createdAt: widget.note?.createdAt ?? now,
                          modifiedAt: now,
                          tags: tags,
                          color: color,
                          imagePath: imagePath,
                        );
                        if (widget.note == null) {
                          await NoteDatabaseHelper.instance.insertNote(note);
                          _scaffoldMessengerKey.currentState?.showSnackBar(
                            const SnackBar(content: Text('Đã thêm ghi chú thành công')),
                          );
                        } else {
                          await NoteDatabaseHelper.instance.updateNote(note);
                          _scaffoldMessengerKey.currentState?.showSnackBar(
                            const SnackBar(content: Text('Đã cập nhật ghi chú thành công')),
                          );
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        _scaffoldMessengerKey.currentState?.showSnackBar(
                          SnackBar(content: Text('Lỗi khi lưu ghi chú: $e')),
                        );
                      }
                    }
                  },
                  child: Text(widget.note == null ? 'Lưu' : 'Cập nhật'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
