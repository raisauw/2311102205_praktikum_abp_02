import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Widgets Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ─── Data untuk ListView.builder & ListView.separated ───────────────────────
const List<String> buahList = ['Apel', 'Mangga', 'Jeruk', 'Anggur', 'Pisang'];
const List<String> kotaList = ['Jakarta', 'Bandung', 'Surabaya', 'Yogyakarta', 'Medan'];

// ─── Home Page dengan Navigation ────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ContainerPage(),
    GridViewPage(),
    ListViewPage(),
    ListViewBuilderPage(),
    ListViewSeparatedPage(),
    StackPage(),
  ];

  final List<String> _titles = [
    'Container',
    'GridView',
    'ListView',
    'ListView.builder',
    'ListView.separated',
    'Stack',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'UI Widgets Demo',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            _buildDrawerItem(0, Icons.square, 'Container'),
            _buildDrawerItem(1, Icons.grid_view, 'GridView'),
            _buildDrawerItem(2, Icons.list, 'ListView'),
            _buildDrawerItem(3, Icons.format_list_bulleted, 'ListView.builder'),
            _buildDrawerItem(4, Icons.horizontal_rule, 'ListView.separated'),
            _buildDrawerItem(5, Icons.layers, 'Stack'),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: _currentIndex == index ? Colors.indigo : Colors.grey),
      title: Text(label),
      selected: _currentIndex == index,
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }
}

// ─── 1. CONTAINER ───────────────────────────────────────────────────────────
class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Container - Kotak Berwarna', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Container(
            width: 150,
            height: 150,
            color: Colors.red,
            child: const Center(child: Text('Merah', style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
          const SizedBox(height: 16),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('Hijau', style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
          const SizedBox(height: 16),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: const Center(child: Text('Biru', style: TextStyle(color: Colors.white, fontSize: 18))),
          ),
        ],
      ),
    );
  }
}

// ─── 2. GRIDVIEW ────────────────────────────────────────────────────────────
class GridViewPage extends StatelessWidget {
  const GridViewPage({super.key});

  final List<Map<String, dynamic>> items = const [
    {'label': 'Item 1', 'color': Colors.red},
    {'label': 'Item 2', 'color': Colors.green},
    {'label': 'Item 3', 'color': Colors.blue},
    {'label': 'Item 4', 'color': Colors.orange},
    {'label': 'Item 5', 'color': Colors.purple},
    {'label': 'Item 6', 'color': Colors.teal},
    {'label': 'Item 7', 'color': Colors.pink},
    {'label': 'Item 8', 'color': Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: items.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: item['color'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item['label'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── 3. LISTVIEW ────────────────────────────────────────────────────────────
class ListViewPage extends StatelessWidget {
  const ListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTile('A', 'Item A', Colors.red),
        const SizedBox(height: 12),
        _buildTile('B', 'Item B', Colors.green),
        const SizedBox(height: 12),
        _buildTile('C', 'Item C', Colors.blue),
      ],
    );
  }

  Widget _buildTile(String leading, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color, child: Text(leading, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

// ─── 4. LISTVIEW.BUILDER ────────────────────────────────────────────────────
class ListViewBuilderPage extends StatelessWidget {
  const ListViewBuilderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: buahList.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.indigo,
              child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
            ),
            title: Text(buahList[index], style: const TextStyle(fontSize: 16)),
            subtitle: Text('Buah ke-${index + 1}'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}

// ─── 5. LISTVIEW.SEPARATED ──────────────────────────────────────────────────
class ListViewSeparatedPage extends StatelessWidget {
  const ListViewSeparatedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: kotaList.length,
      separatorBuilder: (context, index) => const Divider(
        color: Colors.indigo,
        thickness: 1.5,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.location_city, color: Colors.indigo.shade400),
          title: Text(kotaList[index], style: const TextStyle(fontSize: 16)),
          subtitle: Text('Kota ke-${index + 1}'),
        );
      },
    );
  }
}

// ─── 6. STACK ───────────────────────────────────────────────────────────────
class StackPage extends StatelessWidget {
  const StackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Stack - Tampilan Bertumpuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),

          // Stack 1: teks di atas gambar warna
          Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 250, height: 150, color: Colors.orange),
              Container(width: 180, height: 100, color: Colors.deepOrange),
              const Text('STACK', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),

          const SizedBox(height: 32),

          // Stack 2: badge di pojok
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(16)),
                child: const Center(child: Icon(Icons.inbox, color: Colors.white, size: 48)),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
