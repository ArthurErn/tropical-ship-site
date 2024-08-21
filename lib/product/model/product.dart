class Produto {
  final int id;
  final String codigo;
  final String fornecedor;
  final String marca;
  final String embalagem;
  final String tamanho;
  final String remark;
  final String descricao;
  final String unity;
  final String descricaoCompra;
  final String? custo;
  final String departamento;
  final String setor;
  final String? codMae;
  final String? fatorMae;
  final String? endereco;
  final String? desconto;
  final String? recordedAt;
  final String? originalSheetName;

  Produto({
    required this.id,
    required this.codigo,
    required this.fornecedor,
    required this.marca,
    required this.embalagem,
    required this.tamanho,
    required this.remark,
    required this.descricao,
    required this.unity,
    required this.descricaoCompra,
    this.custo,
    required this.departamento,
    required this.setor,
    this.codMae,
    this.fatorMae,
    this.endereco,
    this.desconto,
    this.recordedAt,
    this.originalSheetName,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      codigo: json['codigo'],
      fornecedor: json['fornecedor'],
      marca: json['marca'],
      embalagem: json['embalagem'],
      tamanho: json['tamanho'],
      remark: json['remark'],
      descricao: json['descricao'],
      unity: json['unity'],
      descricaoCompra: json['descricaoCompra'],
      custo: json['custo'],
      departamento: json['departamento'],
      setor: json['setor'],
      codMae: json['codMae'],
      fatorMae: json['fatorMae'],
      endereco: json['endereco'],
      desconto: json['desconto'],
      recordedAt: json['recordedAt'],
      originalSheetName: json['originalSheetName'],
    );
  }
}