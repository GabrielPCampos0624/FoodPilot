import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/models/app_data.dart';

class MealsScreen extends StatelessWidget {
  final List<MealEntry> meals;
  final void Function(MealEntry meal) onAddMeal;
  final void Function(int index) onRemoveMeal;
  final VoidCallback onClearMeals;

  const MealsScreen({
    super.key,
    required this.meals,
    required this.onAddMeal,
    required this.onRemoveMeal,
    required this.onClearMeals,
  });

  static const List<FoodOption> foodOptions = [
    FoodOption(name: 'Pão francês', calories: 135, unit: 'unidade'),
    FoodOption(name: 'Pão com ovo', calories: 150, unit: 'unidade'),
    FoodOption(name: 'Ovo cozido', calories: 78, unit: 'unidade'),
    FoodOption(name: 'Banana', calories: 90, unit: 'unidade'),
    FoodOption(name: 'Maçã', calories: 70, unit: 'unidade'),
    FoodOption(name: 'Aveia', calories: 120, unit: '30g'),
    FoodOption(name: 'Iogurte natural', calories: 95, unit: 'unidade'),
    FoodOption(name: 'Tapioca', calories: 140, unit: '100g'),
    FoodOption(name: 'Arroz branco cozido', calories: 130, unit: '100g'),
    FoodOption(name: 'Arroz integral', calories: 124, unit: '100g'),
    FoodOption(name: 'Feijão cozido', calories: 90, unit: '100g'),
    FoodOption(name: 'Frango grelhado', calories: 165, unit: '100g'),
    FoodOption(name: 'Carne bovina magra', calories: 220, unit: '100g'),
    FoodOption(name: 'Peixe grelhado', calories: 180, unit: '100g'),
    FoodOption(name: 'Macarrão cozido', calories: 157, unit: '100g'),
    FoodOption(name: 'Batata-doce cozida', calories: 86, unit: '100g'),
    FoodOption(name: 'Batata inglesa cozida', calories: 77, unit: '100g'),
    FoodOption(name: 'Salada verde', calories: 20, unit: '100g'),
    FoodOption(name: 'Brócolis cozido', calories: 35, unit: '100g'),
    FoodOption(name: 'Queijo minas', calories: 85, unit: '30g'),
    FoodOption(name: 'Castanhas', calories: 170, unit: '30g'),
    FoodOption(name: 'Amendoim', calories: 180, unit: '30g'),
    FoodOption(name: 'Barra de cereal', calories: 95, unit: 'unidade'),
    FoodOption(name: 'Whey protein', calories: 120, unit: 'dose'),
    FoodOption(name: 'Leite desnatado', calories: 70, unit: '200ml'),
    FoodOption(name: 'Suco natural', calories: 110, unit: '300ml'),
    FoodOption(name: 'Pizza muçarela', calories: 285, unit: 'fatia'),
    FoodOption(name: 'Hambúrguer artesanal', calories: 450, unit: 'unidade'),
    FoodOption(name: 'Chocolate', calories: 150, unit: '30g'),
    FoodOption(name: 'Sorvete', calories: 210, unit: '100g'),
  ];

