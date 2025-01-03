import 'dart:io';
import 'create_todos.dart';
import 'package:vania/vania.dart';
import 'create_user.dart';
import 'create_personal_access_token.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
    await CreateUser().up();
    await CreatePersonalAccessToken().up();
    await CreateTodos().up();
  }

  dropTables() async {
    await CreateTodos().down();
    await CreatePersonalAccessToken().down();
    await CreateUser().down();
  }
}
