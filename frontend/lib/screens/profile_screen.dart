import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  bool isBiometricEnabled = false;
  bool isCloudBackupEnabled = false;
  bool isNotificationsEnabled = true;
  String selectedLanguage = 'English';
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF8CD3FF),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _buildProfileSections(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 18,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18),
                    onPressed: _pickImage,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            'john.doe@example.com',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSection(
            'Personal Information',
            Icons.person_outline,
            [
              _buildEditableField('Name', 'John Doe'),
              _buildEditableField('Date of Birth', '01/01/1990'),
              _buildEditableField('Gender', 'Male'),
              _buildEditableField('Country', 'United States'),
              _buildEditableField('City', 'New York'),
              _buildEditableField(
                  'Bio', 'Flutter Developer & Journal Enthusiast'),
            ],
          ),
          _buildSection(
            'Appearance',
            Icons.palette_outlined,
            [
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() => isDarkMode = value);
                },
              ),
            ],
          ),
          _buildSection(
            'Privacy & Security',
            Icons.security_outlined,
            [
              SwitchListTile(
                title: const Text('Biometric Authentication'),
                value: isBiometricEnabled,
                onChanged: (value) {
                  setState(() => isBiometricEnabled = value);
                },
              ),
              SwitchListTile(
                title: const Text('Cloud Backup'),
                value: isCloudBackupEnabled,
                onChanged: (value) {
                  setState(() => isCloudBackupEnabled = value);
                },
              ),
            ],
          ),
          _buildSection(
            'Notifications',
            Icons.notifications_outlined,
            [
              SwitchListTile(
                title: const Text('Push Notifications'),
                value: isNotificationsEnabled,
                onChanged: (value) {
                  setState(() => isNotificationsEnabled = value);
                },
              ),
            ],
          ),
          _buildSection(
            'Language & Accessibility',
            Icons.language_outlined,
            [
              ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: selectedLanguage,
                  items: ['English', 'Spanish', 'French']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => selectedLanguage = newValue);
                    }
                  },
                ),
              ),
            ],
          ),
          _buildSection(
            'Help & Support',
            Icons.help_outline,
            [
              ListTile(
                title: const Text('FAQs'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to FAQs
                },
              ),
              ListTile(
                title: const Text('Contact Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to Support
                },
              ),
              ListTile(
                title: const Text('App Version'),
                trailing: const Text('1.0.0'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement delete account functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Account'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit, size: 16),
        ],
      ),
      onTap: () {
        // Show edit dialog
        _showEditDialog(label, value);
      },
    );
  }

  void _showEditDialog(String label, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update the value
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }
}