  IconData getMealIcon(String mealType) {
    switch (mealType) {
      case 'Café da manhã':
        return Icons.coffee;
      case 'Almoço':
        return Icons.lunch_dining;
      case 'Lanche':
        return Icons.cookie;
      case 'Jantar':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  void openFoodListDialog(
    BuildContext context,
    void Function(FoodOption food) onSelected,
  ) {
    String search = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredFoods = foodOptions.where((food) {
              return food.name.toLowerCase().contains(search.toLowerCase());
            }).toList();

            return AlertDialog(
              title: const Text('Selecionar alimento'),
              content: SizedBox(
                width: 520,
                height: 480,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Buscar alimento',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          search = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredFoods.length,
                        itemBuilder: (context, index) {
                          final food = filteredFoods[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.fastfood_outlined),
                              title: Text(food.name),
                              subtitle: Text(
                                '${food.calories.toStringAsFixed(0)} kcal por ${food.unit}',
                              ),
                              trailing: const Icon(Icons.check_circle_outline),
                              onTap: () {
                                onSelected(food);
                                Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void openAddMealModal(BuildContext context) {
    final quantityController = TextEditingController();
    final foodSearchController = TextEditingController();

    String selectedMeal = 'Café da manhã';
    FoodOption? selectedFood;
    String searchText = '';
    String? foodError;
    String? quantityError;

    final List<MealEntry> temporaryItems = [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Montar refeição'),
          content: StatefulBuilder(
            builder: (context, setModalState) {
              final suggestions = searchText.isEmpty
                  ? <FoodOption>[]
                  : foodOptions.where((food) {
                      return food.name.toLowerCase().contains(
                        searchText.toLowerCase(),
                      );
                    }).toList();

              void selectFood(FoodOption food) {
                setModalState(() {
                  selectedFood = food;
                  foodSearchController.text = food.name;
                  searchText = food.name;
                  foodError = null;
                });
              }

              void clearSelectedFood() {
                setModalState(() {
                  selectedFood = null;
                  foodSearchController.clear();
                  searchText = '';
                });
              }

              void addTemporaryItem() {
                final quantity = double.tryParse(
                  quantityController.text.trim().replaceAll(',', '.'),
                );

                setModalState(() {
                  foodError = null;
                  quantityError = null;
                });

                if (selectedFood == null) {
                  setModalState(() {
                    foodError = 'Selecione um alimento';
                  });
                  return;
                }

                if (quantity == null || quantity <= 0) {
                  setModalState(() {
                    quantityError = 'Informe uma quantidade válida';
                  });
                  return;
                }

                final totalCalories = selectedFood!.calories * quantity;

                setModalState(() {
                  temporaryItems.add(
                    MealEntry(
                      mealType: selectedMeal,
                      foodName: selectedFood!.name,
                      quantity: quantity,
                      unit: selectedFood!.unit,
                      caloriesPerUnit: selectedFood!.calories,
                      totalCalories: totalCalories,
                    ),
                  );

                  quantityController.clear();
                  selectedFood = null;
                  foodSearchController.clear();
                  searchText = '';
                });
              }

              void saveMeal() {
                if (temporaryItems.isEmpty) {
                  setModalState(() {
                    foodError = 'Adicione pelo menos um alimento';
                  });
                  return;
                }

                for (final item in temporaryItems) {
                  onAddMeal(item);
                }

                Navigator.pop(context);
              }

              final temporaryCalories = temporaryItems.fold<double>(
                0,
                (total, item) => total + item.totalCalories,
              );

              return SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedMeal,
                        decoration: const InputDecoration(
                          labelText: 'Refeição',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Café da manhã',
                            child: Text('Café da manhã'),
                          ),
                          DropdownMenuItem(
                            value: 'Almoço',
                            child: Text('Almoço'),
                          ),
                          DropdownMenuItem(
                            value: 'Lanche',
                            child: Text('Lanche'),
                          ),
                          DropdownMenuItem(
                            value: 'Jantar',
                            child: Text('Jantar'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setModalState(() {
                            selectedMeal = value;
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: foodSearchController,
                        decoration: InputDecoration(
                          labelText: 'Alimento',
                          hintText: 'Digite para buscar',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (selectedFood != null)
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  tooltip: 'Limpar alimento',
                                  onPressed: clearSelectedFood,
                                ),
                              IconButton(
                                icon: const Icon(Icons.manage_search),
                                tooltip: 'Ver todos os alimentos',
                                onPressed: () {
                                  openFoodListDialog(context, (food) {
                                    selectFood(food);
                                  });
                                },
                              ),
                            ],
                          ),
                          errorText: foodError,
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            searchText = value;
                            selectedFood = null;
                          });
                        },
                      ),

                      if (suggestions.isNotEmpty && selectedFood == null) ...[
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 160),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              final food = suggestions[index];

                              return ListTile(
                                dense: true,
                                title: Text(food.name),
                                subtitle: Text(
                                  '${food.calories.toStringAsFixed(0)} kcal por ${food.unit}',
                                ),
                                onTap: () => selectFood(food),
                              );
                            },
                          ),
                        ),
                      ],

                      if (selectedFood != null) ...[
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: Text(selectedFood!.name),
                            subtitle: Text(
                              '${selectedFood!.calories.toStringAsFixed(0)} kcal por ${selectedFood!.unit}',
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Quantidade consumida',
                          hintText: selectedFood?.unit == 'unidade'
                              ? 'Ex: 2'
                              : 'Ex: 1.5',
                          helperText: selectedFood == null
                              ? 'Selecione um alimento primeiro'
                              : 'Base: ${selectedFood!.calories.toStringAsFixed(0)} kcal por ${selectedFood!.unit}',
                          errorText: quantityError,
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: addTemporaryItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar item à refeição'),
                        ),
                      ),

                      if (temporaryItems.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Itens adicionados (${temporaryItems.length})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...temporaryItems.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final item = entry.value;

                                  return ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(item.foodName),
                                    subtitle: Text(
                                      '${item.quantity.toStringAsFixed(1)} ${item.unit} • '
                                      '${item.totalCalories.toStringAsFixed(0)} kcal',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () {
                                        setModalState(() {
                                          temporaryItems.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                }),
                                const Divider(),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Total: ${temporaryCalories.toStringAsFixed(0)} kcal',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: saveMeal,
                          child: const Text('Salvar refeição'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void confirmRemoveMeal(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir alimento'),
          content: const Text('Deseja excluir este alimento do cardápio?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                onRemoveMeal(index);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void confirmClearMeals(BuildContext context) {
    if (meals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma refeição para remover.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recomeçar dia'),
          content: const Text(
            'Deseja remover todas as refeições e zerar as calorias consumidas?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                onClearMeals();
                Navigator.pop(context);
              },
              child: const Text('Limpar tudo'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealTypes = ['Café da manhã', 'Almoço', 'Lanche', 'Jantar'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refeições'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 52),
            child: IconButton(
              onPressed: () => confirmClearMeals(context),
              icon: const Icon(Icons.refresh),
              tooltip: 'Recomeçar dia',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final mealType in mealTypes)
            Card(
              margin: const EdgeInsets.only(bottom: 14),
              child: ExpansionTile(
                leading: Icon(getMealIcon(mealType)),
                title: Text(mealType),
                children: [
                  ...meals
                      .asMap()
                      .entries
                      .where((entry) => entry.value.mealType == mealType)
                      .map((entry) {
                        final index = entry.key;
                        final meal = entry.value;

                        return ListTile(
                          title: Text(meal.foodName),
                          subtitle: Text(
                            '${meal.quantity.toStringAsFixed(1)} ${meal.unit} • '
                            '${meal.caloriesPerUnit.toStringAsFixed(0)} kcal/${meal.unit}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${meal.totalCalories.toStringAsFixed(0)} kcal',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () =>
                                    confirmRemoveMeal(context, index),
                              ),
                            ],
                          ),
                        );
                      }),
                  if (!meals.any((meal) => meal.mealType == mealType))
                    const ListTile(title: Text('Nenhum alimento registrado')),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAddMealModal(context),
        icon: const Icon(Icons.add),
        label: const Text('Adicionar refeição'),
      ),
    );
  }
}
