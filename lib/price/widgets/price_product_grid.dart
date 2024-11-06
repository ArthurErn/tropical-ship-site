import 'package:flutter/material.dart';
import 'package:tropical_ship_supply/product/model/product.dart';
import 'price_grid_row.dart';

class PriceProductGrid extends StatefulWidget {
  final List<Produto> products;
  final Function(int index, Produto updatedProduct) onProductUpdated;

  const PriceProductGrid({
    required this.products,
    required this.onProductUpdated,
    super.key,
  });

  @override
  _PriceProductGridState createState() => _PriceProductGridState();
}

class _PriceProductGridState extends State<PriceProductGrid> {
  void _updateProductInGrid(int index, Produto updatedProduct) {
    widget.onProductUpdated(index, updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 550, // Defina uma altura apropriada para o PlutoGrid
      child: PriceGridRow(
        key: UniqueKey(), // Força a recriação do PlutoGrid
        products: widget.products,
        onProductUpdated: _updateProductInGrid,
      ),
    );
  }
}
