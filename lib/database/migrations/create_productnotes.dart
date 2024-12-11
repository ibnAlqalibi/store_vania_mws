import 'package:vania/vania.dart';

class CreateProductnotes extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('productnotes', () {
      char("note_id", length: 5, unique: true, nullable: false);
      string("prod_id", length: 10);
      date("note_date");
      text('note_text');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('productnotes');
  }
}
