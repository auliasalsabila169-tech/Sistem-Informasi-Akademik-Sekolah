-- ==============================================================
-- BASIS DATA LANJUT - SISTEM INFORMASI AKADEMIK (SIAKAD)
-- OBJEK STUDI: SMP NEGERI 1 TRIMURJO
-- DBMS: MySQL / MariaDB (phpMyAdmin Compatible)
-- Engine: InnoDB (Full Foreign Key Constraints)
-- ==============================================================

CREATE DATABASE IF NOT EXISTS `siakad_smpn1_trimurjo` 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `siakad_smpn1_trimurjo`;

-- Nonaktifkan pengecekan foreign key sementara saat setup tabel
SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------------
-- 1. Tabel: roles (Hak Akses Pengguna)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  `guard_name` VARCHAR(50) NOT NULL DEFAULT 'web',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 2. Tabel: users (Akun Login Aplikasi Laravel)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id_user` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `email_verified_at` TIMESTAMP NULL DEFAULT NULL,
  `password` VARCHAR(255) NOT NULL,
  `remember_token` VARCHAR(100) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 3. Tabel: model_has_roles (Relasi Pengguna ke Role)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `model_has_roles`;
CREATE TABLE `model_has_roles` (
  `role_id` BIGINT UNSIGNED NOT NULL,
  `model_type` VARCHAR(255) NOT NULL DEFAULT 'App\\Models\\User',
  `model_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `model_id`, `model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`, `model_type`),
  CONSTRAINT `fk_mhr_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_mhr_user` FOREIGN KEY (`model_id`) REFERENCES `users` (`id_user`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 4. Tabel: tahun_ajaran (Periode Akademik)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `tahun_ajaran`;
CREATE TABLE `tahun_ajaran` (
  `id_tahun_ajaran` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `tahun` VARCHAR(50) NOT NULL, -- Contoh: 2025/2026
  `semester_aktif` ENUM('Ganjil', 'Genap') NOT NULL DEFAULT 'Ganjil',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 5. Tabel: guru (Data Guru & Tenaga Pengajar)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `guru`;
CREATE TABLE `guru` (
  `id_guru` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NULL,
  `nip` VARCHAR(50) NOT NULL UNIQUE,
  `nama_guru` VARCHAR(255) NOT NULL,
  `jenis_kelamin` ENUM('L', 'P') NOT NULL,
  `no_hp` VARCHAR(25) NULL,
  `alamat` TEXT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_guru_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id_user`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 6. Tabel: kelas (Rombongan Belajar & Wali Kelas)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `kelas`;
CREATE TABLE `kelas` (
  `id_kelas` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `nama_kelas` VARCHAR(50) NOT NULL, -- Misal: VII A, VIII B, IX C
  `tingkat` VARCHAR(20) NOT NULL,    -- 7, 8, 9
  `jurusan` VARCHAR(50) NOT NULL DEFAULT 'Umum',
  `guru_id` BIGINT UNSIGNED NULL,    -- Wali Kelas
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_kelas_walikelas` FOREIGN KEY (`guru_id`) REFERENCES `guru` (`id_guru`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 7. Tabel: siswas (Data Induk Siswa Lengkap)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `siswas`;
CREATE TABLE `siswas` (
  `id_siswa` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` BIGINT UNSIGNED NULL, -- Perbaikan: menghubungkan akun login siswa
  `kelas_id` BIGINT UNSIGNED NULL, -- Relasi kelas siswa
  `nis` VARCHAR(50) NOT NULL UNIQUE,
  `nisn` VARCHAR(50) NOT NULL UNIQUE,
  `nama` VARCHAR(255) NOT NULL,
  `jenis_kelamin` ENUM('L', 'P') NOT NULL,
  `tempat_lahir` VARCHAR(100) NULL,
  `tanggal_lahir` DATE NULL,
  `agama` VARCHAR(50) NOT NULL DEFAULT 'Islam',
  `kewarganegaraan` VARCHAR(50) NOT NULL DEFAULT 'Indonesia',
  `anak_ke` VARCHAR(10) NULL,
  `jumlah_saudara_kandung` INT NOT NULL DEFAULT 0,
  `jumlah_saudara_tiri` INT NOT NULL DEFAULT 0,
  `jumlah_saudara_angkat` INT NOT NULL DEFAULT 0,
  `bahasa_sehari_hari` VARCHAR(100) NOT NULL DEFAULT 'Bahasa Indonesia',
  `alamat` TEXT NULL,
  `desa` VARCHAR(100) NULL,
  `kecamatan` VARCHAR(100) NULL,
  `kabupaten` VARCHAR(100) NULL,
  `provinsi` VARCHAR(100) NULL,
  `kode_pos` VARCHAR(20) NULL,
  `jarak_ke_sekolah` VARCHAR(50) NULL,
  `tinggal_dengan` VARCHAR(50) NULL,
  `transportasi` VARCHAR(50) NULL,
  `telepon` VARCHAR(50) NULL,
  `golongan_darah` VARCHAR(10) NULL,
  `penyakit` VARCHAR(100) NULL,
  `penyakit_pernah_diderita` TEXT NULL,
  `kelainan_jasmani` VARCHAR(100) NULL,
  `tinggi_badan` VARCHAR(20) NULL,
  `berat_badan` VARCHAR(20) NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_siswa_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id_user`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_siswa_kelas` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id_kelas`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 8. Tabel: kelas_siswa (Tabel Perbaikan: Menentukan Kelas Siswa per Tahun Ajaran)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `kelas_siswa`;
CREATE TABLE `kelas_siswa` (
  `id_kelas_siswa` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `siswa_id` BIGINT UNSIGNED NOT NULL,
  `kelas_id` BIGINT UNSIGNED NOT NULL,
  `tahun_ajaran_id` BIGINT UNSIGNED NOT NULL,
  `status` ENUM('Aktif', 'Lulus', 'Pindah', 'Tinggal Kelas') NOT NULL DEFAULT 'Aktif',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_siswa_tahun` (`siswa_id`, `tahun_ajaran_id`),
  CONSTRAINT `fk_ks_siswa` FOREIGN KEY (`siswa_id`) REFERENCES `siswas` (`id_siswa`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ks_kelas` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ks_tahun` FOREIGN KEY (`tahun_ajaran_id`) REFERENCES `tahun_ajaran` (`id_tahun_ajaran`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 9. Tabel: hari (Data Master Hari)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `hari`;
CREATE TABLE `hari` (
  `id_hari` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `nama_hari` VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 10. Tabel: jam_pelajaran (Master Slot Jam Belajar)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `jam_pelajaran`;
CREATE TABLE `jam_pelajaran` (
  `id_jam_pelajaran` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `jam_mulai` TIME NOT NULL,
  `jam_selesai` TIME NOT NULL,
  `urutan` INT NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 11. Tabel: mata_pelajaran (Master Mata Pelajaran)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `mata_pelajaran`;
CREATE TABLE `mata_pelajaran` (
  `id_mata_pelajaran` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `kode_mapel` VARCHAR(50) NOT NULL UNIQUE,
  `nama_mapel` VARCHAR(255) NOT NULL,
  `kkm` INT NOT NULL DEFAULT 75,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 12. Tabel: jadwal (Jadwal Pelajaran Kelas & Guru Pengampu)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `jadwal`;
CREATE TABLE `jadwal` (
  `id_jadwal` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `guru_id` BIGINT UNSIGNED NOT NULL,
  `mapel_id` BIGINT UNSIGNED NOT NULL,
  `kelas_id` BIGINT UNSIGNED NOT NULL,
  `hari_id` BIGINT UNSIGNED NOT NULL,
  `jam_id` BIGINT UNSIGNED NOT NULL,
  `tahun_ajaran_id` BIGINT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_jadwal_guru` FOREIGN KEY (`guru_id`) REFERENCES `guru` (`id_guru`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_jadwal_mapel` FOREIGN KEY (`mapel_id`) REFERENCES `mata_pelajaran` (`id_mata_pelajaran`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_jadwal_kelas` FOREIGN KEY (`kelas_id`) REFERENCES `kelas` (`id_kelas`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_jadwal_hari` FOREIGN KEY (`hari_id`) REFERENCES `hari` (`id_hari`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_jadwal_jam` FOREIGN KEY (`jam_id`) REFERENCES `jam_pelajaran` (`id_jam_pelajaran`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_jadwal_tahun` FOREIGN KEY (`tahun_ajaran_id`) REFERENCES `tahun_ajaran` (`id_tahun_ajaran`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------
-- 13. Tabel: nilais (Penilaian Akademik, Rapor, dan Leger)
-- --------------------------------------------------------------
DROP TABLE IF EXISTS `nilais`;
CREATE TABLE `nilais` (
  `id_nilai` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `siswa_id` BIGINT UNSIGNED NOT NULL,
  `jadwal_id` BIGINT UNSIGNED NOT NULL,
  `tahun_ajaran_id` BIGINT UNSIGNED NOT NULL,
  `semester` ENUM('Ganjil', 'Genap') NOT NULL DEFAULT 'Ganjil',
  `nilai_pengetahuan` INT NOT NULL DEFAULT 0,
  `nilai_keterampilan` INT NOT NULL DEFAULT 0,
  `nilai_sikap` VARCHAR(10) NOT NULL DEFAULT 'B',
  `nilai_akhir` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  `deskripsi` TEXT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_nilai_siswa` FOREIGN KEY (`siswa_id`) REFERENCES `siswas` (`id_siswa`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_nilai_jadwal` FOREIGN KEY (`jadwal_id`) REFERENCES `jadwal` (`id_jadwal`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_nilai_tahun` FOREIGN KEY (`tahun_ajaran_id`) REFERENCES `tahun_ajaran` (`id_tahun_ajaran`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Aktifkan kembali pengecekan foreign key
SET FOREIGN_KEY_CHECKS = 1;


-- ==============================================================
-- DUMMY SEEDER DATA (DATA AWAL LENGKAP SMPN 1 TRIMURJO)
-- Password default semua user: password (bcrypt hash)
-- ==============================================================

-- 1. Insert Roles (4 Hak Akses Skripsi)
INSERT INTO `roles` (`id`, `name`, `guard_name`) VALUES
(1, 'Tata Usaha', 'web'),
(2, 'Guru', 'web'),
(3, 'Wali Kelas', 'web'),
(4, 'Siswa', 'web');

-- 2. Insert Users
-- Hash: $2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi adalah hash laravel untuk 'password'
INSERT INTO `users` (`id_user`, `name`, `email`, `password`) VALUES
(1, 'Staf Tata Usaha', 'tu@smpn1trimurjo.sch.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
(2, 'Istri Sugiyatmi, S.Pd.', 'sugiyatmi@smpn1trimurjo.sch.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
(3, 'Budi Santoso, S.Pd.', 'budi@smpn1trimurjo.sch.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
(4, 'Ahmad Pratama', 'ahmad@siswa.smpn1trimurjo.sch.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'),
(5, 'Siti Nurhaliza', 'siti@siswa.smpn1trimurjo.sch.id', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- 3. Assign Role ke User
INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1), -- Tata Usaha
(3, 'App\\Models\\User', 2), -- Wali Kelas
(2, 'App\\Models\\User', 3), -- Guru Mata Pelajaran
(4, 'App\\Models\\User', 4), -- Siswa
(4, 'App\\Models\\User', 5); -- Siswa

-- 4. Insert Tahun Ajaran
INSERT INTO `tahun_ajaran` (`id_tahun_ajaran`, `tahun`, `semester_aktif`, `is_active`) VALUES
(1, '2025/2026', 'Ganjil', 1),
(2, '2024/2025', 'Genap', 0);

-- 5. Insert Guru
INSERT INTO `guru` (`id_guru`, `user_id`, `nip`, `nama_guru`, `jenis_kelamin`, `no_hp`, `alamat`) VALUES
(1, 2, '197508122005012003', 'Istri Sugiyatmi, S.Pd.', 'P', '081234567890', 'Trimurjo, Lampung Tengah'),
(2, 3, '198203152008021004', 'Budi Santoso, S.Pd.', 'L', '081398765432', 'Metro, Lampung');

-- 6. Insert Kelas
INSERT INTO `kelas` (`id_kelas`, `nama_kelas`, `tingkat`, `jurusan`, `guru_id`) VALUES
(1, 'VII A', '7', 'Umum', 1), -- Wali kelas: Ibu Istri Sugiyatmi
(2, 'VII B', '7', 'Umum', NULL),
(3, 'VIII A', '8', 'Umum', NULL),
(4, 'IX A', '9', 'Umum', NULL);

-- 7. Insert Hari
INSERT INTO `hari` (`id_hari`, `nama_hari`) VALUES
(1, 'Senin'),
(2, 'Selasa'),
(3, 'Rabu'),
(4, 'Kamis'),
(5, 'Jumat'),
(6, 'Sabtu');

-- 8. Insert Jam Pelajaran
INSERT INTO `jam_pelajaran` (`id_jam_pelajaran`, `jam_mulai`, `jam_selesai`, `urutan`) VALUES
(1, '07:15:00', '07:55:00', 1),
(2, '07:55:00', '08:35:00', 2),
(3, '08:35:00', '09:15:00', 3),
(4, '09:30:00', '10:10:00', 4);

-- 9. Insert Mata Pelajaran
INSERT INTO `mata_pelajaran` (`id_mata_pelajaran`, `kode_mapel`, `nama_mapel`, `kkm`) VALUES
(1, 'MP-IPA', 'Ilmu Pengetahuan Alam (IPA)', 75),
(2, 'MP-MTK', 'Matematika', 75),
(3, 'MP-BINDO', 'Bahasa Indonesia', 78),
(4, 'MP-BING', 'Bahasa Inggris', 75),
(5, 'MP-PAI', 'Pendidikan Agama Islam', 80);

-- 10. Insert Siswa
INSERT INTO `siswas` (`id_siswa`, `user_id`, `nis`, `nisn`, `nama`, `jenis_kelamin`, `tempat_lahir`, `tanggal_lahir`, `alamat`, `desa`, `kecamatan`, `kabupaten`, `provinsi`) VALUES
(1, 4, '24001', '0091234567', 'Ahmad Pratama', 'L', 'Lampung Tengah', '2011-04-12', 'Jl. Merdeka No. 12', 'Trimurjo', 'Trimurjo', 'Lampung Tengah', 'Lampung'),
(2, 5, '24002', '0091234568', 'Siti Nurhaliza', 'P', 'Metro', '2011-09-20', 'Jl. Sudirman No. 45', 'Simbarwaringin', 'Trimurjo', 'Lampung Tengah', 'Lampung');

-- 11. Insert Penempatan Siswa di Kelas (kelas_siswa)
INSERT INTO `kelas_siswa` (`siswa_id`, `kelas_id`, `tahun_ajaran_id`, `status`) VALUES
(1, 1, 1, 'Aktif'), -- Ahmad Pratama di kelas VII A (2025/2026)
(2, 1, 1, 'Aktif'); -- Siti Nurhaliza di kelas VII A (2025/2026)

-- 12. Insert Jadwal Pelajaran
INSERT INTO `jadwal` (`id_jadwal`, `guru_id`, `mapel_id`, `kelas_id`, `hari_id`, `jam_id`, `tahun_ajaran_id`) VALUES
(1, 1, 1, 1, 1, 1, 1), -- Ibu Istri mengajar IPA di kelas VII A, Senin jam 1
(2, 2, 2, 1, 1, 2, 1); -- Budi Santoso mengajar MTK di kelas VII A, Senin jam 2

-- 13. Insert Nilai (Contoh Pengisian Nilai Leger)
INSERT INTO `nilais` (`siswa_id`, `jadwal_id`, `tahun_ajaran_id`, `semester`, `nilai_pengetahuan`, `nilai_keterampilan`, `nilai_sikap`, `nilai_akhir`, `deskripsi`) VALUES
(1, 1, 1, 'Ganjil', 85, 88, 'A', 86.50, 'Sangat baik dalam memahami materi sistem pencernaan dan praktikum IPA'),
(2, 1, 1, 'Ganjil', 80, 84, 'B', 82.00, 'Baik dalam pemahaman materi IPA, terus tingkatkan keaktifan praktikum');

