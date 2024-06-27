import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nfc_tool/custom_widgets/database_screen_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nfc_tool/constants/color.dart';
import 'package:nfc_tool/utils/context_extensiton.dart';

class DatabaseScreen extends StatelessWidget {
  DatabaseScreen({super.key});
  final DatabaseScreenWidget databaseScreenWidget = DatabaseScreenWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: HexColor(appBarColor),
      iconTheme: IconThemeData(color: HexColor(appBarIconColor)),
      centerTitle: true,
      title: Text(
        "databaseScreen.title".tr(),
        style: TextStyle(color: HexColor(appBarTitleColor)),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final List<Map<String, dynamic>> dataList = [];
    for (int i = 0; i < 20; i++) {
      dataList.add({'full_name': 'John Doe', 'created_date': '2024-06-28'});
    }
    return ListView(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: DataTable(
              columnSpacing: 5,
              horizontalMargin: context.dynamicWidth(0.2),
              headingRowColor:
                  WidgetStateColor.resolveWith((states) => Colors.grey[300]!),
              columns: [
                databaseScreenWidget.buildColumn(
                    title: "databaseScreen.fullName"),
                databaseScreenWidget.buildColumn(
                    title: "databaseScreen.createdDate", numeric: true)
              ],
              rows: dataList.map((data) {
                return DataRow(cells: [
                  DataCell(Text(
                    data['full_name'],
                  )),
                  DataCell(Text(
                    data['created_date'],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: context.dynamicHeight(0.01)),
      ],
    );
  }
}
