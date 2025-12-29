class Product {
  final String id;
  final String crop;
  final String quantity;
  final String price;
  final String location;
  final String date;
  final String syncStatus;
  final String traceId;
  final String? seller;
  final String? district;
  final String? imagePath;
  final String? audioPath;
  final String? noveltyTag;

  Product({
    required this.id,
    required this.crop,
    required this.quantity,
    required this.price,
    required this.location,
    required this.date,
    required this.syncStatus,
    required this.traceId,
    this.seller,
    this.district,
    this.imagePath,
    this.audioPath,
    this.noveltyTag,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'crop': crop,
    'quantity': quantity,
    'price': price,
    'location': location,
    'date': date,
    'syncStatus': syncStatus,
    'traceId': traceId,
    'seller': seller,
    'district': district,
    'imagePath': imagePath,
    'audioPath': audioPath,
    'noveltyTag': noveltyTag,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    crop: json['crop'],
    quantity: json['quantity'],
    price: json['price'],
    location: json['location'],
    date: json['date'],
    syncStatus: json['syncStatus'],
    traceId: json['traceId'],
    seller: json['seller'],
    district: json['district'],
    imagePath: json['imagePath'],
    audioPath: json['audioPath'],
    noveltyTag: json['noveltyTag'],
  );
}
