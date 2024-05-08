class Section {
  final int id;
  final int book_id;
  final String book_name;
  final int chapter_id;
  final int section_id;
  final String title;
  final String preface;
  final String number;
  final Hadith hadith;

  Section({
    required this.id,
    required this.book_id,
    required this.book_name,
    required this.chapter_id,
    required this.section_id,
    required this.title,
    required this.preface,
    required this.number,
    required this.hadith
  });

  factory Section.fromMap(Map<String, dynamic> map) {
    return Section(
      id: map['id'],
      book_id: map['book_id'],
      book_name: map['book_name'],
      chapter_id: map["chapter_id"],
      section_id: map["section_id"],
      title: map["title"],
      preface: map["preface"],
      number: map["number"],
      hadith: Hadith.fromMap(map),
    );
  }
}

class Hadith{
  final int hadith_id;
  final int book_id;
  final String book_name;
  final int chapter_id;
  final int section_id;
  final String narrator;
  final String bn;
  final String ar;
  final String ar_diacless;
  final String note;
  final int grade_id;
  final String grade;
  final String grade_color;

  Hadith({
    required this.hadith_id,
    required this.book_id,
    required this.book_name,
    required this.chapter_id,
    required this.section_id,
    required this.narrator,
    required this.bn,
    required this.ar,
    required this.ar_diacless,
    required this.note,
    required this.grade_id,
    required this.grade,
    required this.grade_color,
  });

  factory Hadith.fromMap(Map<String, dynamic> map) {
    return Hadith(
      hadith_id: map['hadith_id'],
      book_id: map['book_id'],
      book_name: map['book_name'],
      chapter_id: map["chapter_id"],
      section_id: map["section_id"],
      narrator: map["narrator"],
      bn: map["bn"],
      ar: map["ar"],
      ar_diacless: map["ar_diacless"],
      note: map["note"],
      grade_id: map["grade_id"],
      grade: map["grade"],
      grade_color: map["grade_color"],
    );
  }
}