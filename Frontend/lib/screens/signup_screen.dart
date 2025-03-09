// lib/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/location_data.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  // Color scheme - matching the login screen
  static const Color _primaryGreen =
      Color(0xFF2E7D32); // Deeper green for better contrast
  static const Color _lightGreen = Color(0xFF81C784); // Accent green
  static const Color _softBlack = Color(0xFF212121); // Richer black
  static const Color _offWhite = Color(0xFFF5F5F5); // Slightly warmer white
  static const Color _hintGrey = Color(0xFFAAAAAA); // Subtle grey for hints

  final _formKey = GlobalKey<FormState>();
  String? _selectedProvince;
  String? _selectedDistrict;
  List<String> _districts = [];
  bool _isPasswordVisible = false;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userData: {
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'province': _selectedProvince,
          'district': _selectedDistrict,
        },
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _softBlack,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new, color: _offWhite, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Account',
          style: TextStyle(
            color: _offWhite,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _softBlack,
              Color(0xFF1A3025), // Dark green-black blend
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeInAnimation,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header text with styling
                      Text(
                        'Join Us',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _offWhite,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Create your account to get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: _offWhite.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      // First Name field
                      TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        cursorColor: _primaryGreen,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(color: _hintGrey),
                          hintText: 'John',
                          hintStyle:
                              TextStyle(color: _hintGrey.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.person_outline,
                                color: _primaryGreen, size: 22),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: _validateRequired,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Last Name field
                      TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        cursorColor: _primaryGreen,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(color: _hintGrey),
                          hintText: 'Doe',
                          hintStyle:
                              TextStyle(color: _hintGrey.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.person_outline,
                                color: _primaryGreen, size: 22),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: _validateRequired,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        cursorColor: _primaryGreen,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(color: _hintGrey),
                          hintText: 'name@example.com',
                          hintStyle:
                              TextStyle(color: _hintGrey.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.email_outlined,
                                color: _primaryGreen, size: 22),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Password field with visibility toggle
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        cursorColor: _primaryGreen,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: _hintGrey),
                          hintText: '••••••••',
                          hintStyle:
                              TextStyle(color: _hintGrey.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.lock_outline,
                                color: _primaryGreen, size: 22),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: _hintGrey,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: _validatePassword,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Phone Number field
                      TextFormField(
                        controller: _phoneController,
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        cursorColor: _primaryGreen,
                        decoration: InputDecoration(
                          labelText: 'Phone Number (Optional)',
                          labelStyle: TextStyle(color: _hintGrey),
                          hintText: '+1 (555) 123-4567',
                          hintStyle:
                              TextStyle(color: _hintGrey.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.phone_outlined,
                                color: _primaryGreen, size: 22),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 16),

                      // Province Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: _hintGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.location_on_outlined,
                                color: _primaryGreen, size: 22),
                          ),
                        ),
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        value: _selectedProvince,
                        dropdownColor: _offWhite,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: _primaryGreen),
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
                        hint: Text('Select Province',
                            style: TextStyle(color: _hintGrey)),
                      ),

                      const SizedBox(height: 16),

                      // District Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: _hintGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: _primaryGreen, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                BorderSide(color: Colors.redAccent, width: 2),
                          ),
                          filled: true,
                          fillColor: _offWhite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 12, right: 8),
                            child: const Icon(Icons.location_city_outlined,
                                color: _primaryGreen, size: 22),
                          ),
                        ),
                        style: const TextStyle(
                            color: _softBlack, fontWeight: FontWeight.w500),
                        value: _selectedDistrict,
                        dropdownColor: _offWhite,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: _primaryGreen),
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
                        hint: Text('Select District',
                            style: TextStyle(color: _hintGrey)),
                        disabledHint: Text('Select Province First',
                            style:
                                TextStyle(color: _hintGrey.withOpacity(0.5))),
                      ),

                      const SizedBox(height: 32),

                      // Sign Up Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryGreen,
                          foregroundColor: _offWhite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: _primaryGreen.withOpacity(0.5),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                      ),

                      const SizedBox(height: 24),

                      // Divider with "OR" text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                                color: _offWhite.withOpacity(0.2),
                                thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: _offWhite.withOpacity(0.6),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                                color: _offWhite.withOpacity(0.2),
                                thickness: 1),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Google Sign Up button
                      OutlinedButton.icon(
                        icon: const Icon(
                          Icons.g_mobiledata,
                          color: _offWhite,
                          size: 28,
                        ),
                        label: const Text(
                          'Sign up with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _offWhite,
                            letterSpacing: 0.5,
                          ),
                        ),
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                              color: _offWhite.withOpacity(0.3), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: _offWhite.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: _lightGreen,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
