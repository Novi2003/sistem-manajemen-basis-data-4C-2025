CREATE DATABASE tugasprak4;

USE tugasprak4;

#1
ALTER TABLE pembayaran ADD COLUMN keterangan VARCHAR(100);
	
#2
SELECT s.id_siswa, s.nama_lengkap, p.status_pendaftaran, p.tanggal_daftar
FROM siswa s
JOIN pendaftaran p ON s.id_siswa = p.id_siswa;

#3
SELECT * FROM siswa ORDER BY nama_lengkap ASC;
SELECT * FROM pembayaran ORDER BY id_pembayaran DESC;
SELECT * FROM kelas ORDER BY tingkatan ASC;
SELECT * FROM pendaftaran ORDER BY id_pendaftaran DESC;
SELECT * FROM penempatan_kelas ORDER BY id_kelas DESC;
 
#4
ALTER TABLE siswa MODIFY COLUMN no_hp VARCHAR(12);

#5
SELECT s.nama_lengkap, p.status_pendaftaran
FROM siswa s
LEFT JOIN pendaftaran p ON s.id_siswa = p.id_siswa;

SELECT s.nama_lengkap, p.status_pendaftaran
FROM siswa s
RIGHT JOIN pendaftaran p ON s.id_siswa = p.id_siswa;

SELECT s1.nama_lengkap AS siswa1, s2.nama_lengkap AS siswa2
FROM siswa s1
INNER JOIN siswa s2 ON s1.id_siswa = s2.id_siswa;


#6
-- Siswa yang lahir setelah 2004
SELECT * FROM siswa WHERE tanggal_lahir > '2004-01-01';

-- Pembayaran lebih kecil dari 150000
SELECT * FROM pembayaran WHERE jumlah < 150000.00;

-- Status pembayaran selain berhasil
SELECT * FROM pembayaran WHERE status_pembayaran <> 'berhasil';

-- siswa yang lahir sebelum 2004
SELECT * FROM siswa WHERE tanggal_lahir <= '2004-01-01';

-- siswa yang lahir setelah 2003
SELECT * FROM siswa WHERE tanggal_lahir >= '2003-10-12';

-- Pembayaran sama dengan 150000
SELECT * FROM pembayaran WHERE jumlah = 150000;

SELECT nama_lengkap FROM siswa WHERE nama_lengkap LIKE'w%';






