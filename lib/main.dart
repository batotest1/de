import 'dart:async';
import 'dart:convert';
import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// SplashScreen Widget
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay of 3 seconds before navigating to RegistrationPage
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // You can show a loading indicator here
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _familiyaController = TextEditingController();
  final _ismController = TextEditingController();
  final _loginController = TextEditingController();
  final _parolController = TextEditingController();

  final String _correctPassword = "123"; // Correct password
  bool _isPasswordVisible = false; // Track password visibility
  bool _isMonkeyClosedEyes = true; // Track monkey emoji state

  void _checkLogin() {
    String password = _parolController.text;

    if (password == _correctPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ma'lumotlar muvaffaqiyatli saqlandi!")),
      );

      // Navigate to SuccessPage and pass Familiya and Ism
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(
            familiya: _familiyaController.text,
            ism: _ismController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Parol noto'g'ri!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.pink], // Blue and pink gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            "Ro'yxatdan o'tish",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent, // Transparent to allow gradient
          elevation: 0, // No shadow to keep the gradient clean
        ),
      ),
      body: Stack(
        children: [
          // Background GIF
          Positioned.fill(
            child: Image.asset(
              'assets/2.gif', // GIF file
              fit: BoxFit.cover, // Cover the whole screen
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glass Effect TextFields with BackdropFilter
                _buildGlassTextField('Familiya', _familiyaController),
                SizedBox(height: 15),
                _buildGlassTextField('Ism', _ismController),
                SizedBox(height: 15),
                _buildGlassTextField('Login', _loginController),
                SizedBox(height: 15),
                _buildGlassTextField(
                  'Parol',
                  _parolController,
                  isPassword: !_isPasswordVisible, // Toggle password visibility
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle visibility
                        _isMonkeyClosedEyes =
                            !_isMonkeyClosedEyes; // Toggle monkey emoji
                      });
                    },
                    child: Image.asset(
                      _isMonkeyClosedEyes
                          ? 'assets/m.webp' // Closed eyes image
                          : 'assets/l.webp', // Open eyes image
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _checkLogin, // Calls _checkLogin method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 95, 41, 93),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Saqlash",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Glass Effect for TextField
  Widget _buildGlassTextField(String label, TextEditingController controller,
      {bool isPassword = false, Widget? suffixIcon}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color:
                Colors.white.withOpacity(0.3), // Transparent background color
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white),
              border: InputBorder.none, // No border
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}

// SuccessPage now accepts the familiya and ism as parameters
class SuccessPage extends StatefulWidget {
  final String familiya;
  final String ism;

  SuccessPage({required this.familiya, required this.ism});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  final _loginController = TextEditingController();
  final _parolController = TextEditingController();

  final String _correctPassword = "123"; // Correct password

  void _checkLogin() {
    String password = _parolController.text;

    if (password == _correctPassword) {
      // Show a welcome message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xush kelibsiz!")),
      );
      // Navigate to HomePage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  familiya: widget.familiya, // Pass the familiya
                  ism: widget.ism, // Pass the ism
                )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Parol noto'g'ri!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple], // Gradient colors
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text fields for Login and Password
                _buildGlassTextField('Login', _loginController),
                SizedBox(height: 15),
                _buildGlassTextField('Parol', _parolController,
                    isPassword: true),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _checkLogin, // Check password on button press
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Kirish",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Glass Effect for TextField
  Widget _buildGlassTextField(String label, TextEditingController controller,
      {bool isPassword = false, Widget? suffixIcon}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String familiya;
  final String ism;

  HomePage({required this.familiya, required this.ism});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _currentTime;
  late Timer _timer;
  List<dynamic> _currencyData = [];

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchCurrencyData();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          "${now.hour}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });
  }

  Future<void> _fetchCurrencyData() async {
    const url = 'https://cbu.uz/uz/arkhiv-kursov-valyut/json/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _currencyData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load currency data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_sharp, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              "${widget.ism} ${widget.familiya}",
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Text(
              _currentTime,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: _currencyData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _currencyData.length,
              itemBuilder: (context, index) {
                final currency = _currencyData[index];
                return _buildCurrencyCard(currency);
              },
            ),
    );
  }

  Widget _buildCurrencyCard(Map<String, dynamic> currency) {
    final rate = double.tryParse(currency['Rate'].toString()) ?? 0.0;
    final change = double.tryParse(currency['Diff'].toString()) ?? 0.0;
    final isPositive = change >= 0;

    return GestureDetector(
      onTap: () {
        _showCurrencyDialog(currency, rate);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Yangilangan kun: ${DateTime.now().toLocal().toString().split(' ')[0]}'),
            Divider(),
            Center(
              child: Text(
                "${currency['CcyNm_UZ']} (${currency['Ccy']})",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1 ${currency['Ccy']}",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "$rate uzs",
                ),
                Text(
                  "${isPositive ? '+' : ''}${change.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog(Map<String, dynamic> currency, double rate) {
    TextEditingController _amountController = TextEditingController();
    String? _resultText; // Variable to store the result text
    bool isUZS =
        true; // Boolean to track if we're converting UZS to USD or the other way around

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("USD ma'lumotlari"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Qiymati: ${rate.toStringAsFixed(2)} UZS"),
                  Text("Valyuta: ${currency['Ccy']}"),
                  Text("Nomi: ${currency['CcyNm_UZ']}"),
                  SizedBox(height: 10),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: isUZS
                          ? "Miqdor (UZS)"
                          : "Miqdor (USD)", // Dynamic label change
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  if (_resultText != null)
                    Text(
                      _resultText!,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Qaytish"),
                ),
                TextButton(
                  onPressed: () {
                    if (isUZS) {
                      // Convert UZS to USD
                      final amountInUZS =
                          double.tryParse(_amountController.text) ?? 0.0;
                      final result =
                          amountInUZS / rate; // UZS to USD conversion

                      setState(() {
                        _resultText =
                            "Natija: \$${result.toStringAsFixed(2)} USD"; // Show the result
                      });
                    } else {
                      // Convert USD to UZS
                      final amountInUSD =
                          double.tryParse(_amountController.text) ?? 0.0;
                      final result =
                          amountInUSD * rate; // USD to UZS conversion

                      setState(() {
                        _resultText =
                            "Natija: ${result.toStringAsFixed(2)} UZS"; // Show the result
                      });
                    }
                  },
                  child: Text(isUZS ? "Hisoblash" : "Hisoblash"),
                ),
                // Switch between UZS to USD and USD to UZS
                TextButton(
                  onPressed: () {
                    setState(() {
                      isUZS = !isUZS; // Toggle the conversion direction
                      _amountController.clear(); // Clear the input field
                      _resultText = null; // Clear the previous result
                    });
                  },
                  child: Text(isUZS ? "USD ga o'tish" : "UZS ga o'tish"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
