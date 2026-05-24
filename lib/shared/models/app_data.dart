class FoodOption {
  final String name;
  final double calories;
  final String unit;

  const FoodOption({
    required this.name,
    required this.calories,
    required this.unit,
  });
}

class MealEntry {
  final String mealType;
  final String foodName;
  final double quantity;
  final String unit;
  final double caloriesPerUnit;
  final double totalCalories;

  MealEntry({
    required this.mealType,
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.caloriesPerUnit,
    required this.totalCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      'mealType': mealType,
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'caloriesPerUnit': caloriesPerUnit,
      'totalCalories': totalCalories,
    };
  }

  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      mealType: json['mealType'] ?? '',
      foodName: json['foodName'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] ?? 'unidade',
      caloriesPerUnit: (json['caloriesPerUnit'] as num?)?.toDouble() ?? 0,
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0,
    );
  }
}

class HealthAlert {
  final String title;
  final String message;
  final String type;

  HealthAlert({
    required this.title,
    required this.message,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'type': type,
    };
  }

  factory HealthAlert.fromJson(Map<String, dynamic> json) {
    return HealthAlert(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class UserProfile {
  String name;
  String age;
  String weight;
  String height;
  String gender;
  String goal;
  String activityLevel;
  double? calorieGoal;

  UserProfile({
    this.name = '',
    this.age = '',
    this.weight = '',
    this.height = '',
    this.gender = '',
    this.goal = '',
    this.activityLevel = '',
    this.calorieGoal,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
      'goal': goal,
      'activityLevel': activityLevel,
      'calorieGoal': calorieGoal,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      weight: json['weight'] ?? '',
      height: json['height'] ?? '',
      gender: json['gender'] ?? '',
      goal: json['goal'] ?? '',
      activityLevel: json['activityLevel'] ?? '',
      calorieGoal: json['calorieGoal'] == null
          ? null
          : (json['calorieGoal'] as num).toDouble(),
    );
  }
}