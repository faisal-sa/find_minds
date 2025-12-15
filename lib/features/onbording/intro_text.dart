import 'package:flutter/material.dart';

//======================  DATA BASE !!OUT THT CLASS!!  =========================
//
final List<Map<String, dynamic>> introText = [
  {
    "icon": Icons.rocket_launch,
    "title": "Build Your Future",
    "description":
        "Start shaping your professional journey and showcase your skills with confidence.",
  },
  {
    "icon": Icons.people,
    "title": "Connect & Grow",
    "description":
        "Network with professionals, expand your opportunities, and grow your career.",
  },
  {
    "icon": Icons.star,
    "title": "Show Your Potential",
    "description":
        "Share your experience, highlight your strengths, and unlock your full potential.",
  },
];
/*
==========================  END OF DATA BASE   ==============================

 ___________________________________________________________________________|
|                              COMMAN DATA CODS                             |
|===========================================================================|
|                                                                           |
|  [1]          itemCount: df.length < pageView / listView                  |
|  [2]         df["image"] / df["title"] / df["suptitle"] / ETS...          |
|                                                                           |
|  [3]           itemBuilder: (context, index)                              |
|                 final page = df[index];                                   |
|  [4]          df = [ {" KEY ":"DATA"} , {"KEY":"DATA"} ]                  |
|  [5]         "image ": "assets/pic1.png"                                  |
|                                                                           |
|___________________________________________________________________________|
*/
