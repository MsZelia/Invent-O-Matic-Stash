package utils
{
   public class ArmorGrade
   {
      
      private static const GRADED_ARMOR:Object = {
         "COMBAT":{
            "CHEST":{
               "DEFAULT":{
                  "50":{
                     "36/36/0":"LIGHT",
                     "47/47/0":"STURDY",
                     "61/61/0":"HEAVY"
                  },
                  "40":{
                     "30/30/0":"LIGHT",
                     "40/40/0":"STURDY",
                     "52/52/0":"HEAVY"
                  },
                  "30":{
                     "25/25/0":"LIGHT",
                     "33/33/0":"STURDY",
                     "43/43/0":"HEAVY"
                  },
                  "20":{
                     "16/16/0":"LIGHT",
                     "21/21/0":"STURDY",
                     "27/27/0":"HEAVY"
                  }
               },
               "REINFORCED":{
                  "50":[10,10,0],
                  "40":[8,8,0],
                  "30":[6,6,0],
                  "20":[4,4,0]
               },
               "SHADOWED":{
                  "50":[10,10,0],
                  "40":[8,8,0],
                  "30":[6,6,0],
                  "20":[4,4,0]
               },
               "FIBERGLASS":{
                  "50":[15,15,0],
                  "40":[12,12,0],
                  "30":[9,9,0],
                  "20":[7,7,0]
               },
               "POLYMER":{
                  "50":[20,20,0],
                  "40":[16,16,0],
                  "30":[13,13,0],
                  "20":[9,9,0]
               },
               "BOS":{
                  "50":[25,25,0],
                  "40":[20,20,0],
                  "30":[16,16,0],
                  "20":[12,12,0]
               }
            },
            "LIMB":{
               "DEFAULT":{
                  "50":{
                     "12/12/0":"LIGHT",
                     "15/15/0":"STURDY",
                     "20/20/0":"HEAVY"
                  },
                  "40":{
                     "10/10/0":"LIGHT",
                     "13/13/0":"STURDY",
                     "17/17/0":"HEAVY"
                  },
                  "30":{
                     "8/8/0":"LIGHT",
                     "11/11/0":"STURDY",
                     "14/14/0":"HEAVY"
                  },
                  "20":{
                     "6/6/0":"LIGHT",
                     "8/8/0":"STURDY",
                     "11/11/0":"HEAVY"
                  }
               },
               "REINFORCED":{
                  "50":[7,7,0],
                  "40":[5,5,0],
                  "30":[4,4,0],
                  "20":[3,3,0]
               },
               "SHADOWED":{
                  "50":[7,7,0],
                  "40":[5,5,0],
                  "30":[4,4,0],
                  "20":[3,3,0]
               },
               "FIBERGLASS":{
                  "50":[10,10,0],
                  "40":[8,8,0],
                  "30":[6,6,0],
                  "20":[5,5,0]
               },
               "POLYMER":{
                  "50":[13,13,0],
                  "40":[10,10,0],
                  "30":[8,8,0],
                  "20":[6,6,0]
               },
               "BOS":{
                  "50":[15,25,0],
                  "40":[12,20,0],
                  "30":[10,16,0],
                  "20":[8,12,0]
               }
            }
         },
         "LEATHER":{
            "CHEST":{
               "DEFAULT":{
                  "50":{
                     "16/45/0":"LIGHT",
                     "21/59/0":"STURDY",
                     "28/76/0":"HEAVY"
                  },
                  "40":{
                     "14/40/0":"LIGHT",
                     "18/52/0":"STURDY",
                     "24/67/0":"HEAVY"
                  },
                  "30":{
                     "12/35/0":"LIGHT",
                     "16/45/0":"STURDY",
                     "21/58/0":"HEAVY"
                  },
                  "20":{
                     "10/30/0":"LIGHT",
                     "13/39/0":"STURDY",
                     "17/50/0":"HEAVY"
                  },
                  "10":{
                     "8/25/0":"LIGHT",
                     "11/32/0":"STURDY",
                     "15/41/0":"HEAVY"
                  },
                  "5":{
                     "6/15/0":"LIGHT",
                     "8/20/0":"STURDY",
                     "11/26/0":"HEAVY"
                  },
                  "1":{
                     "4/10/0":"LIGHT",
                     "5/13/0":"STURDY",
                     "7/17/0":"HEAVY"
                  }
               },
               "BOILED":{
                  "50":[5,15,0],
                  "40":[4,12,0],
                  "30":[3,9,0],
                  "20":[2,6,0],
                  "10":[1,3,0],
                  "5":[1,2,0],
                  "1":[1,1,0]
               },
               "SHADOWED":{
                  "50":[5,15,0],
                  "40":[4,12,0],
                  "30":[3,9,0],
                  "20":[2,6,0],
                  "10":[1,3,0],
                  "5":[1,2,0],
                  "1":[1,1,0]
               },
               "GIRDED":{
                  "50":[10,20,0],
                  "40":[8,16,0],
                  "30":[6,12,0],
                  "20":[4,8,0],
                  "10":[2,5,0],
                  "5":[1,3,0],
                  "1":[1,2,0]
               },
               "TREATED":{
                  "50":[15,25,0],
                  "40":[12,20,0],
                  "30":[9,16,0],
                  "20":[6,11,0],
                  "10":[3,7,0],
                  "5":[2,4,0],
                  "1":[1,3,0]
               },
               "STUDDED":{
                  "50":[20,30,0],
                  "40":[16,24,0],
                  "30":[12,19,0],
                  "20":[8,14,0],
                  "10":[4,8,0],
                  "5":[2,6,0],
                  "1":[1,4,0]
               }
            },
            "LIMB":{
               "DEFAULT":{
                  "50":{
                     "11/21/0":"LIGHT",
                     "17/36/0":"STURDY",
                     "22/47/0":"HEAVY"
                  },
                  "40":{
                     "9/17/0":"LIGHT",
                     "14/30/0":"STURDY",
                     "19/39/0":"HEAVY"
                  },
                  "30":{
                     "7/13/0":"LIGHT",
                     "11/24/0":"STURDY",
                     "15/31/0":"HEAVY"
                  },
                  "20":{
                     "5/9/0":"LIGHT",
                     "8/17/0":"STURDY",
                     "11/22/0":"HEAVY"
                  },
                  "10":{
                     "3/5/0":"LIGHT",
                     "5/11/0":"STURDY",
                     "7/14/0":"HEAVY"
                  },
                  "5":{
                     "2/4/0":"LIGHT",
                     "3/7/0":"STURDY",
                     "4/9/0":"HEAVY"
                  },
                  "1":{
                     "1/2/0":"LIGHT",
                     "2/4/0":"STURDY",
                     "3/6/0":"HEAVY"
                  }
               },
               "BOILED":{
                  "50":[1,10,0],
                  "40":[1,8,0],
                  "30":[1,6,0],
                  "20":[1,4,0],
                  "10":[1,2,0],
                  "5":[1,1,0],
                  "1":[1,1,0]
               },
               "SHADOWED":{
                  "50":[1,10,0],
                  "40":[1,8,0],
                  "30":[1,6,0],
                  "20":[1,4,0],
                  "10":[1,2,0],
                  "5":[1,1,0],
                  "1":[1,1,0]
               },
               "GIRDED":{
                  "50":[5,13,0],
                  "40":[4,10,0],
                  "30":[3,8,0],
                  "20":[2,6,0],
                  "10":[1,4,0],
                  "5":[1,2,0],
                  "1":[1,2,0]
               },
               "TREATED":{
                  "50":[8,16,0],
                  "40":[6,13,0],
                  "30":[5,10,0],
                  "20":[3,8,0],
                  "10":[2,5,0],
                  "5":[1,4,0],
                  "1":[1,3,0]
               },
               "STUDDED":{
                  "50":[10,30,0],
                  "40":[8,24,0],
                  "30":[6,19,0],
                  "20":[4,14,0],
                  "10":[2,8,0],
                  "5":[1,6,0],
                  "1":[1,4,0]
               }
            }
         },
         "METAL":{
            "CHEST":{
               "DEFAULT":{
                  "50":{
                     "51/11/0":"LIGHT",
                     "67/13/0":"STURDY",
                     "87/14/0":"HEAVY"
                  },
                  "40":{
                     "42/9/0":"LIGHT",
                     "55/11/0":"STURDY",
                     "72/12/0":"HEAVY"
                  },
                  "30":{
                     "33/7/0":"LIGHT",
                     "43/9/0":"STURDY",
                     "56/10/0":"HEAVY"
                  },
                  "20":{
                     "24/5/0":"LIGHT",
                     "32/7/0":"STURDY",
                     "42/7/0":"HEAVY"
                  },
                  "10":{
                     "20/3/0":"LIGHT",
                     "26/4/0":"STURDY",
                     "34/4/0":"HEAVY"
                  }
               },
               "PAINTED":{
                  "50":[15,3,0],
                  "40":[12,2,0],
                  "30":[10,2,0],
                  "20":[8,1,0],
                  "10":[6,1,0]
               },
               "ENAMELED":{
                  "50":[20,4,0],
                  "40":[17,3,0],
                  "30":[14,2,0],
                  "20":[11,2,0],
                  "10":[8,1,0]
               },
               "SHADOWED":{
                  "50":[15,3,0],
                  "40":[12,2,0],
                  "30":[10,2,0],
                  "20":[8,1,0],
                  "10":[6,1,0]
               },
               "ALLOYED":{
                  "50":[25,20,0],
                  "40":[21,16,0],
                  "30":[17,13,0],
                  "20":[13,9,0],
                  "10":[10,6,0]
               },
               "POLISHED":{
                  "50":[30,6,0],
                  "40":[25,5,0],
                  "30":[21,4,0],
                  "20":[16,3,0],
                  "10":[12,2,0]
               }
            },
            "LIMB":{
               "DEFAULT":{
                  "50":{
                     "20/5/0":"LIGHT",
                     "26/6/0":"STURDY",
                     "34/8/0":"HEAVY"
                  },
                  "40":{
                     "18/4/0":"LIGHT",
                     "24/5/0":"STURDY",
                     "32/7/0":"HEAVY"
                  },
                  "30":{
                     "16/3/0":"LIGHT",
                     "21/4/0":"STURDY",
                     "27/6/0":"HEAVY"
                  },
                  "20":{
                     "12/2/0":"LIGHT",
                     "16/3/0":"STURDY",
                     "20/4/0":"HEAVY"
                  },
                  "10":{
                     "8/1/0":"LIGHT",
                     "11/2/0":"STURDY",
                     "14/3/0":"HEAVY"
                  }
               },
               "PAINTED":{
                  "50":[10,1,0],
                  "40":[8,1,0],
                  "30":[6,1,0],
                  "20":[5,1,0],
                  "10":[3,1,0]
               },
               "ENAMELED":{
                  "50":[13,2,0],
                  "40":[10,1,0],
                  "30":[8,1,0],
                  "20":[6,1,0],
                  "10":[4,1,0]
               },
               "SHADOWED":{
                  "50":[10,1,0],
                  "40":[8,1,0],
                  "30":[6,1,0],
                  "20":[5,1,0],
                  "10":[3,1,0]
               },
               "ALLOYED":{
                  "50":[15,3,0],
                  "40":[12,2,0],
                  "30":[10,2,0],
                  "20":[8,1,0],
                  "10":[6,1,0]
               },
               "POLISHED":{
                  "50":[20,4,0],
                  "40":[16,3,0],
                  "30":[13,2,0],
                  "20":[10,2,0],
                  "10":[7,1,0]
               }
            }
         },
         "RAIDER":{
            "CHEST":{
               "DEFAULT":{
                  "45":{
                     "42/15/0":"LIGHT",
                     "54/19/0":"STURDY",
                     "70/24/0":"HEAVY"
                  },
                  "35":{
                     "34/12/0":"LIGHT",
                     "44/15/0":"STURDY",
                     "57/19/0":"HEAVY"
                  },
                  "25":{
                     "26/9/0":"LIGHT",
                     "34/11/0":"STURDY",
                     "44/14/0":"HEAVY"
                  },
                  "15":{
                     "18/6/0":"LIGHT",
                     "24/8/0":"STURDY",
                     "32/11/0":"HEAVY"
                  },
                  "5":{
                     "10/4/0":"LIGHT",
                     "13/6/0":"STURDY",
                     "17/8/0":"HEAVY"
                  }
               },
               "WELDED":{
                  "45":[11,5,0],
                  "35":[9,4,0],
                  "25":[7,3,0],
                  "15":[5,2,0],
                  "5":[3,1,0]
               },
               "TEMPERED":{
                  "45":[14,13,0],
                  "35":[12,11,0],
                  "25":[9,8,0],
                  "15":[7,5,0],
                  "5":[4,3,0]
               },
               "HARDENED":{
                  "45":[18,9,0],
                  "35":[15,7,0],
                  "25":[12,6,0],
                  "15":[9,5,0],
                  "5":[6,3,0]
               },
               "BUTTRESSED":{
                  "45":[23,11,0],
                  "35":[19,9,0],
                  "25":[15,7,0],
                  "15":[11,6,0],
                  "5":[7,4,0]
               }
            },
            "LIMB":{
               "DEFAULT":{
                  "45":{
                     "17/8/0":"LIGHT",
                     "22/10/0":"STURDY",
                     "28/13/0":"HEAVY"
                  },
                  "35":{
                     "14/7/0":"LIGHT",
                     "18/9/0":"STURDY",
                     "23/11/0":"HEAVY"
                  },
                  "25":{
                     "11/4/0":"LIGHT",
                     "14/6/0":"STURDY",
                     "18/8/0":"HEAVY"
                  },
                  "15":{
                     "8/3/0":"LIGHT",
                     "10/5/0":"STURDY",
                     "13/6/0":"HEAVY"
                  },
                  "5":{
                     "5/2/0":"LIGHT",
                     "7/3/0":"STURDY",
                     "9/4/0":"HEAVY"
                  }
               },
               "WELDED":{
                  "45":[9,4,0],
                  "35":[7,3,0],
                  "25":[5,2,0],
                  "15":[3,2,0],
                  "5":[1,1,0]
               },
               "TEMPERED":{
                  "45":[10,5,0],
                  "35":[8,4,0],
                  "25":[6,3,0],
                  "15":[4,3,0],
                  "5":[2,2,0]
               },
               "HARDENED":{
                  "45":[11,6,0],
                  "35":[9,5,0],
                  "25":[7,4,0],
                  "15":[5,4,0],
                  "5":[3,3,0]
               },
               "BUTTRESSED":{
                  "45":[12,7,0],
                  "35":[10,6,0],
                  "25":[8,5,0],
                  "15":[6,5,0],
                  "5":[4,4,0]
               }
            }
         },
         "ROBOT":{
            "CHEST":{
               "DEFAULT":{
                  "50":{
                     "24/24/13":"LIGHT",
                     "32/32/15":"STURDY",
                     "42/42/15":"HEAVY"
                  },
                  "40":{
                     "20/20/11":"LIGHT",
                     "26/26/13":"STURDY",
                     "34/34/13":"HEAVY"
                  },
                  "30":{
                     "16/16/9":"LIGHT",
                     "21/21/11":"STURDY",
                     "27/27/11":"HEAVY"
                  },
                  "20":{
                     "12/12/7":"LIGHT",
                     "16/16/9":"STURDY",
                     "20/20/9":"HEAVY"
                  },
                  "10":{
                     "8/8/5":"LIGHT",
                     "11/11/7":"STURDY",
                     "14/14/7":"HEAVY"
                  }
               },
               "PAINTED":{
                  "50":[13,6,0],
                  "40":[10,4,0],
                  "30":[8,3,0],
                  "20":[6,2,0],
                  "10":[4,1,0]
               },
               "SHADOWED":{
                  "50":[10,10,5],
                  "40":[8,8,4],
                  "30":[6,6,3],
                  "20":[4,4,2],
                  "10":[2,2,1]
               },
               "ENAMELED":{
                  "50":[12,12,6],
                  "40":[9,9,4],
                  "30":[7,7,3],
                  "20":[5,5,2],
                  "10":[3,3,1]
               },
               "ALLOYED":{
                  "50":[13,13,7],
                  "40":[10,10,5],
                  "30":[8,8,4],
                  "20":[6,6,3],
                  "10":[4,4,2]
               },
               "POLISHED":{
                  "50":[14,14,8],
                  "40":[11,11,6],
                  "30":[9,9,5],
                  "20":[7,7,3],
                  "10":[5,5,2]
               }
            },
            "ARM":{
               "DEFAULT":{
                  "50":{
                     "10/10/10":"LIGHT",
                     "13/10/13":"STURDY",
                     "17/17/15":"HEAVY"
                  },
                  "40":{
                     "9/9/9":"LIGHT",
                     "12/9/12":"STURDY",
                     "15/15/13":"HEAVY"
                  },
                  "30":{
                     "7/7/7":"LIGHT",
                     "9/6/9":"STURDY",
                     "12/12/11":"HEAVY"
                  },
                  "20":{
                     "5/5/5":"LIGHT",
                     "7/5/7":"STURDY",
                     "9/9/9":"HEAVY"
                  },
                  "10":{
                     "3/3/3":"LIGHT",
                     "5/3/5":"STURDY",
                     "7/7/7":"HEAVY"
                  }
               },
               "PAINTED":{
                  "50":[10,10,5],
                  "40":[8,8,4],
                  "30":[6,6,3],
                  "20":[4,4,2],
                  "10":[2,2,1]
               },
               "SHADOWED":{
                  "50":[10,10,5],
                  "40":[8,8,4],
                  "30":[6,6,3],
                  "20":[4,4,2],
                  "10":[2,2,1]
               },
               "ENAMELED":{
                  "50":[12,12,6],
                  "40":[9,9,4],
                  "30":[7,7,3],
                  "20":[5,5,2],
                  "10":[3,3,1]
               },
               "ALLOYED":{
                  "50":[13,13,7],
                  "40":[10,10,5],
                  "30":[8,8,4],
                  "20":[6,6,3],
                  "10":[4,4,2]
               },
               "POLISHED":{
                  "50":[14,14,8],
                  "40":[11,11,6],
                  "30":[9,9,5],
                  "20":[7,7,3],
                  "10":[5,5,2]
               }
            },
            "LEG":{
               "DEFAULT":{
                  "50":{
                     "10/10/10":"LIGHT",
                     "13/13/13":"STURDY",
                     "17/17/15":"HEAVY"
                  },
                  "40":{
                     "9/9/9":"LIGHT",
                     "12/12/12":"STURDY",
                     "15/15/13":"HEAVY"
                  },
                  "30":{
                     "7/7/7":"LIGHT",
                     "9/9/9":"STURDY",
                     "12/12/11":"HEAVY"
                  },
                  "20":{
                     "5/5/5":"LIGHT",
                     "7/7/7":"STURDY",
                     "9/9/9":"HEAVY"
                  },
                  "10":{
                     "3/3/3":"LIGHT",
                     "5/5/5":"STURDY",
                     "7/7/7":"HEAVY"
                  }
               },
               "PAINTED":{
                  "50":[10,10,5],
                  "40":[8,8,4],
                  "30":[6,6,3],
                  "20":[4,4,2],
                  "10":[2,2,1]
               },
               "SHADOWED":{
                  "50":[10,10,5],
                  "40":[8,8,4],
                  "30":[6,6,3],
                  "20":[4,4,2],
                  "10":[2,2,1]
               },
               "ENAMELED":{
                  "50":[12,12,6],
                  "40":[9,9,4],
                  "30":[7,7,3],
                  "20":[5,5,2],
                  "10":[3,3,1]
               },
               "ALLOYED":{
                  "50":[13,13,7],
                  "40":[10,10,5],
                  "30":[8,8,4],
                  "20":[6,6,3],
                  "10":[4,4,2]
               },
               "POLISHED":{
                  "50":[14,14,8],
                  "40":[11,11,6],
                  "30":[9,9,5],
                  "20":[7,7,3],
                  "10":[5,5,2]
               }
            }
         }
      };
      
      private static const UNGRADED_ARMOR:Object = {
         "ARCTIC_MARINE":"STURDY",
         "BOTSMITH":"HEAVY",
         "BROTHERHOOD":"HEAVY",
         "CIVIL_ENGINEER":"STURDY",
         "COVERT_SCOUT":"LIGHT",
         "FOREST_SCOUT":"LIGHT",
         "MARINE":"STURDY",
         "SECRET_SERVICE":"HEAVY",
         "SOLAR":"LIGHT",
         "THORN":"LIGHT",
         "TRAPPER":"STURDY",
         "URBAN_SCOUT":"LIGHT",
         "WOOD":"LIGHT",
         "EXCAVATOR":"POWER",
         "HELLCAT":"POWER",
         "RAIDER_POWER":"POWER",
         "STRANGLER_HEART":"POWER",
         "T_45":"POWER",
         "T_51B":"POWER",
         "T_60":"POWER",
         "T_65":"POWER",
         "ULTRACITE":"POWER",
         "UNION":"POWER",
         "VULCAN":"POWER",
         "X_01":"POWER"
      };
      
      private static var ARMOR_TYPES:Object = {
         "ARCTIC_MARINE":"Arctic Marine",
         "BOTSMITH":"Botsmith",
         "BROTHERHOOD":"Brotherhood",
         "CIVIL_ENGINEER":"Civil Engineer",
         "COMBAT":"Combat",
         "COVERT_SCOUT":"Covert Scout",
         "FOREST_SCOUT":"Forest Scout",
         "LEATHER":"Leather",
         "MARINE":"Marine",
         "METAL":"Metal",
         "RAIDER":"Raider",
         "ROBOT":"Robot",
         "SECRET_SERVICE":"Secret Service",
         "SOLAR":"Solar",
         "THORN":"Thorn",
         "TRAPPER":"Trapper",
         "URBAN_SCOUT":"Urban Scout",
         "WOOD":"Wood",
         "EXCAVATOR":"Excavator",
         "HELLCAT":"Hellcat",
         "RAIDER_POWER":"Raider Power",
         "STRANGLER_HEART":"Strangler Heart",
         "T_45":"T-45",
         "T_51B":"T-51b",
         "T_60":"T-60",
         "T_65":"T-65",
         "ULTRACITE":"Ultracite",
         "UNION":"Union",
         "VULCAN":"Vulcan",
         "X_01":"X-01"
      };
      
      private static var ARMOR_GRADES:Object = {
         "LIGHT":"Light",
         "STURDY":"Sturdy",
         "HEAVY":"Heavy",
         "POWER":"Power"
      };
      
      private static var ARMOR_PIECES:Object = {
         "LEFT_ARM":"Left Arm",
         "LEFT_LEG":"Left Leg",
         "RIGHT_ARM":"Right Arm",
         "RIGHT_LEG":"Right Leg",
         "CHEST_PIECE":"Chest Piece",
         "PA_TORSO":"Torso",
         "PA_HELMET":"Helmet"
      };
      
      private static var ARMOR_PREFIXES:Object = {
         "REINFORCED":"Reinforced",
         "SHADOWED":"Shadowed",
         "FIBERGLASS":"Fiberglass",
         "POLYMER":"Polymer",
         "BOS":"BOS",
         "BOILED":"Boiled",
         "GIRDED":"Girded",
         "TREATED":"Treated",
         "PAINTED":"Painted",
         "ENAMELED":"Enameled",
         "STUDDED":"Studded",
         "ALLOYED":"Alloyed",
         "POLISHED":"Polished",
         "WELDED":"Welded",
         "TEMPERED":"Tempered",
         "HARDENED":"Hardened",
         "BUTTRESSED":"Buttressed"
      };
      
      private static var ARMOR_MOD_LEADED:String = "Leaded";
       
      
      public function ArmorGrade()
      {
         super();
      }
      
      public static function initLocalization(config:Object) : void
      {
         var property:* = null;
         for(property in config)
         {
            switch(property)
            {
               case "ARMOR_MOD_LEADED":
                  ARMOR_MOD_LEADED = config[property];
                  break;
               case "ARMOR_PREFIXES":
               case "ARMOR_GRADES":
               case "ARMOR_PIECES":
               case "ARMOR_TYPES":
                  for(entry in config[property])
                  {
                     ArmorGrade[property][entry] = config[property][entry];
                  }
                  break;
            }
         }
      }
      
      private static function reduceResistances(initResistances:Array, resistances:Array) : Array
      {
         return [initResistances[0] - resistances[0],initResistances[1] - resistances[1],initResistances[2] - resistances[2]];
      }
      
      public static function getArmorPieceFromName(itemText:String, isLocalized:Boolean = false) : String
      {
         itemText = itemText.toLowerCase();
         for(piece in ARMOR_PIECES)
         {
            if(ARMOR_PIECES[piece].toLowerCase().split("||").some(function(element:*, index:int, arr:Array):Boolean
            {
               return itemText.indexOf(element) != -1;
            }))
            {
               return isLocalized ? ARMOR_PIECES[piece].split("||")[0] : piece;
            }
         }
         return "";
      }
      
      public static function getArmorTypeFromName(itemText:String, isLocalized:Boolean = false) : String
      {
         itemText = itemText.toLowerCase();
         if(itemText.indexOf(ARMOR_TYPES["RAIDER_POWER"].toLowerCase()) != -1)
         {
            return isLocalized ? ARMOR_TYPES["RAIDER_POWER"] : "RAIDER_POWER";
         }
         for(type in ARMOR_TYPES)
         {
            if(itemText.indexOf(ARMOR_TYPES[type].toLowerCase()) != -1)
            {
               return isLocalized ? ARMOR_TYPES[type] : type;
            }
         }
         return "";
      }
      
      private static function getArmorGradeFromName(itemText:String) : String
      {
         itemText = itemText.toLowerCase();
         if(itemText.indexOf(ARMOR_GRADES["HEAVY"].toLowerCase()) != -1)
         {
            return "HEAVY";
         }
         if(itemText.indexOf(ARMOR_GRADES["STURDY"].toLowerCase()) != -1)
         {
            return "STURDY";
         }
         return "";
      }
      
      public static function lookupArmorGrade(item:Object, isLocalized:Boolean = false) : String
      {
         var armorFullName:String;
         var armorLevel:String;
         var itemCard:Object;
         var resistances:Array;
         var armorType:String;
         var armorPiece:String;
         var piece:String;
         var sResistances:*;
         var grade:String;
         var sResistancesHazmat:String;
         var errorCode:String = 0;
         try
         {
            errorCode = "filterFlag";
            if(!(item.filterFlag & 8))
            {
               return "";
            }
            armorFullName = item.text.toLowerCase();
            grade = getArmorGradeFromName(armorFullName);
            if(grade != "")
            {
               return isLocalized ? ARMOR_GRADES[grade] : grade;
            }
            armorLevel = String(item.itemLevel);
            errorCode = "itemCard";
            itemCard = ItemCardData.get(item.serverHandleID);
            if(itemCard == null)
            {
               return "";
            }
            errorCode = "resistances";
            resistances = [ItemCardData.findResistanceValue(itemCard.itemCardEntries,1),ItemCardData.findResistanceValue(itemCard.itemCardEntries,4),ItemCardData.findResistanceValue(itemCard.itemCardEntries,6)];
            if(resistances[0] == 0 && resistances[1] == 0 && resistances[2] == 0)
            {
               return "";
            }
            errorCode = "armorType";
            armorType = getArmorTypeFromName(armorFullName);
            if(armorType == "")
            {
               return "";
            }
            errorCode = "GRADED_ARMOR";
            if(GRADED_ARMOR[armorType] == null)
            {
               if(UNGRADED_ARMOR[armorType] == null)
               {
                  return "";
               }
               return isLocalized ? ARMOR_GRADES[UNGRADED_ARMOR[armorType]] : UNGRADED_ARMOR[armorType];
            }
            errorCode = "armorPiece";
            armorPiece = getArmorPieceFromName(armorFullName);
            if(armorPiece == "")
            {
               return "";
            }
            errorCode = "piece";
            piece = "";
            if(armorPiece == "CHEST_PIECE")
            {
               piece = "CHEST";
            }
            else if(armorType == "ROBOT")
            {
               errorCode = "robot";
               if(armorPiece == "LEFT_ARM" || armorPiece == "RIGHT_ARM")
               {
                  piece = "ARM";
               }
               else
               {
                  piece = "LEG";
               }
            }
            else
            {
               piece = "LIMB";
            }
            errorCode = "material";
            for(material in GRADED_ARMOR[armorType][piece])
            {
               errorCode = "material " + material;
               if(material != "DEFAULT" && armorFullName.indexOf(ARMOR_PREFIXES[material].toLowerCase()) != -1)
               {
                  resistances = reduceResistances(resistances,GRADED_ARMOR[armorType][piece][material][armorLevel] || [0,0,0]);
               }
            }
            errorCode = "leaded";
            if(resistances[2] >= 10 && armorFullName.indexOf(ARMOR_MOD_LEADED.toLowerCase()) != -1)
            {
               resistances[2] -= 10;
            }
            errorCode = "sRes";
            sResistances = resistances.join("/");
            errorCode = "level";
            if(GRADED_ARMOR[armorType][piece]["DEFAULT"][armorLevel] == null)
            {
               return "";
            }
            errorCode = "grade";
            grade = GRADED_ARMOR[armorType][piece]["DEFAULT"][armorLevel][sResistances];
            if(!grade)
            {
               errorCode = "res check 25r";
               if(resistances[2] >= 25)
               {
                  errorCode = "res 25r";
                  resistances[2] -= 25;
                  sResistancesHazmat = resistances.join("/");
                  errorCode = "grade 25r";
                  grade = GRADED_ARMOR[armorType][piece]["DEFAULT"][armorLevel][sResistancesHazmat];
                  if(!grade)
                  {
                     return sResistances;
                  }
                  return isLocalized ? ARMOR_GRADES[grade] : grade;
               }
               return sResistances;
            }
            return isLocalized ? ARMOR_GRADES[grade] : grade;
         }
         catch(e:*)
         {
            Logger.get().error("Error looking up armor grade: " + errorCode + " : " + e);
            Logger.get().error(armorType + ", " + armorPiece + "/" + piece + ", " + material + ", " + armorLevel + ", " + sResistances);
         }
         return "";
      }
   }
}
