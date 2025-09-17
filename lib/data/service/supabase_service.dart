import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peserta_model.dart';

/// Abstraksi akses data ke Supabase (CRUD peserta + data dusun).
class SupabaseService {
  /// Client Supabase yang telah diinisialisasi di `main.dart`.
  final SupabaseClient supabase = Supabase.instance.client;

  /// Ambil seluruh peserta.
  Future<List<PesertaModel>> getPeserta() async {
    try {
      final response = await supabase.from('peserta_tni').select();
      return (response as List)
          .map((e) => PesertaModel.fromMap(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Error server: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }

  /// Tambah peserta baru.
  Future<void> addPeserta(PesertaModel peserta) async {
    await supabase.from('peserta_tni').insert(peserta.toMap());
  }

  /// Perbarui peserta berdasarkan `id`.
  Future<void> updatePeserta(int id, PesertaModel peserta) async {
    await supabase.from('peserta_tni').update(peserta.toMap()).eq('id', id);
  }

  /// Hapus peserta berdasarkan `id`.
  Future<void> deletePeserta(int id) async {
    await supabase.from('peserta_tni').delete().eq('id', id);
  }

  /// Ambil daftar saran nama dusun mengandung `query` (dibatasi 10 hasil).
  Future<List<String>> getDusunSuggestions(String query) async {
    final response = await supabase
        .from('data_dusun')
        .select('dusun')
        .ilike('dusun', '%$query%')
        .limit(10);
    return (response as List)
        .map((e) => (e as Map<String, dynamic>)['dusun'] as String)
        .toList();
  }

  /// Ambil detail dusun untuk mengisi otomatis alamat + simpan foreign key.
  Future<Map<String, dynamic>?> getDusunDetails(String dusun) async {
    final response = await supabase
        .from('data_dusun')
        .select('id, kabupaten, kecamatan, desa, kode_pos')
        .eq('dusun', dusun)
        .maybeSingle();
    return response;
  }
}
