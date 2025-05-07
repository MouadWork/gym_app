import 'package:flutter/material.dart';
import 'package:gym_application/login.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  final Color _primaryColor = const Color.fromARGB(255, 163, 6, 6);
  final Color _accentColor = const Color(0xFF00BCD4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Fitness App'),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: _primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: _primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 35, color: _primaryColor),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Premium Member',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
              _buildDrawerItem(Icons.calculate, 'Calorie Calculator', 1),
              _buildDrawerItem(Icons.food_bank, 'Nutrition Database', 2),
              _buildDrawerItem(Icons.shopping_cart, 'Shop', 3),
              _buildDrawerItem(Icons.card_membership, 'Subscription', 4),
              const Divider(),
              _buildDrawerItem(Icons.settings, 'Settings', 5),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyLogin()),
                ),
                child: _buildDrawerItem(Icons.logout, 'Logout', 6),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index ? _primaryColor : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? _primaryColor : Colors.grey[800],
          fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: index == 6 ? null : () => setState(() => _selectedIndex = index),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildSelectedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildCalorieCalculator();
      case 2:
        return _buildNutritionDatabase();
      case 3:
        return _buildShop();
      case 4:
        return _buildSubscription();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Progress',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 16),
        _buildUserStats(),
        const SizedBox(height: 16),
        _buildQuickActions(),
        const SizedBox(height: 16),
        _buildUpcomingPayments(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUserStats() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fitness Goals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildStatItem(
                          'Current Weight', '75 kg', Icons.monitor_weight),
                    ),
                    Expanded(
                      child:
                          _buildStatItem('Target Weight', '70 kg', Icons.flag),
                    ),
                    Expanded(
                      child: _buildStatItem(
                          'Days Active', '45', Icons.calendar_today),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 28, color: _primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionCard('Calculate Calories', Icons.calculate),
                _buildActionCard('View Products', Icons.shopping_cart),
                _buildActionCard('Nutrition Guide', Icons.food_bank),
                _buildActionCard('Subscription Status', Icons.card_membership),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, size: 32, color: _primaryColor),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A237E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingPayments() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, color: _primaryColor),
              ),
              title: const Text('Next Payment Due'),
              subtitle: const Text('April 23, 2024'),
              trailing: const Text(
                '\$50',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCalculator() {
    final TextEditingController ageController = TextEditingController();
    final TextEditingController heightController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    String selectedGoal = 'bulk';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calorie Calculator',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.height),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.monitor_weight),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Goal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Bulk'),
                              value: 'bulk',
                              groupValue: selectedGoal,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              onChanged: (value) {
                                setState(() {
                                  selectedGoal = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Cut'),
                              value: 'cut',
                              groupValue: selectedGoal,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              onChanged: (value) {
                                setState(() {
                                  selectedGoal = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (ageController.text.isNotEmpty &&
                            heightController.text.isNotEmpty &&
                            weightController.text.isNotEmpty) {
                          double weight = double.parse(weightController.text);
                          double height = double.parse(heightController.text);
                          int age = int.parse(ageController.text);
                          double bmr =
                              (10 * weight) + (6.25 * height) - (5 * age) + 5;
                          double dailyCalories =
                              selectedGoal == 'bulk' ? bmr + 500 : bmr - 500;

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Your Daily Calories'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'BMR: ${bmr.toStringAsFixed(0)} calories'),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Daily Calories for ${selectedGoal.toUpperCase()}: ${dailyCalories.toStringAsFixed(0)} calories',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        backgroundColor: const Color(0xFF1A237E),
                      ),
                      child: const Text(
                        'Calculate Calories',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildNutritionDatabase() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Nutrition Database Coming Soon'),
      ),
    );
  }

  Widget _buildShop() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Shop Coming Soon'),
      ),
    );
  }

  Widget _buildSubscription() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Subscription Details Coming Soon'),
      ),
    );
  }
}
