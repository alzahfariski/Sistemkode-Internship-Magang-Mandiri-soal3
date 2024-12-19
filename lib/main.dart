import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mahasiswa_controller.dart'; // Import controller yang sudah Anda buat

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mahasiswa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // Membuat instance controller
  final MahasiswaController mahasiswaController =
      Get.put(MahasiswaController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Mahasiswa'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: mahasiswaController.getMahasiswaData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Data tidak ditemukan.'));
          } else {
            var mahasiswaList = snapshot.data!;
            return ListView.builder(
              itemCount: mahasiswaList.length,
              itemBuilder: (context, index) {
                var mahasiswa = mahasiswaList[index];
                return ListTile(
                  title: Text(mahasiswa['nama']),
                  subtitle: Text(
                      'Jurusan: ${mahasiswa['jurusan']}, Alamat: ${mahasiswa['alamat']}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the updateAlamat method
          // mahasiswaController.updateAlamat('Jl. Baru No. 1');
        },
        tooltip: 'Update Alamat',
        child: Icon(Icons.update),
      ),
    );
  }
}
