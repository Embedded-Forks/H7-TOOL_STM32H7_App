--���¿�ݷ�ʽ����ʾ��PC�������(STM8)
--F01=�Զ����,start_prog()
--F03=����flash,erase_chip(FLASH_ADDRESS)
--F04=����eeprom,erase_chip(EEPROM_ADDRESS)
--F05=��ӡflash,print_flash(FLASH_ADDRESS,512,16,FLASH_ADDRESS)
--F06=��ӡeeprom,print_flash(EEPROM_ADDRESS,256,16,EEPROM_ADDRESS)
--F07=��ӡUID,print_flash(UID_ADDR,12)
--F08=��ӡ�ں�id,print_core_id()
--F09=�޸�RAM,pg_write_mem(0, "1234")
--F10=����RAM,print_flash(0, 16)
--F12=Ӳ����λ,pg_reset()
--F13=���ö�����, set_read_protect(1)
--F14=���������, set_read_protect(0)
--F15=��ӡOption Bytes,print_option_bytes()

--�����ע�ͽ���ʾ��H7-TOOLҺ����
Note01 = "���Գ���"

beep()

CHIP_NAME = "STM8L051F3"

--dofile("0:/H7-TOOL/Programmer/Device/ST/STM8S/STM8S103_903_003_001.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM8S/STM8S105_005_007.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM8S/STM8S207_208.lua")

--CHIP_NAME = "STM8L151C8"
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM8L/STM8L101.lua")
dofile("0:/H7-TOOL/Programmer/Device/ST/STM8L/STM8L151_152_05x_162.lua")

--CHIP_NAME = "STM8AF52AA"
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM8A/STM8AF6226_F6223_F6213.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM8A/STM8AF52xx_F62xx_F63xx.lua")

--UID���ܺͲ�Ʒ��Ŵ����ļ�
dofile("0:/H7-TOOL/Programmer/LuaLib/fix_data.lua")

--����lua�ӳ���
dofile("0:/H7-TOOL/Programmer/LuaLib/prog_lib.lua")

--����оƬ�ӿںͲ���
function config_chip1(void)

	config_cpu()

	--�������������󣬱���ϵ������Ч����������´���
	REMOVE_RDP_POWEROFF = 0
	POWEROFF_TIME1 = 0		--д��OB�ӳ�ʱ�� 2000ms
	POWEROFF_TIME2 = 100	--�ϵ�ʱ�� 100ms
	POWEROFF_TIME3 = 20		--�ϵ��ȴ�ʱ�� 100ms

	--��������б���������׷��
	--�����ļ���֧�־���·�������·�������·��ʱ��lua�ļ�ͬĿ¼��֧��../�ϼ�Ŀ¼
	TaskList = {
		"0:/H7-TOOL/Programmer/User/TestBin/8K_5A.bin",	--�����ļ� (""��ʾ����)
		0x008000,										--Ŀ���ַ (0x008000 Flash)

--		"0:/H7-TOOL/Programmer/User/TestBin/128.bin",	--�����ļ� (""��ʾ����)
--		EEPROM_ADDRESS,									--Ŀ���ַ (0x004000 EEPROM)
	}

	--����CPU�����ѹTVCC
	TVCC_VOLT = 3.3

	--1��ʾ��Ƭ������0��ʾ����������. ��ЩCPU��Ƭ�����ٶȿ�ܶ࣬��Щ���ܶ�
	ERASE_CHIP_ENABLE = 1

	RESET_TYPE = 0				-- 0��ʾ�����λ  1��ʾӲ����λ

	--�Ƿ�˶�CPU�ں�ID
	CHECK_MCU_ID = 0

	--��̽�����λ 0��ʾ����λ  1��ʾӲ����λ
	RESET_AFTER_COMPLETE = 0

	AUTO_REMOVE_PROTECT = 1		--1��ʾ�Զ������������д����

	--OPTION BYTES ����
	OB_ENABLE	= 0 			--1��ʾ�����Ϻ�дOPTION BYTES
	SECURE_ENABLE  = 0			--ѡ����ܻ��ǲ�����

	pg_reload_var()				--���ڸ���c�����ȫ�ֱ���
end

--��̬���SN UID USR����
function config_fix_data(void)
	SN_ENABLE = 0				--1��ʾ����   0��ʾ������
	SN_SAVE_ADDR = 0			--��Ʒ��ű����ַ

	UID_ENABLE = 0	       		--1��ʾ���ü��ܺ���1  0��ʾ������
	UID_SAVE_ADDR = 0 			--���ܽ��FLASH�洢��ַ

	USR_ENABLE = 0	       		--1��ʾ����   0��ʾ������
	USR_SAVE_ADDR = 0 			--�Զ������ݴ洢��ַ
end

config_chip1()				--ִ��һ�θ�ȫ�ֱ�������ֵ

config_fix_data()			--��̬���SN UID USR����

MULTI_MODE = pg_read_c_var("MultiProgMode")

---------------------------����-----------------------------------
