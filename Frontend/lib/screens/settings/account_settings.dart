// lib/screens/settings/account_settings.dart
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Added colors from ExploreTab
    final Color _paleGreen = const Color(0xFFE8F5E9); // Background green
    final Color _lightBg = const Color(0xFFFAFAFA); // Off-white background

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Container(
        // Added gradient background same as ExploreTab
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_paleGreen, _lightBg],
            stops: const [0.3, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Change Profile Picture'),
              onTap: () {
                // Add functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Change Username'),
              onTap: () {
                // Add functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                // Add functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Change Mobile Number'),
              onTap: () {
                // Add functionality
              },
            ),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text(
                'Deactivate Account',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // Add functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}