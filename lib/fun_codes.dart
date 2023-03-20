import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

String normalize(String text) {
  text = text.trim();
  text = text.replaceAll("إ", "ا");
  text = text.replaceAll("أ", "ا");
  text = text.replaceAll("ٱ", "ا");
  text = text.replaceAll("آ", "ا");
  text = text.replaceAll("ا", "ا");
  text = text.replaceAll("ى", "ي");
  text = text.replaceAll("ؤ", "ء");
  text = text.replaceAll("ئ", "ء");
  text = text.replaceAll("ة", "ه");
  return text;
}

Future<String> find_ayah(String text) async {
  var input;
  var quran_map;
  var normalized_text = normalize(text);
  var words_list = normalized_text.split(' ');
  var match_list = [];

  input = await rootBundle.loadString('assets/index.json');
  quran_map = jsonDecode(input);
  //print(quran_map['احد']);

  for (var i in words_list) {
    try {
      print(i);
      match_list.add(quran_map[i]);
    } catch (e) {
      print(e);
      continue;
    }
  }
  //print(match_list);

  // print(res);
  // print(res.elementAt(0));
  if (match_list.length == 0) {
    final res = {''};
    return res.elementAt(0);
  } else {
    final res = match_list.fold<Set<String>>(
      match_list.first.keys.toSet(),
      (result, map) => result.intersection(map.keys.toSet()),
    );
    if (res.length == 0) {
      return "not found";
    } else {
      return res.elementAt(0);
    }
  }

  // return res.elementAt(0).toString();
}

Future<String> get_surah_name(String ayah) async {
  if (ayah == '') {
    return 'لا يوجد';
  } else if (ayah == Null) {
    return 'Null';
  }
  String ayah_ID = await find_ayah(ayah);
  if (ayah_ID == 'not found') {
    return 'لا يوجد';
  } else {
    var surah_id = ayah_ID.substring(0, 3);
    //print(surah_id);
    var num = int.parse(surah_id) - 1;
    var arr = [
      'الفاتحة',
      'البقرة',
      'آل عمران',
      'النساء',
      'المائدة',
      'الأنعام',
      'الأعراف',
      'الأنفال',
      'التوبة',
      'يونس',
      'هود',
      'يوسف',
      'الرعد',
      'إبراهيم',
      'الحجر',
      'النحل',
      'الإسراء',
      'الكهف',
      'مريم',
      'طه',
      'الأنبياء',
      'الحج',
      'المؤمنون',
      'النور',
      'الفرقان',
      'الشعراء',
      'النمل',
      'القصص',
      'العنكبوت',
      'الروم',
      'لقمان',
      'السجدة',
      'الأحزاب',
      'سبأ',
      'فاطر',
      'يس',
      'الصافات',
      'ص',
      'الزمر',
      'غافر',
      'فصلت',
      'الشورى',
      'الزخرف',
      'الدخان',
      'الجاثية',
      'الأحقاف',
      'محمد',
      'الفتح',
      'الحجرات',
      'ق',
      'الذاريات',
      'الطور',
      'النجم',
      'القمر',
      'الرحمن',
      'الواقعة',
      'الحديد',
      'المجادلة',
      'الحشر',
      'الممتحنة',
      'الصف',
      'الجمعة',
      'المنافقون',
      'التغابن',
      'الطلاق',
      'التحريم',
      'الملك',
      'القلم',
      'الحاقة',
      'المعارج',
      'نوح',
      'الجن',
      'المزّمِّل',
      'المدّثر',
      'القيامة',
      'الإنسان',
      'المرسلات',
      'النبأ',
      'النازعات',
      'عبس',
      'التكوير',
      'الإنفطار',
      'المطففين',
      'الانشقاق',
      'البروج',
      'الطارق',
      'الأعلى',
      'الغاشية',
      'الفجر',
      'البلد',
      'الشمس',
      'الليل',
      'الضحى',
      'الشرح',
      'التين',
      'العلق',
      'القدر',
      'البينة',
      'الزلزلة',
      'العاديات',
      'القارعة',
      'التكاثر',
      'العصر',
      'الهُمَزَة',
      'الفيل',
      'قريش',
      'الماعون',
      'الكوثر',
      'الكافرون',
      'النصر',
      'المسد',
      'الإخلاص',
      'الفلق',
      'الناس'
    ];
    return arr[num].toString();
  }
}

