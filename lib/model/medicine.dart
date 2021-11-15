
class Medicine{
  String name;
  String className;
  String? dose;
  String strength;

  Medicine.fromJson(Map<String, dynamic> data,String className):
      this.className = className,
      this.name=data['name'],
  this.dose = data['dose'],
  this.strength=data['strength'];

}