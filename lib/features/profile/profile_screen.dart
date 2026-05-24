import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/models/app_data.dart';
import '../../shared/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final void Function(UserProfile profile) onSaveProfile;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onSaveProfile,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController ageController;
  late final TextEditingController weightController;
  late final TextEditingController heightController;

  late String selectedGender;
  late String selectedGoal;
  late String selectedActivity;

  final Map<String, String> activityDescriptions = {
    'Sedentário':
        'Trabalhos domésticos leves, caminhadas curtas e atividades comuns do cotidiano.',
    'Pouca':
        'Caminhadas leves ou atividades físicas ocasionais durante a semana.',
    'Moderada':
        'Ginástica aeróbica, corrida, natação, tênis ou atividades físicas regulares.',
    'Intensa':
        'Ciclismo, corrida, pular corda, tênis ou exercícios de intensidade elevada.',
    'Muito intensa':
        'Treinos intensos, esportes frequentes ou rotina física altamente ativa.',
  };

  final Map<String, double> activityFactors = {
    'Sedentário': 1.2,
    'Pouca': 1.375,
    'Moderada': 1.55,
    'Intensa': 1.725,
    'Muito intensa': 1.9,
  };

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.profile.name);
    ageController = TextEditingController(text: widget.profile.age);
    weightController = TextEditingController(text: widget.profile.weight);
    heightController = TextEditingController(text: widget.profile.height);

    selectedGender = widget.profile.gender.isEmpty
        ? 'Masculino'
        : widget.profile.gender;

    selectedGoal = widget.profile.goal.isEmpty
        ? 'Manter peso'
        : widget.profile.goal;

    selectedActivity = widget.profile.activityLevel.isEmpty
        ? 'Sedentário'
        : widget.profile.activityLevel;
  }

  double calculateCalorieGoal({
    required int age,
    required double weight,
    required double height,
  }) {
    double basalMetabolicRate;

    if (selectedGender == 'Masculino') {
      basalMetabolicRate = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      basalMetabolicRate = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    final activityFactor = activityFactors[selectedActivity] ?? 1.2;

    double totalCalories = basalMetabolicRate * activityFactor;

    if (selectedGoal == 'Perder peso') {
      totalCalories -= 300;
    } else if (selectedGoal == 'Ganhar massa') {
      totalCalories += 300;
    }

    return totalCalories;
  }

  void saveProfile() {
    final age = int.tryParse(ageController.text.trim());
    final weight = double.tryParse(
      weightController.text.trim().replaceAll(',', '.'),
    );
    final height = double.tryParse(
      heightController.text.trim().replaceAll(',', '.'),
    );

    if (nameController.text.trim().isEmpty ||
        age == null ||
        weight == null ||
        height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha corretamente todos os dados do perfil.'),
        ),
      );
      return;
    }

    final calorieGoal = calculateCalorieGoal(
      age: age,
      weight: weight,
      height: height,
    );

    widget.onSaveProfile(
      UserProfile(
        name: nameController.text.trim(),
        age: ageController.text.trim(),
        weight: weightController.text.trim(),
        height: heightController.text.trim(),
        gender: selectedGender,
        goal: selectedGoal,
        activityLevel: selectedActivity,
        calorieGoal: calorieGoal,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Perfil salvo! Meta calórica: ${calorieGoal.toStringAsFixed(0)} kcal/dia',
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final description = activityDescriptions[selectedActivity] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Informações Nutricionais')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Idade',
                    prefixIcon: Icon(Icons.calendar_month),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Peso em kg',
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Altura em cm',
                    prefixIcon: Icon(Icons.height),
                  ),
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Masculino',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'Feminino',
                      child: Text('Feminino'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedGender = value);
                  },
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: selectedGoal,
                  decoration: const InputDecoration(
                    labelText: 'Objetivo',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Perder peso',
                      child: Text('Perder peso'),
                    ),
                    DropdownMenuItem(
                      value: 'Manter peso',
                      child: Text('Manter peso'),
                    ),
                    DropdownMenuItem(
                      value: 'Ganhar massa',
                      child: Text('Ganhar massa'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedGoal = value);
                  },
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<String>(
                  value: selectedActivity,
                  decoration: const InputDecoration(
                    labelText: 'Nível de atividade',
                    prefixIcon: Icon(Icons.directions_run),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Sedentário',
                      child: Text('Sedentário'),
                    ),
                    DropdownMenuItem(value: 'Pouca', child: Text('Pouca')),
                    DropdownMenuItem(
                      value: 'Moderada',
                      child: Text('Moderada'),
                    ),
                    DropdownMenuItem(value: 'Intensa', child: Text('Intensa')),
                    DropdownMenuItem(
                      value: 'Muito intensa',
                      child: Text('Muito intensa'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedActivity = value);
                  },
                ),

                const SizedBox(height: 10),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 10),
                        Expanded(child: Text(description)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Salvar informações e calcular meta',
                    onPressed: saveProfile,
                  ),
                ),

                if (widget.profile.calorieGoal != null) ...[
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Meta calórica atual: ${widget.profile.calorieGoal!.toStringAsFixed(0)} kcal/dia',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
