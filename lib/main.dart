import 'package:flutter/material.dart';
import 'screen/home.dart'; // นำเข้าหน้าจอจากโฟลเดอร์ screen

// ความรู้จากใบงานที่ 3: ฟังก์ชันหลักของแอปพลิเคชัน[cite: 2]
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ความรู้จากใบงานที่ 2 & 3: กำหนดค่าเริ่มต้นของแอป[cite: 1, 2]
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snack Shop App',
      home: HomeScreen(), // เรียกหน้าจอ HomeScreen มาแสดงเป็นหน้าแรก
    );
  }
}