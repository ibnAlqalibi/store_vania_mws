import 'package:vania/vania.dart';
import 'package:store/app/http/controllers/auth_controller.dart';
import 'package:store/app/http/controllers/user_controller.dart';
import 'package:store/app/http/middleware/authenticate.dart';

import '../app/http/controllers/todos_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    Router.basePrefix("api");
    Router.group(() {
      Router.post('register', authController.register);
      Router.post('login', authController.login);
    }, prefix: 'auth');

    Router.group(() {
      Router.get('me', userController.index);
      Router.post("todos", todosController.store);
      Router.get("todos", todosController.index);
      Router.put("todos/{id}", todosController.update);
      Router.delete("todos/{id}", todosController.destroy);
    }, prefix: 'user', middleware: [AuthenticateMiddleware()]);
  }
}
