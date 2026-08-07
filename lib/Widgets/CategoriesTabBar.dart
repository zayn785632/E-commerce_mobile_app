import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Product.dart';
import '../Card/ProductCard.dart';

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
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF18181A)),
          );
        }

        if (!catSnapshot.hasData || catSnapshot.data!.isEmpty) {
          return const Center(child: Text("No categories found."));
        }

        // --- KEEP "ALL" STRICTLY AT INDEX 0 ---
        final rawCategories =
            List<Map<String, dynamic>>.from(catSnapshot.data!);

        final allCategory = rawCategories.firstWhere(
          (c) => (c['name'] ?? '').toString().toLowerCase() == 'all',
          orElse: () => {'id': 0, 'name': 'All'},
        );

        rawCategories.removeWhere(
          (c) => (c['name'] ?? '').toString().toLowerCase() == 'all',
        );

        final categories = [allCategory, ...rawCategories];
        // ----------------------------------------

        final selectedCategoryName = categories[selectedIndex]['name'] ?? 'All';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SLEEK LOOKBOOK CATEGORY SLIDER
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryName = categories[index]['name'] ?? 'Unnamed';
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF18181A)
                            : const Color(0xFFF4F5F8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color:
                                      const Color(0xFF18181A).withOpacity(0.25),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF5E1F), // Warm orange dot
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            categoryName,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF6E6E73),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 2. PRODUCTS WITH EDITORIAL LOOKBOOK HEADER
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _productsStream,
                builder: (context, prodSnapshot) {
                  if (prodSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF5E1F),
                      ),
                    );
                  }

                  if (prodSnapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error loading products:\n${prodSnapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
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

                  final allProducts = prodSnapshot.data!
                      .map((map) => Product.fromMap(map))
                      .toList();

                  final filteredProducts =
                      selectedCategoryName.toString().toLowerCase() == 'all'
                          ? allProducts
                          : allProducts
                              .where((p) =>
                                  p.category.toLowerCase() ==
                                  selectedCategoryName.toString().toLowerCase())
                              .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Collection Sub-header Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  selectedCategoryName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF18181A),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF5E1F)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${filteredProducts.length} ITEMS",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFFF5E1F),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Iconsax.grid_5,
                              size: 18,
                              color: Color(0xFF8E8E93),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Magazine Grid
                      Expanded(
                        child: filteredProducts.isEmpty
                            ? Center(
                                child: Text(
                                  "No products found in '$selectedCategoryName'",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 4, 20, 20),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      0.56, // Editorial magazine card ratio
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 18,
                                ),
                                itemCount: filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: filteredProducts[index],
                                  );
                                },
                              ),
                      ),
                    ],
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
