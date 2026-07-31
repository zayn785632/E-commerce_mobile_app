import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Product.dart';
import '../Card/ProductCard.dart'; // Ensure this points to your ProductCard.dart

class CategoriesTabBar extends StatefulWidget {
  const CategoriesTabBar({super.key});

  @override
  State<CategoriesTabBar> createState() => _CategoriesTabBarState();
}

class _CategoriesTabBarState extends State<CategoriesTabBar> {
  int selectedIndex = 0;

  final _categoriesStream = Supabase.instance.client
      .from('categories')
      .stream(primaryKey: ['id']).order('id', ascending: true);

  final _productsStream = Supabase.instance.client
      .from('products')
      .stream(primaryKey: ['id']).order('id', ascending: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _categoriesStream,
      builder: (context, catSnapshot) {
        if (catSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!catSnapshot.hasData || catSnapshot.data!.isEmpty) {
          return const Center(child: Text("No categories found."));
        }

        final categories = catSnapshot.data!;
        final selectedCategoryName = categories[selectedIndex]['name'] ?? 'All';

        return Column(
          children: [
            // 1. Horizontal Category Tabs (Untouched UI)
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryName = categories[index]['name'] ?? '';
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          categoryName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black54,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            // 2. Dynamic Category-Wise Product Grid (Using your exact ProductCard!)
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _productsStream,
                builder: (context, prodSnapshot) {
                  if (prodSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!prodSnapshot.hasData || prodSnapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No products added yet.\nAdd some from the Admin Panel!",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  // Filter products by selected category
                  final allProducts = prodSnapshot.data!
                      .map((map) => Product.fromMap(map))
                      .toList();

                  final filteredProducts = selectedCategoryName == 'All'
                      ? allProducts
                      : allProducts
                          .where((p) =>
                              p.category.toLowerCase() ==
                              selectedCategoryName.toLowerCase())
                          .toList();

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text(
                        "No products found in '$selectedCategoryName'",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: filteredProducts[index]);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
