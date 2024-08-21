import 'dart:convert';
import 'dart:html' as html;
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/assets/colors.dart';
import 'package:tropical_ship_supply/home_page/home_page.dart';
import 'package:tropical_ship_supply/product/register_product_dialog.dart';
import 'package:csv/csv.dart';
import 'package:tropical_ship_supply/user/register_user_dialog.dart';
import 'package:tropical_ship_supply/unity/register_unity_dialog.dart';
import 'package:tropical_ship_supply/upload/upload_file_dialog.dart';
import 'package:tropical_ship_supply/vessel/model/vessel.dart';
import 'package:tropical_ship_supply/vessel/vessel_grid_state.dart';
import 'package:tropical_ship_supply/vessel/vessel_service.dart';

class VesselPageState extends State<VesselPage> {
  late VesselService vesselService;
  List<Vessel>? vessels;
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    vesselService = VesselService(
        apiService: ApiService(baseUrl: 'http://localhost:3000/'));
    fetchVessels();
  }

  Future<void> fetchVessels() async {
    try {
      final data = await vesselService.fetchVessels();
      setState(() {
        vessels = data;
        columns = _buildColumns();
        rows = _buildRows(vessels!);
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
        type: PlutoColumnType.text(), // Usando texto em vez de número
      ),
      PlutoColumn(
        title: 'IMO',
        field: 'imo',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Vessel Name',
        field: 'vesselName',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Flag',
        field: 'flag',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Type',
        field: 'type',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'DWT',
        field: 'dwt',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'ETA (UTC)',
        field: 'etaUtc',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Vessel Email',
        field: 'vesselEmail',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Management Company',
        field: 'managementCompany',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Fleet Size',
        field: 'fleetSize',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'Average Age',
        field: 'avgAge',
        type: PlutoColumnType.text(),
      ),
    ];
  }

  List<PlutoRow> _buildRows(List<Vessel> vessels) {
    return vessels.map((vessel) {
      return PlutoRow(
        cells: {
          'id': PlutoCell(value: vessel.id),
          'imo': PlutoCell(value: vessel.imo),
          'vesselName': PlutoCell(value: vessel.vesselName),
          'flag': PlutoCell(value: vessel.flag),
          'type': PlutoCell(value: vessel.type),
          'dwt': PlutoCell(value: vessel.dwt),
          'etaUtc': PlutoCell(value: vessel.etaUtc),
          'vesselEmail': PlutoCell(value: vessel.vesselEmail),
          'managementCompany': PlutoCell(value: vessel.managementCompany),
          'fleetSize': PlutoCell(value: vessel.fleetSize),
          'avgAge': PlutoCell(value: vessel.avgAge),
        },
      );
    }).toList();
  }

  void _addNewRow(Vessel vessel) {
    setState(() {
      rows.add(
        PlutoRow(
          cells: {
            'id': PlutoCell(value: vessel.id),
            'imo': PlutoCell(value: vessel.imo),
            'vesselName': PlutoCell(value: vessel.vesselName),
            'flag': PlutoCell(value: vessel.flag),
            'type': PlutoCell(value: vessel.type),
            'dwt': PlutoCell(value: vessel.dwt),
            'etaUtc': PlutoCell(value: vessel.etaUtc),
            'vesselEmail': PlutoCell(value: vessel.vesselEmail),
            'managementCompany': PlutoCell(value: vessel.managementCompany),
            'fleetSize': PlutoCell(value: vessel.fleetSize),
            'avgAge': PlutoCell(value: vessel.avgAge),
          },
        ),
      );
    });
  }

  Future<void> _exportCSV() async {
    List<List<dynamic>> csvData = [
      columns.map((column) => column.title).toList(),
      ...rows.map((row) =>
          columns.map((column) => row.cells[column.field]!.value).toList()),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "vessels.csv")
      ..click();
    html.Url.revokeObjectUrl(url);

    CherryToast.success(
      title: Text('Exportação bem-sucedida'),
      description: Text('Dados exportados com sucesso'),
      animationType: AnimationType.fromRight,
      animationDuration: const Duration(milliseconds: 500),
      autoDismiss: true,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 70,
        backgroundColor: AppColors().blueColor,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportCSV,
          ),
        ],
      ),
      // drawer: Drawer(
      //   backgroundColor: Colors.white,
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: AppColors().blueColor,
      //         ),
      //         child: Image.asset(
      //           'lib/assets/images/logo-escura.png',
      //           height: 110,
      //         ),
      //       ),
      //       ListTile(
      //         leading: Icon(Icons.person_add_alt_1_rounded,
      //             color: AppColors().blueColor),
      //         title: Text(
      //           'Cadastrar usuário',
      //           style: TextStyle(color: AppColors().blueColor),
      //         ),
      //         onTap: () {
      //           registerUser(context);
      //         },
      //       ),
      //       const SizedBox(height: 15),
      //       ListTile(
      //         leading: Icon(Icons.one_x_mobiledata_sharp,
      //             color: AppColors().blueColor),
      //         title: Text(
      //           'Cadastrar unidade',
      //           style: TextStyle(color: AppColors().blueColor),
      //         ),
      //         onTap: () {
      //           registerUnity(context);
      //         },
      //       ),
      //       const SizedBox(height: 15),
      //       ListTile(
      //         leading: Icon(Icons.upload_file, color: AppColors().blueColor),
      //         title: Text(
      //           'Upload de produto',
      //           style: TextStyle(color: AppColors().blueColor),
      //         ),
      //         onTap: () {
      //           uploadFile(context);
      //         },
      //       ),
      //       const SizedBox(height: 15),
      //       ListTile(
      //         leading: Icon(Icons.upload_file, color: AppColors().blueColor),
      //         title: Text(
      //           'Upload de vessel',
      //           style: TextStyle(color: AppColors().blueColor),
      //         ),
      //         onTap: () {
      //           uploadFile(context);
      //         },
      //       ),
      //       const SizedBox(height: 15),
      //       ListTile(
      //         leading: Icon(Icons.add_box, color: AppColors().blueColor),
      //         title: Text(
      //           'Cadastrar produto',
      //           style: TextStyle(color: AppColors().blueColor),
      //         ),
      //         onTap: () {
      //           registerProduct(context, _addNewRow); // Pass the callback here
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text('Erro: $errorMessage'))
              : vessels != null
                  ? PlutoGrid(
                      columns: columns,
                      rows: rows,
                      onChanged: (event) async {
                        await ApiService(baseUrl: 'http://localhost:3000/').post(
                            'vessels/${vessels![event.rowIdx].id}/ec4b2d97-7f7d-4031-accb-1601c1666a3a',
                            body: {
                              event.column.field.toString(): event.value
                            }).then((value) {});
                      },
                      onLoaded: (PlutoGridOnLoadedEvent event) {
                        event.stateManager.setShowColumnFilter(true, notify: false);
                      },
                      configuration: const PlutoGridConfiguration(
                        enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
                        localeText: PlutoGridLocaleText(
                          unfreezeColumn: 'Descongelar coluna',
                          freezeColumnToStart: 'Congelar no início',
                          freezeColumnToEnd: 'Congelar no final',
                          autoFitColumn: 'Ajuste automático',
                          hideColumn: 'Ocultar coluna',
                          setColumns: 'Definir colunas',
                          setFilter: 'Definir filtro',
                          resetFilter: 'Redefinir filtro',
                          setColumnsTitle: 'Título da coluna',
                          filterColumn: 'Coluna',
                          filterType: 'Tipo',
                          filterValue: 'Valor',
                          filterAllColumns: 'Filtrar todas as colunas',
                          filterContains: 'Contém',
                          filterEquals: 'Igual a',
                          filterStartsWith: 'Começa com',
                          filterEndsWith: 'Termina com',
                          filterGreaterThan: 'Maior que',
                          filterGreaterThanOrEqualTo: 'Maior ou igual a',
                          filterLessThan: 'Menor que',
                          filterLessThanOrEqualTo: 'Menor ou igual a',
                          sunday: 'Dom',
                          monday: 'Seg',
                          tuesday: 'Ter',
                          wednesday: 'Qua',
                          thursday: 'Qui',
                          friday: 'Sex',
                          saturday: 'Sáb',
                          hour: 'Hora',
                          minute: 'Minuto',
                          loadingText: 'Carregando',
                        ),
                      ),
                    )
                  : const Center(child: Text('Nenhum vessel encontrado')),
    );
  }
}
