import '../../data/database_helper.dart';
import '../../model/viaje.dart';
import '../../model/actividad.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatabaseService {
  final DatabaseHelper _db = DatabaseHelper();

  Future<void> insertarViaje(Viaje viaje) => _db.insertarViaje(viaje);
  Future<void> actualizarViaje(Viaje viaje) => _db.actualizarViaje(viaje);

  Future<void> insertarActividad(Actividad actividad) =>
      _db.insertarActividad(actividad);
  Future<List<Actividad>> obtenerActividades(int viajeId) =>
      _db.obtenerActividadesPorViaje(viajeId);
}

final databaseServiceProvider = Provider<DatabaseService>(
  (ref) => DatabaseService(),
);
