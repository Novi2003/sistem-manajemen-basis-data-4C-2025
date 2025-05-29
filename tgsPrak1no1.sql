CREATE DATABASE tugasprak1no1;

USE tugasprak1no1;

DROP DATABASE tugasprak1no1;

SHOW TABLES ;

CREATE TABLE mahasiswa(
	nim INT PRIMARY KEY,
	nama VARCHAR(50) NOT NULL,
	alamat VARCHAR(50) NOT NULL,
	fakultas VARCHAR(50) NOT NULL,
	prodi VARCHAR(50) NOT NULL,
	tahun_masuk DATE NOT NULL
);

INSERT INTO mahasiswa VALUES 
    (23044190, 'Noer khofifah oktavia yusuf', 'pakong', 'Teknik', 'Sistem informasi', '2023-08-10'),
    (23044150, 'Nur Lailia ilhami', 'sampang', 'Teknik', 'Sistem informasi', '2023-09-23'),
    (23044184, 'Wira selfina laydi', 'sumenep', 'Teknik', 'Sistem informasi', '2023-08-12'),
    (23044110, 'Siti nur aini', 'waru', 'FEB', 'manajemen bisnis', '2023-07-11'),
    (23044124, 'Shobihatin', 'probolinggo', 'Fisib', 'psikologi', '2022-10-03'),
    (23044176, 'Imam Mawardi', 'pamekasan', 'Teknik', 'teknik mesin', '2020-05-13'),
    (23044167, 'Novaila', 'surabaya', 'Fkip', 'sains', '2023-04-04'),
    (23044134, 'Eko afandani', 'kediri', 'Fkis', 'usuluddin', '2019-06-25'),
    (23044145, 'Mohammad alfan', 'bangkalan', 'Teknik', 'Teknik informatika', '2018-12-31'),
    (23044198, 'Chandra habibullah hozrin', 'mojkerto', 'hukum', 'hukum tatanegara', '2021-04-09');

SELECT * FROM pelajar;

RENAME TABLE pelajar TO mahasiswa;

CREATE TABLE dosen(
	nip INT PRIMARY KEY,
	nama VARCHAR(50) NOT NULL,
	alamat VARCHAR(50) NOT NULL
);

INSERT INTO dosen VALUES
	(21770036, 'mohammad fajri', 'jombang'),
	(21770030, 'ahmad ali', 'pamekasan'),
	(21770046, 'abdus sukur', 'surabaya'),
	(21770048, 'syarif hidayatullah', 'sumenep'),
	(21770074, 'andi wahyudi', 'gresik'),
	(21770093, 'agus jufriyanto', 'jakarta'),
	(21770029, 'abdul somad', 'kediri'),
	(21770067, 'achmad rifani', 'sidoarjo'),
	(21770034, 'ainul yakin', 'sampang'),
	(21770089, 'ahmad alghazali', 'banten');
	
SELECT * FROM dosen;

CREATE TABLE matakuliah(
	id_matakuliah INT PRIMARY KEY,
	matakuliah VARCHAR(50) NOT NULL,
	sks INT NOT NULL,
	nip INT NOT NULL,
	FOREIGN KEY (nip) REFERENCES dosen (nip)
);

INSERT INTO matakuliah VALUES
	(1109, 'Riset operasi', 3, 21770036),
	(1167, 'bahasa indonesia', 2, 21770030),
	(1134, 'pemrograman visual', 4, 21770046),
	(1149, 'arsitektur SI/TI', 3, 21770048),
	(1115, 'bahasa inggris', 2, 21770074),
	(1195, 'pemrograman visual', 4, 21770093),
	(1127, 'kewarganegaraan', 2, 21770029),
	(1163, 'keamanan informasi', 3, 21770067),
	(1137, 'sistem operasi', 3, 21770034),
	(1113, 'data mining', 3, 21770089);
	
SELECT * FROM matakuliah;

CREATE TABLE krs(
	id_krs INT PRIMARY KEY,
	id_matakuliah INT NOT NULL,
	nim INT NOT NULL,
	FOREIGN KEY (nim) REFERENCES mahasiswa (nim),
	FOREIGN KEY (id_matakuliah) REFERENCES matakuliah (id_matakuliah)
);

INSERT INTO krs VALUES 
	(123, 1113 , 23044184),
	(432, 1163 , 23044190),
	(875, 1167 , 23044150),
	(214, 1109 , 23044110),
	(385, 1149 , 23044124);
	
SELECT * FROM krs;