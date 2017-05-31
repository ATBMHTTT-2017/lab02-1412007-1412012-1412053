alter session set "_ORACLE_SCRIPT"=true;

create or replace function funcTRUONGDA_chitieu (p_schema varchar2, p_obj varchar2)
return varchar2
as
  user varchar2 (20);
begin
    user := SYS_CONTEXT ('userenv', 'SESSION_USER');
    if (user = 'TDA001' or user = 'TDA002' or user = 'TDA003' or user = 'TDA004' or user = 'TDA005') then
      return 'dbaDuAn_lab2.chitieu.duan in (select dbaDuAn_lab2.duan.mada from dbaDuAn_lab2.duan where dbaDuAn_lab2.duan.truongda = ' || '''' || user || ''')';
    else
      return '';
    end if;
end;

begin dbms_rls.add_policy(
  object_schema => 'dbaDuAn_lab2',
  object_name => 'chitieu',
  policy_name => 'cau3_1412053',
  function_schema => 'dbaDuAn_lab2',
  policy_function => 'funcTRUONGDA_chitieu',
  statement_types => 'select, insert, update',
  update_check => true);
end;

GRANT select, insert, update on dbaDuAn_lab2.ChiTieu TO roleTRUONGDA;

create or replace procedure sp_insert_encrypt_CHITIEU
(p_maCT varchar2, p_tenCT nvarchar2, p_sotien varchar2, p_duan varchar2)
is
  key_pri clob := '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCTlRzFkKRlk4kexec91kCCLyW
FA7m2QD1Mc49jYK4qJoZ6MI4IiuNENlDzcYAat8JTITKQKdNfjq+kdppDnLTmeeU
I4Jtlc06L1uDLji1hgeN315t6g3tOf0iHVdyt4dilcHDannCU0duU0TXhh6OK/HH
HtwZ7lcxCo5NgzUDlwIDAQAB
-----END PUBLIC KEY-----';

  sotien_mahoa_raw raw (32000);
begin
  sotien_mahoa_raw := ora_rsa.encrypt (message => UTL_I18N.STRING_TO_RAW(p_sotien, 'AL32UTF8'),
                                        public_key => UTL_RAW.CAST_TO_RAW(key_pri));
                                        
  insert into CHITIEU values (p_maCT, p_tenCT, sotien_mahoa_raw, p_duan);
  
  DBMS_OUTPUT.PUT_LINE ('Them CHITIEU thanh cong!');
end;

create or replace procedure sp_update_sotien_CHITIEU
(p_maCT varchar2, p_sotien varchar2)
is
  key_pri clob := '-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCTlRzFkKRlk4kexec91kCCLyW
FA7m2QD1Mc49jYK4qJoZ6MI4IiuNENlDzcYAat8JTITKQKdNfjq+kdppDnLTmeeU
I4Jtlc06L1uDLji1hgeN315t6g3tOf0iHVdyt4dilcHDannCU0duU0TXhh6OK/HH
HtwZ7lcxCo5NgzUDlwIDAQAB
-----END PUBLIC KEY-----';

  sotien_mahoa_raw raw (32000);
begin
  sotien_mahoa_raw := ora_rsa.encrypt (message => UTL_I18N.STRING_TO_RAW(p_sotien, 'AL32UTF8'),
                                        public_key => UTL_RAW.CAST_TO_RAW(key_pri));
                                        
  update CHITIEU SET sotien = sotien_mahoa_raw where maChiTieu = p_maCT;
end;

create or replace procedure sp_show_sotien_CHITIEU
(p_maCT varchar2)
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

  sotien_giaima varchar2 (20);
  sotien_giaima_raw raw (32000);
  sotien_mahoa_raw raw (32000);
begin
  select sotien into sotien_mahoa_raw from chitieu where Machitieu = p_maCT;
  sotien_giaima_raw := ORA_RSA.DECRYPT(sotien_mahoa_raw, UTL_RAW.CAST_TO_RAW(key_pub));
  sotien_giaima := UTL_I18N.RAW_TO_CHAR(sotien_giaima_raw, 'AL32UTF8');
  DBMS_OUTPUT.PUT_LINE ('So tien cua chi tieu nay la: ' || sotien_giaima);
end;

grant execute on sp_insert_encrypt_CHITIEU to roleTRUONGDA;
grant execute on sp_update_sotien_CHITIEU to roleTRUONGDA;
grant execute on sp_show_sotien_CHITIEU to roleTRUONGDA;