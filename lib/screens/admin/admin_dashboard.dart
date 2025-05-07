import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_application/login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final Color _primaryColor = const Color.fromARGB(255, 163, 6, 6);
  final Color _accentColor = const Color(0xFF00BCD4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
                      'Admin Panel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'admin@example.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
              _buildDrawerItem(Icons.people, 'Manage Members', 1),
              _buildDrawerItem(Icons.card_membership, 'Subscriptions', 2),
              _buildDrawerItem(Icons.shopping_cart, 'Products', 3),
              _buildDrawerItem(Icons.payment, 'Payments', 4),
              const Divider(),
              _buildDrawerItem(Icons.settings, 'Settings', 5),
              GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyLogin()),
                      ),
                  child: _buildDrawerItem(Icons.logout, 'Logout', 6)),
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
            const SizedBox(height: 20), // Add bottom padding
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
        return _buildMembersContent();
      case 2:
        return _buildSubscriptionsContent();
      case 3:
        return _buildProductsContent();
      case 4:
        return _buildPaymentsContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
        const SizedBox(height: 20),
        _buildStatCards(),
        const SizedBox(height: 20),
        _buildCharts(),
        const SizedBox(height: 20),
        _buildRecentActivity(),
      ],
    );
  }

  Widget _buildStatCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = (width - 24) / 2; // Account for spacing
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                  'Total Members', '190', Icons.people, _primaryColor),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard('Active Subscriptions', '100',
                  Icons.card_membership, Colors.green),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard('Monthly Revenue', '\$3000',
                  Icons.attach_money, Colors.orange),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                  'Products Sold', '45', Icons.shopping_cart, Colors.purple),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Revenue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 1),
                        const FlSpot(2, 4),
                        const FlSpot(3, 2),
                        const FlSpot(4, 5),
                      ],
                      isCurved: true,
                      color: _primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: _primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
                'New member registration', '2 hours ago', Icons.person_add),
            _buildActivityItem(
                'Subscription renewal', '4 hours ago', Icons.card_membership),
            _buildActivityItem(
                'Product purchase', '6 hours ago', Icons.shopping_cart),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: _primaryColor),
      ),
      title: Text(title),
      subtitle: Text(time, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildMembersContent() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Members Management'),
      ),
    );
  }

  Widget _buildSubscriptionsContent() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Subscriptions Management'),
      ),
    );
  }

  Widget _buildProductsContent() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Products Management'),
      ),
    );
  }

  Widget _buildPaymentsContent() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Payments Management'),
      ),
    );
  }
}
