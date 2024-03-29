import 'package:flutter/material.dart';

class Availibility {
  late String day;
  late TimeOfDay startTime;
  late TimeOfDay endTime; 
  late int startMinute;
  late int endMinute;
  
  Availibility(this.day, int hStart, int mStart, int hEnd, int mEnd) {
    startTime = TimeOfDay(hour: translateStringHour(hStart), minute: mStart);
    endTime = TimeOfDay(hour: translateStringHour(hEnd), minute: mEnd);
    startMinute = hStart*60 + mStart;
    endMinute = hEnd*60 + mEnd;
  }

  int getMinutePeriod() {
    return endMinute - startMinute;
  }
  
  TimeOfDay getTime(bool isTimeEnd) {
    if (isTimeEnd) {
      return endTime;
    }
    return startTime;
  }

  void updateAvailibility(Availibility availibility) {
    day = availibility.day;
    startTime = availibility.startTime;
    endTime = availibility.endTime;
    startMinute = availibility.startMinute;
    endMinute = availibility.endMinute;
  }

  bool compare(Availibility availibility) { 
    if (daysMap[day] == daysMap[availibility.day]) {
      return startMinute < availibility.startMinute;
    }
    return daysMap[day]! < daysMap[availibility.day]!;
  }

  bool isInclude(Availibility availibility) {
    if (daysMap[day] != daysMap[availibility.day]) {
      return false;
    }
    bool startBool =  availibility.startMinute >= startMinute && availibility.startMinute <= endMinute;
    bool endBool =  availibility.endMinute >= startMinute && availibility.endMinute <= endMinute;
    return startBool || endBool;
  }

  Availibility copy() {
    int hStart = startMinute ~/ 60;
    int hEnd = endMinute ~/ 60;
    return Availibility(day, hStart, startTime.minute, hEnd, endTime.minute);
  }
}

int translateStringHour(int hour) {
  if (hour == 0) {return 12;}
  else if (hour == 12) {return 0;}
  return hour;
}

String translateTime(TimeOfDay time, String separator) {
  int h = time.hourOfPeriod;
  int m = time.minute;
  if (time.period == DayPeriod.pm) {h = (12 + h) % 24;}
  String hSTR = h.toString();
  String mSTR = m.toString();
  if (h<10) {hSTR = "0$h";}
  if (m<10) {mSTR = "0$mSTR";}
  return "$hSTR$separator$mSTR";
}

List<int> checkAvailibilities(List<Availibility> availibilities) {
    List<int> errorList = [];
    for (int i = 0; i < availibilities.length; i++) {
      if (availibilities[i].getMinutePeriod() < 60) {
        errorList.add(i);
      } else {
        for (int j = 0; j < availibilities.length; j++) {
          if (i != j && availibilities[i].isInclude(availibilities[j])) {
            errorList.add(i);
            errorList.add(j);
          }
        }
      }
    }
    return errorList;
  }

List<Availibility> shortAvailibilities(List<Availibility> availibilities) {
  List<Availibility> shortAvailibilities = [];
  for (Availibility old in availibilities) {
    int i = 0;
    bool find = false;
    
    while (!find && i != shortAvailibilities.length) {
      find = old.compare(shortAvailibilities[i]);
      if (!find) {
        i++;
      }
    }
    shortAvailibilities.insert(i, old);
  } 
  return shortAvailibilities;
}

Map<String, int> daysMap = {"lundi":1, "mardi":2, "mercredi":3, "jeudi":4,"vendredi":5, "samedi":6, "dimanche":7};