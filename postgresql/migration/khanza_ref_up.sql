-- Role
CREATE TABLE IF NOT EXISTS role (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Organisasi
CREATE TABLE IF NOT EXISTS organisasi (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nama VARCHAR(255) NOT NULL,
    alamat VARCHAR(255) NOT NULL,
    latitude NUMERIC NOT NULL,
    longitude NUMERIC NOT NULL,
    radius NUMERIC NOT NULL,
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
-- Satuan Barang Medis
CREATE TABLE IF NOT EXISTS satuan_barang_medis (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Jenis Obat
CREATE TABLE IF NOT EXISTS jenis_obat (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Kategori Obat
CREATE TABLE IF NOT EXISTS kategori_obat (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Golongan Obat
CREATE TABLE IF NOT EXISTS golongan_obat (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Ruangan
CREATE TABLE IF NOT EXISTS ruangan (
    id INT PRIMARY KEY,
    nama VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Supplier Barang Medis
CREATE TABLE IF NOT EXISTS supplier_barang_medis (
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

-- Akun Bayar
CREATE TABLE IF NOT EXISTS akun_bayar (
    id INT PRIMARY KEY,
    nama_akun VARCHAR(100) NOT NULL,
    nomor_rekening VARCHAR(50) NOT NULL,
    nama_rekening VARCHAR(50) NOT NULL,
    ppn FLOAT NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
