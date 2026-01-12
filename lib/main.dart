import 'package:flutter/material.dart';

void main() {
  runApp(const MonAppli());
}

/* =======================
   CLASSE PRINCIPALE
======================= */
class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Magazine Infos',
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }
}

/* =======================
   PAGE D’ACCUEIL
======================= */
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: const [
            Image(
              image: AssetImage('assets/images/magazineInfo.jpg'),
            ),
            PartieTitre(),
            PartieTexte(),
            PartieIcone(),
            PartieRubrique(),
          ],
        ),
      ),
    );
  }
}

/* =======================
   PARTIE TITRE
======================= */
class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Magazine Infos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Toute l’actualité en un clic',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

/* =======================
   PARTIE TEXTE
======================= */
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Text(
        'Magazine Infos est un magazine numérique moderne qui '
        'propose à ses lecteurs des articles variés sur la presse, '
        'la mode, la culture et les tendances actuelles. '
        'Il offre une lecture simple, rapide et accessible à tous.',
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

/* =======================
   PARTIE ICONE
======================= */
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(Icons.phone, 'TEL'),
          _buildIcon(Icons.email, 'MAIL'),
          _buildIcon(Icons.share, 'PARTAGE'),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.pink),
        ),
      ],
    );
  }
}

/* =======================
   PARTIE RUBRIQUE
======================= */
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/presse.jpg',
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/design.jpg',
              width: 150,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
