class client_uptd {
  int? id;
  String nama_client;
  String jenis_kelamin_client;
  String umur_client;
  String klasifikasi_kecacatan_client;
  String tanggal_lahir_client;
  String tanggal_masuk_client;
  String nilai_raport;

  client_uptd({
    this.id,
    required this.nama_client,
    required this.jenis_kelamin_client,
    required this.umur_client,
    required this.klasifikasi_kecacatan_client,
    required this.tanggal_lahir_client,
    required this.tanggal_masuk_client,
    required this.nilai_raport,
  });

  factory client_uptd.fromSQLite(Map map) {
    return client_uptd(
      id: map['id'],
      nama_client: map['nama_client'],
      jenis_kelamin_client: map['jenis_kelamin_client'],
      umur_client: map['umur_client'],
      klasifikasi_kecacatan_client: map['klasifikasi_kecacatan_client'],
      tanggal_lahir_client: map['tanggal_lahir_client'],
      tanggal_masuk_client: map['tanggal_masuk_client'],
      nilai_raport: map['nilai_raport'],
    );
  }

  static List<client_uptd> fromSQLiteList(List<Map> listMap) {
    List<client_uptd> client_uptds = [];
    for (Map item in listMap) {
      client_uptds.add(client_uptd.fromSQLite(item));
    }
    return client_uptds;
  }

  factory client_uptd.empty() {
    return client_uptd(
      nama_client: '',
      jenis_kelamin_client: '',
      umur_client: '',
      klasifikasi_kecacatan_client: '',
      tanggal_lahir_client: '',
      tanggal_masuk_client: '',
      nilai_raport: '',
    );
  }
}
