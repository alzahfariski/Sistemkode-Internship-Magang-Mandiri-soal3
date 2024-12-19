import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MahasiswaController extends GetxController {
  // Database variables
  Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mahasiswa.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      // Create tables
      db.execute('''
        CREATE TABLE mahasiswa (
          nim INTEGER PRIMARY KEY,
          nama TEXT,
          alamat TEXT,
          jurusan TEXT,
          umur INTEGER
        )
      ''');

      db.execute('''
        CREATE TABLE mataKuliah (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          mataKuliah TEXT,
          nim INTEGER,
          nilai INTEGER,
          dosen TEXT,
          FOREIGN KEY (nim) REFERENCES mahasiswa (nim)
        )
      ''');
    });
  }

  // Update alamat mahasiswa with NIM '123456'
  Future<void> updateAlamat(String newAlamat) async {
    final db = await database;
    await db.update('mahasiswa', {'alamat': newAlamat},
        where: 'nim = ?', whereArgs: ['123456']);
  }

  // Get data from database
  Future<List<Map<String, dynamic>>> getMahasiswaData() async {
    final db = await database;
    return await db.query('mahasiswa');
  }

  // Get data from database
  Future<List<Map<String, dynamic>>> getMataKuliahData() async {
    final db = await database;
    return await db.query('mataKuliah');
  }

  @override
  void onInit() async {
    // Populate the database with initial data
    await populateDatabase();
    super.onInit();
  }

  // Populate the database with initial data
  Future<void> populateDatabase() async {
    final db = await database;

    // Mahasiswa ```dart
    List<Map<String, dynamic>> mahasiswaList = [
      {
        'nim': 123456,
        'nama': 'John',
        'alamat': 'Jl. Merdeka No. 1',
        'jurusan': 'Teknik Informatika',
        'umur': 21
      },
      {
        'nim': 234567,
        'nama': 'Alice',
        'alamat': 'Jl. Gatot Subroto',
        'jurusan': 'Sistem Informasi',
        'umur': 23
      },
      {
        'nim': 345678,
        'nama': 'Bob',
        'alamat': 'Jl. Sudirman No. 5',
        'jurusan': 'Teknik Informatika',
        'umur': 20
      },
      {
        'nim': 456789,
        'nama': 'Cindy',
        'alamat': 'Jl. Pahlawan No. 2',
        'jurusan': 'Manajemen',
        'umur': 22
      },
      {
        'nim': 567890,
        'nama': 'David',
        'alamat': 'Jl. Diponegoro No. 3',
        'jurusan': 'Teknik Elektro',
        'umur': 25
      },
      {
        'nim': 678901,
        'nama': 'Emily',
        'alamat': 'Jl. Cendrawasih No. 4',
        'jurusan': 'Manajemen',
        'umur': 24
      },
      {
        'nim': 789012,
        'nama': 'Frank',
        'alamat': 'Jl. Ahmad Yani No. 6',
        'jurusan': 'Teknik Informatika',
        'umur': 19
      },
    ];

    for (var mahasiswa in mahasiswaList) {
      await db.insert('mahasiswa', mahasiswa);
    }

    List<Map<String, dynamic>> mataKuliahList = [
      {
        'mataKuliah': 'Pemrograman Web',
        'nim': 123456,
        'nilai': 85,
        'dosen': 'Pak Budi'
      },
      {
        'mataKuliah': 'Basis Data',
        'nim': 234567,
        'nilai': 70,
        'dosen': 'Ibu Ani'
      },
      {
        'mataKuliah': 'Jaringan Komputer',
        'nim': 345678,
        'nilai': 75,
        'dosen': 'Pak Dodi'
      },
      {
        'mataKuliah': 'Sistem Operasi',
        'nim': 123456,
        'nilai': 90,
        'dosen': 'Pak Budi'
      },
      {
        'mataKuliah': 'Manajemen Proyek',
        'nim': 456789,
        'nilai': 80,
        'dosen': 'Ibu Desi'
      },
      {
        'mataKuliah': 'Bahasa Inggris',
        'nim': 567890,
        'nilai': 85,
        'dosen': 'Ibu Eka'
      },
      {
        'mataKuliah': 'Statistika',
        'nim': 678901,
        'nilai': 75,
        'dosen': 'Pak Farhan'
      },
      {
        'mataKuliah': 'Algoritma',
        'nim': 789012,
        'nilai': 65,
        'dosen': 'Ibu Siti'
      },
      {
        'mataKuliah': 'Pemrograman Java',
        'nim': 123456,
        'nilai': 95,
        'dosen': 'Pak Budi'
      },
    ];

    for (var mataKuliah in mataKuliahList) {
      await db.insert('mataKuliah', mataKuliah);
    }
  }

  // Tampilkan NIM, nama, dan jurusan dari mahasiswa yang memiliki jurusan 
  // ‘Teknik Informatika’, serta tampilkan juga nama dosen pembimbingnya
  Future<List<Map<String, dynamic>>> getMahasiswaTeknikInformatika() async {
    final db = await database;
    return await db.query('mahasiswa',
        where: 'jurusan = ?', whereArgs: ['Teknik Informatika']);
  }

  // Tampilkan 5 nama mahasiswa dengan umur tertua.
  Future<List<Map<String, dynamic>>> getMahasiswaTertua() async {
    final db = await database;
    return await db.query('mahasiswa', orderBy: 'umur DESC', limit: 5);
  }

  // Tampilkan nama mahasiswa, mata kuliah yang diambil, dan nilai yang 
  // diperoleh untuk setiap mata kuliah. Hanya tampilkan data mahasiswa 
  // yang memiliki nilai lebih bagus dari 70.
  Future<List<Map<String, dynamic>>> getMahasiswaDenganNilaiBaik() async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT m.nama, mk.mataKuliah, mk.nilai 
    FROM mahasiswa m 
    JOIN mataKuliah mk ON m.nim = mk.nim 
    WHERE mk.nilai > 70
  ''');
    return result;
  }
}
