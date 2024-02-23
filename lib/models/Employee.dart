class Employee {
  final String image;
  final int idx;
  final String id;
  final String name;
  final String position;
  final String department;

  Employee(
      {required this.image,
      required this.idx,
      required this.id,
      required this.name,
      required this.position,
      required this.department});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      image: json['image'],
      idx: json['idx'],
      id: json['id'],
      name: json['name'],
      position: json['position'],
      department: json['department'],
    );
  }
}
