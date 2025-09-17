/// Representasi entitas peserta di aplikasi.
/// Pemetaan kolom DB (snake_case) ke properti Dart (camelCase).
class PesertaModel {
  final int? id;
  final String nisn;
  final String namaLengkap;
  final String jenisKelamin;
  final String agama;
  final String ttl;
  final String noHp;
  final String nik;
  final String jalan;
  final String rtRw;
  final String dusun;
  final String desa;
  final String kecamatan;
  final String kabupaten;
  final String provinsi;
  final String kodePos;
  final String namaAyah;
  final String namaIbu;
  final String namaWali;
  final String alamatOrtu;
  final int? dataDusunId; // Tambahkan field ini

  PesertaModel({
    this.id,
    required this.nisn,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.agama,
    required this.ttl,
    required this.noHp,
    required this.nik,
    required this.jalan,
    required this.rtRw,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kabupaten,
    required this.provinsi,
    required this.kodePos,
    required this.namaAyah,
    required this.namaIbu,
    required this.namaWali,
    required this.alamatOrtu,
    this.dataDusunId, // Tambahkan parameter ini
  });

  /// Membuat instance dari hasil query Supabase.
  factory PesertaModel.fromMap(Map<String, dynamic> map) {
    return PesertaModel(
      id: map['id'],
      nisn: map['nisn'],
      namaLengkap: map['nama_lengkap'],
      jenisKelamin: map['jenis_kelamin'] ?? '',
      agama: map['agama'] ?? '',
      ttl: map['ttl'] ?? '',
      noHp: map['no_hp'] ?? '',
      nik: map['nik'] ?? '',
      jalan: map['jalan'] ?? '',
      rtRw: map['rt_rw'] ?? '',
      dusun: map['dusun'] ?? '',
      desa: map['desa'] ?? '',
      kecamatan: map['kecamatan'] ?? '',
      kabupaten: map['kabupaten'] ?? '',
      provinsi: map['provinsi'] ?? '',
      kodePos: map['kode_pos'] ?? '',
      namaAyah: map['nama_ayah'] ?? '',
      namaIbu: map['nama_ibu'] ?? '',
      namaWali: map['nama_wali'] ?? '',
      alamatOrtu: map['alamat_ortu'] ?? '',
      dataDusunId: map['data_dusun_id'], // Tambahkan ini
    );
  }

  /// Mengubah model menjadi map untuk insert/update ke Supabase.
  Map<String, dynamic> toMap() {
    return {
      'nisn': nisn,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'agama': agama,
      'ttl': ttl,
      'no_hp': noHp,
      'nik': nik,
      'jalan': jalan,
      'rt_rw': rtRw,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kabupaten': kabupaten,
      'provinsi': provinsi,
      'kode_pos': kodePos,
      'nama_ayah': namaAyah,
      'nama_ibu': namaIbu,
      'nama_wali': namaWali,
      'alamat_ortu': alamatOrtu,
      'data_dusun_id': dataDusunId, // Tambahkan ini
    };
  }
}