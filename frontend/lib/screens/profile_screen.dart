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
  late TextEditingController _cityController;
  String _selectedCountry = 'Sri Lanka';
  String _selectedLanguage = 'English';

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
    _loadUserProfile();
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
      final email = widget.userInfo['email'] as String?;
      if (email == null) {
        throw Exception('Email not found in user info');
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
        });
      } else {
        // Create a new profile if one doesn't exist
        final newProfile = {
          'email': email,
          'name': widget.userInfo['name']?.toString() ?? '',
          'picture': widget.userInfo['picture']?.toString() ?? '',
          'language': _languages[0], // Default to first language
          'country': _countries[0], // Default to first country
          'city': '',
          'bio': '',
          'dateOfBirth': DateTime.now().toIso8601String(),
        };

        final createdProfile = await ProfileService.createProfile(newProfile);
        if (createdProfile != null && mounted) {
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
          });
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
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = {
        'name': _nameController.text,
        'bio': _bioController.text,
        'country': _selectedCountry,
        'city': _cityController.text,
        'language': _selectedLanguage,
      };

      final result = await ProfileService.updateProfile(
          _userProfile['_id'], updatedProfile);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          _userProfile = result;
          _isEditing = false;
        });
        PopupMessage.show(context, "Profile updated successfully");
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
                //await _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileField(String label, TextEditingController? controller,
      {bool readOnly = false,
      bool isDropdown = false,
      String? value,
      List<String>? items,
      Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: _isEditing && !readOnly
          ? isDropdown
              ? DropdownButtonFormField<String>(
                  value: value,
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                  ),
                  items: items?.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList() ??
                      [],
                  onChanged: onChanged,
                )
              : TextField(
                  controller: controller,
                  readOnly: readOnly,
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                    enabled: !readOnly,
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
                  isDropdown
                      ? value ?? 'Not set'
                      : controller?.text.isNotEmpty == true
                          ? controller!.text
                          : 'Not set',
                  style: TextStyle(
                    fontSize: 16,
                    color: (isDropdown ? value : controller?.text)
                            .toString()
                            .isNotEmpty
                        ? Colors.black
                        : Colors.grey,
                  ),
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
                      _userProfile['picture']?.toString() ??
                          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileField(
                      'Email',
                      TextEditingController(
                          text: widget.userInfo['email'] ?? ''),
                      readOnly: true),
                  _buildProfileField('Name', _nameController),
                  _buildProfileField('Bio', _bioController),
                  _buildProfileField(
                    'Country',
                    null,
                    isDropdown: true,
                    value: _selectedCountry,
                    items: _countries,
                    onChanged: _isEditing
                        ? (value) {
                            setState(() => _selectedCountry = value!);
                          }
                        : null,
                  ),
                  _buildProfileField('City', _cityController),
                  _buildProfileField(
                    'Language',
                    null,
                    isDropdown: true,
                    value: _selectedLanguage,
                    items: _languages,
                    onChanged: _isEditing
                        ? (value) {
                            setState(() => _selectedLanguage = value!);
                          }
                        : null,
                  ),
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
                  // Delete Account Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(
                      onPressed: _showDeleteAccountDialog,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
