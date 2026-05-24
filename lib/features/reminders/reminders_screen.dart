import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/models/app_data.dart';

class RemindersScreen extends StatelessWidget {
  final List<HealthAlert> alerts;
  final void Function(HealthAlert alert) onAddAlert;
  final void Function(int index) onRemoveAlert;

  const RemindersScreen({
    super.key,
    required this.alerts,
    required this.onAddAlert,
    required this.onRemoveAlert,
  });

  IconData getAlertIcon(String type) {
    switch (type) {
      case 'Água':
        return Icons.water_drop;
      case 'Medicamento':
        return Icons.medication;
      case 'Refeição':
        return Icons.restaurant;
      case 'Exercício':
        return Icons.directions_run;
      default:
        return Icons.notifications;
    }
  }

  String normalizeTime(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) return 'Sem horário';

    if (digits.length < 3) {
      return digits.padLeft(2, '0') + ':00';
    }

    final padded = digits.padRight(4, '0').substring(0, 4);

    int hours = int.parse(padded.substring(0, 2));
    int minutes = int.parse(padded.substring(2, 4));

    if (minutes >= 60) {
      hours += minutes ~/ 60;
      minutes = minutes % 60;
    }

    hours = hours % 24;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  void openAddAlertModal(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final timeController = TextEditingController();
    final customFrequencyController = TextEditingController();

    String selectedType = 'Água';
    String selectedFrequency = 'Diário';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo alerta'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de alerta',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Água', child: Text('Água')),
                        DropdownMenuItem(value: 'Refeição', child: Text('Refeição')),
                        DropdownMenuItem(value: 'Exercício', child: Text('Exercício')),
                        DropdownMenuItem(value: 'Outro', child: Text('Outro')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setModalState(() {
                          selectedType = value;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        labelText: 'Mensagem',
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        SimpleTimeInputFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Horário',
                        hintText: 'Ex: 14:30',
                        prefixIcon: Icon(Icons.schedule),
                      ),
                    ),

                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedFrequency,
                      decoration: const InputDecoration(
                        labelText: 'Frequência',
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Diário', child: Text('Diário')),
                        DropdownMenuItem(value: 'Dias úteis', child: Text('Dias úteis')),
                        DropdownMenuItem(value: 'Semanal', child: Text('Semanal')),
                        DropdownMenuItem(value: 'Personalizado', child: Text('Personalizado')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setModalState(() {
                          selectedFrequency = value;
                        });
                      },
                    ),

                    if (selectedFrequency == 'Personalizado') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: customFrequencyController,
                        decoration: const InputDecoration(
                          labelText: 'Personalizar frequência',
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;

                final frequency = selectedFrequency == 'Personalizado'
                    ? customFrequencyController.text.trim()
                    : selectedFrequency;

                onAddAlert(
                  HealthAlert(
                    title: titleController.text.trim(),
                    message: messageController.text.trim(),
                    type:
                        '$selectedType • ${normalizeTime(timeController.text)} • ${frequency.isEmpty ? 'Personalizado' : frequency}',
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void confirmRemoveAlert(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir alerta'),
          content: const Text('Tem certeza que deseja excluir este alerta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                onRemoveAlert(index);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
      ),
      body: alerts.isEmpty
          ? const Center(child: Text('Nenhum alerta cadastrado'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final alertType = alert.type.split(' • ').first;

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: Icon(getAlertIcon(alertType)),
                    title: Text(alert.title),
                    subtitle: Text(
                      alert.message.isEmpty
                          ? alert.type
                          : '${alert.message}\n${alert.type}',
                    ),
                    isThreeLine: alert.message.isNotEmpty,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => confirmRemoveAlert(context, index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAddAlertModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo alerta'),
      ),
    );
  }
}

class SimpleTimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length > 4) {
      digits = digits.substring(0, 4);
    }

    String formatted = digits;

    if (digits.length > 2) {
      formatted = '${digits.substring(0, 2)}:${digits.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
