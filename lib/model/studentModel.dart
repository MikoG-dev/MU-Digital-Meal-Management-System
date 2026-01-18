class StudentModel {
  late String name;
  late String idNo;
  late String gender;
  late String entryYear;
  late String program;
  late String? image;
  StudentModel(
      {required this.name,
      required this.idNo,
      required this.gender,
      required this.entryYear,
      required this.program,
      this.image});
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
        idNo: map['id'],
        name: map['name'],
        gender: map['gender'],
        entryYear: map['entryYear'],
        program: map['program'],
        image: map['image']);
  }
}
