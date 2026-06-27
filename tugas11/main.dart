import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product.dart';
import 'cart_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(),
      child: MaterialApp(
        title: 'Daftar Produk dengan Cubit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ProductPage(),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        centerTitle: true,
        actions: [
          // Menampilkan jumlah item di keranjang secara real-time
          BlocBuilder<CartCubit, List<Product>>(
            builder: (context, cartItems) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Stack(
                    children: [
                      const Icon(Icons.shopping_cart, size: 28),
                      if (cartItems.isNotEmpty)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              '${cartItems.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, size: 36),
              title: Text(product.name),
              subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Menambahkan produk ke keranjang lewat Cubit
                  context.read<CartCubit>().addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} ditambahkan ke keranjang'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text('Tambah'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
        icon: const Icon(Icons.shopping_cart_checkout),
        label: const Text('Lihat Keranjang'),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Hapus Semua',
            onPressed: () {
              context.read<CartCubit>().clearCart();
            },
          ),
        ],
      ),
      // BlocBuilder membangun ulang UI setiap kali state keranjang berubah
      body: BlocBuilder<CartCubit, List<Product>>(
        builder: (context, cartItems) {
          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final product = cartItems[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(product.name),
                      subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          // Menghapus produk dari keranjang lewat Cubit
                          context.read<CartCubit>().removeFromCart(index);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: Rp ${context.read<CartCubit>().totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
