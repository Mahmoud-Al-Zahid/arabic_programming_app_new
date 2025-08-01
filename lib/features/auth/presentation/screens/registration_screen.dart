import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedCountry = 'السعودية';
  String _selectedSkillLevel = 'مبتدئ';
  bool _isPythonSelected = false;
  bool _obscurePassword = true;

  final List<String> _countries = [
    'السعودية',
    'الإمارات',
    'مصر',
    'الأردن',
    'لبنان',
    'المغرب',
    'تونس',
    'الجزائر',
    'العراق',
    'سوريا',
  ];

  final List<String> _skillLevels = ['مبتدئ', 'متوسط', 'متقدم'];

  void _submitForm() {
    if (_formKey.currentState!.validate() && _isPythonSelected) {
      context.go('/home');
    } else if (!_isPythonSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار مسار البايثون للمتابعة'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Text
                Text(
                  'مرحباً بك في رحلة تعلم البايثون',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'أكمل المعلومات التالية للبدء',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل *',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم الكامل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Age and Country Row
                Row(
                  children: [
                    // Age
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'العمر',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final age = int.tryParse(value);
                            if (age == null || age < 8 || age > 100) {
                              return 'عمر غير صحيح';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Country
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: const InputDecoration(
                          labelText: 'البلد',
                          prefixIcon: Icon(Icons.flag),
                        ),
                        items: _countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني *',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value.contains('@')) {
                      return 'بريد إلكتروني غير صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف (اختياري)',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور *',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Python Selection
                Text(
                  'اختر مسار التعلم: *',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Card(
                  child: CheckboxListTile(
                    title: const Text('🐍 Python - الثعبان الودود'),
                    subtitle: const Text('تعلم لغة البايثون من الصفر إلى الاحتراف'),
                    value: _isPythonSelected,
                    onChanged: (value) {
                      setState(() {
                        _isPythonSelected = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Skill Level Selection
                Text(
                  'مستوى خبرتك في البرمجة:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ..._skillLevels.map((level) {
                  return RadioListTile<String>(
                    title: Text(level),
                    value: level,
                    groupValue: _selectedSkillLevel,
                    onChanged: (value) {
                      setState(() {
                        _selectedSkillLevel = value!;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  );
                }),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'ابدأ رحلتك التعليمية',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
