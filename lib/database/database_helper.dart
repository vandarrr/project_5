import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // versi database saat ini
  static const int _dbVersion = 4;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('profil_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // ===================== CREATE DB =====================
  Future _createDB(Database db, int version) async {
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

    await db.execute('''
      CREATE TABLE riwayat_pendidikan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        institusi TEXT,
        jurusan TEXT,
        tahun TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE kemampuan_teknis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        kategori TEXT,
        tingkat TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE kemampuan_bahasa (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bahasa TEXT,
        tingkat TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cv (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE dokumen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE kota_diinginkan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_kota TEXT
      )
  ''');
    await db.execute('''
  CREATE TABLE posisi_diinginkan (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama_posisi TEXT
  )
''');
    await db.execute('''
  CREATE TABLE data_diri (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT,
    email TEXT,
    no_hp TEXT,
    gender TEXT,
    tanggal_lahir TEXT,
    lokasi TEXT,
    foto_path TEXT
  )
''');
  }

  // ===================== UPGRADE DB =====================
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Pastikan kolom baru untuk kemampuan_teknis ada
    final columnsTeknis = await db.rawQuery(
      "PRAGMA table_info(kemampuan_teknis)",
    );
    final colNamesTeknis = columnsTeknis
        .map((c) => c['name'] as String)
        .toList();

    if (!colNamesTeknis.contains('kategori')) {
      await db.execute('ALTER TABLE kemampuan_teknis ADD COLUMN kategori TEXT');
    }
    if (!colNamesTeknis.contains('tingkat')) {
      await db.execute('ALTER TABLE kemampuan_teknis ADD COLUMN tingkat TEXT');
    }

    // ✅ Tambahkan kolom foto_path ke tabel data_diri jika belum ada
    final columnsDataDiri = await db.rawQuery("PRAGMA table_info(data_diri)");
    final colNamesDataDiri = columnsDataDiri
        .map((c) => c['name'] as String)
        .toList();

    if (!colNamesDataDiri.contains('foto_path')) {
      await db.execute('ALTER TABLE data_diri ADD COLUMN foto_path TEXT');
    }
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

  Future<int> updatePengalaman(int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      'pengalaman_kerja',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
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

  Future<int> updatePendidikan(int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      'riwayat_pendidikan',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
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
  Future<void> _ensureColumnsKemampuanTeknis() async {
    final db = await database;
    final columns = await db.rawQuery("PRAGMA table_info(kemampuan_teknis)");
    final columnNames = columns.map((c) => c['name'] as String).toList();

    if (!columnNames.contains('kategori')) {
      await db.execute('ALTER TABLE kemampuan_teknis ADD COLUMN kategori TEXT');
    }
    if (!columnNames.contains('tingkat')) {
      await db.execute('ALTER TABLE kemampuan_teknis ADD COLUMN tingkat TEXT');
    }
  }

  Future<int> insertKemampuanTeknis(Map<String, dynamic> data) async {
    final db = await database;
    await _ensureColumnsKemampuanTeknis();
    return await db.insert('kemampuan_teknis', data);
  }

  Future<List<Map<String, dynamic>>> getAllKemampuanTeknis() async {
    final db = await database;
    await _ensureColumnsKemampuanTeknis();
    return await db.query('kemampuan_teknis', orderBy: 'id DESC');
  }

  Future<int> deleteKemampuanTeknis(int id) async {
    final db = await database;
    await _ensureColumnsKemampuanTeknis();
    return await db.delete(
      'kemampuan_teknis',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateKemampuanTeknis(int id, Map<String, dynamic> data) async {
    final db = await database;
    await _ensureColumnsKemampuanTeknis();
    return await db.update(
      'kemampuan_teknis',
      data,
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

  Future<int> updateKemampuanBahasa(int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.update(
      'kemampuan_bahasa',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
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
  Future<void> insertDokumen(Map<String, dynamic> dokumen) async {
    final db = await database;
    await db.insert('dokumen', dokumen);
  }

  Future<List<Map<String, dynamic>>> getAllDokumen() async {
    final db = await database;
    return await db.query('dokumen');
  }

  Future<void> deleteDokumenByPath(String path) async {
    final db = await database;
    await db.delete('dokumen', where: 'path = ?', whereArgs: [path]);
  }

  // ===================== KOTA DIINGINKAN (VERSI AMAN) =====================
  Future<void> insertOrUpdateKotaDiinginkan(String namaKota) async {
    final db = await database;

    try {
      // 1) pastikan tabel ada (jika belum ada, buat)
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='kota_diinginkan'",
      );
      if (tables.isEmpty) {
        await db.execute('''
        CREATE TABLE kota_diinginkan (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama_kota TEXT
        )
      ''');
      }

      // 2) ambil existing
      final existing = await db.query('kota_diinginkan', orderBy: 'id ASC');

      if (existing.isNotEmpty) {
        // update baris pertama (atau ubah strategi jika mau hanya 1 baris)
        final id = (existing.first['id'] as num).toInt();
        await db.update(
          'kota_diinginkan',
          {'nama_kota': namaKota},
          where: 'id = ?',
          whereArgs: [id],
        );

        // --- Alternatif: kalau kamu mau pastikan hanya 1 baris ada ---
        // await db.delete('kota_diinginkan');
        // await db.insert('kota_diinginkan', {'nama_kota': namaKota});
      } else {
        await db.insert('kota_diinginkan', {'nama_kota': namaKota});
      }
    } catch (e) {
      // Jangan crash aplikasi — boleh print untuk debugging
      // print('insertOrUpdateKotaDiinginkan error: $e');
    }
  }

  Future<String?> getKotaDiinginkan() async {
    try {
      final db = await database;

      // safety: pastikan tabel ada
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='kota_diinginkan'",
      );
      if (tables.isEmpty) return null;

      final result = await db.query(
        'kota_diinginkan',
        limit: 1,
        orderBy: 'id DESC',
      );
      if (result.isNotEmpty) {
        return result.first['nama_kota'] as String?;
      }
      return null;
    } catch (e) {
      // print('getKotaDiinginkan error: $e');
      return null;
    }
  }

  Future<void> deleteKotaDiinginkan() async {
    try {
      final db = await database;

      // jika tabel belum ada, nothing to do
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='kota_diinginkan'",
      );
      if (tables.isEmpty) return;

      await db.delete('kota_diinginkan');
    } catch (e) {
      // print('deleteKotaDiinginkan error: $e');
    }
  }

  // ===================== POSISI DIINGINKAN =====================
  Future<void> insertOrUpdatePosisiDiinginkan(String namaPosisi) async {
    final db = await database;

    // pastikan tabel ada
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='posisi_diinginkan'",
    );
    if (tables.isEmpty) {
      await db.execute('''
      CREATE TABLE posisi_diinginkan (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_posisi TEXT
      )
    ''');
    }

    final existing = await db.query('posisi_diinginkan', orderBy: 'id ASC');
    if (existing.isNotEmpty) {
      final id = (existing.first['id'] as num).toInt();
      await db.update(
        'posisi_diinginkan',
        {'nama_posisi': namaPosisi},
        where: 'id = ?',
        whereArgs: [id],
      );
    } else {
      await db.insert('posisi_diinginkan', {'nama_posisi': namaPosisi});
    }
  }

  Future<String?> getPosisiDiinginkan() async {
    final db = await database;

    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='posisi_diinginkan'",
    );
    if (tables.isEmpty) return null;

    final result = await db.query(
      'posisi_diinginkan',
      limit: 1,
      orderBy: 'id DESC',
    );
    if (result.isNotEmpty) {
      return result.first['nama_posisi'] as String?;
    }
    return null;
  }

  Future<void> deletePosisiDiinginkan() async {
    final db = await database;
    await db.delete('posisi_diinginkan');
  }

  // ===================== DATA DIRI =====================
  Future<void> insertOrUpdateDataDiri(Map<String, dynamic> data) async {
    final db = await database;

    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='data_diri'",
    );
    if (tables.isEmpty) {
      await db.execute('''
      CREATE TABLE data_diri (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        email TEXT,
        no_hp TEXT,
        gender TEXT,
        tanggal_lahir TEXT,
        lokasi TEXT,
        foto_path TEXT
      )
    ''');
    }

    final existing = await db.query('data_diri', limit: 1);
    if (existing.isNotEmpty) {
      final id = (existing.first['id'] as num).toInt();
      await db.update('data_diri', data, where: 'id = ?', whereArgs: [id]);
    } else {
      await db.insert('data_diri', data);
    }
  }

  Future<Map<String, dynamic>?> getDataDiri() async {
    final db = await database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='data_diri'",
    );
    if (tables.isEmpty) return null;

    final result = await db.query('data_diri', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // ===================== CLOSE DB =====================
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
