// lib/screens/settings/account_settings.dart
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: ListView(
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
    );
  }
}