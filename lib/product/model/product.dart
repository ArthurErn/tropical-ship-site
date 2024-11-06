class Produto {
   int? id;
   String? codigo;
   String? fornecedor;
   String? marca;
   String? embalagem;
   String? tamanho;
   String? remark;
   String? descricao;
   String? unity;
   String? descricaoCompra;
   String? custo; // Custo original em real
   String? departamento;
   String? setor;
   String? codMae;
   String? fatorMae;
   String? endereco;
   String? desconto;
   String? recordedAt;
   String? originalSheetName;
  
  // Novo campo para armazenar o preço calculado
  String? precoCalculado;

  Produto({
    this.id,
    this.codigo,
    this.fornecedor,
    this.marca,
    this.embalagem,
    this.tamanho,
    this.remark,
    this.descricao,
    this.unity,
    this.descricaoCompra,
    this.custo,
    this.departamento,
    this.setor,
    this.codMae,
    this.fatorMae,
    this.endereco,
    this.desconto,
    this.recordedAt,
    this.originalSheetName,
    this.precoCalculado, // Incluindo o novo campo
  });

  // Método para criar Produto a partir de JSON
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
      precoCalculado: null, // Inicializa o preço calculado como nulo
    );
  }
}
