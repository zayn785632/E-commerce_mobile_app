import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen>
    with SingleTickerProviderStateMixin {
  final String adminId = "admin";
  final String adminPass = "admin123";

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Category Form
  final TextEditingController _categoryController = TextEditingController();

  // Product Form
  final TextEditingController _prodNameController = TextEditingController();
  final TextEditingController _prodPriceController = TextEditingController();
  final TextEditingController _prodDescController = TextEditingController();
  String? _selectedCategory;
  List<XFile> _selectedImages = [];

  bool _isLoggedIn = false;
  bool _isLoading = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _login() {
    if (_idController.text.trim() == adminId &&
        _passController.text.trim() == adminPass) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Admin ID or Password!")),
      );
    }
  }

  Future<void> _addCategory() async {
    final name = _categoryController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('categories').insert({'name': name});
      _categoryController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Category '$name' added successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  Future<void> _addProduct() async {
    if (_prodNameController.text.isEmpty ||
        _prodPriceController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields and pick at least 1 image!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<String> uploadedImageUrls = [];

      // 1. Upload images from local machine to Supabase Storage
      for (XFile file in _selectedImages) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
        final imageBytes = await file.readAsBytes();

        await Supabase.instance.client.storage
            .from('product-images')
            .uploadBinary(fileName, imageBytes);

        final imageUrl = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl(fileName);

        uploadedImageUrls.add(imageUrl);
      }

      // 2. Insert product into Supabase table
      await Supabase.instance.client.from('products').insert({
        'name': _prodNameController.text.trim(),
        'price': double.tryParse(_prodPriceController.text.trim()) ?? 0.0,
        'description': _prodDescController.text.trim(),
        'category': _selectedCategory,
        'images': uploadedImageUrls,
        'quantity': 1,
      });

      _prodNameController.clear();
      _prodPriceController.clear();
      _prodDescController.clear();
      setState(() {
        _selectedImages.clear();
        _selectedCategory = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product added successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding product: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Area"),
        backgroundColor: Colors.white,
        bottom: _isLoggedIn
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                tabs: const [
                  Tab(text: "Add Category"),
                  Tab(text: "Add Product"),
                ],
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _isLoggedIn
            ? TabBarView(
                controller: _tabController,
                children: [
                  _buildCategoryForm(),
                  _buildProductForm(),
                ],
              )
            : _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 64, color: Colors.black),
        const SizedBox(height: 20),
        const Text("Admin Access Required",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        TextField(
          controller: _idController,
          decoration: const InputDecoration(
              labelText: "Admin ID", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _passController,
          obscureText: true,
          decoration: const InputDecoration(
              labelText: "Password", border: OutlineInputBorder()),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: _login,
            child: const Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
                labelText: "Category Name", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: _isLoading ? null : _addCategory,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Category",
                      style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextField(
            controller: _prodNameController,
            decoration: const InputDecoration(
                labelText: "Product Name", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _prodPriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: "Price (EUR)", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _prodDescController,
            maxLines: 3,
            decoration: const InputDecoration(
                labelText: "Description", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),

          // Dynamic Category Dropdown from Supabase
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('categories')
                .stream(primaryKey: ['id']),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();
              final categories = snapshot.data!;
              return DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                    labelText: "Select Category", border: OutlineInputBorder()),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat['name'],
                    child: Text(cat['name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
              );
            },
          ),
          const SizedBox(height: 15),

          // Image Picker Button
          OutlinedButton.icon(
            onPressed: _pickImages,
            icon: const Icon(Icons.image, color: Colors.black),
            label: Text(
              _selectedImages.isEmpty
                  ? "Pick Images from Device"
                  : "${_selectedImages.length} Image(s) Selected",
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: _isLoading ? null : _addProduct,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Product",
                      style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
