import 'package:date_picker/screen/add_title_screen.dart';
import 'package:date_picker/screen/pick_date.dart';
import 'package:fluro/fluro.dart';

class FluroRouter {
  static Router router = Router();
  var addTitleHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> param) {
    return AddTitle();
  });
  var pickDateHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return PickDate(title: params["title"][0]);
  });
  void setRouter() {
    router.define("/", handler: addTitleHandler);
    router.define("/pickdate/:title", handler: pickDateHandler);
  }
}
