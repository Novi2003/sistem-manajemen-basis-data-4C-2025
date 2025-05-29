CREATE DATABASE tugasprak1no2;

USE tugasprak1no2;

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
	id_kelas varchar(10) NOT NULL,
	tanggal_penempatan DATE NOT NULL,
	FOREIGN KEY (id_siswa) REFERENCES siswa (id_siswa),
	FOREIGN KEY (id_kelas) REFERENCES kelas (id_kelas)
);

INSERT INTO penempatan_kelas VALUES
	('M11', 206612, 001, '2016-07-05'),
	('M12', 206687, 002, '2016-07-05'),
	('M13', 206613, 003, '2016-07-05');
	
select * from siswa;
SELECT * FROM kelas;
select * from pendaftaran;
select * from pembayaran;
select * from penempatan_kelas;


