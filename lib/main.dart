import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'images/homebck.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.7,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Your ',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '\nQUITTING',
                          style: GoogleFonts.playfairDisplay(
                            color: const Color(0xFFEB5656),
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        TextSpan(
                          text: '\njourney starts here.',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SlideToActionButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideToActionButton extends StatefulWidget {
  const SlideToActionButton({super.key});

  @override
  SlideToActionButtonState createState() => SlideToActionButtonState();
}

class SlideToActionButtonState extends State<SlideToActionButton> {
  double slidePosition = 0;
  final double buttonWidth = 300;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      slidePosition += details.delta.dx;
      if (slidePosition < 0) slidePosition = 0;
      if (slidePosition > buttonWidth) slidePosition = buttonWidth;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (slidePosition >= buttonWidth) {
      if (mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const UserInfoPage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              var fadeAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
          ),
        );
      }

      setState(() {
        slidePosition = 0;
      });
    } else {
      setState(() {
        slidePosition = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: 380,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFEB5656),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text(
              'Slide to Start',
              style: GoogleFonts.playfairDisplay(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.8),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(slidePosition, 0),
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward, color: Color(0xFFEB5656)),
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  UserInfoPageState createState() => UserInfoPageState();
}

class UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cigarettesController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  Future<void> _saveUserInfoAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'averageDailyCigarettes',
        int.parse(_cigarettesController.text),
      );
      await prefs.setDouble(
        'costPerCigarette',
        double.parse(_costController.text),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    const DashboardPage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              var fadeAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'images/homebck.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Your Smoking Habits',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: _cigarettesController,
                        decoration: InputDecoration(
                          labelText: 'Cigarettes per day',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a number';
                          }
                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _costController,
                        decoration: InputDecoration(
                          labelText: 'Cost per cigarette (₹)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a cost';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Please enter a valid cost';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _saveUserInfoAndNavigate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB5656),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  double _cigarettesSmokedToday = 0;
  int _averageDailyCigarettes = 20;
  double _costPerCigarette = 0.35;
  bool _isLoading = true;
  final double _nicotinePerCigarette = 0.8;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _maxCigarettes = 20;
  List<DailyProgress> _progressHistory = [];

  final List<String> _dailyTips = [
    "Take deep breaths when cravings hit—inhale, hold, exhale. 🌬️",
    "Keep your hands busy—stress ball, fidget toy, or doodling. ✍️",
    "Avoid smoking triggers—change your routine. 🔄",
    "Chew gum or eat healthy snacks to replace cigarette cravings. 🍏",
    "Remind yourself why you're quitting—better health, more money saved. 💰",
  ];

  String _currentTip = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _generateRandomTip();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _averageDailyCigarettes = prefs.getInt('averageDailyCigarettes') ?? 20;
      _costPerCigarette = prefs.getDouble('costPerCigarette') ?? 0.35;
      _cigarettesSmokedToday = prefs.getDouble('cigarettesSmokedToday') ?? 0;
      _maxCigarettes = _averageDailyCigarettes;

      final savedProgress = prefs.getStringList('progressHistory') ?? [];
      _progressHistory =
          savedProgress
              .map(
                (json) => DailyProgress(
                  date: DateTime.parse(json.split('|')[0]),
                  cigarettesSmoked: int.parse(json.split('|')[1]),
                  moneySaved: double.parse(json.split('|')[2]),
                ),
              )
              .toList();

      _isLoading = false;
    });
  }

  void _generateRandomTip() {
    final random = Random();
    setState(() {
      _currentTip = _dailyTips[random.nextInt(_dailyTips.length)];
    });
  }

  Future<void> _saveCigarettesSmokedToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayProgress = DailyProgress(
      date: today,
      cigarettesSmoked: _cigarettesSmokedToday.toInt(),
      moneySaved: (_maxCigarettes - _cigarettesSmokedToday) * _costPerCigarette,
    );

    _progressHistory.removeWhere(
      (p) =>
          p.date.year == today.year &&
          p.date.month == today.month &&
          p.date.day == today.day,
    );

    _progressHistory.add(todayProgress);

    await prefs.setStringList(
      'progressHistory',
      _progressHistory
          .map(
            (p) => '${p.date.toString()}|${p.cigarettesSmoked}|${p.moneySaved}',
          )
          .toList(),
    );

    await prefs.setDouble('cigarettesSmokedToday', _cigarettesSmokedToday);
  }

  void _incrementCigarettes() async {
    setState(() {
      _cigarettesSmokedToday++;
    });
    await _saveCigarettesSmokedToday();
  }

  void _decrementCigarettes() async {
    setState(() {
      if (_cigarettesSmokedToday > 0) {
        _cigarettesSmokedToday--;
      }
    });
    await _saveCigarettesSmokedToday();
  }

  double calculateSavings() {
    return (_maxCigarettes - _cigarettesSmokedToday) * _costPerCigarette;
  }

  String _calculateMonthlyExpenditure() {
    double dailyExpenditure = _averageDailyCigarettes * _costPerCigarette;
    double monthlyExpenditure = dailyExpenditure * 30;
    return monthlyExpenditure.toStringAsFixed(2);
  }

  String _calculateNicotineConsumed() {
    return (_cigarettesSmokedToday * _nicotinePerCigarette).toStringAsFixed(1);
  }

  String _calculateHealthDegradation() {
    double minutesLost = _cigarettesSmokedToday * 11;

    if (minutesLost >= 60) {
      double hoursLost = minutesLost / 60;
      return '${hoursLost.toStringAsFixed(1)} hours';
    }
    return '${minutesLost.toInt()} minutes';
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // Set the desired background color
          title: Center(
            child: Text(
              'Smoking Harms Info⚠️',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Text(
            '• Causes lung cancer, COPD, and chronic bronchitis.\n'
            '• Increases risk of heart attacks and stroke.\n'
            '• Every cigarette shortens your life by 11 minutes.\n'
            '• Higher risk of infections and slow healing.\n'
            '• Leads to wrinkles, yellow teeth, and bad breath.\n'
            '• Secondhand smoke affects family and friends.\n'
            '• Smoking costs thousands per year.',
            style: GoogleFonts.inter(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFEB5656),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCravingHelp(BuildContext context) {
    final List<String> cravingTips = [
      "Drink a glass of water slowly 🚰",
      "Do 10 jumping jacks or push-ups 💪",
      "Chew gum or eat a healthy snack 🍎",
      "Practice deep breathing for 2 minutes 🌬️",
      "Call a supportive friend or family member 📞",
      "Brush your teeth immediately 🪥",
      "Go for a 5-minute walk outside 🚶‍♂️",
    ];

    final random = Random();
    final tip = cravingTips[random.nextInt(cravingTips.length)];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // Set background color
          title: Center(
            child: Text(
              'CRAVING HELPER',
              style: GoogleFonts.bebasNeue(
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          content: Text(
            "Try this:\n\n$tip",
            style: GoogleFonts.inter(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Thanks!',
                style: GoogleFonts.poppins(color: const Color(0xFFEB5656)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showCravingHelp(context);
              },
              child: Text('Another Tip', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        // ignore: deprecated_member_use
        backgroundColor: const Color(0xFFEB5656),
        elevation: 5,
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF2C3357),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 160,
                child: DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFFEB5656)),
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      'The Quitify',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.emergency, color: Colors.white),
                title: Text(
                  'Craving Button',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCravingHelp(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: Text(
                  'Smoking Harms Info',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showInfoDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.white),
                title: Text(
                  'Monthly Expenditure: ₹${_calculateMonthlyExpenditure()}',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.warning, color: Colors.white),
                title: Text(
                  'Nicotine Consumed: ${_calculateNicotineConsumed()}mg',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: Text(
                  'Edit habits',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserInfoPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'images/homebck.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: const Color(0xFF2C3357).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Today, I smoked',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _cigarettesSmokedToday.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: _decrementCigarettes,
                          ),
                          const SizedBox(width: 30),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                            onPressed: _incrementCigarettes,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoContainer(
                      'MONEY SAVED',
                      '₹${calculateSavings().toStringAsFixed(0)}',
                      'TODAY',
                    ),
                    _buildInfoContainer(
                      'NICOTINE',
                      '${_calculateNicotineConsumed()}mg',
                      'CONSUMED',
                    ),
                    _buildInfoContainer(
                      'HEALTH COST',
                      _calculateHealthDegradation(),
                      'LIFE LOST',
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    Text(
                      'HEALTH IMPACT DETAILS⚠️',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF2C3357).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '• Each cigarette costs you ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: '11 minutes of life',
                                  style: GoogleFonts.inter(
                                    color: Colors.redAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '• Today\'s health cost: ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: _calculateHealthDegradation(),
                                  style: GoogleFonts.inter(
                                    color: Colors.redAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '• Equivalent to watching ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      '${(_cigarettesSmokedToday * 11 / 30).toStringAsFixed(0)} TV episodes',
                                  style: GoogleFonts.inter(
                                    color: Colors.redAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: '• Nicotine Consumed Today: ',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text: '${_calculateNicotineConsumed()}mg',
                                  style: GoogleFonts.inter(
                                    color: Colors.redAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'DAILY TIP💡',
                      style: GoogleFonts.bebasNeue(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 3),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: const Color(0xFF2C3357).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          _currentTip,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String title, String value, String subtitle) {
    return Column(
      children: [
        Container(
          width: 118,
          height: 158,
          decoration: BoxDecoration(
            color: const Color(0xFFEB5656),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  color: Colors.white,
                  fontSize: 32,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.bebasNeue(
            color: Colors.white,
            fontSize: 20,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class DailyProgress {
  final DateTime date;
  final int cigarettesSmoked;
  final double moneySaved;

  DailyProgress({
    required this.date,
    required this.cigarettesSmoked,
    required this.moneySaved,
  });
}

class ChartData {
  final DateTime date;
  final int cigarettes;
  final int goal;

  ChartData({required this.date, required this.cigarettes, required this.goal});
}
