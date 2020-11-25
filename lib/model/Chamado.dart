class Chamado {
  int id;
  String assunto;
  String descricao;
  int classificacaoId;
  int tipoChamadoId;
  int prioridadeId;
  int statusId;
  int pessoaAgenteId;
  int pessoaUsuarioId;
  String dp;
  String usuario;
  String status;
  String prioridade;
  String type;
  String data;
  String tipoChamado;
  String classificacao;

  Chamado(
      {this.id,
      this.assunto,
      this.descricao,
      this.classificacaoId,
      this.tipoChamadoId,
      this.prioridadeId,
      this.statusId,
      this.pessoaAgenteId,
      this.pessoaUsuarioId,
      this.dp,
      this.usuario,
      this.status,
      this.prioridade,
      this.type,
      this.data,
      this.tipoChamado,
      this.classificacao});

  Chamado.fromJson(Map<String, dynamic> json) {
    var hora = json['data'].split('T')[1].split('.')[0];
    var _data = json['data'].split('T')[0].split('-');

    id = json['id'];
    assunto = json['Assunto'];
    descricao = json['Descricao'];
    classificacaoId = json['classificacao_id'];
    tipoChamadoId = json['tipo_chamado_id'];
    prioridadeId = json['prioridade_id'];
    statusId = json['status_id'];
    pessoaAgenteId = json['pessoa_agente_id'];
    pessoaUsuarioId = json['pessoa_usuario_id'];
    dp = json['Dp'];
    usuario = json['Usuario'];
    status = json['Status'];
    prioridade = json['Prioridade'];
    type = json['TipoUsuario'];
    data = _data[2]+'/'+_data[1]+'/'+_data[0]+' '+hora;
    tipoChamado = json['TipoChamado'];
    classificacao = json['Classificacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Assunto'] = this.assunto;
    data['Descricao'] = this.descricao;
    data['classificacao_id'] = this.classificacaoId;
    data['tipo_chamado_id'] = this.tipoChamadoId;
    data['prioridade_id'] = this.prioridadeId;
    data['status_id'] = this.statusId;
    data['pessoa_agente_id'] = this.pessoaAgenteId;
    data['pessoa_usuario_id'] = this.pessoaUsuarioId;
    return data;
  }
}