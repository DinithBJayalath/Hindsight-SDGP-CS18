import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/widgets/popup_message.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const ProfileScreen({super.key, required this.userInfo});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = true;
  bool _hasUnsavedChanges = false;
  File? _profileImage;
  String? _selectedAvatar;

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  String _selectedCountry = 'Sri Lanka';
  String _selectedLanguage = 'English';

  // UI enhancement settings
  bool isDarkMode = false;
  bool isBiometricEnabled = false;
  bool isCloudBackupEnabled = false;
  bool isNotificationsEnabled = true;

  // Lists for dropdowns
  final List<String> _countries = [
    'Sri Lanka',
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'Japan',
    'India',
    'Brazil',
    // Add more countries as needed
  ];

  final List<String> _languages = [
    'English',
    'Sinhala',
    'Spanish',
    'French',
    'German',
    'Japanese',
    'Chinese',
    'Hindi',
    'Arabic',
    'Portuguese',
    // Add more languages as needed
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _cityController = TextEditingController();
    // Set default values for dropdowns
    _selectedCountry = _countries[0]; // Default to first country
    _selectedLanguage = _languages[0]; // Default to first language

    // Defer loading user profile to after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  // Fetch the complete user profile from our backend
  Future<void> _loadUserProfile() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // First try to get email from userInfo
      String? email = widget.userInfo['email'] as String?;

      if (email == null) {
        if (!mounted) return;
        PopupMessage.show(
          context,
          "Could not retrieve user email. Please try logging in again.",
          isSuccess: false,
        );
        return;
      }

      final profile = await ProfileService.getProfile(email);

      if (!mounted) return;

      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile['name']?.toString() ?? '';
          _bioController.text = profile['bio']?.toString() ?? '';
          _cityController.text = profile['city']?.toString() ?? '';

          // Safely set country value
          final countryValue = profile['country']?.toString();
          _selectedCountry =
              _countries.contains(countryValue) ? countryValue! : _countries[0];

          // Safely set language value
          final languageValue = profile['language']?.toString();
          _selectedLanguage = _languages.contains(languageValue)
              ? languageValue!
              : _languages[0];

          // Check if picture is an asset path
          final picturePath = profile['picture']?.toString() ?? '';
          if (picturePath.startsWith('assets/avatars/')) {
            _selectedAvatar = picturePath;
            _profileImage = null;
          }

          // Load boolean settings
          isDarkMode = profile['darkMode'] == true;
          isBiometricEnabled = profile['biometricAuthentication'] == true;
          isCloudBackupEnabled = profile['cloudBackup'] == true;
          isNotificationsEnabled =
              profile['pushNotifications'] != false; // Default to true
        });
      } else {
        print("No existing profile found, creating new profile...");
        // Create a new profile with basic info
        final userProfile = await _authService.getUserProfile();
        final newProfile = {
          'email': email,
          'name':
              userProfile['name'] ?? widget.userInfo['name']?.toString() ?? '',
          'picture': userProfile['picture'] ??
              widget.userInfo['picture']?.toString() ??
              '',
          'language': _languages[0],
          'country': _countries[0],
          'city': '',
          'bio': '',
          'darkMode': false,
          'biometricAuthentication': false,
          'cloudBackup': false,
          'pushNotifications': true,
        };

        final createdProfile = await ProfileService.createProfile(newProfile);
        if (!mounted) return;

        if (createdProfile != null) {
          setState(() {
            _userProfile = createdProfile;
            _nameController.text = createdProfile['name']?.toString() ?? '';
            _bioController.text = createdProfile['bio']?.toString() ?? '';
            _cityController.text = createdProfile['city']?.toString() ?? '';

            // Safely set country value
            final countryValue = createdProfile['country']?.toString();
            _selectedCountry = _countries.contains(countryValue)
                ? countryValue!
                : _countries[0];

            // Safely set language value
            final languageValue = createdProfile['language']?.toString();
            _selectedLanguage = _languages.contains(languageValue)
                ? languageValue!
                : _languages[0];

            // Initialize switch values
            isDarkMode = false;
            isBiometricEnabled = false;
            isCloudBackupEnabled = false;
            isNotificationsEnabled = true;
          });
        } else {
          PopupMessage.show(
            context,
            "Failed to create profile. Please try again.",
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      print("Error loading user profile: $e");
      if (mounted) {
        PopupMessage.show(
          context,
          "Failed to load profile. Please try again later.",
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'country': _selectedCountry,
        'city': _cityController.text,
        'language': _selectedLanguage,
        'darkMode': isDarkMode,
        'biometricAuthentication': isBiometricEnabled,
        'cloudBackup': isCloudBackupEnabled,
        'pushNotifications': isNotificationsEnabled,
      };

      final result = await ProfileService.updateProfile(
          _userProfile['_id'], updatedProfile);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          _userProfile = result;
          _hasUnsavedChanges = false;
        });

        // Show a SnackBar for success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully!"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        PopupMessage.show(
          context,
          "Failed to update profile. Please try again.",
          isSuccess: false,
        );
      }
    } catch (e) {
      print("Error updating profile: $e");
      if (mounted) {
        PopupMessage.show(
          context,
          e.toString(),
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Method to handle field changes and trigger update
  void _handleFieldChange(Function() updateField) {
    updateField();
    setState(() => _hasUnsavedChanges = true);
    // Automatically update profile after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_hasUnsavedChanges) {
        _updateProfile();
      }
    });
  }

  Future<void> _updateProfileImage() async {
    // Update user profile with the selected avatar
    setState(() => _hasUnsavedChanges = true);

    try {
      final updatedProfile = {
        ..._userProfile,
        'picture': _selectedAvatar ?? _userProfile['picture']?.toString() ?? '',
      };

      final result = await ProfileService.updateProfile(
          _userProfile['_id'], updatedProfile);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          _userProfile = result;
          _hasUnsavedChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile picture updated successfully!"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Error updating profile image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Failed to update profile picture. Please try again."),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Show delete account confirmation dialog
  Future<void> _showDeleteAccountDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() => _isLoading = true);

                final success = await _authService.deleteAccount(context);

                if (!mounted) return;
                setState(() => _isLoading = false);

                if (success) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Account deleted successfully"),
                      duration:
                          Duration(seconds: 1), // Short duration before restart
                    ),
                  );

                  // Short delay to allow the snackbar to be seen
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    if (mounted) {
                      // Restart the app
                      _authService.restartAppAfterDeletion(context);
                    }
                  });
                } else {
                  PopupMessage.show(
                    context,
                    "Failed to delete account. Please try again.",
                    isSuccess: false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // UI enhancement methods
  Future<void> _pickImage() async {
    // List of available avatar images
    final List<String> avatarImages = [
      'assets/avatars/1.png',
      'assets/avatars/2.png',
      'assets/avatars/3.png',
      'assets/avatars/4.png',
      'assets/avatars/5.png',
      'assets/avatars/6.png',
    ];

    // Show avatar selection dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select Avatar',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: avatarImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Close dialog and pass selected avatar path
                    Navigator.of(context).pop(avatarImages[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      avatarImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((selectedAvatar) {
      if (selectedAvatar != null) {
        // Update the profile with the selected avatar
        setState(() {
          _profileImage = null; // Clear any file-based image
          _selectedAvatar = selectedAvatar;
        });
        // Update the profile
        _updateProfileImage();
      }
    });
  }

  void _showEditDialog(
      String label, String currentValue, Function(String) onSave) {
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
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
              _updateProfile();
            },
            child: const Text('Save'),
          ),
        ],
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
                backgroundImage: _selectedAvatar != null
                    ? AssetImage(_selectedAvatar!)
                    : _profileImage != null
                        ? FileImage(_profileImage!)
                        : NetworkImage(
                            _userProfile['picture']?.toString() ??
                                'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                          ) as ImageProvider,
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
            _nameController.text.isNotEmpty
                ? _nameController.text
                : 'Your Name',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            widget.userInfo['email'] ?? 'email@example.com',
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
              _buildEditableField('Name', _nameController.text, (value) {
                setState(() => _nameController.text = value);
              }),
              _buildEditableField('Bio', _bioController.text, (value) {
                setState(() => _bioController.text = value);
              }),
              _buildCountryField(),
              _buildEditableField('City', _cityController.text, (value) {
                setState(() => _cityController.text = value);
              }),
            ],
          ),
          _buildSection(
            'Language & Accessibility',
            Icons.language_outlined,
            [
              ListTile(
                title: const Text('Language'),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: _languages
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _handleFieldChange(() {
                        _selectedLanguage = newValue;
                      });
                    }
                  },
                ),
              ),
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
                  _handleFieldChange(() {
                    setState(() => isDarkMode = value);
                  });
                },
              ),
            ],
          ),
          // _buildSection(
          //   'Privacy & Security',
          //   Icons.security_outlined,
          //   [
          //     SwitchListTile(
          //       title: const Text('Biometric Authentication'),
          //       value: isBiometricEnabled,
          //       onChanged: (value) {
          //         _handleFieldChange(() {
          //           setState(() => isBiometricEnabled = value);
          //         });
          //       },
          //     ),
          //     SwitchListTile(
          //       title: const Text('Cloud Backup'),
          //       value: isCloudBackupEnabled,
          //       onChanged: (value) {
          //         _handleFieldChange(() {
          //           setState(() => isCloudBackupEnabled = value);
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // _buildSection(
          //   'Notifications',
          //   Icons.notifications_outlined,
          //   [
          //     SwitchListTile(
          //       title: const Text('Push Notifications'),
          //       value: isNotificationsEnabled,
          //       onChanged: (value) {
          //         _handleFieldChange(() {
          //           setState(() => isNotificationsEnabled = value);
          //         });
          //       },
          //     ),
          //   ],
          // ),
          _buildSection(
            'Help & Support',
            Icons.help_outline,
            [
              ListTile(
                title: const Text('FAQs'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Open the Hindsight website
                  _launchUrl('https://hindsight-18.vercel.app/');
                },
              ),
              ListTile(
                title: const Text('Contact Support'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Open the Hindsight website
                  _launchUrl('https://hindsight-18.vercel.app/');
                },
              ),
              ListTile(
                title: const Text('App Version'),
                trailing: const Text('1.0.0'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Show indicator when changes are being saved
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showDeleteAccountDialog,
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
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: Theme.of(context).primaryColor),
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

  Widget _buildEditableField(
      String label, String value, Function(String) onSave) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value.isNotEmpty ? value : 'Not set',
            style: TextStyle(
              color: value.isNotEmpty ? Colors.grey : Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit, size: 16),
        ],
      ),
      onTap: () {
        _showEditDialog(label, value, onSave);
      },
    );
  }

  Widget _buildCountryField() {
    return ListTile(
      title: const Text('Country'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _selectedCountry,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down, size: 16),
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select Country'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_countries[index]),
                    onTap: () {
                      setState(() {
                        _selectedCountry = _countries[index];
                      });
                      Navigator.pop(context);
                      _updateProfile();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: _isLoading && _userProfile.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
}
