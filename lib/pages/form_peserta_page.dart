import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/models/peserta_model.dart';
import '../data/service/supabase_service.dart';
import '../widgets/modern_form_field.dart';
import '../widgets/form_section.dart';
import '../widgets/custom_toast.dart';

/// Form tambah/edit peserta dengan 3 langkah (step):
/// 0. Data Pribadi, 1. Alamat, 2. Orang Tua/Wali
/// Jika `peserta` null → mode create, selain itu → mode edit (pre-fill).
class FormPesertaPage extends StatefulWidget {
  final PesertaModel? peserta; // kalau null → create, kalau ada → update

  const FormPesertaPage({super.key, this.peserta});

  @override
  State<FormPesertaPage> createState() => _FormPesertaPageState();
}

class _FormPesertaPageState extends State<FormPesertaPage> {
  final _formKey = GlobalKey<FormState>();
  final SupabaseService service = SupabaseService();
  bool _isLoading = false;
  bool _isLoadingSuggestions =
      false; // Indikator loading saat autocomplete dusun
  int _currentStep = 0;
  int? _dataDusunId; // Menyimpan foreign key ke tabel data_dusun

  // Controller
  final TextEditingController nisnC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController agamaC = TextEditingController();
  final TextEditingController tempatLahirC = TextEditingController();
  final TextEditingController tanggalLahirC = TextEditingController();
  final TextEditingController noHpC = TextEditingController();
  final TextEditingController nikC = TextEditingController();
  final TextEditingController jalanC = TextEditingController();
  final TextEditingController rtRwC = TextEditingController();
  final TextEditingController dusunC = TextEditingController();
  final TextEditingController desaC = TextEditingController();
  final TextEditingController kecamatanC = TextEditingController();
  final TextEditingController kabupatenC = TextEditingController();
  final TextEditingController provinsiC = TextEditingController();
  final TextEditingController kodePosC = TextEditingController();
  final TextEditingController ayahC = TextEditingController();
  final TextEditingController ibuC = TextEditingController();
  final TextEditingController waliC = TextEditingController();
  final TextEditingController alamatOrtuC = TextEditingController();

  String? jenisKelamin;

  @override
  void initState() {
    provinsiC.text = 'Jawa Timur';
    super.initState();
    if (widget.peserta != null) {
      // Mode edit: isi semua controller dan metadata dari model
      final p = widget.peserta!;
      nisnC.text = p.nisn;
      namaC.text = p.namaLengkap;
      jenisKelamin = p.jenisKelamin;
      agamaC.text = p.agama;

      // Split TTL
      final ttlParts = p.ttl.split(', ');
      if (ttlParts.length >= 2) {
        tempatLahirC.text = ttlParts[0];
        tanggalLahirC.text = ttlParts[1];
      } else {
        tempatLahirC.text = p.ttl;
      }

      noHpC.text = p.noHp;
      nikC.text = p.nik;
      jalanC.text = p.jalan;
      rtRwC.text = p.rtRw;
      dusunC.text = p.dusun;
      desaC.text = p.desa;
      kecamatanC.text = p.kecamatan;
      kabupatenC.text = p.kabupaten;
      provinsiC.text = p.provinsi;
      kodePosC.text = p.kodePos;
      ayahC.text = p.namaAyah;
      ibuC.text = p.namaIbu;
      waliC.text = p.namaWali;
      alamatOrtuC.text = p.alamatOrtu;
      _dataDusunId = p.dataDusunId;
    }
  }

  /// Pindah ke step berikutnya jika valid.
  void _nextStep() {
    if (_formKey.currentState!.validate() && _validateCurrentStep()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  /// Kembali ke step sebelumnya.
  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  /// Validasi minimal per-step agar navigasi antar langkah terjaga.
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Data Pribadi
        return nisnC.text.isNotEmpty &&
            namaC.text.isNotEmpty &&
            jenisKelamin != null &&
            agamaC.text.isNotEmpty &&
            tempatLahirC.text.isNotEmpty &&
            tanggalLahirC.text.isNotEmpty &&
            noHpC.text.isNotEmpty &&
            nikC.text.isNotEmpty;
      case 1: // Alamat
        return jalanC.text.isNotEmpty &&
            rtRwC.text.isNotEmpty &&
            dusunC.text.isNotEmpty &&
            desaC.text.isNotEmpty &&
            kecamatanC.text.isNotEmpty &&
            kabupatenC.text.isNotEmpty &&
            provinsiC.text.isNotEmpty &&
            kodePosC.text.isNotEmpty &&
            _dataDusunId != null; // Validasi data_dusun_id
      case 2: // Orang Tua/Wali
        return ayahC.text.isNotEmpty &&
            ibuC.text.isNotEmpty &&
            alamatOrtuC.text.isNotEmpty;
      default:
        return true;
    }
  }

