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
      db.execute('''CREATE TABLE mahasiswa (
        nim INTEGER PRIMARY KEY,
        nama TEXT,
        alamat TEXT,
        jurusan TEXT,
        umur INTEGER
      )''');

      db.execute('''CREATE TABLE mataKuliah (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mataKuliah TEXT,
        nim INTEGER,
        nilai INTEGER,
        dosen TEXT,
        FOREIGN KEY (nim) REFERENCES mahasiswa (nim)
      )''');
    });
  }

  // Update any field for a specific mahasiswa using NIM
  Future<void> updateMahasiswa(
      int nim, Map<String, dynamic> updatedData) async {
    final db = await database;
    try {
      await db
          .update('mahasiswa', updatedData, where: 'nim = ?', whereArgs: [nim]);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get mahasiswa data from database
  Future<List<Map<String, dynamic>>> getMahasiswaData() async {
    final db = await database;
    try {
      return await db.query('mahasiswa');
    } catch (e) {
      return [];
    }
  }

  // Get mata kuliah data from database
  Future<List<Map<String, dynamic>>> getMataKuliahData() async {
    final db = await database;
    try {
      return await db.query('mataKuliah');
    } catch (e) {
      return [];
    }
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
      // Add more students here...
    ];

    // Insert mahasiswa data if empty
    for (var mahasiswa in mahasiswaList) {
      await db.insert('mahasiswa', mahasiswa,
          conflictAlgorithm: ConflictAlgorithm.ignore);
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
      // Add more courses here...
    ];

    // Insert mata kuliah data if empty
    for (var mataKuliah in mataKuliahList) {
      await db.insert('mataKuliah', mataKuliah,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  // Fetch mahasiswa based on the 'Teknik Informatika' major
  Future<List<Map<String, dynamic>>> getMahasiswaTeknikInformatika() async {
    final db = await database;
    try {
      return await db.query('mahasiswa',
          where: 'jurusan = ?', whereArgs: ['Teknik Informatika']);
    } catch (e) {
      return [];
    }
  }

  // Get 5 oldest mahasiswa
  Future<List<Map<String, dynamic>>> getMahasiswaTertua() async {
    final db = await database;
    try {
      return await db.query('mahasiswa', orderBy: 'umur DESC', limit: 5);
    } catch (e) {
      return [];
    }
  }

  // Fetch mahasiswa with grades above 70
  Future<List<Map<String, dynamic>>> getMahasiswaDenganNilaiBaik() async {
    final db = await database;
    try {
      final result = await db.rawQuery('''
        SELECT m.nama, mk.mataKuliah, mk.nilai 
        FROM mahasiswa m 
        JOIN mataKuliah mk ON m.nim = mk.nim 
        WHERE mk.nilai > 70
      ''');
      return result;
    } catch (e) {
      return [];
    }
  }
}
