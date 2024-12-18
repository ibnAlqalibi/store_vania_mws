import 'dart:io';
import 'package:vania/vania.dart';
import 'create_customers.dart';
import 'create_orders.dart';
import 'create_orderitems.dart';
import 'create_productnotes.dart';
import 'create_products.dart';
import 'create_vendors.dart';
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
		 await CreateCustomersTable().up();
    await CreateOrders().up();
    await CreateOrderitems().up();
    await CreateProductnotes().up();
    await CreateProducts().up();
    await CreateVendors().up();
		 await CreateUser().up();
		 await CreatePersonalAccessToken().up();
	}

  dropTables() async {
		 await CreatePersonalAccessToken().down();
		 await CreateUser().down();
		 await CreateVendors().down();
    await CreateProducts().down();
    await CreateProductnotes().down();
    await CreateOrderitems().down();
    await CreateOrders().down();
    await CreateCustomersTable().down();
	 }
}
