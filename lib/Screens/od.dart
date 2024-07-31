

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'login.dart'; // Import the login screen
import 'all_readings.dart'; // Import the all readings screen
import 'help.dart'; // Import the help screen
import 'dashboard.dart'; // Import the dashboard screen
import '../google_sheets_service.dart'; // Import the Google Sheets service

class Od extends StatefulWidget {
  const Od({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OdState createState() => _OdState();
}

class _OdState extends State<Od> {
  List<dynamic> readings = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchGoogleSheetData();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => fetchGoogleSheetData());
  }

  Future<void> fetchGoogleSheetData() async {
    try {
      final service = GoogleSheetsService();
      final values = await service.fetchReadings();

      print('Fetched values from service: $values');

      setState(() {
        final fetchedReadings = values['optical_density'];
        if (fetchedReadings is List) {
          readings = fetchedReadings;
        } else if (fetchedReadings is double) {
          readings = [fetchedReadings];
        } else {
          readings = [];
        }
      });

      print('Updated readings state: $readings');
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
              const SizedBox(height: 20),
              buildHeader(context),
              const SizedBox(height: 20),
              buildTable(),
              const SizedBox(height: 20),
              buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        Text('Optical Density Data', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Table', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        Container(
          width: double.infinity,
          color: const Color.fromARGB(255, 7, 7, 52), // Placeholder for graph
          child: readings.isNotEmpty
              ? Table(
                  border: TableBorder.all(color: Colors.white),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Index', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Reading', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...readings.asMap().entries.map((entry) {
                      int index = entry.key;
                      dynamic value = entry.value;
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${index + 1}', style: GoogleFonts.poppins(color: Colors.white)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$value', style: GoogleFonts.poppins(color: Colors.white)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                )
              : Center(child: Text('No data available', style: GoogleFonts.poppins(color: Colors.white))),
        ),
      ],
    );
  }

  Widget buildNavigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Dashboard())),
        ),
        IconButton(
          icon: const Icon(Icons.bar_chart),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AllReadings())),
        ),
        IconButton(
          icon: const Icon(Icons.help),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Help())),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Login())),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Od()));
}
