import 'package:flutter/material.dart';

class PriceGridHeader extends StatefulWidget {
  final List<double> columnWidths;
  final Function(int, double) onResize;

  const PriceGridHeader({
    required this.columnWidths,
    required this.onResize,
    super.key,
  });

  @override
  _PriceGridHeaderState createState() => _PriceGridHeaderState();
}

class _PriceGridHeaderState extends State<PriceGridHeader> {
  @override
  Widget build(BuildContext context) {
    final headers = ['ID', 'Código', 'Custo', 'Fornecedor', 'Marca', 'Embalagem', 'Tamanho', 'Descrição', 'Setor'];

    return Row(
      children: List.generate(headers.length, (index) {
        return GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              double newWidth = widget.columnWidths[index] + details.delta.dx;
              if (newWidth > 50) { // Define um tamanho mínimo para as colunas
                widget.onResize(index, newWidth);
              }
            });
          },
          child: Container(
            width: widget.columnWidths[index],
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[300],
            child: Text(
              headers[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }
}
