import "package:flutter/material.dart";

class MyButtons extends StatelessWidget {
  const MyButtons ({super.key});

  @override
  Widget build(BuildContext context) {
    // Tra ve Scaffold - widget cung cap bo cuc Material Design co ban
    // Man hinh
    return Scaffold(
      // Tiêu đề của ứng dụng
      appBar: AppBar(
        // Tieu de
        title: Text("App 02"),
        // Mau nen
        backgroundColor: Colors.yellow,
        // Do nang/ do bong cua AppBar
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              print("b1");
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              print("b2");
            },
            icon: Icon(Icons.abc),
          ),
          IconButton(
            onPressed: () {
              print("b3");
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                print("Click me!");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Màu nền nút
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: Text("Click me!"),
            ),
            SizedBox(height: 20,),
            TextButton(onPressed: (){},
                child: Text("Button 2", style: TextStyle(fontSize: 24),)),
            SizedBox(height: 20),
// IconButton là button chỉ gồm icon, không có văn bản, thường dùng trong app bar hoặc điều hướng
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite),
            ),

            SizedBox(height: 20),
// FloatingActionButton là button hình tròn, nổi trên giao diện, thường dùng cho hành động chính của màn hình
            FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),

            SizedBox(height: 20),
            // Tùy chỉnh
            ElevatedButton(
                onPressed: () {
                  print("Click me!");
                },
              child: Text("Click me!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // màu nền
                foregroundColor: Colors.black, // màu chữ
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              elevation: 10,
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: (){},
              icon: Icon(Icons.favorite),
              label: Text("Yêu thích"),
            ),

            SizedBox(height: 20),
            TextButton.icon(
              onPressed: (){},
              icon: Icon(Icons.favorite),
              label: Text("Yêu thích"),
            ),
            
            InkWell(
              onTap: (){
                print("InkWell được nhấn!");
              },
              splashColor: Colors.orange.withOpacity(0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color:  Colors.yellow),
                ),
                child: Text("Button tùy chỉnh với InkWell"),
              ),
            )
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressed");
        },
        child: const Icon(Icons.add_ic_call),
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