import 'package:flutter/material.dart';

class BMICalculator {
  static double calculateBMI({required double weightKg, required double heightCm}) {
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  static String categoryForBMI(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obesity';
  }

  /// Returns a more detailed, personalized advice text.
  /// Optional parameters `age` and `gender` are used to tailor recommendations.
  static String detailedAdvice({
    required double bmi,
    int? age,
    String? gender,
  }) {
    final category = categoryForBMI(bmi);
    final buffer = StringBuffer();

    buffer.writeln('You are classified as: $category (BMI ${bmi.toStringAsFixed(1)}).');

    // Short explanation of category
    switch (category) {
      case 'Underweight':
        buffer.writeln('Explanation: Your weight is below the typical healthy range for most adults. This can be due to high metabolism, low calorie intake, or medical conditions.');
        break;
      case 'Normal':
        buffer.writeln('Explanation: Your weight falls within the commonly accepted healthy range. This is associated with lower risk for many chronic conditions.');
        break;
      case 'Overweight':
        buffer.writeln('Explanation: Your weight is above the healthy range. Excess body fat may increase the risk of heart disease, diabetes, and joint problems.');
        break;
      case 'Obesity':
        buffer.writeln('Explanation: Your BMI is in the obesity range. This is associated with higher risk for several health conditions and usually benefits from medical guidance.');
        break;
      default:
        break;
    }

    // Age- and gender-aware notes
    if (age != null) {
      if (age < 18) {
        buffer.writeln('Note: BMI interpretation for children and teens differs from adults — use percentile charts and consult a pediatrician.');
      } else if (age >= 65) {
        buffer.writeln('Note: In older adults, BMI alone may not fully reflect health — muscle loss (sarcopenia) and distribution of fat matter too. Consider functional assessments.');
      }
    }

    if (gender != null && gender.isNotEmpty) {
      buffer.writeln('Context: Gender reported as $gender — body composition and fat distribution patterns can differ between individuals.');
    }

    // Practical recommendations by category
    buffer.writeln('\nRecommendations:');
    switch (category) {
      case 'Underweight':
        buffer.writeln('• Aim for small, consistent weight gains by increasing calorie intake with nutrient-dense foods (nuts, dairy, avocados, whole grains).');
        buffer.writeln('• Include resistance training to build muscle mass and consult a dietitian for a meal plan if needed.');
        buffer.writeln('• If unintentional weight loss or other symptoms occur, seek medical evaluation.');
        break;
      case 'Normal':
        buffer.writeln('• Maintain balanced nutrition and at least 150 minutes of moderate aerobic activity per week plus two sessions of strength training.');
        buffer.writeln('• Monitor sleep, stress, and regular check-ups to sustain healthy weight.');
        break;
      case 'Overweight':
        buffer.writeln('• Introduce gradual calorie reduction (200–500 kcal/day) focusing on whole foods, vegetables, lean proteins and fiber.');
        buffer.writeln('• Increase physical activity: aim for 150–300 minutes/week of moderate exercise and include resistance training.');
        buffer.writeln('• Small, sustainable changes (10% weight reduction) significantly improve health markers.');
        break;
      case 'Obesity':
        buffer.writeln('• Consult a healthcare professional for a personalized plan — interventions may include medical nutrition therapy, structured exercise programs, and in some cases medications or referral to weight management services.');
        buffer.writeln('• Prioritize gradual, sustainable weight loss and monitor for related conditions (blood pressure, lipids, blood sugar).');
        break;
      default:
        break;
    }

    buffer.writeln('\nWhen to seek medical advice:');
    buffer.writeln('• Rapid unintentional weight change, persistent fatigue, or symptoms like shortness of breath and chest pain should prompt immediate medical attention.');
    buffer.writeln('• For long-term weight management, a coordinated plan with a clinician or dietitian is recommended.');

    return buffer.toString();
  }

  static Color colorForCategory(String category) {
    switch (category) {
      case 'Underweight':
        return Colors.blue.shade600;
      case 'Normal':
        return Colors.green.shade600;
      case 'Overweight':
        return Colors.orange.shade700;
      case 'Obesity':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}
