class User {
  final int? id;
  final String name;
  final String email;
  final String pwd;
  final double weight;
  final double height;
  final double bmi;
  final String bmiType;
  final double targetWeight;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.pwd,
    required this.weight,
    required this.height,
  }) : bmi = calculateBmi(weight, height),
       bmiType = determineBmiType(calculateBmi(weight, height)),
       targetWeight = calculateTargetWeight(weight, height);

  static double calculateBmi(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  static String determineBmiType(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  static double calculateTargetWeight(double weight, double height) {
    double bmi = calculateBmi(weight, height);
    double minNormalWeight = 18.5 * ((height / 100) * (height / 100));
    double maxNormalWeight = 24.9 * ((height / 100) * (height / 100));

    if (bmi < 18.5) {
      return minNormalWeight;
    } else if (bmi > 24.9) {
      return maxNormalWeight;
    } else {
      return weight; // Already in normal range
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'pwd': pwd,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'bmi_type': bmiType,
      'target_weight': targetWeight,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      pwd: map['pwd'],
      weight: map['weight'],
      height: map['height'],
    );
  }
}