Future<String> get_surah_num(String ayah) async {
  if (ayah == '') {
    return 'لا يوجد';
  } else if (ayah == Null) {
    return 'Null';
  }
  String ayah_ID = await find_ayah(ayah);
  if (ayah_ID == 'not found') {
    return 'لا يوجد';
  } else {
    var surah_num = ayah_ID.substring(0, 3);
    int surah_int = int.parse(surah_num);

    if (surah_int < 10) {
      // print(ayah_ID.substring(2,3));
      return ayah_ID.substring(2, 3).toString();
    } else if (surah_int >= 10 && surah_int < 100) {
      // print(ayah_ID.substring(1,3));
      return ayah_ID.substring(1, 3).toString();
    }

    return surah_num.toString();
  }
}

Future<String> get_ayah_num(String ayah) async {
  if (ayah == '') {
    return 'لا يوجد';
  } else if (ayah == Null) {
    return 'Null';
  }
  String ayah_ID = await find_ayah(ayah);
  if (ayah_ID == 'not found') {
    return 'لا يوجد';
  } else {
    var ayah_num = ayah_ID.substring(3, 6);
    int ayah_int = int.parse(ayah_num);

    if (ayah_int < 10) {
      // print(ayah_ID.substring(5,6));
      return ayah_ID.substring(5, 6).toString();
    } else if (ayah_int >= 10 && ayah_int < 100) {
      // print(ayah_ID.substring(4,6));
      return ayah_ID.substring(4, 6).toString();
    }

    return ayah_num.toString();
  }
}

Future<String> get_surah_chapter(String ayah) async {
  if (ayah == '') {
    return 'لا يوجد';
  } else if (ayah == Null) {
    return 'Null';
  }
  String name = await get_surah_name(ayah);
  if (name == 'لا يوجد') {
    return 'لا يوجد';
  } else {
    var chapterMap = {
      'الفاتحة': 1,
      'البقرة': 1,
      'آل عمران': 3,
      'النساء': 4,
      'المائدة': 6,
      'الأنعام': 7,
      'الأعراف': 8,
      'الأنفال': 9,
      'التوبة': 10,
      'يونس': 11,
      'هود': 11,
      'يوسف': 12,
      'الرعد': 13,
      'إبراهيم': 13,
      'الحجر': 14,
      'النحل': 14,
      'الإسراء': 15,
      'الكهف': 15,
      'مريم': 16,
      'طه': 16,
      'الأنبياء': 17,
      'الحج': 17,
      'المؤمنون': 18,
      'النور': 18,
      'الفرقان': 18,
      'الشعراء': 19,
      'النمل': 19,
      'القصص': 20,
      'العنكبوت': 20,
      'الروم': 21,
      'لقمان': 21,
      'السجدة': 21,
      'الأحزاب': 21,
      'سبأ': 22,
      'فاطر': 22,
      'يس': 22,
      'الصافات': 23,
      'ص': 23,
      'الزمر': 23,
      'غافر': 24,
      'فصلت': 24,
      'الشورى': 25,
      'الزخرف': 25,
      'الدخان': 25,
      'الجاثية': 25,
      'الأحقاف': 25,
      'محمد': 26,
      'الفتح': 26,
      'الحجرات': 26,
      'ق': 26,
      'الذاريات': 26,
      'الطور': 27,
      'النجم': 27,
      'القمر': 27,
      'الرحمن': 27,
      'الواقعة': 27,
      'الحديد': 27,
      'المجادلة': 28,
      'الحشر': 28,
      'الممتحنة': 28,
      'الصف': 28,
      'الجمعة': 28,
      'المنافقون': 28,
      'التغابن': 28,
      'الطلاق': 28,
      'التحريم': 28,
      'الملك': 29,
      'القلم': 29,
      'الحاقة': 29,
      'المعارج': 29,
      'نوح': 29,
      'الجن': 29,
      'المزّمِّل': 29,
      'المدّثر': 29,
      'القيامة': 29,
      'الإنسان': 29,
      'المرسلات': 29,
      'النبأ': 30,
      'النازعات': 30,
      'عبس': 30,
      'التكوير': 30,
      'الإنفطار': 30,
      'المطففين': 30,
      'الانشقاق': 30,
      'البروج': 30,
      'الطارق': 30,
      'الأعلى': 30,
      'الغاشية': 30,
      'الفجر': 30,
      'البلد': 30,
      'الشمس': 30,
      'الليل': 30,
      'الضحى': 30,
      'الشرح': 30,
      'التين': 30,
      'العلق': 30,
      'القدر': 30,
      'البينة': 30,
      'الزلزلة': 30,
      'العاديات': 30,
      'القارعة': 30,
      'التكاثر': 30,
      'العصر': 30,
      'الهُمَزَة': 30,
      'الفيل': 30,
      'قريش': 30,
      'الماعون': 30,
      'الكوثر': 30,
      'الكافرون': 30,
      'النصر': 30,
      'المسد': 30,
      'الإخلاص': 30,
      'الفلق': 30,
      'الناس': 30
    };

    var chapter = chapterMap[name].toString();
    return chapter.toString();
  }
}

