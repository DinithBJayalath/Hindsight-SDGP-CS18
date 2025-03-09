import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/widgets/popup_message.dart';

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
  bool _isEditing = false;

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _languageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _languageController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  // Fetch the complete user profile from our backend
  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);

    try {
      final email = widget.userInfo['email'];
      final profile = await ProfileService.getProfile(email);

      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile['name'] ?? '';
          _bioController.text = profile['bio'] ?? '';
          _countryController.text = profile['country'] ?? '';
          _cityController.text = profile['city'] ?? '';
          _languageController.text = profile['language'] ?? 'en';
        });
      } else {
        // Create a new profile if one doesn't exist
        final newProfile = {
          'email': email,
          'name': widget.userInfo['name'] ?? '',
          'picture': widget.userInfo['picture'] ?? '',
          'language': 'en',
          'country': '',
          'city': '',
          'bio': '',
          'dateOfBirth': DateTime.now().toIso8601String(),
        };

        final created = await ProfileService.createProfile(newProfile);
        if (created) {
          _loadUserProfile(); // Reload to get the created profile
        }
      }
    } catch (e) {
      print("Error loading user profile: $e");
      if (mounted) {
        PopupMessage.show(
          context,
          "Failed to load profile. Please try again.",
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
    setState(() => _isLoading = true);

    try {
      final updatedProfile = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'country': _countryController.text,
        'city': _cityController.text,
        'language': _languageController.text,
      };

      final success = await ProfileService.updateProfile(
        widget.userInfo['email'],
        updatedProfile,
      );

      if (mounted) {
        if (success) {
          PopupMessage.show(context, "Profile updated successfully");
          setState(() => _isEditing = false);
          _loadUserProfile();
        } else {
          PopupMessage.show(
            context,
            "Failed to update profile. Please try again.",
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      print("Error updating profile: $e");
      if (mounted) {
        PopupMessage.show(
          context,
          "An error occurred while updating profile",
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: _isEditing
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  controller.text,
                  style: const TextStyle(fontSize: 16),
                ),
                const Divider(),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      _userProfile['picture'] ??
                          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField('Name', _nameController),
                  _buildProfileField('Bio', _bioController),
                  _buildProfileField('Country', _countryController),
                  _buildProfileField('City', _cityController),
                  _buildProfileField('Language', _languageController),
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _isEditing = false);
                            _loadUserProfile(); // Reset to original values
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _updateProfile,
                          child: const Text('Save Changes'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
    );
  }
}
