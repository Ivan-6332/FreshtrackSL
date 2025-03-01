// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import '../../models/location_data.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedProvince;
  String? _selectedDistrict;
  List<String> _districts = [];

  void _updateDistricts(String province) {
    setState(() {
      _selectedProvince = province;
      _districts = LocationData.provinceDistricts[province] ?? [];
      _selectedDistrict = null;
    });
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Province',
                  border: OutlineInputBorder(),
                ),
                value: _selectedProvince,
                items: LocationData.provinceDistricts.keys
                    .map((String province) => DropdownMenuItem(
                  value: province,
                  child: Text(province),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _updateDistricts(newValue);
                  }
                },
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDistrict,
                items: _districts
                    .map((String district) => DropdownMenuItem(
                  value: district,
                  child: Text(district),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                  });
                },
                validator: _validateRequired,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, '/main');
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Sign up with Google'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}