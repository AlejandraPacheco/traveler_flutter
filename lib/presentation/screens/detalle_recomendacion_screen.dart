import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/recomendacion.dart';

class DetalleRecomendacionScreen extends StatefulWidget {
  final Recomendacion recomendacion;

  const DetalleRecomendacionScreen({super.key, required this.recomendacion});

  @override
  State<DetalleRecomendacionScreen> createState() =>
      _DetalleRecomendacionScreenState();
}

class _DetalleRecomendacionScreenState
    extends State<DetalleRecomendacionScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    if (widget.recomendacion.ubicacionUrl != null &&
        widget.recomendacion.ubicacionUrl!.trim().isNotEmpty) {
      final htmlContent =
          '''
        <!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>body, html { margin: 0; padding: 0; }</style>
          </head>
          <body>
            <iframe 
              src="${widget.recomendacion.ubicacionUrl}" 
              width="100%" 
              height="100%" 
              style="border:0;" 
              allowfullscreen 
              loading="lazy" 
              referrerpolicy="no-referrer-when-downgrade">
            </iframe>
          </body>
        </html>
      ''';

      _controller.loadHtmlString(htmlContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recomendacion = widget.recomendacion;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Recomendación')),
      body: Stack(
        children: [
          // Fondo degradado que ocupa toda la pantalla
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Contenido principal con padding
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recomendacion.lugarRecomendado,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_city, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              '${recomendacion.ciudad}, ${recomendacion.pais}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (recomendacion.tipo.isNotEmpty)
                          Row(
                            children: [
                              const Icon(Icons.category, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                'Tipo: ${recomendacion.tipo}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        if (recomendacion.comentario != null &&
                            recomendacion.comentario!.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.comment, color: Colors.black45),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  recomendacion.comentario!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 12),
                        if (recomendacion.puntuacion != null)
                          Chip(
                            label: Text('⭐ ${recomendacion.puntuacion}'),
                            backgroundColor: Colors.amber.shade100,
                          ),
                        const SizedBox(height: 12),
                        if (recomendacion.fechaPublicacion != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Publicada el: ${DateFormat('dd/MM/yyyy').format(recomendacion.fechaPublicacion!)}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                        if (recomendacion.ubicacionUrl != null &&
                            recomendacion.ubicacionUrl!.trim().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Ubicación en el mapa',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 250,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: WebViewWidget(controller: _controller),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
