import 'package:flutter/material.dart';
import 'my_wigdet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: MyColumnAndRow(),
    );
  }
}

class MyText extends StatelessWidget {
  const MyText({super.key});

  @override
  Widget build(BuildContext context) {
    // Trả về một Scaffold - widget cung cấp bố cục Material Design cơ bản
    return Scaffold(
      // AppBar - thanh ứng dụng ở trên cùng
      appBar: AppBar(
        // Tiêu đề của AppBar
        title: const Text('My Scaffold Demo'),
        // Màu nền của AppBar
        backgroundColor: Colors.orange,
        // Độ nâng (đổ bóng) của AppBar
        elevation: 4,
        // Danh sách các nút hành động bên phải AppBar
        actions: [
          // Nút biểu tượng tìm kiếm
          IconButton(
            onPressed: () {
              print("search");
            },
            icon: const Icon(Icons.search),
          ),
          // Nút biểu tượng ...
          IconButton(
            onPressed: () {
              print("...");
            },
            icon: const Icon(Icons.more_vert),
          ), // Nút biểu tượng ...
          IconButton(
            onPressed: () {
              print("abc");
            },
            icon: const Icon(Icons.abc),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text cơ bản
            const Text("Văn bản thông thường"),

            const SizedBox(height: 20),

            // Text với style
            Text(
              "Văn bản có định dạng",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Văn bản dài với các tùy chọn khác nhau như canh lề, giới hạn dòng, overflow ...3456 789 101112',
              style: TextStyle(color: Colors.green, fontSize: 20),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("OK");
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cá nhân"),
        ],
      ),
    );
  }
}