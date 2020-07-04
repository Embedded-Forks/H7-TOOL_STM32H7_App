--���¿�ݷ�ʽ����ʾ��PC�������-------------
--F01=�Զ����,start_prog()
--F03=����MCU flash,erase_chip_mcu()
--F04=����QSPI flash,erase_chip_qspi()
--F05=����EEPROM, erase_chip_eeprom()
--F06=��ӡ�ں�id,print_core_id()
--F07=��ӡUID,print_flash(UID_ADDR,12)
--F08=��ӡFlash,print_flash(FLASH_ADDRESS,1024,32,FLASH_ADDRESS)
--F09=��EEPROM,print_flash(EEPROM_ADDRESS, 256)
--F10=����RAM,print_flash(RAM_ADDRESS, 256)
--F12=Ӳ����λ,pg_reset()
--F13=���ö�����,set_read_protect(1)
--F14=���������,set_read_protect(0)
--F15=��ӡOption Bytes,print_option_bytes()

--ѡ��оƬϵ��----------------------------------
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32L1xx/STM32L1xxx6.lua")
dofile("0:/H7-TOOL/Programmer/Device/ST/STM32L1xx/STM32L1xxx8.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32L1xx/STM32L1xxxB.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32L1xx/STM32L1xxxC.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32L1xx/STM32L1xxxD.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32L1xx/STM32L1xxxE.lua")

--UID���ܺͲ�Ʒ��Ŵ����ļ�
dofile("0:/H7-TOOL/Programmer/LuaLib/fix_data.lua")

--����lua�ӳ���
dofile("0:/H7-TOOL/Programmer/LuaLib/prog_lib.lua")

--�����ע�ͽ���ʾ��H7-TOOLҺ����
Note01 = "���Գ���"

beep()

--����оƬ�ӿںͲ���
function config_chip1(void)

	config_cpu()

	--�������������󣬱���ϵ������Ч����������´���
	REMOVE_RDP_POWEROFF = 1
	POWEROFF_TIME1 = 0	--д��OB�ӳ�ʱ�� 2000ms
	POWEROFF_TIME2 = 100	--�ϵ�ʱ�� 100ms
	POWEROFF_TIME3 = 20	--�ϵ��ȴ�ʱ�� 100ms

	--��������б���������׷��
	--�㷨�ļ����������ļ���֧�־���·�������·�������·��ʱ��lua�ļ�ͬĿ¼��֧��../�ϼ�Ŀ¼
	TaskList = {
		AlgoFile_FLASH,							--�㷨�ļ�
		"0:/H7-TOOL/Programmer/User/TestBin/64k_55.bin",  	--�����ļ�
		0x08000000,								--Ŀ���ַ

--		AlgoFile_EEPROM,							--�㷨�ļ�
--		"0:/H7-TOOL/Programmer/User/TestBin/4k.bin",  	--�����ļ�
--		EEPROM_ADDRESS,								--Ŀ���ַ
	}

	--����CPU�����ѹTVCC
	TVCC_VOLT = 3.3

	--SWDʱ���ӳ٣�0���ӳ٣�ֵԽ���ٶ�Խ��
	if (MULTI_MODE == 0) then
		SWD_CLOCK_DELAY = 2		--��·���
	else
		SWD_CLOCK_DELAY = 2		--��·��̣�����ʵ�ʰ��ӵ��ڣ���CPU��Ƶ�����³����й�
	end

	--1��ʾ��Ƭ������0��ʾ����������. ��ЩCPU��Ƭ�����ٶȿ�ܶ࣬��Щ���ܶ�
	ERASE_CHIP_ENABLE = 0

	RESET_TYPE = 0				-- 0��ʾ�����λ  1��ʾӲ����λ

	--�Ƿ�˶�CPU�ں�ID
	CHECK_MCU_ID = 0

	VERIFY_MODE = 0				--У��ģʽ: 0:�Զ�(FLM�ṩУ�麯�������) 1:����  2:���CRC32  3:STM32Ӳ��CRC32

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
