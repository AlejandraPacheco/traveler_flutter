class Actividad {
  final int? id;
  final int viajeId; // FK que relaciona la actividad con un viaje
  final String tipo;
  final String? descripcion;
  final int? puntuacion;
  final String? fotoLocal; // ruta local de imagen (opcional)
  final String? ubicacionUrl; // URL de Google Maps (opcional)

  Actividad({
    this.id,
    required this.viajeId,
    required this.tipo,
    this.descripcion,
    this.puntuacion,
    this.fotoLocal,
    this.ubicacionUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'viaje_id': viajeId,
      'tipo': tipo,
      'descripcion': descripcion,
      'puntuacion': puntuacion,
      'foto_local': fotoLocal,
      'ubicacion_url': ubicacionUrl,
    };
  }

  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'],
      viajeId: map['viaje_id'],
      tipo: map['tipo'],
      descripcion: map['descripcion'],
      puntuacion: map['puntuacion'],
      fotoLocal: map['foto_local'],
      ubicacionUrl: map['ubicacion_url'],
    );
  }
}
