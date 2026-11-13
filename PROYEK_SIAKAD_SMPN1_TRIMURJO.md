# DOKUMENTASI LENGKAP & BLUEPRINT PROYEK SIAKAD
## SMP NEGERI 1 TRIMURJO (BERBASIS LARAVEL & MYSQL)

> **Catatan Proyek:** File ini menyimpan seluruh spesifikasi kebutuhan sistem, struktur basis data, pemetaan Eloquent model, serta akun default untuk implementasi framework Laravel.

---

### 1. INFORMASI & STUDI KASUS OBJEK
* **Nama Sekolah:** SMP Negeri 1 Trimurjo
* **Lokasi:** Kec. Trimurjo, Kab. Lampung Tengah, Prov. Lampung
* **Kepala Sekolah:** Bapak Prayitno Untoro, S.Pd., M.M.
* **Kapasitas:** ~890 Siswa dan 54 Guru
* **Narasumber Riset:** 
  * Ibu Istri Sugiyatmi, S.Pd. (Wali Kelas)
  * Ibu Fildayana Ayu Ning Tyas, S.Pd. (Staf Tata Usaha)

---

### 2. KEBUTUHAN 4 HAK AKSES (MULTI-ROLE)
1. **Staff Tata Usaha (Administrator):**
   * Manajemen User & Akun Login (TU, Guru, Siswa).
   * Manajemen Data Master: Tahun Ajaran, Hari, Jam Pelajaran, Mata Pelajaran, Kelas, dan Guru.
   * Manajemen Data Induk Siswa (Standar Buku Induk 94 kolom Kemendikbud).
   * Penerimaan & Pengarsipan dokumen cetak Leger Nilai.
2. **Wali Kelas:**
   * Akses Dashboard & daftar siswa kelas binaan.
   * Input & plotting Jadwal Pelajaran untuk kelas yang diampu.
   * Rekapitulasi nilai seluruh mapel rombel.
   * **Output Utama:** Cetak Dokumen Leger Nilai Kelas.
3. **Guru Mata Pelajaran:**
   * Melihat jadwal mengajar KBM.
   * Melihat data presensi/daftar siswa rombel.
   * Input Nilai Siswa (Nilai Pengetahuan, Nilai Keterampilan, Nilai Sikap: `'sb'`, `'b'`, `'c'`, `'k'`, dan Deskripsi/Catatan Capaian).
4. **Siswa (Peserta Didik):**
   * Login fleksibel menggunakan **NISN** atau **Email**.
   * Melihat jadwal KBM kelas secara real-time.
   * Melihat rekapan nilai dan hasil rapor secara transparan.
   * Melihat profil Buku Induk pribadi.

---

### 3. DAFTAR FILE YANG SUDAH TERSIMPAN DI WORKSPACE
Semua file aman tersimpan di folder: `d:\SEMESTER 5\TUGAS UTS BASIS DATA LANJUT\`
1. **`database_siakad_smpn1_trimurjo.sql`** : File skrip DDL & DML database MySQL lengkap dengan 13 tabel dan 16 foreign keys.
2. **`diagram_dan_alur_siakad.html`** : Dashboard dokumentasi interaktif (Flowchart Swimlane, Use Case, 14 Activity Diagrams, Class Diagram, dan Mockup UI Login).
3. **`PROYEK_SIAKAD_SMPN1_TRIMURJO.md`** : Dokumen spesifikasi dan panduan pembuatan Laravel ini.
4. **Database MySQL Live:** Database `siakad_smpn1_trimurjo` sudah terpasang dan aktif di MySQL/phpMyAdmin lokal.

---

### 4. AKUN DEFAULT UNTUK TESTING / SEEDER
Semua akun menggunakan password bawaan: **`password`**

| Role | Nama Pengguna | Email / Akun Login | Keterangan |
|---|---|---|---|
| **Tata Usaha** | Staf Tata Usaha | `tu@smpn1trimurjo.sch.id` | Administrator Sistem |
| **Wali Kelas** | Istri Sugiyatmi, S.Pd. | `sugiyatmi@smpn1trimurjo.sch.id` | Wali Kelas VII A (NIP: 197508122005012003) |
| **Guru** | Budi Santoso, S.Pd. | `budi@smpn1trimurjo.sch.id` | Guru Mapel Matematika (NIP: 198203152008021004) |
| **Siswa 1** | Ahmad Pratama | `ahmad@siswa.smpn1trimurjo.sch.id` (NISN: `0091234567`) | Siswa Kelas VII A |
| **Siswa 2** | Siti Nurhaliza | `siti@siswa.smpn1trimurjo.sch.id` (NISN: `0091234568`) | Siswa Kelas VII A |

---

### 5. STRUKTUR 13 TABEL DATABASE MYSQL
1. `roles` (id, name, guard_name)
2. `users` (id_user, name, email, password, remember_token)
3. `model_has_roles` (role_id, model_type, model_id)
4. `tahun_ajaran` (id_tahun_ajaran, tahun, semester_aktif, is_active)
5. `guru` (id_guru, user_id, nip, nama_guru, jenis_kelamin, no_hp, alamat)
6. `kelas` (id_kelas, nama_kelas, tingkat, jurusan, guru_id)
7. `siswas` (id_siswa, user_id, kelas_id, nis, nisn, nama, jk, ttl, agama, alamat, data_ayah, data_ibu, data_wali, kesehatan, beasiswa, foto, dll - 94 field)
8. `kelas_siswa` (id_kelas_siswa, siswa_id, kelas_id, tahun_ajaran_id, status)
9. `hari` (id_hari, nama_hari)
10. `jam_pelajaran` (id_jam_pelajaran, jam_mulai, jam_selesai, urutan)
11. `mata_pelajaran` (id_mata_pelajaran, kode_mapel, nama_mapel, kkm)
12. `jadwal` (id_jadwal, guru_id, mapel_id, kelas_id, hari_id, jam_id, tahun_ajaran_id)
13. `nilais` (id_nilai, siswa_id, jadwal_id, tahun_ajaran_id, semester, nilai_pengetahuan, nilai_keterampilan, nilai_sikap, nilai_akhir, deskripsi)

---

### 6. LANGKAH CEPAT INISIALISASI BESOK DI LARAVEL
Saat besok mulai membuat program Laravel:
```bash
# 1. Konfigurasi .env ke database yang sudah dibuat:
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=siakad_smpn1_trimurjo
DB_USERNAME=root
DB_PASSWORD=

# 2. Model Eloquent yang siap dibuat:
# - User, Role
# - Guru, Kelas, Siswa, KelasSiswa
# - TahunAjaran, Hari, JamPelajaran, MataPelajaran
# - Jadwal, Nilai
```
Dokumen ini aman dan siap dilanjutkan kapan saja!

