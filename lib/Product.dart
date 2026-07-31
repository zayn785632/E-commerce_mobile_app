class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final List<String> images;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.images,
    required this.quantity,
  });

  // ADD THIS FACTORY METHOD TO READ FROM SUPABASE:
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: (map['id'] ?? 0) as int,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      quantity: (map['quantity'] ?? 1) as int,
    );
  }
}
