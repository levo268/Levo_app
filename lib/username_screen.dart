import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({Key? key}) : super(key: key);

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  bool? _isAvailable;
  String _message = "";
  Timer? _debounce;

  // Jab user type karega toh har keystroke pe database hit na ho, isliye debounce lagaya hai
  _onUsernameChanged(String username) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (username.trim().isEmpty) {
      setState(() {
        _isAvailable = null;
        _message = "";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final cleanUsername = username.trim().toLowerCase();
      
      try {
        // Firestore mein check kar rahe hain ki ye username kisi document mein hai ya nahi
        final result = await _firestore
            .collection('users')
            .where('username', isEqualTo: cleanUsername)
            .get();

        setState(() {
          _isLoading = false;
          if (result.docs.isEmpty) {
            _isAvailable = true;
            _message = "Username is available!";
          } else {
            _isAvailable = false;
            _message = "This username is already taken.";
          }
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _message = "Error checking database. Please try again.";
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose a username",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can always change this later in settings.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              onChanged: _onUsernameChanged,
              decoration: InputDecoration(
                hintText: "username",
                prefixText: "@ ",
                prefixStyle: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
                filled: true,
                fillColor: const Color(0xFF1A1B23),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : _isAvailable == null
                        ? null
                        : _isAvailable!
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _isAvailable == null
                        ? const Color(0xFF0052FF)
                        : _isAvailable!
                            ? Colors.green
                            : Colors.red,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _isAvailable == true ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_isAvailable == true && !_isLoading) ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052FF),
                  disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
