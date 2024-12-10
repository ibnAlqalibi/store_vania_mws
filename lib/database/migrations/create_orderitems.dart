import 'package:vania/vania.dart';

class CreateOrderitems extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('orderitems', () {
      integer('order_item', length: 11);
      integer('order_num', length: 11);
      string('prod_id', length: 10);
      integer('quantity', length: 11);
      integer('size', length: 11);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
