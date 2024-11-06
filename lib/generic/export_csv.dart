import 'dart:convert';
import 'dart:html' as html;

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

Future<void> exportCSV(String fileName, List<PlutoColumn> columns, List<PlutoRow> rows, context) async {
  List<List<dynamic>> csvData = [
    columns.map((column) => column.title).toList(),
    ...rows.map((row) =>
        columns.map((column) => row.cells[column.field]!.value).toList()),
  ];

  String csv = const ListToCsvConverter().convert(csvData);

  final bytes = utf8.encode(csv);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", "$fileName.csv")
    ..click();
  html.Url.revokeObjectUrl(url);

  CherryToast.success(
    title: const Text('Exportação bem-sucedida'),
    description: const Text('Dados exportados com sucesso'),
    animationType: AnimationType.fromRight,
    animationDuration: const Duration(milliseconds: 500),
    autoDismiss: true,
  ).show(context);
}