Future<String> get_img_url(String ayah) async {
  if (ayah == '') {
    return 'https://assets.stickpng.com/images/60fea5143d624000048712b3.png';
  } else {
    String surahNum = await get_surah_num(ayah);
    String ayahNum = await get_ayah_num(ayah);
    if (surahNum == 'لا يوجد' || ayahNum == 'لا يوجد') {
      return 'https://assets.stickpng.com/images/60fea5143d624000048712b3.png';
    } else {
      String general_img_url =
          'http://www.everyayah.com/data/images_png/surahNum_ayahNum.png';
      String ayah_img_url = general_img_url.replaceAll(
          'surahNum_ayahNum', '${surahNum}_${ayahNum}');
      if (ayah_img_url == 'http://www.everyayah.com/data/images_png/_.png') {
        return 'https://assets.stickpng.com/images/60fea5143d624000048712b3.png';
      } else {
        return ayah_img_url;
      }
    }
  }
}

Future<String> get_voice_url(String ayah) async {
  if (ayah == '') {
    return 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/001001.mp3';
  } else {
    String ayah_ID = await find_ayah(ayah);
    if (ayah_ID == 'not found') {
      return 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/001001.mp3';
    } else {
      String general_voice_url =
          'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/ayah_id.mp3';
      String ayah_voice_url = general_voice_url.replaceAll('ayah_id', ayah_ID);
      if (ayah_voice_url ==
          'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/ayah_id.mp3') {
        return 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/001001.mp3';
      } else {
        // print(ayah_voice_url);
        return ayah_voice_url;
      }
    }
  }
}

Future<String> get_ayah_tafseer(String ayah) async {
  var input;
  var tafseer_map;
  if (ayah == '') {
    return 'لا يوجد';
  } else {
    String ayah_ID = await find_ayah(ayah);
    if (ayah_ID == 'not found') {
      return 'لا يوجد';
    } else {
      input = await rootBundle.loadString('assets/tafseerIndex.json');
      tafseer_map = jsonDecode(input);
      return tafseer_map['${ayah_ID}'];
    }
  }
}

//*********************************************************************//
//*********************************************************************//

// depends on user input
Future<List> find_occurrences(String text) async {
  var input;
  var quran_map;
  var normalized_text = normalize(text);
  var words_list = normalized_text.split(' ');
  var match_list = [];

  input = await rootBundle.loadString('assets/index.json');
  quran_map = jsonDecode(input);
  //print(quran_map['احد']);

  for (var i in words_list) {
    try {
      print(i);
      match_list.add(quran_map[i]);
    } catch (e) {
      print(e);
      continue;
    }
  }
  //print(match_list);

  // print(res);
  // print(res.elementAt(0));
  if (match_list.length == 0) {
    List res = [];
    return res;
  } else {
    var res = match_list.fold<Set<String>>(
      match_list.first.keys.toSet(),
      (result, map) => result.intersection(map.keys.toSet()),
    );
    if (res.length == 0) {
      res = {};
      return res.toList();
    } else {
      return res.toList();
    }
  }
}

