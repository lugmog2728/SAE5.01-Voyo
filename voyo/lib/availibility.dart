import 'package:flutter/material.dart';

class Availibility {
  late String day;
  late TimeOfDay startTime;
  late TimeOfDay endTime;

  Availibility(this.day, int hStart, int mStart, int hEnd, int mEnd) {
    startTime = TimeOfDay(hour: hStart, minute: mStart);
    endTime = TimeOfDay(hour: hEnd, minute: mEnd);
  }

  int getMinutePeriod() {
    int sMinute = startTime.hour * 60 + startTime.minute;
    int eMinute = endTime.hour * 60 + endTime.minute;
    return eMinute - sMinute;
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
  }

  bool compare(Availibility availibility) { 
    if (daysMap[day] == daysMap[availibility.day]) {
      return startTime.hour < availibility.startTime.hour;
    }
    return daysMap[day]! < daysMap[availibility.day]!;
  }

  bool isInclude(Availibility availibility) {
    if (day != availibility.day) {
      return false;
    }
    bool startBool = startTime.hour >= availibility.startTime.hour && startTime.hour <= availibility.endTime.hour;
    bool endBool = endTime.hour >= availibility.startTime.hour && endTime.hour <= availibility.endTime.hour;
    return startBool || endBool;
  }

  Availibility copy() {
    return Availibility(day, startTime.hour, startTime.minute, endTime.hour, endTime.minute);
  }
}

int translateStringHour(String hour) {
  int result = int.parse(hour);
  if (result == 0) {result = 12;}
  else if (result == 12) {result = 0;}
  return result;
}

String translateTime(TimeOfDay time) {
  int h = time.hourOfPeriod;
  int m = time.minute;
  if (time.period == DayPeriod.pm) {h = (12 + h) % 24;}
  String hSTR = h.toString();
  String mSTR = m.toString();
  if (h<10) {hSTR = "0$h";}
  if (m<10) {mSTR = "0$mSTR";}
  return "${hSTR}h$mSTR";
}

List<int> checkAvailibilities(List<Availibility> availibilities) {
    List<int> errorList = [];
    for (int i = 0; i < availibilities.length; i++) {
      if (availibilities[i].getMinutePeriod() < 60) {
        errorList.add(i);
      } else {
        for (int j = i+1; j < availibilities.length; j++) {
          if (availibilities[i].isInclude(availibilities[j])) {
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