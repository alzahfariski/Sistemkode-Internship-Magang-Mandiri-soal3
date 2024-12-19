import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'mahasiswa_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final mahasiswaController = Get.put(MahasiswaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GetX Example'),
      ),
      body: Column(
        children: [
          // Data mahasiswa
          Expanded(
            child: Obx(
              () => FutureBuilder<List<Map<String, dynamic>>>(
                future: mahasiswaController.getMahasiswaData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final mahasiswaData = snapshot.data!;
                    return ListView.builder(
                      itemCount: mahasiswaData.length,
                      itemBuilder: (context, index) {
                        final mahasiswa = mahasiswaData[index];
                        return ListTile(
                          title: Text(mahasiswa['nama']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NIM: ${mahasiswa['nim']}'),
                              Text('Alamat: ${mahasiswa['alamat']}'),
                              Text('Jurusan: ${mahasiswa['jurusan']}'),
                              Text('Umur: ${mahasiswa['umur']}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data found'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add new mahasiswa or perform other actions
        },
        tooltip: 'Add Mahasiswa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