// depends on find_occurrences
Future<String> get_surah_name1(String ayahid) async {
  if (ayahid == '') {
    return 'لا يوجد';
  } else if (ayahid == Null) {
    return 'Null';
  }
  String ayah_ID = ayahid;
  if (ayah_ID == 'not found') {
    return 'لا يوجد';
  } else {
    var surah_id = ayah_ID.substring(0, 3);
    //print(surah_id);
    var num = int.parse(surah_id) - 1;
    var arr = [
      'الفاتحة',
      'البقرة',
      'آل عمران',
      'النساء',
      'المائدة',
      'الأنعام',
      'الأعراف',
      'الأنفال',
      'التوبة',
      'يونس',
      'هود',
      'يوسف',
      'الرعد',
      'إبراهيم',
      'الحجر',
      'النحل',
      'الإسراء',
      'الكهف',
      'مريم',
      'طه',
      'الأنبياء',
      'الحج',
      'المؤمنون',
      'النور',
      'الفرقان',
      'الشعراء',
      'النمل',
      'القصص',
      'العنكبوت',
      'الروم',
      'لقمان',
      'السجدة',
      'الأحزاب',
      'سبأ',
      'فاطر',
      'يس',
      'الصافات',
      'ص',
      'الزمر',
      'غافر',
      'فصلت',
      'الشورى',
      'الزخرف',
      'الدخان',
      'الجاثية',
      'الأحقاف',
      'محمد',
      'الفتح',
      'الحجرات',
      'ق',
      'الذاريات',
      'الطور',
      'النجم',
      'القمر',
      'الرحمن',
      'الواقعة',
      'الحديد',
      'المجادلة',
      'الحشر',
      'الممتحنة',
      'الصف',
      'الجمعة',
      'المنافقون',
      'التغابن',
      'الطلاق',
      'التحريم',
      'الملك',
      'القلم',
      'الحاقة',
      'المعارج',
      'نوح',
      'الجن',
      'المزّمِّل',
      'المدّثر',
      'القيامة',
      'الإنسان',
      'المرسلات',
      'النبأ',
      'النازعات',
      'عبس',
      'التكوير',
      'الإنفطار',
      'المطففين',
      'الانشقاق',
      'البروج',
      'الطارق',
      'الأعلى',
      'الغاشية',
      'الفجر',
      'البلد',
      'الشمس',
      'الليل',
      'الضحى',
      'الشرح',
      'التين',
      'العلق',
      'القدر',
      'البينة',
      'الزلزلة',
      'العاديات',
      'القارعة',
      'التكاثر',
      'العصر',
      'الهُمَزَة',
      'الفيل',
      'قريش',
      'الماعون',
      'الكوثر',
      'الكافرون',
      'النصر',
      'المسد',
      'الإخلاص',
      'الفلق',
      'الناس'
    ];
    return arr[num].toString();
  }
}

// depends on find_occurrences
Future<String> get_surah_num1(String ayahid) async {
  if (ayahid == '') {
    return 'لا يوجد';
  } else if (ayahid == Null) {
    return 'Null';
  }
  String ayah_ID = ayahid;
  if (ayah_ID == 'not found') {
    return 'لا يوجد';
  } else {
    var surah_num = ayah_ID.substring(0, 3);
    int surah_int = int.parse(surah_num);

    if (surah_int < 10) {
      // print(ayah_ID.substring(2,3));
      return ayah_ID.substring(2, 3).toString();
    } else if (surah_int >= 10 && surah_int < 100) {
      // print(ayah_ID.substring(1,3));
      return ayah_ID.substring(1, 3).toString();
    }

    return surah_num.toString();
  }
}

// depends on find_occurrences
Future<String> get_ayah_num1(String ayahid) async {
  if (ayahid == '') {
    return 'لا يوجد';
  } else if (ayahid == Null) {
    return 'Null';
  }
  String ayah_ID = ayahid;
  if (ayah_ID == 'not found') {
    return 'لا يوجد';
  } else {
    var ayah_num = ayah_ID.substring(3, 6);
    int ayah_int = int.parse(ayah_num);

    if (ayah_int < 10) {
      // print(ayah_ID.substring(5,6));
      return ayah_ID.substring(5, 6).toString();
    } else if (ayah_int >= 10 && ayah_int < 100) {
      // print(ayah_ID.substring(4,6));
      return ayah_ID.substring(4, 6).toString();
    }

    return ayah_num.toString();
  }
}

