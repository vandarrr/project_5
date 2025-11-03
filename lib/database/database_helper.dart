import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // === Buat tabel awal ===
  Future _createDB(Database db, int version) async {
    // === Table user (data diri) ===
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        email TEXT,
        noHp TEXT,
        gender TEXT,
        tanggalLahir TEXT,
        lokasi TEXT,
        posisi TEXT,
        kota TEXT
      )
    ''');

    // === Table pengalaman kerja (versi baru) ===
    await db.execute('''
      CREATE TABLE pengalaman (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        perusahaan TEXT,
        posisi TEXT,
        tanggalMasuk TEXT,
        tanggalKeluar TEXT,
        gaji TEXT,
        deskripsi TEXT
      )
    ''');

    // === Table pendidikan ===
    await db.execute('''
      CREATE TABLE pendidikan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        institusi TEXT,
        jurusan TEXT,
        tahun TEXT
      )
    ''');

    // === Table kemampuan teknis ===
    await db.execute('''
      CREATE TABLE kemampuan_teknis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT
      )
    ''');

    // === Table kemampuan bahasa ===
    await db.execute('''
      CREATE TABLE kemampuan_bahasa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bahasa TEXT,
        tingkat TEXT
      )
    ''');

    // === Table dokumen dan CV ===
    await db.execute('''
      CREATE TABLE dokumen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cv (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');
  }

  // === Jika kamu upgrade dari versi lama (tanpa tanggal/gaji/deskripsi) ===
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Tambahkan kolom baru ke tabel pengalaman lama
      await db.execute('ALTER TABLE pengalaman ADD COLUMN tanggalMasuk TEXT');
      await db.execute('ALTER TABLE pengalaman ADD COLUMN tanggalKeluar TEXT');
      await db.execute('ALTER TABLE pengalaman ADD COLUMN gaji TEXT');
      await db.execute('ALTER TABLE pengalaman ADD COLUMN deskripsi TEXT');
    }
  }

  // ==================== CRUD: USER (DATA DIRI) ====================
  Future<int> insertUser(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('user', data);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await instance.database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<int> updateUser(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update('user', data, where: 'id = ?', whereArgs: [1]);
  }

  // ==================== CRUD: PENGALAMAN ====================
  Future<List<Map<String, dynamic>>> getAllPengalaman() async {
    final db = await instance.database;
    return await db.query('pengalaman', orderBy: 'id DESC');
  }

  Future<int> insertPengalaman(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('pengalaman', data);
  }

  Future<int> deletePengalaman(int id) async {
    final db = await instance.database;
    return await db.delete('pengalaman', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllPengalaman() async {
    final db = await instance.database;
    await db.delete('pengalaman');
  }

  // ==================== CRUD: PENDIDIKAN ====================
  Future<List<Map<String, dynamic>>> getAllPendidikan() async {
    final db = await instance.database;
    return await db.query('pendidikan');
  }

  Future<int> insertPendidikan(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('pendidikan', data);
  }

  Future<int> deletePendidikan(int id) async {
    final db = await instance.database;
    return await db.delete('pendidikan', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== CRUD: KEMAMPUAN TEKNIS ====================
  Future<List<Map<String, dynamic>>> getAllKemampuanTeknis() async {
    final db = await instance.database;
    return await db.query('kemampuan_teknis');
  }

  Future<int> insertKemampuanTeknis(String nama) async {
    final db = await instance.database;
    return await db.insert('kemampuan_teknis', {'nama': nama});
  }

  Future<int> deleteKemampuanTeknis(int id) async {
    final db = await instance.database;
    return await db.delete(
      'kemampuan_teknis',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== CRUD: KEMAMPUAN BAHASA ====================
  Future<List<Map<String, dynamic>>> getAllKemampuanBahasa() async {
    final db = await instance.database;
    return await db.query('kemampuan_bahasa');
  }

  Future<int> insertKemampuanBahasa(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('kemampuan_bahasa', data);
  }

  Future<int> deleteKemampuanBahasa(int id) async {
    final db = await instance.database;
    return await db.delete(
      'kemampuan_bahasa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== CRUD: DOKUMEN & CV ====================
  Future<List<Map<String, dynamic>>> getAllDokumen() async {
    final db = await instance.database;
    return await db.query('dokumen');
  }

  Future<int> insertDokumen(String path) async {
    final db = await instance.database;
    return await db.insert('dokumen', {'path': path});
  }

  Future<int> deleteDokumen(int id) async {
    final db = await instance.database;
    return await db.delete('dokumen', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllCV() async {
    final db = await instance.database;
    return await db.query('cv');
  }

  Future<int> insertCV(String path) async {
    final db = await instance.database;
    return await db.insert('cv', {'path': path});
  }

  Future<int> deleteCV(int id) async {
    final db = await instance.database;
    return await db.delete('cv', where: 'id = ?', whereArgs: [id]);
  }
}
