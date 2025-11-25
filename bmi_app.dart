import 'package:flutter/material.dart';
import 'bmi_calculator.dart';

// Simple BMI application UI.
// - Collects user details (name, gender, age, weight, height)
// - Uses `BMICalculator` for computation and detailed advice
// - Displays a personalized, color-coded result card

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      // Remove the default debug banner shown in debug builds.
      // Previously the app showed a "DEBUG" watermark; setting this to false
      // hides that banner. (Removed watermark here.)
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark),
        useMaterial3: true,
      ).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  // Controllers for form fields
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Gender is tracked as a plain string; default is opt-out choice
  String _gender = 'Prefer not to say';

  double? _bmi;
  String _category = '';
  String _advice = '';
  Color _resultColor = Colors.transparent;

  // removed unused helper; display name is read directly in build()

  // Perform validation, compute BMI and fetch detailed advice.
  void _calculate() {
    final weight = double.tryParse(_weightController.text.replaceAll(',', '.'));
    final height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    final age = int.tryParse(_ageController.text);

    if (weight == null || height == null || weight <= 0 || height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid positive numbers for weight and height.')),
      );
      return;
    }
    // Compute BMI and get advice using the helper in `bmi_calculator.dart`.
    final bmi = BMICalculator.calculateBMI(weightKg: weight, heightCm: height);
    final category = BMICalculator.categoryForBMI(bmi);
    final advice = BMICalculator.detailedAdvice(
      bmi: bmi,
      age: age,
      gender: _gender == 'Prefer not to say' ? null : _gender,
    );
    final color = BMICalculator.colorForCategory(category);

    setState(() {
      _bmi = bmi;
      _category = category;
      _advice = advice;
      _resultColor = color;
    });
  }

  void _clear() {
    _weightController.clear();
    _heightController.clear();
    _ageController.clear();
    setState(() {
      _bmi = null;
      _category = '';
      _advice = '';
      _resultColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    // Main screen scaffold containing the entire form and result display
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width < 600 ? width : 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input card: collects personal and anthropometric details
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Enter your details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Gender selector uses a form field with an initialValue
                        DropdownButtonFormField<String>(
                          initialValue: _gender,
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                            DropdownMenuItem(value: 'Prefer not to say', child: Text('Prefer not to say')),
                          ],
                          onChanged: (v) => setState(() => _gender = v ?? 'Prefer not to say'),
                          decoration: const InputDecoration(prefixIcon: Icon(Icons.wc), labelText: 'Gender'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            prefixIcon: Icon(Icons.fitness_center),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            prefixIcon: Icon(Icons.height),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Age (optional)',
                            prefixIcon: Icon(Icons.cake),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _calculate,
                                icon: const Icon(Icons.calculate),
                                label: const Text('Calculate'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: _clear,
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _resultColor.withAlpha((0.08 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _resultColor.withAlpha((0.2 * 255).round())),
                  ),
                  padding: const EdgeInsets.all(16),
                  // Result card: shows friendly greeting, BMI value, category and
                  // detailed advice generated by `BMICalculator.detailedAdvice`.
                  child: _bmi == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Result', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            SizedBox(height: 8),
                            Text('Enter weight and height then press Calculate.'),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Personalized header if user provided name
                            if (name.isNotEmpty) ...[
                              Text(
                                'Hello, $name${ageText.isNotEmpty ? ' • $ageText y/o' : ''}${_gender != 'Prefer not to say' ? ' • $_gender' : ''}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                            ],

                            // BMI value + category chip
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Your BMI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),
                                    Text(
                                      _bmi!.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Chip(
                                  backgroundColor: _resultColor,
                                  label: Text(_category, style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),
                            const Text('Interpretation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            // Full textual advice from BMICalculator
                            Text(_advice),
                            const SizedBox(height: 12),
                            const Text('General BMI ranges:', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            const Text('• Underweight: < 18.5'),
                            const Text('• Normal: 18.5 – 24.9'),
                            const Text('• Overweight: 25 – 29.9'),
                            const Text('• Obesity: ≥ 30'),
                          ],
                        ),
                ),
                //const SizedBox(height: 18),
                //Center(child: Text('Simple — Responsive — Friendly UI', style: TextStyle(color: Theme.of(context).colorScheme.primary))),
                //const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
