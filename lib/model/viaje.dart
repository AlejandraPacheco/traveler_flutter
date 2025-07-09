class Viaje {
  final int? id;
  final String pais;
  final String ciudad;
  final String? region;
  final String fechaInicio;
  final String fechaFin;
  final String? transporte;
  final String? alojamiento;
  final String? notasPersonales;
  final String? clima;
  final bool sincronizado;

  Viaje({
    this.id,
    required this.pais,
    required this.ciudad,
    this.region,
    required this.fechaInicio,
    required this.fechaFin,
    this.transporte,
    this.alojamiento,
    this.notasPersonales,
    this.clima,
    this.sincronizado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pais': pais,
      'ciudad': ciudad,
      'region': region,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'transporte': transporte,
      'alojamiento': alojamiento,
      'notas_personales': notasPersonales,
      'clima': clima,
      'sincronizado': sincronizado ? 1 : 0,
    };
  }

  factory Viaje.fromMap(Map<String, dynamic> map) {
    return Viaje(
      id: map['id'],
      pais: map['pais'],
      ciudad: map['ciudad'],
      region: map['region'],
      fechaInicio: map['fecha_inicio'],
      fechaFin: map['fecha_fin'],
      transporte: map['transporte'],
      alojamiento: map['alojamiento'],
      notasPersonales: map['notas_personales'],
      clima: map['clima'],
      sincronizado: (map['sincronizado'] ?? 0) == 1,
    );
  }
}
