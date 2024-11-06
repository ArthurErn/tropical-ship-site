import 'dart:convert';
import 'dart:html' as html;
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:csv/csv.dart';
import 'package:tropical_ship_supply/currency/services/currency_service.dart';
import 'package:tropical_ship_supply/generic/base_model.dart';
import 'package:tropical_ship_supply/generic/export_csv.dart';
import 'package:tropical_ship_supply/main.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  _CurrencyPage createState() => _CurrencyPage();
}

class _CurrencyPage extends State<CurrencyPage> {
  late CurrencyService currencyService;
  List<BaseModel>? currencies;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    currencyService = CurrencyService(apiService: ApiService(baseUrl: url_api));
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    try {
      final data = await currencyService.fetchCurrencies();
      setState(() {
        currencies = data;
        columns = _buildColumns();
        rows = _buildRows(currencies!);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  List<PlutoColumn> _buildColumns() {
    return [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        readOnly: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: ' ',
        field: 'delete',
        enableFilterMenuItem: false,
        readOnly: true,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              int rowIdx = rendererContext.rowIdx;
              _deleteCurrency(rowIdx);
            },
          );
        },
      ),
    ];
  }

  List<PlutoRow> _buildRows(List<BaseModel> currencies) {
    return currencies.map((currency) {
      return PlutoRow(
        cells: {
          'id': PlutoCell(value: currency.id),
          'name': PlutoCell(value: currency.name),
          'delete': PlutoCell(
              value: 'Excluir'), // Placeholder para o botão de exclusão
        },
      );
    }).toList();
  }

  void _deleteCurrency(int rowIdx) async {
    await ApiService(baseUrl: url_api)
        .delete('moedas/${currencies![rowIdx].id}')
        .then((value) {
      if (value.statusCode == 200) {
        setState(() {
          rows.removeAt(rowIdx);
        });
        CherryToast.success(
          title: const Text('Sucesso'),
          description: const Text('Moeda excluída com sucesso'),
          animationType: AnimationType.fromRight,
          animationDuration: const Duration(milliseconds: 500),
          autoDismiss: true,
        ).show(context);
      } else {
        CherryToast.error(
          title: const Text('Erro'),
          description:
              Text('Falha ao excluir moeda ${currencies![rowIdx].name}'),
          animationType: AnimationType.fromRight,
          animationDuration: const Duration(milliseconds: 500),
          autoDismiss: true,
        ).show(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lista de moedas',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors().blueColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchCurrencies,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => exportCSV('currencies', columns, rows, context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Erro: $errorMessage'))
              : currencies != null
                  ? PlutoGrid(
                      columns: columns,
                      rows: rows,
                      configuration: const PlutoGridConfiguration(
                        enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
                      ),
                    )
                  : const Center(child: Text('Nenhuma moeda encontrada')),
    );
  }
}
