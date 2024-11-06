import 'package:pluto_grid/pluto_grid.dart';

class PlutoGridConfig{
  PlutoGridLocaleText getPlutoGridLocaleText(){
    return const PlutoGridLocaleText(
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
                        );
  }
}