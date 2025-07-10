class Recomendacion {
  final String id;
  final String userId;
  final String pais;
  final String ciudad;
  final String? region;
  final String lugarRecomendado;
  final String tipo;
  final String? comentario;
  final String? imagenUrl;
  final int? puntuacion;
  final DateTime? fechaPublicacion;
  final String? ubicacionUrl;

  Recomendacion({
    required this.id,
    required this.userId,
    required this.pais,
    required this.ciudad,
    this.region,
    required this.lugarRecomendado,
    required this.tipo,
    this.comentario,
    this.imagenUrl,
    this.puntuacion,
    this.fechaPublicacion,
    this.ubicacionUrl,
  });

  factory Recomendacion.fromMap(Map<String, dynamic> map) {
    return Recomendacion(
      id: map['id'],
      userId: map['user_id'],
      pais: map['pais'],
      ciudad: map['ciudad'],
      region: map['region'],
      lugarRecomendado: map['lugar_recomendado'],
      tipo: map['tipo'],
      comentario: map['comentario'],
      imagenUrl: map['imagen_url'],
      puntuacion: map['puntuacion'],
      fechaPublicacion: map['fecha_publicacion'] != null
          ? DateTime.parse(map['fecha_publicacion'])
          : null,
      ubicacionUrl: map['ubicacion_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'pais': pais,
      'ciudad': ciudad,
      'region': region,
      'lugar_recomendado': lugarRecomendado,
      'tipo': tipo,
      'comentario': comentario,
      'imagen_url': imagenUrl,
      'puntuacion': puntuacion,
      'ubicacion_url': ubicacionUrl,
    };
  }
}
