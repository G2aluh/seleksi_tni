import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/peserta_model.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  Future<List<PesertaModel>> getPeserta() async {
    final response = await supabase.from('peserta_tni').select();
    return (response as List).map((e) => PesertaModel.fromMap(e)).toList();
  }

  Future<void> addPeserta(PesertaModel peserta) async {
    await supabase.from('peserta_tni').insert(peserta.toMap());
  }

  Future<void> updatePeserta(int id, PesertaModel peserta) async {
    await supabase.from('peserta_tni').update(peserta.toMap()).eq('id', id);
  }

  Future<void> deletePeserta(int id) async {
    await supabase.from('peserta_tni').delete().eq('id', id);
  }
  
}
