import 'package:flutter/material.dart';
import '../models/foodmenu.dart';

// -----------------------------------------------------------------------------
// ส่วนที่ 0: ตัวแปรส่วนกลาง (Global Variables)
// ใช้สำหรับเก็บประวัติการขายและรันเลขออเดอร์ให้ต่อเนื่องกันทุกหน้า
// -----------------------------------------------------------------------------
List<OrderHistoryModel> globalSalesHistory = []; // รายการเก็บประวัติการสั่งซื้อทั้งหมด
int _orderCounter = 1; // ตัวนับเลขออเดอร์ เริ่มต้นที่ 1

// =============================================================================
// ส่วนที่ 1: หน้าจอหลักเลือกสินค้า (HomeScreen)
// ทำหน้าที่แสดงรายการขนม, เพิ่ม/ลดจำนวน, คำนวณราคา, และกดไปหน้าชำระเงิน
// =============================================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // รายการสินค้าจำลองในร้าน (Snack List) กำหนดชื่อ ราคา และรูปภาพ
  final List<FoodMenuModel> snackList = [
    FoodMenuModel(name: "มันฝรั่งทอดกรอบ", price: 20.0, snackPic: SnackPic.menu1),
    FoodMenuModel(name: "ช็อกโกแลตหนืด", price: 35.0, snackPic: SnackPic.menu2),
    FoodMenuModel(name: "ป๊อปคอร์นเนยสด", price: 50.0, snackPic: SnackPic.menu3),
    FoodMenuModel(name: "เค้กสตรอว์เบอร์รี่", price: 65.0, snackPic: SnackPic.menu4),
    FoodMenuModel(name: "คุ้กกี้ชิปส์", price: 40.0, snackPic: SnackPic.menu5),
    FoodMenuModel(name: "เยลลี่ผลไม้รวม", price: 25.0, snackPic: SnackPic.menu6),
    FoodMenuModel(name: "ไอศกรีมวานิลลา", price: 45.0, snackPic: SnackPic.menu7),
  ];

  // Getter สำหรับคำนวณราคารวมของสินค้าทั้งหมดในตะกร้าแบบ Real-time
  double get totalPrice {
    double total = 0.0;
    for (var item in snackList) {
      total += item.price * item.count;
    }
    return total;
  }

  // Getter สำหรับคำนวณจำนวนชิ้นรวมทั้งหมดในตะกร้า
  int get totalItems {
    int totalCount = 0;
    for (var item in snackList) {
      totalCount += item.count;
    }
    return totalCount;
  }

  // ฟังก์ชันสำหรับล้างค่าจำนวนสินค้าในตะกร้าให้กลับเป็น 0 ทั้งหมด
  void resetCart() {
    setState(() {
      for (var item in snackList) {
        item.count = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนหัวของแอปพลิเคชัน (AppBar) พร้อมปุ่มกดดูประวัติการขาย
      appBar: AppBar(
        title: const Text("ร้านขนมหวานทานเล่น"),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 28),
            onPressed: () {
              // คำสั่งเปิดหน้าจอประวัติการขาย (SalesHistoryScreen)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SalesHistoryScreen()),
              );
            },
          ),
        ],
      ),
      // ส่วนเนื้อหาหลักของหน้าจอ
      body: Column(
        children: [
          // พื้นที่แสดงรายการสินค้าแบบเลื่อนได้ (ListView)
          Expanded(
            child: ListView.builder(
              itemCount: snackList.length,
              itemBuilder: (context, index) {
                final item = snackList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // แสดงรูปภาพสินค้า
                      Image.asset(item.snackPic.image, width: 65, height: 65),
                      const SizedBox(width: 10),
                      // แสดงชื่อและราคาต่อหน่วย
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("ราคา : ${item.price} บาท", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ),
                      // ปุ่มควบคุมการเพิ่ม/ลดจำนวนสินค้า
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              if (item.count > 0) {
                                setState(() { item.count--; }); // ลดจำนวนลงทีละ 1 เมื่อมากกว่า 0
                              }
                            },
                          ),
                          Text("${item.count}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () {
                              setState(() { item.count++; }); // เพิ่มจำนวนขึ้นทีละ 1
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // แถบสรุปยอดด้านล่างสุด และปุ่มกดชำระเงิน
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ตะกร้า : $totalItems ชิ้น", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("รวม : ${totalPrice.toStringAsFixed(2)} บาท", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  // หากไม่มีสินค้าในตะกร้า (totalItems == 0) จะปิดการใช้งานปุ่ม (onPressed เป็น null)
                  onPressed: totalItems == 0
                      ? null
                      : () {
                          // กรองเอาเฉพาะสินค้าที่มีการสั่งซื้อ (count > 0) ส่งต่อไปยังหน้าชำระเงิน
                          final selectedItems = snackList.where((e) => e.count > 0).toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                selectedItems: selectedItems,
                                totalPrice: totalPrice,
                                onResetCart: resetCart,
                              ),
                            ),
                          );
                        },
                  icon: const Icon(Icons.payment),
                  label: const Text("ชำระเงิน"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// ส่วนที่ 2: หน้าจอเลือกวิธีชำระเงิน (PaymentScreen)
// ให้ผู้ใช้เลือกช่องทางการจ่ายเงิน (เงินสด, QR Code, บัตรเครดิต)
// =============================================================================
class PaymentScreen extends StatelessWidget {
  final List<FoodMenuModel> selectedItems;
  final double totalPrice;
  final VoidCallback onResetCart;

  const PaymentScreen({
    super.key,
    required this.selectedItems,
    required this.totalPrice,
    required this.onResetCart,
  });

  // ฟังก์ชันประมวลผลการชำระเงิน บันทึกลง globalSalesHistory และเปลี่ยนไปหน้าใบเสร็จ
  void _processPayment(BuildContext context, String method) {
    // ทำสำเนาข้อมูลสินค้าที่ซื้อเก็บไว้ในประวัติ เพื่อป้องกันค่าเปลี่ยนแปลงย้อนหลัง
    final purchasedSnapshot = selectedItems.map((item) {
      return FoodMenuModel(
        name: item.name,
        price: item.price,
        snackPic: item.snackPic,
        count: item.count,
      );
    }).toList();

    // สร้างรหัสออเดอร์รูปแบบ OD001, OD002 จัดรูปแบบด้วย padLeft
    final String formattedOrderId = "OD${_orderCounter.toString().padLeft(3, '0')}";

    // สร้างออบเจกต์คำสั่งซื้อใหม่
    final newOrder = OrderHistoryModel(
      orderId: formattedOrderId,
      items: purchasedSnapshot,
      totalPrice: totalPrice,
      paymentMethod: method,
      dateTime: DateTime.now(),
    );

    _orderCounter++; // เพิ่มเลขออเดอร์สำหรับบิลถัดไป
    globalSalesHistory.insert(0, newOrder); // แทรกข้อมูลใหม่ไว้บนสุดของประวัติ

    // สลับหน้าจอไปที่หน้าใบเสร็จรับเงิน (ReceiptScreen) หลังชำระเงินสำเร็จ
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptScreen(
          order: newOrder,
          onResetCart: onResetCart,
          isFromHistory: false, // บอกว่ามาจากหน้าชำระเงินปกติ
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เลือกวิธีชำระเงิน"), backgroundColor: Colors.blueAccent, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("ยอดชำระ : ${totalPrice.toStringAsFixed(2)} บาท", textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 30),
            // ตัวเลือกช่องทางที่ 1: เงินสด
            Card(child: ListTile(leading: const Icon(Icons.money, color: Colors.green), title: const Text("เงินสด (Cash)"), onTap: () => _processPayment(context, "เงินสด"))),
            // ตัวเลือกช่องทางที่ 2: QR Code
            Card(child: ListTile(leading: const Icon(Icons.qr_code_2, color: Colors.purple), title: const Text("สแกน QR Code"), onTap: () => _processPayment(context, "QR Code"))),
            // ตัวเลือกช่องทางที่ 3: บัตรเครดิต / เดบิต
            Card(child: ListTile(leading: const Icon(Icons.credit_card, color: Colors.orange), title: const Text("บัตรเครดิต / เดบิต"), onTap: () => _processPayment(context, "บัตรเครดิต/เดบิต"))),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ส่วนที่ 3: หน้าจอแสดงใบเสร็จรับเงิน (ReceiptScreen)
// แสดงรายละเอียดการซื้อ วันที่ เวลา รายการสินค้า และราคารวมสุทธิ
// =============================================================================
class ReceiptScreen extends StatelessWidget {
  final OrderHistoryModel order;
  final VoidCallback? onResetCart; // อนุญาตให้เป็น null ได้ กรณีเปิดดูจากหน้าประวัติ
  final bool isFromHistory; // ตัวแปรเช็คว่าเปิดมาจากหน้าประวัติหรือไม่

  const ReceiptScreen({
    super.key, 
    required this.order, 
    this.onResetCart,
    this.isFromHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    // จัดรูปแบบวันที่และเวลาให้อ่านง่าย
    final String dateStr = "${order.dateTime.day}/${order.dateTime.month}/${order.dateTime.year}";
    final String timeStr = "${order.dateTime.hour.toString().padLeft(2, '0')}:${order.dateTime.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("ใบเสร็จรับเงิน"), 
        backgroundColor: Colors.green, 
        // ถ้ามาจากหน้าประวัติ ให้แสดงปุ่ม Back ปกติ แต่ถ้ามาจากหน้าชำระเงินให้ซ่อนไว้
        automaticallyImplyLeading: !isFromHistory, 
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("รายละเอียดใบเสร็จ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ),
            const Divider(thickness: 2),
            Text("รหัสออเดอร์ : ${order.orderId}"),
            Text("วันที่ : $dateStr"),
            Text("เวลา : $timeStr"),
            Text("ช่องทางชำระเงิน : ${order.paymentMethod}"),
            const Divider(thickness: 2),
            
            // หัวตารางแสดงรายละเอียดสินค้า
            const Row(
              children: [
                Expanded(flex: 3, child: Text("รายการ", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("จำนวน", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("ราคา", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const Divider(),

            // รายการสินค้าในใบเสร็จ
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(item.name)),
                        Expanded(flex: 1, child: Text("${item.count}", textAlign: TextAlign.center)),
                        Expanded(flex: 2, child: Text("${(item.price * item.count).toStringAsFixed(2)}", textAlign: TextAlign.right)),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            const Divider(thickness: 2),
            // แสดงยอดสุทธิรวมทั้งหมด
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ยอดสุทธิ:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("${order.totalPrice.toStringAsFixed(2)} บาท", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 20),

            // ปุ่มกด (เปลี่ยนการทำงานตามที่มาของหน้าจอ)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFromHistory ? Colors.indigo : Colors.pinkAccent, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15)
                ),
                onPressed: () {
                  if (isFromHistory) {
                    // ถ้าเปิดมาจากประวัติ ให้กดปุ่มนี้เพื่อกลับหน้าประวัติเฉยๆ
                    Navigator.pop(context);
                  } else {
                    // ถ้ามาจากการชำระเงิน ให้ล้างตะกร้าและกลับหน้าหลักสุด
                    if (onResetCart != null) onResetCart!();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                child: Text(
                  isFromHistory ? "ย้อนกลับ" : "เสร็จสิ้น (กลับหน้าหลัก)", 
                  style: const TextStyle(fontSize: 16)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ส่วนที่ 4: หน้าจอประวัติการขาย (SalesHistoryScreen)
// แสดงประวัติย้อนหลัง พร้อมช่องค้นหารหัสออเดอร์ และกดดูรายละเอียดบิลได้
// =============================================================================
class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  String _searchQuery = ""; // ตัวแปรเก็บค่าข้อความที่ใช้ค้นหา

  @override
  Widget build(BuildContext context) {
    // กรองประวัติการขายตามรหัสออเดอร์ที่พิมพ์ค้นหา
    final filteredList = globalSalesHistory.where((order) => 
      order.orderId.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ประวัติการขาย"), backgroundColor: Colors.indigo, centerTitle: true),
      body: Column(
        children: [
          // ช่องป้อนคำค้นหา (Search Bar)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "ค้นหารหัสออเดอร์ (เช่น OD001)", 
                prefixIcon: Icon(Icons.search), 
                border: OutlineInputBorder()
              ),
              onChanged: (value) => setState(() => _searchQuery = value), // อัปเดตผลลัพธ์ทันทีเมื่อพิมพ์
            ),
          ),
          // แสดงรายการประวัติ
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text("ไม่พบประวัติการขาย", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final order = filteredList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          title: Text("รหัส: ${order.orderId} (${order.paymentMethod})", style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("ยอดรวม: ${order.totalPrice.toStringAsFixed(2)} บาท"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          // เพิ่มคำสั่งเมื่อกดที่รายการออเดอร์ จะพาไปหน้า ReceiptScreen แบบละเอียดทันที
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReceiptScreen(
                                  order: order,
                                  isFromHistory: true, // กำหนดสถานะว่ามาจากหน้าประวัติ
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}