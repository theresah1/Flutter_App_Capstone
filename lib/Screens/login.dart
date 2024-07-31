import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard.dart'; // Import the dashboard screen

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String errorMessage = '';

  Future<void> _signup() async {
    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();

    if (name.isNotEmpty && phone.isNotEmpty) {
      await storage.write(key: 'name', value: name);
      await storage.write(key: 'phone', value: phone);
      setState(() {
        errorMessage = 'Signup successful! You can now login.';
      });
    } else {
      setState(() {
        errorMessage = 'Please enter both name and phone number for signup.';
      });
    }
  }

  Future<void> _login() async {
    final String name = nameController.text.trim();
    final String phone = phoneController.text.trim();

    String? storedName = await storage.read(key: 'name');
    String? storedPhone = await storage.read(key: 'phone');

    if (name == storedName && phone == storedPhone) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      setState(() {
        errorMessage = 'Wrong name or phone number. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double backgroundContainerWidth = constraints.maxWidth * 1.2;
          double backgroundContainerHeight = constraints.maxHeight * 1.4;
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF000000)),
                color: const Color(0xFFFFFDFC),
              ),
              padding: const EdgeInsets.fromLTRB(11, 55, 20, 0),
              child: Stack(
                children: [
                  Positioned(
                    right: -(backgroundContainerWidth * 0.2) / 2,
                    top: -(backgroundContainerHeight * 0.2) / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B0B45),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SizedBox(
                        width: backgroundContainerWidth,
                        height: backgroundContainerHeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 27, 20, 77.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 48),
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  'web/icons/waterdrop.jpg',
                                ),
                              ),
                            ),
                            width: 33,
                            height: 40,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    'web/icons/waterdrop.jpg',
                                  ),
                                ),
                              ),
                              width: 69,
                              height: 100,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SAFETY FIRST',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: const Color(0xFFFFFDFC),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        Text(
                          'Username',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9EBEB),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Password',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: const Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9EBEB),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _signup,
                              child: const Text('Signup'),
                            ),
                            ElevatedButton(
                              onPressed: _login,
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                        if (errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Login()));
}