  /// Simpan data ke Supabase: insert saat create, update saat edit.
  Future<void> _saveData() async {
    if (_formKey.currentState!.validate() && _validateCurrentStep()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final peserta = PesertaModel(
          id: widget.peserta?.id,
          nisn: nisnC.text,
          namaLengkap: namaC.text,
          jenisKelamin: jenisKelamin ?? "",
          agama: agamaC.text,
          ttl: "${tempatLahirC.text}, ${tanggalLahirC.text}",
          noHp: noHpC.text,
          nik: nikC.text,
          jalan: jalanC.text,
          rtRw: rtRwC.text,
          dusun: dusunC.text,
          desa: desaC.text,
          kecamatan: kecamatanC.text,
          kabupaten: kabupatenC.text,
          provinsi: provinsiC.text,
          kodePos: kodePosC.text,
          namaAyah: ayahC.text,
          namaIbu: ibuC.text,
          namaWali: waliC.text,
          alamatOrtu: alamatOrtuC.text,
          dataDusunId: _dataDusunId,
        );

        if (widget.peserta == null) {
          await service.addPeserta(peserta);
          CustomToast.success(context, 'Data peserta berhasil ditambahkan!');
        } else {
          await service.updatePeserta(widget.peserta!.id!, peserta);
          CustomToast.success(context, 'Data peserta berhasil diperbarui!');
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        CustomToast.error(context, 'Error: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  /// Komponen indikator progress langkah di bagian atas form.
  Widget _buildProgressStep(int step, String title, IconData icon) {
    bool isActive = _currentStep == step;
    bool isCompleted = _currentStep > step;

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF3B82F6)
                : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive || isCompleted ? Colors.white : Colors.grey[600],
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? const Color(0xFF3B82F6) : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Merender isi form berdasarkan `step` aktif.
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDataPribadiStep();
      case 1:
        return _buildAlamatStep();
      case 2:
        return _buildOrangTuaStep();
      default:
        return _buildDataPribadiStep();
    }
  }

  /// Step 0: Data pribadi dan identitas dasar peserta.
  Widget _buildDataPribadiStep() {
    return FormSection(
      title: "Data Pribadi",
      icon: Icons.person,
      color: const Color(0xFF3B82F6),
      children: [
        const SizedBox(height: 8),
        ModernFormField(
          label: "NISN",
          controller: nisnC,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
            LengthLimitingTextInputFormatter(
              10,
            ), // Batas panjang (misalnya, 10 digit untuk NISN)
          ],
          prefixIcon: const Icon(
            Icons.badge,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "NISN wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Nama Lengkap",
          controller: namaC,
          prefixIcon: const Icon(
            Icons.person,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Nama lengkap wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernDropdownField(
          label: "Jenis Kelamin",
          value: jenisKelamin,
          items: const ["Laki-laki", "Perempuan"],
          onChanged: (val) => setState(() => jenisKelamin = val),
          prefixIcon: const Icon(Icons.wc, size: 16, color: Color(0xFF6B7280)),
          validator: (v) => v == null ? "Jenis kelamin wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Agama",
          controller: agamaC,
          prefixIcon: const Icon(
            Icons.church,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "Agama wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Tempat Lahir",
          controller: tempatLahirC,
          prefixIcon: const Icon(
            Icons.location_on,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Tempat lahir wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernDateField(
          label: "Tanggal Lahir",
          controller: tanggalLahirC,
          validator: (v) =>
              v == null || v.isEmpty ? "Tanggal lahir wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "No HP/Telp",
          controller: noHpC,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
          ],
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(
            Icons.phone,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "No HP wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "NIK",
          controller: nikC,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
          ],
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(
            Icons.credit_card,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "NIK wajib diisi" : null,
        ),
      ],
    );
  }

  /// Step 1: Alamat lengkap. Field "Dusun" memiliki Autocomplete terhubung DB.
  Widget _buildAlamatStep() {
    return FormSection(
      title: "Alamat",
      icon: Icons.home,
      color: const Color(0xFF10B981),
      children: [
        const SizedBox(height: 8),
        ModernFormField(
          label: "Jalan",
          controller: jalanC,
          prefixIcon: const Icon(
            Icons.straighten,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "Jalan wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "RT/RW",
          controller: rtRwC,
          prefixIcon: const Icon(
            Icons.home,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "RT/RW wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        // Autocomplete dusun → ambil saran dari Supabase dan
        // auto-isi desa/kecamatan/kabupaten/kode pos + simpan dataDusunId
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return [];
            }
            setState(() => _isLoadingSuggestions = true);
            final suggestions = await service.getDusunSuggestions(
              textEditingValue.text,
            );
            setState(() => _isLoadingSuggestions = false);

            if (suggestions.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tidak ada saran dusun ditemukan!'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return suggestions;
          },
          onSelected: (String selectedDusun) async {
            setState(() => _isLoadingSuggestions = true);
            final details = await service.getDusunDetails(selectedDusun);
            setState(() => _isLoadingSuggestions = false);
            if (details != null) {
              setState(() {
                dusunC.text = selectedDusun;
                desaC.text = details['desa'] ?? '';
                kecamatanC.text = details['kecamatan'] ?? '';
                kabupatenC.text = details['kabupaten'] ?? '';
                kodePosC.text = details['kode_pos'] ?? '';
                _dataDusunId = details['id'];
              });
            } else {
              CustomToast.error(context, 'Dusun tidak ditemukan!');
            }
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return ModernFormField(
              label: "Dusun",
              controller: controller,
              focusNode: focusNode,
              prefixIcon: const Icon(
                Icons.location_pin,
                size: 16,
                color: Color(0xFF6B7280),
              ),
              suffixIcon: _isLoadingSuggestions
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              validator: (v) =>
                  v == null || v.isEmpty ? "Dusun wajib diisi" : null,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                color: Colors.white,
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () => onSelected(option),
                        child: ListTile(
                          title: Text(option),
                          tileColor: Colors.grey[100],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Desa",
          controller: desaC,

          prefixIcon: const Icon(
            Icons.location_city,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty ? "Desa wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Kecamatan",
          controller: kecamatanC,

          prefixIcon: const Icon(
            Icons.apartment,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Kecamatan wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Kabupaten",
          controller: kabupatenC,

          prefixIcon: const Icon(
            Icons.account_balance,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Kabupaten wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Provinsi",
          controller: provinsiC,
          prefixIcon: const Icon(Icons.map, size: 16, color: Color(0xFF6B7280)),
          validator: (v) =>
              v == null || v.isEmpty ? "Provinsi wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Kode Pos",
          controller: kodePosC,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
          ],
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(
            Icons.local_post_office,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Kode pos wajib diisi" : null,
        ),
      ],
    );
  }

  /// Step 2: Data orang tua/wali.
  Widget _buildOrangTuaStep() {
    return FormSection(
      title: "Orang Tua / Wali",
      icon: Icons.family_restroom,
      color: const Color(0xFF8B5CF6),
      children: [
        const SizedBox(height: 8),
        ModernFormField(
          label: "Nama Ayah",
          controller: ayahC,
          prefixIcon: const Icon(Icons.man, size: 16, color: Color(0xFF6B7280)),
          validator: (v) =>
              v == null || v.isEmpty ? "Nama ayah wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Nama Ibu",
          controller: ibuC,
          prefixIcon: const Icon(
            Icons.woman,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) =>
              v == null || v.isEmpty ? "Nama ibu wajib diisi" : null,
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Nama Wali",
          controller: waliC,
          prefixIcon: const Icon(
            Icons.person_outline,
            size: 16,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),
        ModernFormField(
          label: "Alamat Orang Tua/Wali",
          controller: alamatOrtuC,
          maxLines: 1,
          prefixIcon: const Icon(
            Icons.home,
            size: 16,
            color: Color(0xFF6B7280),
          ),
          validator: (v) => v == null || v.isEmpty
              ? "Alamat orang tua/wali wajib diisi"
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          widget.peserta == null ? "Tambah Peserta" : "Edit Peserta",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress Indicator
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildProgressStep(0, "Data Pribadi", Icons.person),
                  ),
                  Expanded(child: _buildProgressStep(1, "Alamat", Icons.home)),
                  Expanded(
                    child: _buildProgressStep(
                      2,
                      "Orang Tua",
                      Icons.family_restroom,
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [_buildStepContent(), const SizedBox(height: 32)],
                ),
              ),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF3B82F6)),
                          foregroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: const Text("Sebelumnya"),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : (_currentStep == 2 ? _saveData : _nextStep),
                      style: ElevatedButton.styleFrom(
                        shadowColor: const Color(0),
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _currentStep == 2 ? "Simpan Data" : "Berikutnya",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
