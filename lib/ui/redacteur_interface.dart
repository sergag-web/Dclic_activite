import 'package:flutter/material.dart';
import '../database/database_manager.dart';
import '../modele/redacteur.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _searchController = TextEditingController();

  final DatabaseManager _dbManager = DatabaseManager();
  List<Redacteur> redacteurs = [];
  
  List<Redacteur> redacteursFiltres = []; 
  bool _estEnRecherche = false;

  @override
  void initState() {
    super.initState();
    chargerRedacteurs();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> chargerRedacteurs() async {
    final data = await _dbManager.getAllRedacteurs();
    if (!mounted) return;
    setState(() {
      redacteurs = data;
      redacteursFiltres = data;
    });
  }

  void _filtrerDonnees(String query) {
    setState(() {
      redacteursFiltres = redacteurs
          .where((r) =>
              r.nom.toLowerCase().contains(query.toLowerCase()) ||
              r.prenom.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _afficherFormulaire({Redacteur? redacteur}) {
    if (redacteur != null) {
      _nomController.text = redacteur.nom;
      _prenomController.text = redacteur.prenom;
      _emailController.text = redacteur.email;
    } else {
      _nomController.clear();
      _prenomController.clear();
      _emailController.clear();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              redacteur == null ? "Ajouter un rédacteur" : "Modifier les infos",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildTextField(_nomController, "Nom", Icons.person_rounded),
            const SizedBox(height: 16),
            _buildTextField(_prenomController, "Prénom", Icons.badge_outlined),
            const SizedBox(height: 16),
            _buildTextField(_emailController, "Email", Icons.alternate_email_rounded),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: () async {
                  if (redacteur == null) {
                    await _dbManager.insertRedacteur(Redacteur.sansId(
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      email: _emailController.text,
                    ));
                  } else {
                    await _dbManager.updateRedacteur(Redacteur(
                      id: redacteur.id,
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      email: _emailController.text,
                    ));
                  }
                  
                  if (!mounted) return; 
                  Navigator.pop(context);
                  chargerRedacteurs();
                },
                child: Text(redacteur == null ? "Créer le profil" : "Mettre à jour"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 22),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              accountName: const Text("Admin", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: const Text("admin@monapplication.com"),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text("Accueil"),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text("Déconnexion", style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: _estEnRecherche
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Rechercher...",
                  border: InputBorder.none,
                ),
                onChanged: _filtrerDonnees,
              )
            : const Text("Gestions des rédacteurs", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_estEnRecherche ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _estEnRecherche = !_estEnRecherche;
                if (!_estEnRecherche) {
                  redacteursFiltres = redacteurs;
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: redacteursFiltres.isEmpty
          ? const Center(child: Text("Aucun rédacteur trouvé"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: redacteursFiltres.length,
              itemBuilder: (context, index) {
                final r = redacteursFiltres[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05), 
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Text(
                        r.nom.isNotEmpty ? r.nom[0].toUpperCase() : "?",
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text("${r.prenom} ${r.nom}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(r.email),
                    trailing: PopupMenuButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onSelected: (value) async {
                        if (value == 'edit') {
                          _afficherFormulaire(redacteur: r);
                        } else if (value == 'delete') {
                          await _dbManager.deleteRedacteur(r.id!);
                          chargerRedacteurs();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text("Modifier")),
                        const PopupMenuItem(value: 'delete', child: Text("Supprimer", style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _afficherFormulaire(),
        label: const Text("Ajouter un rédacteur"),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}