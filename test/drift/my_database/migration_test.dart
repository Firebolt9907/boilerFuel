// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:boiler_fuel/api/local_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'generated/schema.dart';

import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDb(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // The following template shows how to write tests ensuring your migrations
  // preserve existing data.
  // Testing this can be useful for migrations that change existing columns
  // (e.g. by alterating their type or constraints). Migrations that only add
  // tables or columns typically don't need these advanced tests. For more
  // information, see https://drift.simonbinder.eu/migrations/tests/#verifying-data-integrity
  // TODO: This generated template shows how these tests could be written. Adopt
  // it to your own needs when testing migrations with data integrity.
  test('migration from v2 to v3 does not corrupt data', () async {
    // Add data to insert into the old database, and the expected rows after the
    // migration.
    // TODO: Fill these lists
    final oldUsersTableData = <v2.UsersTableData>[];
    final expectedNewUsersTableData = <v3.UsersTableData>[];

    final oldMealsTableData = <v2.MealsTableData>[];
    final expectedNewMealsTableData = <v3.MealsTableData>[];

    final oldFoodsTableData = <v2.FoodsTableData>[];
    final expectedNewFoodsTableData = <v3.FoodsTableData>[];

    final oldDiningHallFoodsTableData = <v2.DiningHallFoodsTableData>[];
    final expectedNewDiningHallFoodsTableData = <v3.DiningHallFoodsTableData>[];

    final oldDiningHallsTableData = <v2.DiningHallsTableData>[];
    final expectedNewDiningHallsTableData = <v3.DiningHallsTableData>[];

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDb.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.usersTable, oldUsersTableData);
        batch.insertAll(oldDb.mealsTable, oldMealsTableData);
        batch.insertAll(oldDb.foodsTable, oldFoodsTableData);
        batch.insertAll(
          oldDb.diningHallFoodsTable,
          oldDiningHallFoodsTableData,
        );
        batch.insertAll(oldDb.diningHallsTable, oldDiningHallsTableData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewUsersTableData,
          await newDb.select(newDb.usersTable).get(),
        );
        expect(
          expectedNewMealsTableData,
          await newDb.select(newDb.mealsTable).get(),
        );
        expect(
          expectedNewFoodsTableData,
          await newDb.select(newDb.foodsTable).get(),
        );
        expect(
          expectedNewDiningHallFoodsTableData,
          await newDb.select(newDb.diningHallFoodsTable).get(),
        );
        expect(
          expectedNewDiningHallsTableData,
          await newDb.select(newDb.diningHallsTable).get(),
        );
      },
    );
  });
}
