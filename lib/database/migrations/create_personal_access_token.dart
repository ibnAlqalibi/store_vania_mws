import 'package:vania/vania.dart';

class CreatePersonalAccessToken extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('personal_access_token', () {
      id();
      tinyText("name");
      bigInt("tokenable_id");
      string("token");
      timeStamp("last_used_at", nullable: true);
      timeStamp("created_at", nullable: true);
      timeStamp("updated_at", nullable: true);
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('personal_access_token');
  }
}