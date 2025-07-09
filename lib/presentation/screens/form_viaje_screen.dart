import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traveler/data/database_helper.dart';
import 'package:traveler/model/viaje.dart';

class FormularioViajeScreen extends StatefulWidget {
  final Viaje? viaje; // Si es null, se crea uno nuevo

  const FormularioViajeScreen({super.key, this.viaje});

  @override
  State<FormularioViajeScreen> createState() => _FormularioViajeScreenState();
}

class _FormularioViajeScreenState extends State<FormularioViajeScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  late TextEditingController _paisCtrl;
  late TextEditingController _ciudadCtrl;
  late TextEditingController _regionCtrl;
  late TextEditingController _transporteCtrl;
  late TextEditingController _alojamientoCtrl;
  late TextEditingController _notasCtrl;
  late TextEditingController _climaCtrl;

  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void initState() {
    super.initState();

    // Si hay viaje, precarga los campos, si no, vacíos
    _paisCtrl = TextEditingController(text: widget.viaje?.pais ?? '');
    _ciudadCtrl = TextEditingController(text: widget.viaje?.ciudad ?? '');
    _regionCtrl = TextEditingController(text: widget.viaje?.region ?? '');
    _transporteCtrl = TextEditingController(
      text: widget.viaje?.transporte ?? '',
    );
    _alojamientoCtrl = TextEditingController(
      text: widget.viaje?.alojamiento ?? '',
    );
    _notasCtrl = TextEditingController(
      text: widget.viaje?.notasPersonales ?? '',
    );
    _climaCtrl = TextEditingController(text: widget.viaje?.clima ?? '');

    _fechaInicio = widget.viaje != null
        ? DateTime.tryParse(widget.viaje!.fechaInicio)
        : null;

    _fechaFin = widget.viaje != null
        ? DateTime.tryParse(widget.viaje!.fechaFin)
        : null;
  }

  Future<void> _seleccionarFecha({
    required BuildContext context,
    required bool esInicio,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: esInicio
          ? (_fechaInicio ?? DateTime.now())
          : (_fechaFin ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  Future<void> _guardarViaje() async {
    if (_formKey.currentState!.validate() &&
        _fechaInicio != null &&
        _fechaFin != null) {
      final viajeGuardado = Viaje(
        id: widget.viaje?.id,
        pais: _paisCtrl.text,
        ciudad: _ciudadCtrl.text,
        region: _regionCtrl.text.isEmpty ? null : _regionCtrl.text,
        fechaInicio: DateFormat('yyyy-MM-dd').format(_fechaInicio!),
        fechaFin: DateFormat('yyyy-MM-dd').format(_fechaFin!),
        transporte: _transporteCtrl.text.isEmpty ? null : _transporteCtrl.text,
        alojamiento: _alojamientoCtrl.text.isEmpty
            ? null
            : _alojamientoCtrl.text,
        notasPersonales: _notasCtrl.text.isEmpty ? null : _notasCtrl.text,
        clima: _climaCtrl.text.isEmpty ? null : _climaCtrl.text,
        sincronizado: widget.viaje?.sincronizado ?? false,
      );

      if (widget.viaje == null) {
        // Nuevo viaje
        await dbHelper.insertarViaje(viajeGuardado);
      } else {
        // Actualizar viaje
        await dbHelper.actualizarViaje(viajeGuardado);
      }

      if (context.mounted) {
        Navigator.pop(context, true); // Regresa true para refrescar listas
      }
    }
  }

  @override
  void dispose() {
    _paisCtrl.dispose();
    _ciudadCtrl.dispose();
    _regionCtrl.dispose();
    _transporteCtrl.dispose();
    _alojamientoCtrl.dispose();
    _notasCtrl.dispose();
    _climaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.viaje != null;
    return Scaffold(
      appBar: AppBar(title: Text(esEdicion ? 'Editar Viaje' : 'Nuevo Viaje')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _paisCtrl,
                decoration: const InputDecoration(labelText: 'País'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _ciudadCtrl,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              TextFormField(
                controller: _regionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Región (opcional)',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaInicio == null
                          ? 'Inicio: (no seleccionado)'
                          : 'Inicio: ${DateFormat('dd/MM/yyyy').format(_fechaInicio!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _seleccionarFecha(context: context, esInicio: true),
                    child: const Text('Seleccionar'),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaFin == null
                          ? 'Fin: (no seleccionado)'
                          : 'Fin: ${DateFormat('dd/MM/yyyy').format(_fechaFin!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        _seleccionarFecha(context: context, esInicio: false),
                    child: const Text('Seleccionar'),
                  ),
                ],
              ),
              TextFormField(
                controller: _transporteCtrl,
                decoration: const InputDecoration(labelText: 'Transporte'),
              ),
              TextFormField(
                controller: _alojamientoCtrl,
                decoration: const InputDecoration(labelText: 'Alojamiento'),
              ),
              TextFormField(
                controller: _notasCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notas personales',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _climaCtrl,
                decoration: const InputDecoration(labelText: 'Clima'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarViaje,
                child: Text(esEdicion ? 'Actualizar viaje' : 'Guardar viaje'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
