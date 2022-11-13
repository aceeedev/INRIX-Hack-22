import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:inrix_hack_22/models/proximity_reminder.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('proximity_reminder.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const textType = 'TEXT NOT NULL';
    const floatType = 'FLOAT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableProximity (
  ${ProximityFields.id} $idType,
  ${ProximityFields.longitude} $floatType,
  ${ProximityFields.latitude} $floatType,
  ${ProximityFields.address} $textType,
  ${ProximityFields.proximity} $integerType,
  ${ProximityFields.phoneNumber} $textType,
  ${ProximityFields.phoneNumberName} $textType
  )
''');
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  Future<ProximityReminder> createProximityReminder(
      ProximityReminder proximityReminder) async {
    final db = await instance.database;

    final id = await db.insert(tableProximity, proximityReminder.toJson());
    return proximityReminder.copy(id: id);
  }

  Future<ProximityReminder> readProximityReminder(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableProximity,
      columns: ProximityFields.values,
      where: '${ProximityFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ProximityReminder.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  /// Returns a list of all the ProximityReminders in the database
  Future<List<ProximityReminder>> readAllProximityReminders() async {
    final db = await instance.database;

    String orderBy = '${ProximityFields.id} ASC';
    final result = await db.query(tableProximity, orderBy: orderBy);

    return result.map((json) => ProximityReminder.fromJson(json)).toList();
  }

  Future<int> updateProximityReminder(
      ProximityReminder proximityReminder) async {
    final db = await instance.database;

    return db.update(
      tableProximity,
      proximityReminder.toJson(),
      where: '${ProximityFields.id} = ?',
      whereArgs: [proximityReminder.id],
    );
  }

  Future<int> deleteProximityReminder(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableProximity,
      where: '${ProximityFields.id} = ?',
      whereArgs: [id],
    );
  }
}
