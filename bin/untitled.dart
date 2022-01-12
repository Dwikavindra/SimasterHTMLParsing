
import 'dart:ffi';
import'event_model.dart';
import 'package:html/parser.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
void main(List<String> arguments) async {
  List<String> data = [];
  final html=await File('assets/Coba.html').readAsString();
  final processed=html.toString();
  final processing="""$processed""";
  final document = parse(processing);
  var rows=document.getElementsByTagName("table")[0].getElementsByTagName("td");
  rows.map((e) {
    // print(e);//this is only the tag for some reason
    // print(e.innerHtml);//this the inside
    return e.innerHtml;/*langsung map sini*/} ).forEach((element) {
      List<String> gelar=["Dr.","Prof.","Profs.","M.","Drs.","S.","Ph.","A.Md.","A.Ma.","A.P"];
      var isgelar=clean_data().contains_title(element, gelar);
      bool isInt=clean_data().isInteger(element);


      var pushed=element.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').replaceAll(RegExp('[\\s+]{2,}')," ").trim();//remove html tags and whitesapce more than 2
    if(pushed != "-"&& !isgelar && !isInt){
      data.add(pushed);//sini langsung add ke list beuh mantap
    }
  });
  print(data);
  List<String>schedule_data=clean_data().get_schedule(data);
  List<String>subject_data=clean_data().get_event(data);
  print("Nama Matkul: $subject_data");

  print("Schedules: $schedule_data");
  // int day=get_start_day(schedule_data[0]);
  List<Event_Model> events=data_mapping().map_data(subject_data, schedule_data);
  print(events.length);

}



class clean_data {
  bool isInteger( String input ) {
    try {
      int.parse( input );
      return true;
    }
    catch( e ) {
    return false;
    }
  }
  bool contains_title(String element,List<String>gelar){
    bool condition=false;
    for(int i=0;i<gelar.length;i++){
      if(element.contains(gelar[i])){
        condition=true;
        break;
      }
    }
    return condition;

  }

  List<String>get_schedule(List<String>data){
    List<String> newdata=[];
    for(int i=2;i<data.length;i+=3){
        print("schedule data being added ${data[i]}");
        newdata.add(data[i]);//adding the data to the new list
    }
    return newdata;
  }
  List<String>get_event(List<String>data){
    List<String> newdata=[];
    for(int i=1;i<data.length;i+=3){
      print("data event being added ${data[i]}");
        newdata.add(data[i]);//adding the data to the new list
    }
    return newdata;
  }



  static void clean_kode_matkul(List<String>data,int start_index) {
    for (int i = start_index; i < data.length; i += 2) {
      data.removeAt(i);
    }
  }
}
class data_mapping {
  //mapp the data into the data class
  List<Event_Model> map_data(List<String>subject, List<String>schedule) {
    List<Event_Model>mapped_data = [];
    String event_name;
    String start_day;
    String start_time;
    String end_time;
    for (int i = 0; i < subject.length; i++) {
      event_name = subject[i];
      start_day = get_start_day(schedule[i]).toString();
      start_time = get_start_time(schedule[i]);
      end_time = get_end_time(schedule[i]);
      Event_Model event=new Event_Model(event_name: event_name, start_day: start_day, start_time: start_time, end_time: end_time);
      mapped_data.add(event);
    }
    return mapped_data;
  }
}


// }
int get_start_day(String data) {
  List<String> split_data = data.split(" ");
  String day_with_comma = split_data[0];
  List<String>result_split = day_with_comma.split("");
  result_split.removeLast();
  String result = result_split.join(); // without comma
  switch (result) {
    case "Senin":
      return 1;
    case "Selasa":
      return 2;
    case "Rabu":
      return 3;
    case "Kamis":
      return 4;
    case "Jumat":
      return 5;
    case "Sabtu":
      return 6;
    case "Minggu":
      return 7;
    default:
      return 0;
  }
}
String get_start_time(data){
  List<String> split_data = data.split(" ");
  List<String>unprocessed_time = split_data[1].split("-");
  String start_time=unprocessed_time[0];
  return start_time;

}
String get_end_time(data){
  List<String> split_data = data.split(" ");
  List<String>unprocessed_time = split_data[1].split("-");
  String end_time=unprocessed_time[1];
  return end_time;
}
