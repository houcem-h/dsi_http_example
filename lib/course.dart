class  Course {
  String id;
  String title;
  String description;
  String image;
  String last_update;
  String instructor;
  String language;
  num price;
  List goals;
  List requirements;

  Course(
      this.id,
      this.title,
      this.description,
      this.image,
      this.last_update,
      this.instructor,
      this.language,
      this.price,
      this.goals,
      this.requirements);
}