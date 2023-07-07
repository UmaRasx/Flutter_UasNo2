import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase HTTP Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String temperature = '';
  String humidity = '';
  bool doorLocked = false;

  TextEditingController temperatureController = TextEditingController();
  TextEditingController humidityController = TextEditingController();

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://flutteruasumar-default-rtdb.asia-southeast1.firebasedatabase.app/.json'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = data['temperature'].toString();
        humidity = data['humidity'].toString();
        doorLocked = data['doorLocked'] ?? false;
      });
    } else {
      setState(() {
        temperature = 'Error';
        humidity = 'Error';
      });
    }
  }

  Future<void> sendData() async {
    final customTemperature = temperatureController.text;
    final customHumidity = humidityController.text;

    final data = {
      'temperature': customTemperature,
      'humidity': customHumidity,
      'doorLocked': doorLocked,
    };

    final response = await http.put(Uri.parse('https://flutteruasumar-default-rtdb.asia-southeast1.firebasedatabase.app/.json'),
        body: json.encode(data));

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  void toggleDoorLock() {
    setState(() {
      doorLocked = !doorLocked;
    });
    // Perform actions to control the door lock based on the doorLocked value
    if (doorLocked) {
      // Lock the door
      print('Door locked');
    } else {
      // Unlock the door
      print('Door unlocked');
    }
    sendData(); // Send the updated door lock status to Firebase
  }

  @override
  void dispose() {
    temperatureController.dispose();
    humidityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase HTTP Umar Kharits Al Khikam 2502048022'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Temperature: $temperature°C',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Humidity: $humidity%',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Door Lock Status: ${doorLocked ? 'Locked' : 'Unlocked'}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Custom Temperature:'),
                SizedBox(width: 16),
                Container(
                  width: 100,
                  child: TextField(
                    controller: temperatureController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Custom Humidity:'),
                SizedBox(width: 16),
                Container(
                  width: 100,
                  child: TextField(
                    controller: humidityController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendData,
              child: Text('Send Data'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: toggleDoorLock,
              child: Text(doorLocked ? 'Unlock Door' : 'Lock Door'),
            ),
          ],
        ),
      ),
    );
  }
}
