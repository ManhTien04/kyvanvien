class Story{
  String name;
  String chapter;
  String imagePath;
  String rating;
  // String gener;
  // String author;
  // String description;
  // String type;

  Story({
    required this.name,
    required this.chapter,
    required this.imagePath,
    required this.rating,
    // required this.gener,
    // required this.author,
    // required this.description,
    // required this.type,
  });

  String get _name=> name;
  String get _chapter=>chapter ;
  String get _imagePath=>imagePath ;
  String get _rating=>rating ;
  // String get _gener=>gener ;
  // String get _author=> author;
  // String get _description=>description ;
  // String get _type=>type ;
}