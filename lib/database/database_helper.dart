import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('profil_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // ===================== TABLE PENGALAMAN KERJA =====================
    await db.execute('''
      CREATE TABLE pengalaman_kerja (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        perusahaan TEXT,
        posisi TEXT,
        tanggalMasuk TEXT,
        tanggalKeluar TEXT,
        gaji TEXT,
        deskripsi TEXT
      )
    ''');

    // ===================== TABLE RIWAYAT PENDIDIKAN =====================
    await db.execute('''
      CREATE TABLE riwayat_pendidikan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        institusi TEXT,
        jurusan TEXT,
        tahun TEXT
      )
    ''');

    // ===================== TABLE KEMAMPUAN TEKNIS =====================
    await db.execute('''
      CREATE TABLE kemampuan_teknis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT
      )
    ''');

    // ===================== TABLE KEMAMPUAN BAHASA =====================
    await db.execute('''
      CREATE TABLE kemampuan_bahasa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bahasa TEXT,
        tingkat TEXT
      )
    ''');

    // ===================== TABLE CV =====================
    await db.execute('''
      CREATE TABLE cv (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');

    // ===================== TABLE DOKUMEN =====================
    await db.execute('''
      CREATE TABLE dokumen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');
  }

  // ===================== PENGALAMAN KERJA =====================
  Future<int> insertPengalaman(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('pengalaman_kerja', row);
  }

  Future<List<Map<String, dynamic>>> getAllPengalaman() async {
    final db = await instance.database;
    return await db.query('pengalaman_kerja', orderBy: 'id DESC');
  }

  Future<int> deletePengalaman(int id) async {
    final db = await instance.database;
    return await db.delete(
      'pengalaman_kerja',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===================== RIWAYAT PENDIDIKAN =====================
  Future<int> insertPendidikan(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('riwayat_pendidikan', row);
  }

  Future<List<Map<String, dynamic>>> getAllPendidikan() async {
    final db = await instance.database;
    return await db.query('riwayat_pendidikan', orderBy: 'id DESC');
  }

  Future<int> deletePendidikan(int id) async {
    final db = await instance.database;
    return await db.delete(
      'riwayat_pendidikan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===================== KEMAMPUAN TEKNIS =====================
  Future<int> insertKemampuanTeknis(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('kemampuan_teknis', row);
  }

  Future<List<Map<String, dynamic>>> getAllKemampuanTeknis() async {
    final db = await instance.database;
    return await db.query('kemampuan_teknis', orderBy: 'id DESC');
  }

  Future<int> deleteKemampuanTeknis(int id) async {
    final db = await instance.database;
    return await db.delete(
      'kemampuan_teknis',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===================== KEMAMPUAN BAHASA =====================
  Future<int> insertKemampuanBahasa(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('kemampuan_bahasa', row);
  }

  Future<List<Map<String, dynamic>>> getAllKemampuanBahasa() async {
    final db = await instance.database;
    return await db.query('kemampuan_bahasa', orderBy: 'id DESC');
  }

  Future<int> deleteKemampuanBahasa(int id) async {
    final db = await instance.database;
    return await db.delete(
      'kemampuan_bahasa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===================== CV =====================
  Future<int> insertCV(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('cv', row);
  }

  Future<List<Map<String, dynamic>>> getAllCV() async {
    final db = await instance.database;
    return await db.query('cv', orderBy: 'id DESC');
  }

  Future<int> deleteCV(int id) async {
    final db = await instance.database;
    return await db.delete('cv', where: 'id = ?', whereArgs: [id]);
  }

  // ===================== DOKUMEN =====================
  Future<int> insertDokumen(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('dokumen', row);
  }

  Future<List<Map<String, dynamic>>> getAllDokumen() async {
    final db = await instance.database;
    return await db.query('dokumen', orderBy: 'id DESC');
  }

  Future<int> deleteDokumen(int id) async {
    final db = await instance.database;
    return await db.delete('dokumen', where: 'id = ?', whereArgs: [id]);
  }

  // ===================== CLOSE DB =====================
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
