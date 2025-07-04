import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF2E549A),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Toggle notifications
              },
            ),
          ),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text('Indonesian'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup Data'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Perform logout
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}