import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database_helper.dart';
import '../../model/viaje.dart';

final viajeListProvider = FutureProvider<List<Viaje>>((ref) async {
  final db = DatabaseHelper();
  return db.obtenerViajes();
});

final selectedViajeProvider = StateProvider<Viaje?>((ref) => null);
