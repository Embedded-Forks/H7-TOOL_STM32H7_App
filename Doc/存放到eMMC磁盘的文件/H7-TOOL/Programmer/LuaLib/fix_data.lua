--LuaSubFile=1  --��ʾ���ļ���Ϊ���ļ����أ���Ҫ�޸���һ�У�
-------------------------------------------------------
-- �ļ��� : fix_data.lua
-- ��  �� : V1.0  2020-04-23
-- ˵  �� : ������¼��Ʒ��š�����UID�����ַ����Զ����ַ���
-------------------------------------------------------

--��ʼ���������ļ�����̬���SN UID USR����
function fix_data_begin(void)

	config_fix_data()	--���û�lua���򲿷�ʵ���������

	--��Ʒ���루���룩���ã��̶�4�ֽڣ�
	--SN_ENABLE = 0				--1��ʾ����   0��ʾ������
	--SN_SAVE_ADDR = 0			--��Ʒ��ű����ַ

	SN_INIT_VALUE = 1			--��Ʒ��ų�ʼֵ
	SN_LITTLE_ENDIN = 1			--0��ʾ��ˣ�1��ʾС��
	SN_DATA = ""				--������ݣ��ɺ���� sn_new() ��������
	SN_LEN = 0					--��ų���

	SN_DATA1 = ""
	SN_DATA2 = ""
	SN_DATA3 = ""
	SN_DATA4 = ""

	--UID���ܴ洢���ã�ֻ�����UID��MCU��
	--UID_ENABLE = 0	       		--1��ʾ���ü���  0��ʾ������
	--UID_SAVE_ADDR = 0 			--���ܽ��FLASH�洢��ַ
	--UID_BYTES = 12             	--UID����
	UID_DATA = ""				--�����������ݣ��ɺ���� uid_encrypt() ��������
	UID_LEN = 0					--���ݳ���

	UID_DATA1 = ""
	UID_DATA2 = ""
	UID_DATA3 = ""
	UID_DATA4 = ""

	--�û��Զ������ݣ�������������ڣ��ͻ���ŵ����ݣ�Ҫ������������
	--USR_ENABLE = 0	       		--1��ʾ����   0��ʾ������
	--USR_SAVE_ADDR = 0 			--�Զ������ݴ洢��ַ
	USR_DATA = ""				--�Զ����������ݣ��ɺ���� make_user_data() ��������
	USR_LEN = 0					--���ݳ���

	local str
	local re

	--���ļ����ϴ�SN�������µ�SN����
	if (SN_ENABLE == 1) then
		if (MULTI_MODE > 0) then
			SN_DATA1 = sn_new()	--�����ϴ�SN�����µ�SN
			SN_DATA2 = sn_new()	--�����ϴ�SN�����µ�SN
			SN_DATA3 = sn_new()	--�����ϴ�SN�����µ�SN
			SN_DATA4 = sn_new()	--�����ϴ�SN�����µ�SN
			SN_LEN = string.len(SN_DATA1)

			str = "new sn1 = "..bin2hex(SN_DATA1) print(str)
			str = "new sn2 = "..bin2hex(SN_DATA2) print(str)
			str = "new sn3 = "..bin2hex(SN_DATA3) print(str)
			str = "new sn4 = "..bin2hex(SN_DATA4) print(str)
		else
			SN_DATA = sn_new()	--�����ϴ�SN�����µ�SN
			SN_LEN = string.len(SN_DATA)
			str = "new sn  = "..bin2hex(SN_DATA) print(str)
		end
	end

	--��UID��unique device identifier) ������UID��������
	if (MULTI_MODE > 0) then
		local uid1,uid2,uid3,uid4

		re,uid1,uid2,uid3,uid4 = pg_read_mem(UID_ADDR, UID_BYTES)
		if (re == 1) then
			str = "uid1 = "..bin2hex(uid1) print(str) delayms(5)
			str = "uid2 = "..bin2hex(uid2) print(str) delayms(5)
			str = "uid3 = "..bin2hex(uid3) print(str) delayms(5)
			str = "uid4 = "..bin2hex(uid4) print(str) delayms(5)

			if (UID_ENABLE == 1) then
				UID_DATA1 = uid_encrypt(uid1)
				UID_DATA2 = uid_encrypt(uid2)
				UID_DATA3 = uid_encrypt(uid3)
				UID_DATA4 = uid_encrypt(uid4)
				UID_LEN = string.len(UID_DATA1)

				str = "uid encrypt 1 = "..bin2hex(UID_DATA1)  print(str) delayms(5)
				str = "uid encrypt 2 = "..bin2hex(UID_DATA2)  print(str) delayms(5)
				str = "uid encrypt 3 = "..bin2hex(UID_DATA3)  print(str) delayms(5)
				str = "uid encrypt 4 = "..bin2hex(UID_DATA4)  print(str) delayms(5)
			end
		end
	else
		re,mcu_uid = pg_read_mem(UID_ADDR, UID_BYTES)
		if (re == 1) then
			str = "uid original = "..bin2hex(mcu_uid)
			print(str)

			if (UID_ENABLE == 1) then
				UID_DATA = uid_encrypt(mcu_uid)
				UID_LEN = string.len(UID_DATA)
				str = "uid encrypt  = "..bin2hex(UID_DATA)
				print(str)
			end
		end
	end

	--��̬�����û�������
	if (USR_ENABLE == 1) then
		USR_DATA = make_user_data()
		USR_LEN = string.len(USR_DATA)
		str = "user data  = "..USR_DATA
		print(str)
	end

	--֪ͨC������±���
	pg_reload_var("UidSnUsr")
