import 'package:vania/vania.dart';

class CreateTodos extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('todos', () {
      string("id", unique: true);
      integer("userId");
      string('todo');
      string("status");
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('todos');
  }
}
