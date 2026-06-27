import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'task_provider.dart';
import 'notification_service.dart';

// Handler untuk notifikasi saat app di background/terminated
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Cukup biarkan kosong, sistem Android akan menampilkan notifikasi otomatis
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi layanan notifikasi (FCM + local notification)
  await NotificationService.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List dengan Provider & FCM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengakses TaskProvider untuk mendapatkan data tugas terkini
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List (Provider & FCM)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Hapus Semua Tugas',
            onPressed: () {
              context.read<TaskProvider>().clearAllTasks();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input untuk menambah tugas baru
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan tugas baru...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    context.read<TaskProvider>().addTask(_controller.text);
                    _controller.clear();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Daftar tugas yang sudah ditambahkan
            Expanded(
              child: taskProvider.tasks.isEmpty
                  ? const Center(
                child: Text(
                  'Belum ada tugas',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.check_box_outline_blank),
                      title: Text(taskProvider.tasks[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
