import 'package:flutter/material.dart';
import '../../model/recomendacion.dart';
import 'package:intl/intl.dart';

class DetalleRecomendacionScreen extends StatelessWidget {
  final Recomendacion recomendacion;

  const DetalleRecomendacionScreen({super.key, required this.recomendacion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Recomendación')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              recomendacion.lugarRecomendado,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${recomendacion.ciudad}, ${recomendacion.pais}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (recomendacion.tipo.isNotEmpty)
              Text(
                'Tipo: ${recomendacion.tipo}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 12),
            if (recomendacion.comentario != null &&
                recomendacion.comentario!.isNotEmpty)
              Text(
                recomendacion.comentario!,
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 12),
            if (recomendacion.puntuacion != null)
              Chip(
                label: Text('⭐ ${recomendacion.puntuacion}'),
                backgroundColor: Colors.amber.shade100,
              ),
            const SizedBox(height: 12),
            if (recomendacion.fechaPublicacion != null)
              Text(
                'Publicada el: ${DateFormat('dd/MM/yyyy').format(recomendacion.fechaPublicacion!)}',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
