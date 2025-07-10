import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//import 'dart:io';

import '../model/viaje.dart';
import '../model/actividad.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'bitacora_viajera.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE viajes_personales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        pais TEXT NOT NULL,
        ciudad TEXT NOT NULL,
        region TEXT,
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT NOT NULL,
        transporte TEXT,
        alojamiento TEXT,
        notas_personales TEXT,
        clima TEXT,
        sincronizado INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE actividades_realizadas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        viaje_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        descripcion TEXT,
        puntuacion INTEGER,
        foto_local TEXT,
        ubicacion_url TEXT,
        FOREIGN KEY (viaje_id) REFERENCES viajes_personales(id) ON DELETE CASCADE
      )
    ''');
  }

  // VIAJES

  Future<int> insertarViaje(Viaje viaje) async {
    final db = await database;
    return await db.insert('viajes_personales', viaje.toMap());
  }

  Future<List<Viaje>> obtenerViajes() async {
    final db = await database;
    final maps = await db.query('viajes_personales');

    return maps.map((map) => Viaje.fromMap(map)).toList();
  }

  Future<List<Viaje>> obtenerViajesPorUsuario(String userId) async {
    final db = await database;
    final maps = await db.query(
      'viajes_personales',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return maps.map((map) => Viaje.fromMap(map)).toList();
  }

  Future<int> actualizarViaje(Viaje viaje) async {
    final db = await database;
    return await db.update(
      'viajes_personales',
      viaje.toMap(),
      where: 'id = ?',
      whereArgs: [viaje.id],
    );
  }

  // ACTIVIDADES

  Future<int> insertarActividad(Actividad actividad) async {
    final db = await database;
    return await db.insert('actividades_realizadas', actividad.toMap());
  }

  Future<List<Actividad>> obtenerActividadesPorViaje(int viajeId) async {
    final db = await database;
    final maps = await db.query(
      'actividades_realizadas',
      where: 'viaje_id = ?',
      whereArgs: [viajeId],
    );

    return maps.map((map) => Actividad.fromMap(map)).toList();
  }

  Future<void> eliminarTodasLasActividades() async {
    final db = await database;
    await db.delete('actividades_realizadas');
  }

  Future<void> eliminarTodosLosViajes() async {
    final db = await database;
    await db.delete('viajes_personales');
  }
}
