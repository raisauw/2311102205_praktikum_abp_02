import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Kamera & Notifikasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Plugin notifikasi lokal
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  // Inisialisasi setting notifikasi lokal
  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  // Menampilkan notifikasi lokal
  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'foto_channel', // channel id
      'Notifikasi Foto', // channel name
      channelDescription: 'Notifikasi setelah foto diambil/dipilih',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notifDetails =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0,
      'Berhasil!',
      message,
      notifDetails,
    );
  }

  // Ambil foto langsung dari kamera
  Future<void> _ambilFotoDariKamera() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.camera);

    if (foto != null) {
      setState(() {
        _selectedImage = File(foto.path);
      });
      await _showNotification('Foto berhasil diambil dari kamera!');
    }
  }

  // Pilih foto dari galeri
  Future<void> _pilihFotoDariGaleri() async {
    final XFile? foto = await _picker.pickImage(source: ImageSource.gallery);

    if (foto != null) {
      setState(() {
        _selectedImage = File(foto.path);
      });
      await _showNotification('Foto berhasil dipilih dari galeri!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi & API Perangkat Keras'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Area tampilan foto
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Text(
                          'Belum ada foto dipilih',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Kamera
            ElevatedButton.icon(
              onPressed: _ambilFotoDariKamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ambil Foto (Kamera)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Galeri
            ElevatedButton.icon(
              onPressed: _pilihFotoDariGaleri,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih Foto (Galeri)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
