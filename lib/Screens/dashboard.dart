import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../google_sheets_service.dart';
import 'login.dart';
import 'all_readings.dart';
import 'help.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, dynamic> readings = {
    'ph': '0',
    'optical_density': '0',
    'conductivity': '0',
    'resistivity': '0'
  };

  List<FlSpot> phData = [];
  List<FlSpot> opticalDensityData = [];
  List<FlSpot> conductivityData = [];
  List<FlSpot> resistivityData = [];
  Timer? timer;

  final double phThreshold = 7.5; // Example threshold value
  final String nexmoApiKey = 'b0afc461';
  final String nexmoApiSecret = 'q3dyQVyPL0QrO2wH';
  final String fromPhoneNumber = 'Vonage APIs';
  final String toPhoneNumber = '233552536846';

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

      setState(() {
        readings['ph'] = values['ph']?.toString() ?? '0';
        readings['optical_density'] = values['optical_density']?.toString() ?? '0';
        readings['conductivity'] = values['conductivity']?.toString() ?? '0';
        readings['resistivity'] = values['resistivity']?.toString() ?? '0';
        _updateTrendData();
      });

      checkThresholds();

      print('Fetched values: $values');
      print('Updated readings: $readings');
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _updateTrendData() {
    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    phData.add(FlSpot(currentTime, double.parse(readings['ph']!)));
    opticalDensityData.add(FlSpot(currentTime, double.parse(readings['optical_density']!)));
    conductivityData.add(FlSpot(currentTime, double.parse(readings['conductivity']!)));
    resistivityData.add(FlSpot(currentTime, double.parse(readings['resistivity']!)));

    print('Updated trend data: phData: $phData, opticalDensityData: $opticalDensityData, conductivityData: $conductivityData, resistivityData: $resistivityData');

    // Keep only the latest 10 entries
    if (phData.length > 10) {
      phData.removeAt(0);
      opticalDensityData.removeAt(0);
      conductivityData.removeAt(0);
      resistivityData.removeAt(0);
    }
  }

  void checkThresholds() {
    if (double.parse(readings['ph']!) > phThreshold) {
      sendSms('PH level exceeded threshold: ${readings['ph']}');
    }
  }

  Future<void> sendSms(String message) async {
    final url = Uri.parse('https://rest.nexmo.com/sms/json');
    final response = await http.post(
      url,
      body: {
        'api_key': nexmoApiKey,
        'api_secret': nexmoApiSecret,
        'to': toPhoneNumber,
        'from': fromPhoneNumber,
        'text': message,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('SMS Response: $responseBody');

      if (responseBody['messages'][0]['status'] == '0') {
        print('SMS sent successfully');
      } else {
        print('Failed to send SMS: ${responseBody['messages'][0]['error-text']}');
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      print('HTTP response: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color(0xFFEDEAD2),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              buildHeader(context),
              const SizedBox(height: 20),
              buildCurrentReadings(),
              const SizedBox(height: 20),
              buildTrendGraph(),
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
        Text('Dashboard', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget buildCurrentReadings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Readings', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ReadingCard(label: 'ph', value: readings['ph']!, color: Colors.blue),
            ReadingCard(label: 'Optical Density', value: readings['optical_density']!, color: Colors.red),
            ReadingCard(label: 'Conductivity', value: readings['conductivity']!, color: Colors.green),
            ReadingCard(label: 'Resistivity', value: readings['resistivity']!, color: Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget buildTrendGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Data Trend', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(
          width: double.infinity,
          height: 300,
          child: LineChart(LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: phData,
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: opticalDensityData,
                isCurved: true,
                color: Colors.red,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: conductivityData,
                isCurved: true,
                color: Colors.green,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: resistivityData,
                isCurved: true,
                color: Colors.orange,
                barWidth: 4,
                belowBarData: BarAreaData(show: false),
                dotData: const FlDotData(show: false),
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget buildNavigationButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Navigation', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavigationButton(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
              },
            ),
            NavigationButton(
              icon: Icons.list_alt,
              label: 'All Readings',
              color: Colors.blue,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AllReadings()));
              },
            ),
            NavigationButton(
              icon: Icons.help,
              label: 'Help',
              color: Colors.green,
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Help()));
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class ReadingCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const ReadingCard({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 10),
            Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const NavigationButton({super.key, required this.icon, required this.label, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Column(
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 10),
          Text(label, style: GoogleFonts.poppins(fontSize: 16)),
        ],
      ),
    );
  }
}


