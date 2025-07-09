import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database_helper.dart';
import '../../model/actividad.dart';

final actividadListProvider = FutureProvider.family<List<Actividad>, int>((
  ref,
  viajeId,
) async {
  final db = DatabaseHelper();
  return db.obtenerActividadesPorViaje(viajeId);
});
