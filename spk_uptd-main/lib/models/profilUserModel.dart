class profilUser {
  int? id;
  String nama;
  String tgl_lahir;
  String alamat;
  String jabatan;
  String telepon;
  String foto;
  int? user;

  profilUser({
    this.id,
    required this.nama,
    required this.tgl_lahir,
    required this.alamat,
    required this.jabatan,
    required this.telepon,
    required this.foto,
    this.user,
  });

  factory profilUser.fromSQLite(Map map) {
    return profilUser(
      id: map['id'],
      nama: map['nama'],
      tgl_lahir: map['tgl_lahir'],
      alamat: map['alamat'],
      jabatan: map['jabatan'],
      telepon: map['telepon'],
      foto: map['foto'],
      user: map['user'],
    );
  }

  static List<profilUser> fromSQLiteList(List<Map> listMap) {
    List<profilUser> profilUsers = [];
    for (Map item in listMap) {
      profilUsers.add(profilUser.fromSQLite(item));
    }
    return profilUsers;
  }

  factory profilUser.empty() {
    return profilUser(
      nama: '',
      tgl_lahir: '',
      alamat: '',
      jabatan: '',
      telepon: '',
      foto: '',
    );
  }
}
