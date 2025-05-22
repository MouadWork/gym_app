import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_application/login.dart';
import 'package:gym_application/db_helper.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  final Color _primaryColor = const Color.fromARGB(255, 97, 4, 4);
  final Color _accentColor = const Color(0xFF00BCD4);
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadProducts();
  }

  void _loadMembers() async {
    final data = await DBHelper.getMembers();
    setState(() {
      _members = data;
    });
  }

  void _loadProducts() async {
    final data = await DBHelper.getProducts();
    setState(() {
      _products = data;
    });
  }
// Liste des produits

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Tableau de bord'),
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
                      'Admin',
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
              _buildDrawerItem(Icons.dashboard, 'Tableau de bord', 0),
              _buildDrawerItem(Icons.people, 'Gérer les membres', 1),
              _buildDrawerItem(Icons.card_membership, 'Abonnements', 2),
              _buildDrawerItem(Icons.shopping_cart, 'Produits', 3),
              const Divider(),
              GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MyLogin()),
                      ),
                  child: _buildDrawerItem(Icons.logout, 'Déconnexion', 6)),
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
            const SizedBox(height: 20), // Ajouter un espacement en bas
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
          'Vue d\'ensemble',
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
        final itemWidth = (width - 24) / 2; // Compte pour l'espacement
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                  'Membres totaux', '190', Icons.people, _primaryColor),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard('Abonnements actifs', '100',
                  Icons.card_membership, Colors.green),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard('Revenu mensuel', '\$3000',
                  Icons.attach_money, Colors.orange),
            ),
            SizedBox(
              width: itemWidth,
              child: _buildStatCard(
                  'Produits vendus', '45', Icons.shopping_cart, Colors.purple),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation:
          6, // Augmenter légèrement l'élévation pour un aspect plus professionnel
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.1)], // Gradient subtil
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Ombre subtile
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
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
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            _primaryColor.withOpacity(0.05)
          ], // Gradient subtil
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Ombre subtile
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenu mensuel',
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            _primaryColor.withOpacity(0.05)
          ], // Gradient subtil
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Ombre subtile
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activité récente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem('Nouvelle inscription membre', 'Il y a 2 heures',
                Icons.person_add),
            _buildActivityItem('Renouvellement d\'abonnement',
                'Il y a 4 heures', Icons.card_membership),
            _buildActivityItem(
                'Achat de produit', 'Il y a 6 heures', Icons.shopping_cart),
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
      subtitle: Text(time, style: const TextStyle(color: Color(0xFF1A237E))),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  void _showAddMemberDialog() {
    final _nomController = TextEditingController();
    final _prenomController = TextEditingController();
    final _numTelephoneController = TextEditingController();
    String? _selectedSexe;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un nouveau membre'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _numTelephoneController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSexe,
                  items: const [
                    DropdownMenuItem(value: 'Homme', child: Text('Homme')),
                    DropdownMenuItem(value: 'Femme', child: Text('Femme')),
                  ],
                  onChanged: (value) {
                    _selectedSexe = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sexe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty &&
                    _prenomController.text.isNotEmpty &&
                    _numTelephoneController.text.isNotEmpty &&
                    _selectedSexe != null) {
                  await DBHelper.insertMember({
                    'name': '${_nomController.text} ${_prenomController.text}',
                    'email': _numTelephoneController.text,
                  });
                  _loadMembers();
                  Navigator.pop(context);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMembersContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: _showAddMemberDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Ajouter un membre',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Liste des membres',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
          const SizedBox(height: 10),
          _members.isEmpty
              ? const Center(
                  child: Text('Aucun membre disponible.'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _members.length,
                  itemBuilder: (context, index) {
                    final member = _members[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _primaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            color: _primaryColor,
                          ),
                        ),
                        title: Text(member['name'] ?? ''),
                        subtitle: Text('Tel: ${member['email'] ?? ''}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditMemberDialog(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMember(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsContent() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Gestion des abonnements'),
      ),
    );
  }

 Widget _buildProductsContent() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Liste des produits',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showAddProductDialog,
              icon: const Icon(
                Icons.add,
                size: 16,
                color: Colors.white,
              ),
              label: const Text(
                'Ajouter',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _products.isEmpty
            ? const Center(
                child: Text(
                  'Aucun produit disponible.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: Colors.grey,
                      ),
                      title: Text(product['name'] ?? ''),
                      subtitle: Text('Prix: ${product['price']} MAD'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _showEditProductDialog(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteProduct(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    ),
  );
}
 

  Widget _buildPaymentsContent() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Gestion des paiements'),
      ),
    );
  }

  void _showEditMemberDialog(int index) {
    final member = _members[index];
    final _nomController = TextEditingController(text: member['nom']);
    final _prenomController = TextEditingController(text: member['prenom']);
    final _numTelephoneController =
        TextEditingController(text: member['telephone']);
    String? _selectedSexe = member['sexe'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier un membre'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _numTelephoneController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedSexe,
                  items: const [
                    DropdownMenuItem(value: 'Homme', child: Text('Homme')),
                    DropdownMenuItem(value: 'Femme', child: Text('Femme')),
                  ],
                  onChanged: (value) {
                    _selectedSexe = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Sexe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty &&
                    _prenomController.text.isNotEmpty &&
                    _numTelephoneController.text.isNotEmpty &&
                    _selectedSexe != null) {
                  await DBHelper.updateMember({
                    'id': member['id'],
                    'name': '${_nomController.text} ${_prenomController.text}',
                    'email': _numTelephoneController.text,
                  });
                  _loadMembers();

                  Navigator.pop(context); // Fermer la boîte de dialogue
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMember(int index) async {
    await DBHelper.deleteMember(_members[index]['id']);
    _loadMembers();
  }

  void _showAddProductDialog() {
    final _nomController = TextEditingController();
    final _prixController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un produit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du produit',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _prixController,
                  decoration: const InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer la boîte de dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty &&
                    _prixController.text.isNotEmpty) {
                  await DBHelper.insertProduct({
                    'name': _nomController.text,
                    'price': double.parse(_prixController.text),
                  });
                  _loadProducts();

                  Navigator.pop(context); // Fermer la boîte de dialogue
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(int index) {
    final product = _products[index];
    final _nomController = TextEditingController(text: product['nom']);
    final _prixController = TextEditingController(text: product['prix']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier un produit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom du produit',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _prixController,
                  decoration: const InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty &&
                    _prixController.text.isNotEmpty) {
                  await DBHelper.updateProduct({
                    'id': _products[index]['id'],
                    'name': _nomController.text,
                    'price': double.parse(_prixController.text),
                  });
                  _loadProducts();

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int index) async {
    await DBHelper.deleteProduct(_products[index]['id']);
    _loadProducts();
  }
}
