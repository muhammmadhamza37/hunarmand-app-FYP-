import 'package:intl/intl.dart';

class Helper {
static String getHumanDate(int millis){
  DateFormat dateFormat = DateFormat('dd-MMM-yyyy hh:mm a');
   return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(millis));
}
}