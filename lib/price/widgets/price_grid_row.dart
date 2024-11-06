import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tropical_ship_supply/connection/api_service.dart';
import 'package:tropical_ship_supply/main.dart';
import 'package:tropical_ship_supply/product/model/product.dart';

class PriceGridRow extends StatefulWidget {
  final List<Produto> products;
  final Function(int index, Produto updatedProduct) onProductUpdated;

  const PriceGridRow({
    required this.products,
    required this.onProductUpdated,
    super.key,
  });

  @override
  _PriceGridRowState createState() => _PriceGridRowState();
}

class _PriceGridRowState extends State<PriceGridRow> {
  late List<PlutoColumn> columns;
  late List<PlutoRow> rows;

  @override
  void initState() {
    super.initState();
    _initializeColumns();
    _initializeRows(widget.products);
  }

  void _initializeColumns() {
    columns = [
      PlutoColumn(title: 'ID', field: 'id', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Código', field: 'codigo', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Custo em real', field: 'custo', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Custo total', field: 'precoCalculado', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Fornecedor', field: 'fornecedor', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Marca', field: 'marca', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Embalagem', field: 'embalagem', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Tamanho', field: 'tamanho', type: PlutoColumnType.text(), readOnly: true),
      PlutoColumn(title: 'Descrição', field: 'descricao', type: PlutoColumnType.text(), readOnly: false),
      PlutoColumn(title: 'Setor', field: 'setor', type: PlutoColumnType.text(), readOnly: true),
    ];
  }

  void _initializeRows(List<Produto> products) {
    rows = products.map((product) => _createRow(product)).toList();
  }

  PlutoRow _createRow(Produto product) {
    return PlutoRow(
      cells: {
        'id': PlutoCell(value: product.id?.toString() ?? ''),
        'codigo': PlutoCell(value: product.codigo ?? ''),
        'custo': PlutoCell(value: product.custo ?? ''),
        'precoCalculado': PlutoCell(value: product.precoCalculado??''),
        'fornecedor': PlutoCell(value: product.fornecedor ?? ''),
        'marca': PlutoCell(value: product.marca ?? ''),
        'embalagem': PlutoCell(value: product.embalagem ?? ''),
        'tamanho': PlutoCell(value: product.tamanho ?? ''),
        'descricao': PlutoCell(value: product.descricao ?? ''),
        'setor': PlutoCell(value: product.setor ?? ''),
      },
    );
  }

  Future<void> _updateProductInGrid(PlutoGridOnChangedEvent event) async {
    if (event.column.field == 'descricao') {
      final int rowIndex = event.rowIdx!;
      final updatedProduct = widget.products[rowIndex];
      updatedProduct.descricao = event.value;

      // Realiza a chamada API para buscar o produto atualizado
      final response = await ApiService(baseUrl: url_api).get('products/search/exact/${event.value}');
      
      if (response != null && mounted) {
        // Atualiza o objeto Produto com os dados da resposta da API
        updatedProduct.id = response['id'];
        updatedProduct.codigo = response['codigo'];
        updatedProduct.fornecedor = response['fornecedor'];
        updatedProduct.marca = response['marca'];
        updatedProduct.embalagem = response['embalagem'];
        updatedProduct.tamanho = response['tamanho'];
        updatedProduct.descricao = response['descricao'];
        updatedProduct.setor = response['setor'];
        updatedProduct.custo = response['custo'];

        // Dispara o callback para informar a classe pai sobre a atualização
        widget.onProductUpdated(rowIndex, updatedProduct);

        // Atualiza a linha na grid com os novos valores
        setState(() {
          rows[rowIndex].cells['id']!.value = response['id'].toString();
          rows[rowIndex].cells['codigo']!.value = response['codigo'];
          rows[rowIndex].cells['fornecedor']!.value = response['fornecedor'];
          rows[rowIndex].cells['marca']!.value = response['marca'];
          rows[rowIndex].cells['embalagem']!.value = response['embalagem'];
          rows[rowIndex].cells['tamanho']!.value = response['tamanho'];
          rows[rowIndex].cells['descricao']!.value = response['descricao'];
          rows[rowIndex].cells['setor']!.value = response['setor'];
          rows[rowIndex].cells['custo']!.value = response['custo'];
        });
      } else {
        print('Erro ao buscar o produto ou widget desmontado.');
      }
    }
  }

  @override
  void didUpdateWidget(covariant PriceGridRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.products != oldWidget.products) {
      _initializeRows(widget.products);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onLoaded: (_) {},
      onChanged: _updateProductInGrid,
      rowColorCallback: (PlutoRowColorContext rowColorContext) {
        final idValue = rowColorContext.row.cells['id']!.value;
        if (idValue == null || idValue.isEmpty) {
          return Colors.red.shade200;
        }
        return Colors.transparent;
      },
      configuration: const PlutoGridConfiguration(
        columnSize: PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.equal,
        ),
        style: PlutoGridStyleConfig(
          enableColumnBorderHorizontal: true,
          enableColumnBorderVertical: true
        ),
      ),
      mode: PlutoGridMode.normal,
    );
  }
}
