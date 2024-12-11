import 'package:store/app/http/controllers/order_item_controller.dart';
import 'package:store/app/http/controllers/product_controller.dart';
import 'package:store/app/http/controllers/product_note_controller.dart';
import 'package:store/app/http/controllers/vendor_controller.dart';
import 'package:vania/vania.dart';
import 'package:store/app/http/controllers/customer_controller.dart';

import '../app/http/controllers/orders_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix("api");
    Router.post("/customer", customerController.store);
    Router.get("/customer", customerController.index);
    Router.put("/customer/{cust_id}", customerController.update);
    Router.delete("/customer/{cust_id}", customerController.destroy);

    Router.post("/orders", ordersController.store);
    Router.get("/orders", ordersController.index);
    Router.put("/orders/{order_num}", ordersController.update);
    Router.delete("/orders/{order_num}", ordersController.destroy);

    Router.post("/vendor", vendorController.store);
    Router.get("/vendor", vendorController.index);
    Router.put("/vendor/{vend_id}", vendorController.update);
    Router.delete("/vendor/{vend_id}", vendorController.destroy);

    Router.post("/product", productController.store);
    Router.get("/product", productController.index);
    Router.put("/product/{prod_id}", productController.update);
    Router.delete("/product/{prod_id}", productController.destroy);

    Router.post("/productNote", productNoteController.store);
    Router.get("/productNote", productNoteController.index);
    Router.put("/productNote/{note_id}", productNoteController.update);
    Router.delete("/productNote/{note_id}", productNoteController.destroy);

    Router.post("/orderItem", orderItemController.store);
    Router.get("/orderItem", orderItemController.index);
    Router.put("/orderItem/{order_item}", orderItemController.update);
    Router.delete("/orderItem/{order_item}", orderItemController.destroy);
  }
}
