import 'package:vania/vania.dart';
import 'package:store/app/http/controllers/customer_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix("api");
    Router.post("/customer", customerController.store);
    Router.get("/customer", customerController.index);
    Router.put("/customer/{cust_id}", customerController.update);
    Router.delete("/customer/{cust_id}", customerController.destroy);
  }
}
