import 'Product.dart';

class MyProducts {
  static List<Product> menProducts = [
    Product(
      id: 1,
      name: "Off White Oversized Shirt Long Sleeve",
      category: "Men",
      price: 45.95,
      description:
          "The Unisex Long Sleeve Oversized Shirt in Off White by Gorur Ghash is your new anchor for effortless earth-toned street style. This isn’t just a basic button-down; it’s a masterclass in relaxed proportions and rugged utility.",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy-2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9097-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),
    Product(
      id: 1,
      name: "Brown Oversized Shirt Long Sleeve",
      category: "Men",
      price: 45.95,
      description:
          "The Unisex Long Sleeve Oversized Shirt in Off White by Gorur Ghash is your new anchor for effortless earth-toned street style. This isn’t just a basic button-down; it’s a masterclass in relaxed proportions and rugged utility.",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9075-copy-2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9080-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),
    Product(
      id: 1,
      name: "Half Sleeve Embroidered Boxy Shirt in Cream",
      category: "Men",
      price: 45.95,
      description:
          "The Unisex Long Sleeve Oversized Shirt in Off White by Gorur Ghash is your new anchor for effortless earth-toned street style. This isn’t just a basic button-down; it’s a masterclass in relaxed proportions and rugged utility.",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/05/DSC0713-copy2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9097-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),

    // Add more men's products here
  ];

  static List<Product> womenProducts = [
    Product(
      id: 11,
      name: "Floral Printed Kaftan Top in White",
      category: "Women",
      price: 32.95,
      description: "fsjfsdf",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/05/DSC0765-copy-2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9097-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),
    Product(
      id: 11,
      name: "METALLIC THREAD FLORAL PRINT SHIRT",
      category: "Women",
      price: 32.95,
      description: "fsjfsdf",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy-2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9097-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),
    Product(
      id: 11,
      name: "METALLIC THREAD FLORAL PRINT SHIRT",
      category: "Women",
      price: 32.95,
      description: "fsjfsdf",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy-2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9097-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),
    Product(
      id: 11,
      name: "METALLIC THREAD FLORAL PRINT SHIRT",
      category: "Women",
      price: 32.95,
      description: "fsjfsdf",
      images: [
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy-2.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9097-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9096-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9094-copy.jpg",
        "https://gorurghash.com/wp-content/uploads/2026/03/DSC9092-copy.jpg"
      ],
      quantity: 1,
    ),

    // Add more women's products here
  ];

  static List<Product> getAllProducts() {
    List<Product> allProducts = [];
    allProducts.addAll(menProducts);
    allProducts.addAll(womenProducts);
    return allProducts;
  }
}
