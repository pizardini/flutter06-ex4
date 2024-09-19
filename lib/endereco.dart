class Endereco {
  final String cep;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;

  Endereco({
      required this.cep,
      required this.rua,
      required this.bairro,
      required this.cidade,
      required this.estado,
  });

  // Método para converter um Map em um objeto Endereco
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'],
      rua: json['logradouro'],
      bairro: json['bairro'],
      cidade: json['localidade'],
      estado: json['estado'],
    );
  }
}