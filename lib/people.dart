class People{
  String personName;
  int personAge;

  People(this.personName, this.personAge);

  factory People.fromJson(Map<dynamic, dynamic> json){
    return People(json["personName"] as String, json["personAge"] as int);
  }
}