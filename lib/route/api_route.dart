import 'package:vania/vania.dart';
import 'package:store/app/http/controllers/customer_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix("api");
    Router.post("/customer", customerController.create);
    Router.get("/customer", customerController.index);
  }
}
