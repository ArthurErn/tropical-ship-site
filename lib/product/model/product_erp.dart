class ProdutoErp {
  final String prCodigoExterno;
  final String prDescricao;

  ProdutoErp({
    required this.prCodigoExterno,
    required this.prDescricao,
  });

  factory ProdutoErp.fromJson(Map<String, dynamic> json) {
    return ProdutoErp(
      prCodigoExterno: json['prCodigoExterno'],
      prDescricao: json['prDescricao'],
    );
  }
}