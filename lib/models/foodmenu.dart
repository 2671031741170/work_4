// ---------------------------------------------------------
// Enum สำหรับกำหนดเส้นทางรูปภาพของขนมแต่ละเมนู
// ---------------------------------------------------------
enum SnackPic {
  menu1(image: "assets/images/1.png"),
  menu2(image: "assets/images/2.png"),
  menu3(image: "assets/images/3.png"),
  menu4(image: "assets/images/4.png"),
  menu5(image: "assets/images/5.png"),
  menu6(image: "assets/images/6.png"),
  menu7(image: "assets/images/7.png");

  const SnackPic({required this.image}); // คอนสตรัคเตอร์รับค่ารูปภาพ
  final String image; // ตัวแปรเก็บที่อยู่ของไฟล์ภาพ
}

// ---------------------------------------------------------
// Data Model สำหรับกำหนดโครงสร้างข้อมูลสินค้าแต่ละชิ้น
// ---------------------------------------------------------
class FoodMenuModel {
  String name;      // ชื่อสินค้า
  double price;     // ราคาสินค้าต่อชิ้น
  SnackPic snackPic;// รูปภาพสินค้าจาก Enum
  int count;        // จำนวนสินค้าที่ผู้ใช้เลือก (เริ่มต้นเป็น 0)

  FoodMenuModel({
    required this.name,
    required this.price,
    required this.snackPic,
    this.count = 0,
  });
}

// ---------------------------------------------------------
// Data Model สำหรับเก็บข้อมูลประวัติการขาย (บิลแต่ละรายการที่ชำระเงินแล้ว)
// ---------------------------------------------------------
class OrderHistoryModel {
  final String orderId;                 // รหัสคำสั่งซื้อ (ใช้วันที่และเวลาแปลงเป็นข้อความ)
  final List<FoodMenuModel> items;      // รายการสินค้าทั้งหมดในบิลนั้น
  final double totalPrice;              // ราคารวมสุทธิของบิล
  final String paymentMethod;           // วิธีการชำระเงิน (เงินสด/QR/บัตร)
  final DateTime dateTime;              // วันและเวลาที่ทำรายการ

  OrderHistoryModel({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    required this.paymentMethod,
    required this.dateTime,
  });
}