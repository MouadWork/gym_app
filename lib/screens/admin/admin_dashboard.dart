import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gym_application/login.dart';
import 'package:gym_application/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
              ListTile(
                leading: Icon(Icons.logout, color: Colors.grey[600]),
                title: Text(
                  'Déconnexion',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyLogin()),
                  );
                },
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
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe temporaire',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
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
                    _emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty &&
                    _selectedSexe != null) {
                  try {
                    // 1. Create user in Firebase Authentication
                    final UserCredential userCredential = await FirebaseAuth
                        .instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );

                    if (userCredential.user != null) {
                      // 2. Store member data in Firestore
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({
                        'uid': userCredential.user!.uid,
                        'email': _emailController.text.trim(),
                        'name':
                            '${_nomController.text.trim()} ${_prenomController.text.trim()}',
                        'phone': _numTelephoneController.text.trim(),
                        'sexe': _selectedSexe!,
                        'role': 'user',
                        'createdAt': FieldValue.serverTimestamp(),
                        'lastLogin': FieldValue.serverTimestamp(),
                      });

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Member created successfully!')),
                        );
                      }

                      _nomController.clear();
                      _prenomController.clear();
                      _numTelephoneController.clear();
                      _emailController.clear();
                      _passwordController.clear();

                      Navigator.pop(context);

                      _loadMembers();
                    }
                  } on FirebaseAuthException catch (e) {
                    String message = 'Failed to create member.';
                    if (e.code == 'email-already-in-use') {
                      message = 'The email address is already in use.';
                    } else if (e.code == 'weak-password') {
                      message = 'The password is too weak.';
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('An error occurred: ${e.toString()}')),
                      );
                    }
                  }
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
          SizedBox(
            height: MediaQuery.of(context).size.height -
                250, // Adjust height to prevent overflow
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .where('role', isEqualTo: 'user')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun membre disponible.'));
                }

                final members = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member =
                        members[index].data() as Map<String, dynamic>;
                    final String displayName = member['name'] ??
                        '${member['nom'] ?? ''} ${member['prenom'] ?? ''}'
                            .trim();

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _primaryColor.withOpacity(0.1),
                          child: Icon(Icons.person, color: _primaryColor),
                        ),
                        title: Text(
                          displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${member['email'] ?? 'N/A'}'),
                            Text('Téléphone: ${member['phone'] ?? 'N/A'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showEditMemberDialog(members[index].id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMember(members[index].id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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

  void _showEditMemberDialog(String memberId) {
    showDialog(
      context: context,
      builder: (context) {
        final _nomController = TextEditingController();
        final _prenomController = TextEditingController();
        final _numTelephoneController = TextEditingController();
        final _emailController = TextEditingController();
        String? _selectedSexe;

        // Load member data
        _firestore.collection('users').doc(memberId).get().then((doc) {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            _nomController.text = data['nom'] ?? '';
            _prenomController.text = data['prenom'] ?? '';
            _numTelephoneController.text = data['phone'] ?? '';
            _emailController.text = data['email'] ?? '';
            _selectedSexe = data['sexe'];
          }
        });

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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
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
                    _emailController.text.isNotEmpty &&
                    _selectedSexe != null) {
                  try {
                    await _firestore.collection('users').doc(memberId).update({
                      'nom': _nomController.text.trim(),
                      'prenom': _prenomController.text.trim(),
                      'phone': _numTelephoneController.text.trim(),
                      'email': _emailController.text.trim(),
                      'sexe': _selectedSexe,
                      'name':
                          '${_nomController.text.trim()} ${_prenomController.text.trim()}',
                    });

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Member updated successfully!')),
                      );
                    }

                    Navigator.pop(context);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error updating member: ${e.toString()}')),
                      );
                    }
                  }
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMember(String memberId) async {
    try {
      await _firestore.collection('users').doc(memberId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member deleted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting member: ${e.toString()}')),
        );
      }
    }
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
                Navigator.pop(context);
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
                Navigator.pop(context);
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

                  Navigator.pop(context);
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
