class Resource {
  String isBooked;
  bool isMine;
  int idx; // Make sure to have an identifier for the resource

  Resource({required this.isBooked, required this.isMine, required this.idx});

  factory Resource.fromJson(Map<String, dynamic> json, index) {
    return Resource(
      isBooked: json['isBooked'],
      isMine: json['isMine'],
      idx: index
    );
  }

  factory Resource.clone(Resource other) {
    return Resource(
        isBooked: other.isBooked, isMine: other.isMine, idx: other.idx);
  }
}

class Category {
  final int id;
  final List<Resource> resources;
  bool isExpanded = false;

  Category({required this.id, required this.resources});
}
