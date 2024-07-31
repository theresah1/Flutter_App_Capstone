import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard.dart';
import 'help.dart';
import 'login.dart';
import 'ph.dart';
import 'od.dart';
import 'conductivity.dart';
import 'resistivity.dart';


void main() {
  runApp(const AllReadings());
}

class AllReadings extends StatelessWidget {
  // ignore: use_super_parameters
  const AllReadings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color(0xFFEDEAD2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              buildHeader(),
              const SizedBox(height: 50),
              buildCheckReadings(context),
              const SizedBox(height: 40),
              buildRefreshButton(),
              const SizedBox(height: 40),
              buildNavigationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Text(
      'Individual Readings',
      style: GoogleFonts.poppins(fontSize: 30, color: const Color.fromARGB(255, 7, 7, 52), fontWeight: FontWeight.bold),
    );
  }

Widget buildCheckReadings(BuildContext context) {
  return Column(
    children: [
      buildReadingButton('pH', () => navigateToPh(context)),
      const SizedBox(height: 20),
      buildReadingButton('Optical Density', () => navigateToOD(context)),
      const SizedBox(height: 20),
      buildReadingButton('Conductivity', () => navigateToConductivity(context)),
      const SizedBox(height: 20),
      buildReadingButton('Resistivity', () => navigateToResistivity(context)),
    ],
  );
}

Widget buildReadingButton(String label, VoidCallback onPressed) {
  return Container(
    width: double.infinity,
    height: 60,
    decoration: BoxDecoration(
      color: const Color(0xFF0B0B45), 
      borderRadius: BorderRadius.circular(30), // Set border radius to half of height
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0B0B45), // Transparent button background
        elevation: 0, // No elevation
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)), // Match container border radius
      ),
      child: Align(
        alignment: Alignment.centerLeft, // Align button text to the left
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30), 
          child: Text(
            label,
            style: GoogleFonts.getFont(
              'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildRefreshButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          'Refresh',
          style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xF7000000), fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 12.5),
        width: 50,
        height: 43,
        child: ElevatedButton(
          onPressed: refreshData,  // Assuming refreshData is a method that refreshes the readings
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 48, 173, 65),
          ),
          child: const Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    ],
  );
}

void refreshData() {
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

  void navigateToPh(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Ph()));
  }

  void navigateToOD(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Od()));
  }

  void navigateToConductivity(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Conductivity()));
  }

  void navigateToResistivity(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const Resistivity()));
  }
}