// depends on get_surah_name
Future<String> get_surah_chapter1(String ayahid) async {
  if (ayahid == '') {
    return 'لا يوجد';
  } else if (ayahid == Null) {
    return 'Null';
  }
  String name = await get_surah_name1(ayahid);
  if (name == 'لا يوجد') {
    return 'لا يوجد';
  } else {
    var chapterMap = {
      'الفاتحة': 1,
      'البقرة': 1,
      'آل عمران': 3,
      'النساء': 4,
      'المائدة': 6,
      'الأنعام': 7,
      'الأعراف': 8,
      'الأنفال': 9,
      'التوبة': 10,
      'يونس': 11,
      'هود': 11,
      'يوسف': 12,
      'الرعد': 13,
      'إبراهيم': 13,
      'الحجر': 14,
      'النحل': 14,
      'الإسراء': 15,
      'الكهف': 15,
      'مريم': 16,
      'طه': 16,
      'الأنبياء': 17,
      'الحج': 17,
      'المؤمنون': 18,
      'النور': 18,
      'الفرقان': 18,
      'الشعراء': 19,
      'النمل': 19,
      'القصص': 20,
      'العنكبوت': 20,
      'الروم': 21,
      'لقمان': 21,
      'السجدة': 21,
      'الأحزاب': 21,
      'سبأ': 22,
      'فاطر': 22,
      'يس': 22,
      'الصافات': 23,
      'ص': 23,
      'الزمر': 23,
      'غافر': 24,
      'فصلت': 24,
      'الشورى': 25,
      'الزخرف': 25,
      'الدخان': 25,
      'الجاثية': 25,
      'الأحقاف': 25,
      'محمد': 26,
      'الفتح': 26,
      'الحجرات': 26,
      'ق': 26,
      'الذاريات': 26,
      'الطور': 27,
      'النجم': 27,
      'القمر': 27,
      'الرحمن': 27,
      'الواقعة': 27,
      'الحديد': 27,
      'المجادلة': 28,
      'الحشر': 28,
      'الممتحنة': 28,
      'الصف': 28,
      'الجمعة': 28,
      'المنافقون': 28,
      'التغابن': 28,
      'الطلاق': 28,
      'التحريم': 28,
      'الملك': 29,
      'القلم': 29,
      'الحاقة': 29,
      'المعارج': 29,
      'نوح': 29,
      'الجن': 29,
      'المزّمِّل': 29,
      'المدّثر': 29,
      'القيامة': 29,
      'الإنسان': 29,
      'المرسلات': 29,
      'النبأ': 30,
      'النازعات': 30,
      'عبس': 30,
      'التكوير': 30,
      'الإنفطار': 30,
      'المطففين': 30,
      'الانشقاق': 30,
      'البروج': 30,
      'الطارق': 30,
      'الأعلى': 30,
      'الغاشية': 30,
      'الفجر': 30,
      'البلد': 30,
      'الشمس': 30,
      'الليل': 30,
      'الضحى': 30,
      'الشرح': 30,
      'التين': 30,
      'العلق': 30,
      'القدر': 30,
      'البينة': 30,
      'الزلزلة': 30,
      'العاديات': 30,
      'القارعة': 30,
      'التكاثر': 30,
      'العصر': 30,
      'الهُمَزَة': 30,
      'الفيل': 30,
      'قريش': 30,
      'الماعون': 30,
      'الكوثر': 30,
      'الكافرون': 30,
      'النصر': 30,
      'المسد': 30,
      'الإخلاص': 30,
      'الفلق': 30,
      'الناس': 30
    };

    var chapter = chapterMap[name].toString();
    return chapter.toString();
  }
}

// depends on get_surah_num
// depends on get_ayah_num
Future<String> get_img_url1(String ayahid) async {
  if (ayahid == '') {
    return 'https://assets.stickpng.com/images/60fea5143d624000048712b3.png';
  } else {
    String surahNum = await get_surah_num1(ayahid);
    String ayahNum = await get_ayah_num1(ayahid);
    if (surahNum == 'لا يوجد' || ayahNum == 'لا يوجد') {
      return 'https://assets.stickpng.com/images/60fea5143d624000048712b3.png';
    } else {
      String general_img_url =
          'http://www.everyayah.com/data/images_png/surahNum_ayahNum.png';
      String ayah_img_url = general_img_url.replaceAll(
          'surahNum_ayahNum', '${surahNum}_${ayahNum}');
      if (ayah_img_url == 'http://www.everyayah.com/data/images_png/_.png') {
        return 'https://assets.stickpng.com/images/60fea5143d624000048712b3.png';
      } else {
        return ayah_img_url;
      }
    }
  }
}

// depends on fide_occurrences
Future<String> get_voice_url1(String ayahid) async {
  if (ayahid == '') {
    return 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/001001.mp3';
  } else {
    String ayah_ID = ayahid;
    if (ayah_ID == 'not found') {
      return 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/001001.mp3';
    } else {
      String general_voice_url =
          'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/ayah_id.mp3';
      String ayah_voice_url = general_voice_url.replaceAll('ayah_id', ayah_ID);
      if (ayah_voice_url ==
          'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/ayah_id.mp3') {
        return 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/001001.mp3';
      } else {
        // print(ayah_voice_url);
        return ayah_voice_url;
      }
    }
  }
}

// depends on fide_occurrences
Future<String> get_ayah_tafseer1(String ayahid) async {
  var input;
  var tafseer_map;
  if (ayahid == '') {
    return 'لا يوجد';
  } else {
    String ayah_ID = ayahid;
    if (ayah_ID == 'not found') {
      return 'لا يوجد';
    } else {
      input = await rootBundle.loadString('assets/tafseerIndex.json');
      tafseer_map = jsonDecode(input);
      return tafseer_map['${ayah_ID}'];
    }
  }
}
