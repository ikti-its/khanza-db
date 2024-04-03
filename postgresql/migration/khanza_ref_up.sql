-- Role
CREATE TABLE IF NOT EXISTS role (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Modul C (Fathur, Ruben)
-- Jabatan
CREATE TABLE IF NOT EXISTS jabatan (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Departemen
CREATE TABLE IF NOT EXISTS departemen (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Status Aktif Pegawai
CREATE TABLE IF NOT EXISTS status_aktif_pegawai (
    id VARCHAR(2) PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Shift
CREATE TABLE IF NOT EXISTS shift (
    id VARCHAR(2) PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    jam_masuk TIME WITH TIME ZONE NOT NULL,
    jam_pulang TIME WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Hari
CREATE TABLE IF NOT EXISTS hari (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Alasan Cuti
CREATE TABLE IF NOT EXISTS alasan_cuti (
    id VARCHAR(2) PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- MODUL D (Leo)
-- Industri Farmasi
CREATE TABLE IF NOT EXISTS industri_farmasi (
    id INT PRIMARY KEY,
    kode VARCHAR(20) NOT NULL UNIQUE,
    nama VARCHAR(50) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    kota VARCHAR(255) NOT NULL,
    telepon VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO industri_farmasi (id, kode, nama, alamat, kota, telepon) VALUES ('1000', 'KLBF', 'Kalbe Farma', 'Jln. jalan', 'Jakarta','0812312312');

-- Jenis Obat
CREATE TABLE IF NOT EXISTS ref.jenis_obat (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ref.jenis_obat (id, nama) VALUES ('1000', 'Obat Oral'), ('2000', 'Obat Topikal'), ('3000', 'Obat Injeksi'), ('4000', 'Obat Sublingual'), ('5000', 'Obat Infus');

-- Kategori Obat
CREATE TABLE IF NOT EXISTS ref.kategori_obat (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ref.kategori_obat (id, nama) VALUES ('1000', 'Obat Paten'), ('2000', 'Obat Generik'), ('3000', 'Obat Merek'), ('4000', 'Obat Eksklusif'), ('5000', 'Obat Bebas Paten');

-- Golongan Obat
CREATE TABLE IF NOT EXISTS ref.golongan_obat (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ref.golongan_obat (id, nama) VALUES ('1000', 'Analgesik'), ('2000', 'Antibiotik'), ('3000', 'Antijamur'), ('4000', 'Antivirus'), ('5000', 'Antasida');

-- Ruangan
CREATE TABLE IF NOT EXISTS ref.ruangan (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ref.ruangan (id, nama) VALUES ('1000', 'VIP 1'), ('2000', 'VIP 2'), ('3000', 'VVIP 1'), ('4000', 'VVIP 2'), ('5000', 'Gudang Farmasi');

-- Supplier Barang Medis
CREATE TABLE IF NOT EXISTS ref.supplier_barang_medis (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    no_telp VARCHAR(20) NOT NULL,
    kota VARCHAR(50) NOT NULL,
    nama_bank VARCHAR(100) NOT NULL,
    no_rekening VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ref.supplier_barang_medis (id, nama, alamat, no_telp, kota, nama_bank, no_rekening) VALUES ('1', 'Mitra', 'Jln. Benar', '08234234','Jakarta', 'BCA','8123123');

-- Akun Bayar
CREATE TABLE IF NOT EXISTS ref.akun_bayar (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    nomor_rekening VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ref.akun_bayar (id, nama, nomor_rekening) VALUES ('1000', 'Cash', '-'), ('2000', 'Bank Mandiri', '12308123123'), ('3000', 'Bank BCA', '12208123123');
