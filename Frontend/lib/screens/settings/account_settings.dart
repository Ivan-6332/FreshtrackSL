// lib/screens/settings/account_settings.dart
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color paleGreen = const Color(0xFFE8F5E9); // Background green
    final Color lightBg = const Color(0xFFFAFAFA); // Off-white background

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [paleGreen, lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSettingsItem(
              context,
              icon: Icons.photo_camera,
              title: 'Change Profile Picture',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () {
                // Add functionality
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.person,
              title: 'Change Username',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () {
                // Add functionality
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.lock,
              title: 'Change Password',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () {
                // Add functionality
              },
            ),
            _buildSettingsItem(
              context,
              icon: Icons.phone,
              title: 'Change Mobile Number',
              gradientColors: [Colors.green[300]!, Colors.green[500]!],
              onTap: () {
                // Add functionality
              },
            ),
            const SizedBox(height: 16),
            _buildSettingsItem(
              context,
              icon: Icons.delete_forever,
              title: 'Deactivate Account',
              gradientColors: [Colors.red[300]!, Colors.red[500]!],
              isDestructive: true,
              onTap: () {
                // Add functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required List<Color> gradientColors,
        bool isDestructive = false,
        required VoidCallback onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : null,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}