ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

SET SERVEROUTPUT ON;

create or replace procedure sp_insert_encrypt_NHANVIEN
(p_maNV varchar2, p_hoten nvarchar2, p_diachi nvarchar2, p_dienthoai varchar2,
p_email varchar2, p_maphong varchar2, p_chinhanh varchar2, p_luong varchar2)
is
  key_raw raw (32);
  luong_mahoa_raw raw (2000);
  kieumahoa pls_integer;
begin
  if (length (p_maNV) = 5) then
    key_raw := utl_raw.cast_to_raw('1412007_1412012_1412053_000' || p_maNV);
  else
    key_raw := utl_raw.cast_to_raw('1412007_1412012_1412053_00' || p_maNV);
  end if;
  
  kieumahoa := DBMS_CRYPTO.ENCRYPT_AES256
                + DBMS_CRYPTO.CHAIN_CBC
                + DBMS_CRYPTO.PAD_PKCS5;
                
  luong_mahoa_raw := dbms_crypto.encrypt
  (
     src => UTL_I18N.STRING_TO_RAW (p_luong, 'AL32UTF8'),
     typ => kieumahoa,
     key => key_raw
  );
  
  insert into NHANVIEN values (p_maNV, p_hoten, p_diachi, p_dienthoai, p_email, p_maphong, p_chinhanh, luong_mahoa_raw);
  
  DBMS_OUTPUT.PUT_LINE ('Them NHANVIEN thanh cong!');
end;

create or replace procedure sp_show_luongNHANVIEN
is
  key_raw raw (32);
  user varchar2 (20);
  kieumahoa pls_integer;
  luong_giaima varchar2 (20);
  luong_mahoa_raw raw (2000);
begin
  user := SYS_CONTEXT ('userenv', 'SESSION_USER');
  
  if (length (user) = 5) then
    key_raw := utl_raw.cast_to_raw('1412007_1412012_1412053_000' || user);
  else
    key_raw := utl_raw.cast_to_raw('1412007_1412012_1412053_00' || user);
  end if;
  
  kieumahoa := DBMS_CRYPTO.ENCRYPT_AES256
                + DBMS_CRYPTO.CHAIN_CBC
                + DBMS_CRYPTO.PAD_PKCS5;
  
  select luong into luong_mahoa_raw
  from NHANVIEN
  where maNV = user;
    
  luong_giaima := UTL_I18N.RAW_TO_CHAR ( DBMS_CRYPTO.DECRYPT (src => luong_mahoa_raw,
                                                              typ => kieumahoa,
                                                              key => key_raw), 'AL32UTF8');
  
  dbms_output.put_line('Luong cua ban: ' || luong_giaima);
  
end;

grant execute on SP_SHOW_LUONGNHANVIEN to roleNHANVIEN;
grant execute on SP_SHOW_LUONGNHANVIEN to roleTRUONGPHONG;
grant execute on SP_SHOW_LUONGNHANVIEN to roleTRUONGDA;
grant execute on SP_SHOW_LUONGNHANVIEN to roleTRUONGCN;