end

--�������������ļ�
function fix_data_end(void)
	SN_ENABLE = 0
	UID_ENABLE = 0
	USR_ENABLE = 0
end

--��Ʒ���SN���ɺ��� ��last_sn��һ��UINT32�������룩����Ƕ������ַ���
function sn_new(void)
	local bin = {}
	local out = {}
	local sn1
	local s

	sn1 = pg_read_sn()	--���ϴ�SN ��������������
	str = string.format("last sn = %d", sn1) print(str)
	if (sn1 == nil) then
		sn1 = SN_INIT_VALUE
	else
		sn1 = sn1 + 1	--��Ų���=1
	end

	pg_write_sn(sn1)	--��̳ɹ���Żᱣ�汾��SN

	--ƴ��Ϊ�����ƴ�����
	if (SN_LITTLE_ENDIN == 1) then
		s =    string.char(sn1 & 0xFF)
		s = s..string.char((sn1 >> 8) & 0xFF)
		s = s..string.char((sn1 >> 16) & 0xFF)
		s = s..string.char((sn1 >> 24) & 0xFF)
	else
		s =    string.char((sn1 >> 24) & 0xFF)
		s = s..string.char((sn1 >> 16) & 0xFF)
		s = s..string.char((sn1 >> 8) & 0xFF)
		s = s..string.char(sn1 & 0xFF)
	end
	return s;
end

--UID���ܺ������û��������޸�
--	&	��λ��
--	|	��λ��
--	~	��λ���
--	>>	����
--	<<	����
--	~	��λ��
function uid_encrypt(uid)
	local bin = {}
	local out = {}
	local i

	--�������Ƶ�uid�ַ���ת��Ϊlua��������
	for i = 1,12,1 do
		bin[i] = tonumber(string.byte(uid, i,i))
	end

	--�����߼����� �û��������޸�Ϊ�����㷨
	out[1] = bin[1] ~ (bin[5] >> 1) ~ (bin[9]  >> 1)
	out[2] = bin[2] ~ (bin[6] >> 1) ~ (bin[10] >> 2)
	out[3] = bin[3] ~ (bin[7] >> 1) ~ (bin[11] >> 3)
	out[4] = bin[4] ~ (bin[8] >> 2) ~ (bin[12] >> 4)

    out[1] = out[4] ~ 0x12
    out[2] = out[3] ~ 0x34
    out[3] = out[1] ~ 0x56
    out[4] = out[2] ~ 0x78

	--ƴ��Ϊ�����ƴ�����
	s =    string.char(out[1] & 0xFF)
	s = s..string.char(out[2] & 0xFF)
	s = s..string.char(out[3] & 0xFF)
	s = s..string.char(out[4] & 0xFF)
	return s
end

--��̬�����û�������USR
function make_user_data(uid)
	s = os.date("%Y-%m-%d %H:%M:%S")	--����ASCII�ַ��� 2020-01-21 23:25:01
	s = s.." aaa"..string.char(0)
	return s
end

---------------------------����-----------------------------------
