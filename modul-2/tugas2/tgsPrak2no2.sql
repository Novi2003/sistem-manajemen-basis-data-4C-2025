CREATE DATABASE tugasprak2no2;

USE tugasprak2no2;

SHOW TABLES;

CREATE TABLE siswa(
	id_siswa INT PRIMARY KEY,
	nama_lengkap VARCHAR(50) NOT NULL,
	tanggal_lahir DATE NOT NULL,
	jenis_kelamin ENUM('laki-laki', 'perempuan') NOT NULL,
	alamat VARCHAR(50) NOT NULL,
	no_hp VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL
);

INSERT INTO siswa VALUES
	(206612, 'siti aini', '2003-10-12', 'perempuan', 'waru', '085940075787', 'aini@gmail.com'),
	(206687, 'ahmad alghazali', '2005-10-17', 'laki-laki', 'pakong', '083123924456', 'ahmdalgha@gmail.com'),
	(206613, 'zehroh', '2003-05-23', 'perempuan', 'pamekasan', '082964246567', 'zehroh@gmail.com');

CREATE TABLE kelas(
	id_kelas VARCHAR(10) PRIMARY KEY,
	nama_kelas VARCHAR(50) NOT NULL,
	tingkatan INT NOT NULL,
	jurusan VARCHAR(50) NOT NULL
);

INSERT INTO kelas VALUES
	(001, 'X ips 2',10, 'ips'),
	(002, 'XI ipa 3', 11, 'ipa'),
	(003, 'XII bhs 1', 12, 'bhs');

SELECT * FROM kelas;

CREATE TABLE pendaftaran(
	id_pendaftaran INT PRIMARY KEY,
	id_siswa INT NOT NULL,
	tanggal_daftar DATE NOT NULL,
	status_pendaftaran ENUM('diterima', 'tidak diterima') NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa)
);


INSERT INTO pendaftaran VALUES
	(123, 206612, '2016-06-20', 'diterima'),
	(162, 206687, '2016-06-12', 'diterima'),
	(178, 206613, '2016-06-25', 'tidak diterima');

CREATE TABLE pembayaran(
	id_pembayaran INT PRIMARY KEY,
	id_pendaftaran INT NOT NULL,
	tanggal_bayar DATE NOT NULL,
	jumlah DECIMAL(10, 2) NOT NULL,
	metode_pembayaran VARCHAR(50) NOT NULL,
	status_pembayaran ENUM('berhasil','gagal') NOT NULL,
	FOREIGN KEY (id_pendaftaran) REFERENCES pendaftaran (id_pendaftaran)
);

INSERT INTO pembayaran VALUES
	(2, 123, '2016-06-22', 150000, 'tunai', 'berhasil'),
	(5, 162, '2016-06-17', 150000, 'transfer', 'gagal'),
	(3, 178, '2016-06-25', 150000, 'tunai', 'berhasil');

CREATE TABLE penempatan_kelas(
	id_penempatan VARCHAR(10) PRIMARY KEY,
	id_siswa INT NOT NULL,
	id_kelas VARCHAR(10) NOT NULL,
	tanggal_penempatan DATE NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa),
	FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas)
);

INSERT INTO penempatan_kelas VALUES
	('M11', 206612, 001, '2016-07-05'),
	('M12', 206687, 002, '2016-07-05'),
	('M13', 206613, 003, '2016-07-05');
	
SELECT * FROM siswa;
SELECT * FROM kelas;
SELECT * FROM pendaftaran;
SELECT * FROM pembayaran;
SELECT * FROM penempatan_kelas;

#1 gabungan dari 2 tabel	
CREATE VIEW view_siswa_pendaftaran AS
SELECT 
    s.id_siswa,
    s.nama_lengkap,
    p.id_pendaftaran,
    p.tanggal_daftar,
    p.status_pendaftaran
FROM siswa s
JOIN pendaftaran p ON s.id_siswa = p.id_siswa;

SELECT * FROM view_siswa_pendaftaran;


#2 gabungan 3 tabel
CREATE VIEW view_siswa_pendaftaran_pembayaran AS
SELECT 
    s.id_siswa,
    s.nama_lengkap,
    p.id_pendaftaran,
    pd.id_pembayaran,
    p.status_pendaftaran,
    pd.jumlah,
    pd.metode_pembayaran,
    pd.status_pembayaran
FROM siswa s
JOIN pendaftaran p ON s.id_siswa = p.id_siswa
JOIN pembayaran pd ON p.id_pendaftaran = pd.id_pendaftaran;

SELECT * FROM view_siswa_pendaftaran_pembayaran;

#3 gabungan 2 tbl dgn memenuhi syarat tertentu
CREATE VIEW view_siswa_pembayaran_berhasil AS
SELECT 
    s.nama_lengkap,
    p.id_pembayaran,
    p.jumlah,
    p.metode_pembayaran
FROM siswa s
JOIN pendaftaran d ON s.id_siswa = d.id_siswa
JOIN pembayaran p ON d.id_pendaftaran = p.id_pendaftaran
WHERE p.status_pembayaran = 'berhasil';

SELECT * FROM view_siswa_pembayaran_berhasil;

#4 menampilkan hasil fungsi agregasi
CREATE VIEW view_total_pembayaran_siswa AS
SELECT 
    s.id_siswa,
    s.nama_lengkap,
    SUM(p.jumlah) AS total_pembayaran
FROM siswa s
JOIN pendaftaran d ON s.id_siswa = d.id_siswa
JOIN pembayaran p ON d.id_pendaftaran = p.id_pendaftaran
WHERE p.status_pembayaran = 'berhasil'
GROUP BY s.id_siswa, s.nama_lengkap;

SELECT * FROM view_total_pembayaran_siswa;

#5 yang berguna dlm database
CREATE VIEW view_siswa_kelas AS
SELECT 
    s.id_siswa,
    s.nama_lengkap,
    k.nama_kelas,
    k.jurusan,
    pk.tanggal_penempatan
FROM siswa s
JOIN penempatan_kelas pk ON s.id_siswa = pk.id_siswa
JOIN kelas k ON pk.id_kelas = k.id_kelas;

SELECT * FROM view_siswa_kelas;

