create database QLSV
 go

 use QLSV
 go

 create table sinhVien(
 maSV char(10) PRIMARY KEY,
 hoTen nvarchar(50),
 tuoi int,
 gioiTinh nvarchar(10)
 )
 create table monHoc(
 maMH char(10) PRIMARY KEY,
 tenMH nvarchar(50)
 )
 create table Hoc(
 maSV  char(10),
 maMH char(10),
 diem int
 FOREIGN KEY (maSV) REFERENCES sinhVien(maSV),
 FOREIGN KEY (maMH) REFERENCES monHoc(maMH),
 )

 INSERT INTO sinhVien
VALUES ('SV01',N'Kiều Phong',30,N'Nam'),
 ('SV02',N'Hư Trúc',28,N'Nam'),
 ('SV03',N'Đoàn Dự',25,N'Nam'),
 ('SV04',N'Mộ Dung Phục',26,N'Nam'),
 ('SV05',N'Tiểu Long Nữ',18,N'Nữ')
 
 insert into monHoc(maMH,tenMH)
 values
 (N'MH01',N'Túy Quyền'),
 (N'MH02',N'Túy Kiếm'),
 (N'MH03',N'Túy Côn'),
 (N'MH04',N'Hàng Long Thập Bát Trưởng'),
 (N'MH05',N'Lang Tam Di Bộ'),
 (N'MH06',N'Lục Mạch Thần Kiếm')
 
 insert into Hoc
 values 
 (N'SV01',N'MH01',8),
 (N'SV01',N'MH04',9),
 (N'SV02',N'MH01',5),
 (N'SV02',N'MH02',7),
 (N'SV02',N'MH03',8),
 (N'SV03',N'MH05',9),
 (N'SV03',N'MH06',10),
 (N'SV05',N'MH01',4),
 (N'SV05',N'MH05',9)

 select * from sinhVien
 select * from Hoc
 select * from monHoc

 
 --1. MaSV, HoTen của toàn bộ Sinh Viên.
 select sinhVien.maSv,sinhVien.hoTen from sinhVien

--2. MaSV, HoTen, Tuoi của Sinh Viên “Nữ”
 select sinhVien.maSv,sinhVien.hoTen,sinhVien.tuoi from sinhVien where gioiTinh = N'Nữ'

--3. Thông tin Các Môn Học
 select * from monHoc

--4. MaMH, TenMH, Số Sinh Viên Học của Từng Môn
SELECT monHoc.maMH, monHoc.tenMH, COUNT(Hoc.maSV) AS N' Số sinh viên học từng môn'
FROM monHoc
INNER JOIN Hoc ON monHoc.maMH = Hoc.maMH
GROUP BY monHoc.maMH, monHoc.tenMH


--5. MaMH, TenMH, MaSV, TenSV của môn học có nhiều SV học nhất.
SELECT monHoc.maMH, monHoc.tenMH, sinhVien.maSV, sinhVien.hoTen AS 'TenSV'
FROM monHoc
INNER JOIN Hoc ON monHoc.maMH = Hoc.maMH
INNER JOIN sinhVien ON Hoc.maSV = sinhVien.maSV
WHERE monHoc.maMH = (
   SELECT TOP 1 monHoc.maMH
   FROM monHoc
   INNER JOIN Hoc ON monHoc.maMH = Hoc.maMH
   GROUP BY monHoc.maMH
   ORDER BY COUNT(DISTINCT Hoc.maSV) DESC
)

--6. MaMH, TenMH, Số Sinh Viên Học của Từng Môn
SELECT monHoc.maMH, monHoc.tenMH, COUNT(DISTINCT Hoc.maSV) AS 'SoSinhVienHoc'
FROM monHoc
INNER JOIN Hoc ON monHoc.maMH = Hoc.maMH
GROUP BY monHoc.maMH, monHoc.tenMH

--7. MaSV, HoTen, Tuoi của Sinh Viên chưa học bất kỳ môn nào
SELECT sinhVien.maSV, sinhVien.hoTen, sinhVien.tuoi
FROM sinhVien
LEFT JOIN Hoc ON sinhVien.maSV = Hoc.maSV
WHERE Hoc.maSV IS NULL

--8. MaSV, HoTen, MaMH, TenMH, Diem của Sinh Viên có Điểm <=4
SELECT sinhVien.maSV, sinhVien.hoTen, monHoc.maMH, monHoc.tenMH, Hoc.diem
FROM sinhVien
INNER JOIN Hoc ON sinhVien.maSV = Hoc.maSV
INNER JOIN monHoc ON Hoc.maMH = monHoc.maMH
WHERE Hoc.diem <= 4

--9. Liệt kê MaMH, TenMH,Diem các Môn học mà Sinh Viên "Kiều Phong" theo học.
SELECT monHoc.maMH, monHoc.tenMH, Hoc.diem
FROM sinhVien
INNER JOIN Hoc ON sinhVien.maSV = Hoc.maSV
INNER JOIN monHoc ON Hoc.maMH = monHoc.maMH
WHERE sinhVien.hoTen = N'Kiều Phong'

--10. Liệt Kê MaSV,HoTen,Tuoi,Diem của các Sinh Viên học môn "Túy Quyền"
SELECT sinhVien.maSV, sinhVien.hoTen, sinhVien.tuoi, Hoc.diem, monHoc.maMH, monHoc.tenMH
FROM sinhVien
JOIN Hoc ON sinhVien.maSV = Hoc.maSV
JOIN monHoc ON Hoc.maMH = monHoc.maMH
WHERE monHoc.tenMH = N'Túy Quyền' AND sinhVien.hoTen = N'Kiều Phong'


