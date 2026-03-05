class Usuario {
  final String id;
  final String nomeCompleto;
  final String email;
  final String telefone;
  final String? fotoPerfilUrl;
  final bool ativo;
  final DateTime criadoEm;

  const Usuario({
    required this.id,
    required this.nomeCompleto,
    required this.email,
    required this.telefone,
    this.fotoPerfilUrl,
    required this.ativo,
    required this.criadoEm
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nomeCompleto: json['nome_completo'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String,
      fotoPerfilUrl: json['foto_perfil_url'] as String?,
      ativo: json['ativo'] as bool,
      criadoEm: DateTime.parse(json['criado_em'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome_completo': nomeCompleto,
      'email': email,
      'telefone': telefone,
      if (fotoPerfilUrl != null) 'foto_perfil_url': fotoPerfilUrl,
      'ativo': ativo,
      'criado_em': criadoEm.toString()
    };
  }

  Usuario copyWith({
    String? id,
    String? nomeCompleto,
    String? email,
    String? telefone,
    Object? fotoPerfilUrl = const Object(),
    bool? ativo,
    DateTime? criadoEm
  }) {
    return Usuario(
      id: id ?? this.id,
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      fotoPerfilUrl: fotoPerfilUrl == const Object() ? this.fotoPerfilUrl : fotoPerfilUrl as String?,
      ativo: ativo ?? this.ativo,
      criadoEm: criadoEm ?? this.criadoEm
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Usuario(id: $id, nome: $nomeCompleto, email: $email, telefone: $telefone, fotoPerfilUrl: $fotoPerfilUrl, ativo: $ativo, criadoEm: $criadoEm)';
}

void main() {
  final json = {
    'id': 'usr-4f8a', 
    'nome_completo': 'Ana Lima', 
    'email': 'ana.lima@exemplo.com', 
    'telefone': '+5511999990000', 
    'foto_perfil_url': null,
    'ativo': true,
    'criado_em': '2024-09-15T10:30:00Z'
  };

  final usuarioComJson = Usuario.fromJson(json);

  print(usuarioComJson);

  final usuarioTelefoneDiferente = usuarioComJson.copyWith(telefone: '+55000009999');

  print(usuarioComJson == usuarioTelefoneDiferente);
  
  print(usuarioTelefoneDiferente.toJson());
}
