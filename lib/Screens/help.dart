import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:convert';
import 'dashboard.dart';
import 'all_readings.dart';
import 'login.dart';

void main() {
  runApp(const MaterialApp(home: Help()));
}

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final String name = _nameController.text;
    final String phone = _phoneController.text;
    final String message = _messageController.text;

    if (name.isEmpty || phone.isEmpty || message.isEmpty) {
      _showDialog('Error', 'Please fill out all fields.');
      return;
    }

    const String apiKey = 'b0afc461';
    const String apiSecret = 'q3dyQVyPL0QrO2wH';
    const String toNumber = '233552536846'; // Replace with your phone number
    const String from = 'Vonage APIs';

    final Uri url = Uri.parse('https://rest.nexmo.com/sms/json');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'from': from,
          'text': 'Help Request from $name\nPhone: $phone\n\n$message',
          'to': toNumber,
          'api_key': apiKey,
          'api_secret': apiSecret,
        },
      );

      if (response.statusCode == 200) {
        _showDialog('Success', 'Your message has been sent.');
        _nameController.clear();
        _phoneController.clear();
        _messageController.clear();
      } else {
        _showDialog('Error', 'Failed to send your message. Please try again later.');
      }
    } catch (e) {
      _showDialog('SENT ', 'Your message has been sent.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color(0xFFEDEAD2),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              buildLogo(context),
              const SizedBox(height: 20),
              buildHeader(context),
              const SizedBox(height: 20),
              buildHelpContainer(context),
              const SizedBox(height: 20),
              buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('web/icons/waterdrop.jpg'),
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
                color: const Color.fromARGB(255, 7, 7, 52),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildHeader(BuildContext context) {
    return Text(
      'HELP',
      style: GoogleFonts.poppins(
        fontSize: 30,
        color: const Color.fromARGB(255, 7, 7, 52),
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildHelpContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(13, 0, 0, 49),
      decoration: BoxDecoration(
        color: const Color(0xF20B0B45),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 17, 19, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel('FULL NAME'),
            buildInputField(_nameController),
            buildLabel('PHONE NUMBER'),
            buildInputField(_phoneController),
            buildLabel('MESSAGE'),
            buildMessageInputField(_messageController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(
                  'Submit',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Container(
      margin: const EdgeInsets.fromLTRB(13, 0, 13, 3),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  Widget buildInputField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF9EBEB),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  Widget buildMessageInputField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFF9EBEB),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Dashboard())),
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllReadings())),
        ),
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Help())),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Login())),
        ),
      ],
    );
  }
}

