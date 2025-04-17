import 'package:flutter/material.dart';
import 'package:app_02/NoteApp/DatabaseHelper/DatabaseHelper.dart';
import 'package:app_02/NoteApp/Model/NoteModel.dart';
import 'package:app_02/NoteApp/UI/NoteForm.dart';
import 'package:app_02/userMS/database/NoteItem.dart';

class NoteListScreen extends StatefulWidget {
  final VoidCallback onThemeChanged;
  final bool isDarkMode;

  const NoteListScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late List<Note> notes;
  bool isLoading = false;
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    setState(() => isLoading = true);
    notes = await NoteDatabaseHelper.instance.getAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Ghi Chú'),
        actions: _buildAppBarActions(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildNoteList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteFormScreen()),
          );
          loadNotes();
        },
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
        onPressed: widget.onThemeChanged,
        tooltip: widget.isDarkMode ? 'Chuyển sang chế độ sáng' : 'Chuyển sang chế độ tối',
      ),
      IconButton(
        icon: Icon(isGridView ? Icons.list : Icons.grid_view),
        onPressed: () => setState(() => isGridView = !isGridView),
      ),
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'refresh') loadNotes();
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'refresh', child: Text('Làm mới')),
        ],
      ),
    ];
  }

  Widget _buildNoteList() {
    if (notes.isEmpty) {
      return const Center(child: Text('Không có ghi chú nào'));
    }

    return isGridView
        ? GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteItem(
        note: notes[index],
        onDelete: loadNotes,
      ),
    )
        : ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) => NoteItem(
        note: notes[index],
        onDelete: loadNotes,
      ),
    );
  }
}
