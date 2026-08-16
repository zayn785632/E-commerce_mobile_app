import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  // Category Form
  final TextEditingController _categoryController = TextEditingController();

  // Product Form
  final TextEditingController _prodNameController = TextEditingController();
  final TextEditingController _prodPriceController = TextEditingController();
  final TextEditingController _prodDescController = TextEditingController();
  String? _selectedCategory;

  List<XFile> _selectedImages = [];
  List<Uint8List> _imageBytes = []; // For fast rendering of previews

  bool _isLoading = false;

  // --- CATEGORY UPLOAD LOGIC ---
  Future<void> _addCategory() async {
    final name = _categoryController.text.trim();
    if (name.isEmpty) {
      Get.snackbar("Missing Field", "Please enter a category name.",
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('categories').insert({'name': name});
      _categoryController.clear();
      Get.snackbar("Success", "Category '$name' added!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Could not add category.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- IMAGE PICKER LOGIC ---
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      List<Uint8List> bytesList = [];
      for (var img in images) {
        bytesList.add(await img
            .readAsBytes()); // Read safely for web/mobile compatibility
      }
      setState(() {
        _selectedImages = images;
        _imageBytes = bytesList;
      });
    }
  }

  // --- PRODUCT UPLOAD LOGIC ---
  Future<void> _addProduct() async {
    if (_prodNameController.text.isEmpty ||
        _prodPriceController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedImages.isEmpty) {
      Get.snackbar("Missing Fields",
          "Please fill all details and pick at least 1 image.",
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);

    try {
      List<String> uploadedImageUrls = [];

      // 1. Upload images to Supabase Storage
      for (int i = 0; i < _selectedImages.length; i++) {
        final file = _selectedImages[i];
        final bytes = _imageBytes[i];
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${file.name}';

        await Supabase.instance.client.storage
            .from('product-images')
            .uploadBinary(fileName, bytes);
        final imageUrl = Supabase.instance.client.storage
            .from('product-images')
            .getPublicUrl(fileName);
        uploadedImageUrls.add(imageUrl);
      }

      // 2. Insert into Products Database
      await Supabase.instance.client.from('products').insert({
        'name': _prodNameController.text.trim(),
        'price': double.tryParse(_prodPriceController.text.trim()) ?? 0.0,
        'description': _prodDescController.text.trim(),
        'category': _selectedCategory,
        'images': uploadedImageUrls,
        'quantity': 1,
      });

      // Clear Form
      _prodNameController.clear();
      _prodPriceController.clear();
      _prodDescController.clear();
      setState(() {
        _selectedImages.clear();
        _imageBytes.clear();
        _selectedCategory = null;
      });

      Get.snackbar("Success", "Product added successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Could not upload product.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9F9FB),
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF18181A)),
              onPressed: () => Get.back()),
          title: const Text("Catalog Manager",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Color(0xFF18181A),
                  letterSpacing: -0.5)),
          bottom: const TabBar(
            indicatorColor: Color(0xFF18181A),
            labelColor: Color(0xFF18181A),
            unselectedLabelColor: Colors.grey,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            tabs: [
              Tab(text: "New Category"),
              Tab(text: "New Product"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            _buildCategoryForm(),
            _buildProductForm(),
          ],
        ),
      ),
    );
  }

  // --- CATEGORY TAB ---
  Widget _buildCategoryForm() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Create Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text("Add a new category label to organize your store.",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          _buildInput(
              controller: _categoryController,
              hint: "e.g., Summer Collection, Jackets",
              icon: Iconsax.category),
          const Spacer(),
          _buildSubmitButton(title: "Save Category", onTap: _addCategory),
        ],
      ),
    );
  }

  // --- PRODUCT TAB ---
  Widget _buildProductForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Product Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          _buildInput(
              controller: _prodNameController,
              hint: "Product Name",
              icon: Iconsax.box),
          const SizedBox(height: 16),
          _buildInput(
              controller: _prodPriceController,
              hint: "Price (EUR)",
              icon: Iconsax.money,
              isNumber: true),
          const SizedBox(height: 16),
          _buildInput(
              controller: _prodDescController,
              hint: "Detailed Description",
              icon: Iconsax.textalign_left,
              maxLines: 3),
          const SizedBox(height: 16),

          // Live Category Dropdown
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('categories')
                .stream(primaryKey: ['id']),
            builder: (context, snapshot) {
              final categories = snapshot.data ?? [];
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFF0F0F3), width: 1.5)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text("Select Category",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600)),
                    icon: const Icon(Iconsax.arrow_down_1, size: 20),
                    items: categories
                        .map((cat) => DropdownMenuItem<String>(
                            value: cat['name'],
                            child: Text(cat['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700))))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Image Selection Area
          const Text("Product Images",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          if (_imageBytes.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageBytes.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: MemoryImage(_imageBytes[index]),
                          fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8ECEF))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.image, color: Color(0xFF18181A), size: 20),
                  const SizedBox(width: 8),
                  Text(
                      _selectedImages.isEmpty
                          ? "Upload Images"
                          : "Change Images",
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF18181A))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildSubmitButton(title: "Publish Product", onTap: _addProduct),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- REUSABLE UI COMPONENTS ---
  Widget _buildInput(
      {required TextEditingController controller,
      required String hint,
      required IconData icon,
      bool isNumber = false,
      int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F3), width: 1.5)),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Icon(icon, color: Colors.grey, size: 20)),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      {required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color(0xFF18181A),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF18181A).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ]),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2)
              : Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}
