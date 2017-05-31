ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

SET SERVEROUTPUT ON;

create or replace procedure sp_insert_encrypt_PHANCONG
(p_maNV varchar2, p_duan varchar2, p_vaitro nvarchar2, p_phucap varchar2)
is
  key_pri clob := '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCTlRzFkKRlk4kexec91kCCLyW
FA7m2QD1Mc49jYK4qJoZ6MI4IiuNENlDzcYAat8JTITKQKdNfjq+kdppDnLTmeeU
I4Jtlc06L1uDLji1hgeN315t6g3tOf0iHVdyt4dilcHDannCU0duU0TXhh6OK/HH
HtwZ7lcxCo5NgzUDlwIDAQAB
-----END PUBLIC KEY-----';

  phucap_mahoa_raw raw (32000);
begin
  phucap_mahoa_raw := ora_rsa.encrypt (message => UTL_I18N.STRING_TO_RAW(p_phucap, 'AL32UTF8'),
  public_key => UTL_RAW.CAST_TO_RAW(key_pri));
  
  insert into PHANCONG values (p_maNV, p_duan, p_vaitro, p_phucap, phucap_mahoa_raw);
  
  DBMS_OUTPUT.PUT_LINE ('Them PHANCONG thanh cong!');
end;

create or replace procedure sp_show_phucap_PHANCONG
(p_maNV varchar2, p_duan varchar2)
is
  key_pub clob := '-----BEGIN PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMJOVHMWQpGWTiR7
F5z3WQIIvJYUDubZAPUxzj2NgriomhnowjgiK40Q2UPNxgBq3wlMhMpAp01+Or6R
2mkOctOZ55Qjgm2VzTovW4MuOLWGB43fXm3qDe05/SIdV3K3h2KVwcNqecJTR25T
RNeGHo4r8cce3BnuVzEKjk2DNQOXAgMBAAECgYEAuqIMQaL+++IYWrgU/UMkLmz/
31OS4K9NWTamt77F8eKYagyFCO/hTxUA6zyqU9pTMxZZcf9Z83gsqsFjvYcQSHy6
mRXFuORzh0r/wXKJtyFF0B26KC7WipqtPAuzn7SNGNeMh8g3H1qH8neEjir15Uai
6lR/sDIOZlO9sUJoZBECQQDkLXnXl/YXGoQDdupUQMzrF+ZK/od2U9YjdSOi+k/j
x23usurtzRhYGW/73vJd9Sw6Qc6ijPr+ItSpnl+qaxzvAkEA2f+OVzn1HwmYbc2a
Booo32aT96TJrwN8V4gC7m5hseHoXDDoXmwLZwNm7+w0vu3lk1p9tSqs8oc/nR0E
fHhT2QJAOQslasCSxTPbzQHtkyKgGCXhbN40/1/2KOcgAZ6SWl+BHCuej9S2QVAa
rt0Num+Qnv/UqM6V8PLEN6NgRzqAAQJBALeQYrp+WjKNcOYc97LECdC73qLsBswx
QjWumNFO70LLOE7Q/AnuLtfKXJZwrqWLSwJ+c1XnHoSGcIGK2qk45VkCQA6b1qCv
jGFksgcQ8vff5lwOWfJ2ZxA8Zpgeq5w7EaDTWS/WhtVUYg3bBsadgXb3LxpZScxq
U4Ad7pAZrI6H6Tc=
-----END PRIVATE KEY-----';
  phucap_duocluu varchar2 (20);
  phucap_giaima varchar2 (20);
  phucap_giaima_raw raw (32000);
  phucap_mahoa_raw raw (32000);
begin
  select phucap_mahoa into phucap_mahoa_raw from phancong where maNV = p_maNV and duAn = p_duan;
  select phucap into phucap_duocluu from phancong where maNV = p_maNV and duAn = p_duan;
  phucap_giaima_raw := ORA_RSA.DECRYPT(phucap_mahoa_raw, UTL_RAW.CAST_TO_RAW(key_pub));
  phucap_giaima := UTL_I18N.RAW_TO_CHAR(phucap_giaima_raw, 'AL32UTF8');
  DBMS_OUTPUT.PUT_LINE ('Phu cap duoc giai ma ra la: ' || phucap_giaima);
  DBMS_OUTPUT.PUT_LINE ('Phu cap duoc luu la: ' || phucap_duocluu);
  if (phucap_giaima = phucap_duocluu) then
    DBMS_OUTPUT.PUT_LINE ('Do 2 thong tin tren trung khop nen day la thong tin do truong DA thiet lap');
  else
    DBMS_OUTPUT.PUT_LINE ('Do 2 thong tin tren khong trung khop nen day la thong tin gia');
  end if;
end;

grant select on PHANCONG to roleTRUONGDA;
grant execute on sp_insert_encrypt_PHANCONG to roleTRUONGDA;

grant execute on sp_show_phucap_PHANCONG to roleNHANVIEN;
grant execute on sp_show_phucap_PHANCONG to roleTRUONGPHONG;
grant execute on sp_show_phucap_PHANCONG to roleTRUONGDA;
grant execute on sp_show_phucap_PHANCONG to roleTRUONGCN;