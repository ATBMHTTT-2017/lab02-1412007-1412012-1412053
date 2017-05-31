// this is sample schema
//SCRIPT TAO CAU TRUC CO SO DU LIEU
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

--TAO BANG
--CHINHANH
CREATE TABLE ChiNhanh (
  maCN varchar2(5),
  tenCN nvarchar2(100) not null enable,
  truongChiNhanh varchar2(6) not null enable,
  primary key (maCN)
);

--CHITIEU
CREATE TABLE ChiTieu (
  maChiTieu varchar2(5),
  tenChiTieu nvarchar2(100) not null enable,
  soTien raw (2000),
  duAn varchar2(5) not null enable,
  primary key (maChiTieu)
);

--NHANVIEN
CREATE TABLE NhanVien (
  maNV varchar2(6),
  hoTen nvarchar2(50) not null enable,
  diaChi nvarchar2(100),
  dienThoai varchar2(12),
  email varchar2(30),
  maPhong varchar2(5) not null enable,
  chiNhanh varchar2(5) not null enable,
  luong raw (2000) not null enable,
  primary key (maNV)
);

--PHANCONG
CREATE TABLE PhanCong (
  maNV varchar2(6),
  duAn varchar2(5),
  vaiTro nvarchar2(50),
  phuCap varchar2 (20),
  phuCap_mahoa raw (2000),
  primary key (maNV, duAn)
);

--PHONGBAN
CREATE TABLE PhongBan (
  maPhong varchar2(5),
  tenPhong nvarchar2(30) not null enable,
  truongPhong varchar2(6) not null enable,
  ngayNhanChuc date not null enable,
  soNhanVien smallint not null enable,
  chiNhanh varchar2(5) not null enable,
  primary key (maPhong)
);

--DUAN
CREATE TABLE DuAn (
  maDA varchar2(5),
  tenDA nvarchar2(50) not null enable,
  kinhPhi float,
  phongChuTri varchar2(5) not null enable,
  truongDA varchar2(6) not null enable,
  primary key (maDA)
);

--TAO KHOA NGOAI
--CHINHANH
ALTER TABLE dbaDuAn.CHINHANH
ADD CONSTRAINT FK_CN_NV FOREIGN KEY (truongChiNhanh) REFERENCES NHANVIEN(maNV);

--CHITIEU
ALTER TABLE dbaDuAn.CHITIEU
ADD CONSTRAINT FK_CT_DA FOREIGN KEY (duAn) REFERENCES DUAN(maDA);

--NHANVIEN
ALTER TABLE dbaDuAn.NHANVIEN
ADD CONSTRAINT FK_NV_CN FOREIGN KEY (chiNhanh) REFERENCES CHINHANH(maCN);

ALTER TABLE dbaDuAn.NHANVIEN
ADD CONSTRAINT FK_NV_PB FOREIGN KEY (maPhong) REFERENCES PHONGBAN(maPhong);

--PHANCONG
ALTER TABLE dbaDuAn.PHANCONG
ADD CONSTRAINT FK_PC_NV FOREIGN KEY (maNV) REFERENCES NHANVIEN(maNV);

ALTER TABLE dbaDuAn.PHANCONG
ADD CONSTRAINT FK_PC_DA FOREIGN KEY (duAn) REFERENCES DUAN(maDA);

--PHONGBAN
ALTER TABLE dbaDuAn.PHONGBAN
ADD CONSTRAINT FK_PB_CN FOREIGN KEY (chiNhanh) REFERENCES CHINHANH(maCN);

ALTER TABLE dbaDuAn.PHONGBAN
ADD CONSTRAINT FK_PB_NV FOREIGN KEY (truongPhong) REFERENCES NHANVIEN(maNV);

--DUAN
ALTER TABLE dbaDuAn.DUAN
ADD CONSTRAINT FK_DA_NV FOREIGN KEY (truongDA) REFERENCES NHANVIEN(maNV);

ALTER TABLE dbaDuAn.DUAN
ADD CONSTRAINT FK_DA_PB FOREIGN KEY (phongChuTri) REFERENCES PHONGBAN(maPhong);
