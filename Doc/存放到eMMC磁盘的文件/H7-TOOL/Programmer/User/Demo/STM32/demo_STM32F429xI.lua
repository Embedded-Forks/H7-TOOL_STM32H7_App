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
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F401xx_128.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F401xx_256.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F401xx_384.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F401xx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F40xxx_41xxx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F40xxx_41xxx_1024.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F410xx_412xx_128.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F410xx_412xx_256.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F410xx_412xx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F410xx_412xx_1024.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F411xx_256.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F411xx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F413xx_423xx_1024.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F413xx_423xx_1536.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F42xxx_43xxx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F42xxx_43xxx_1024.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F42xxx_43xxx_1536.lua")
dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F42xxx_43xxx_2048.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F446xx_256.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F446xx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F469xx_479xx_512.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F469xx_479xx_1024.lua")
--dofile("0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F469xx_479xx_2048.lua")

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

	--��������б���������׷��
	--�㷨�ļ����������ļ���֧�־���·�������·�������·��ʱ��lua�ļ�ͬĿ¼��֧��../�ϼ�Ŀ¼
	TaskList = {
		AlgoFile_FLASH,							--�㷨�ļ�
		"0:/H7-TOOL/Programmer/User/TestBin/2M_55.bin",  	--�����ļ�
		0x08000000,								--Ŀ���ַ
	}

	--����CPU�����ѹTVCC
	TVCC_VOLT = 3.3

	--SWDʱ���ӳ٣�0���ӳ٣�ֵԽ���ٶ�Խ��
	if (MULTI_MODE == 0) then
		SWD_CLOCK_DELAY = 0		--��·���
	else
		SWD_CLOCK_DELAY = 1		--��·��̣�����ʵ�ʰ��ӵ��ڣ���CPU��Ƶ�����³����й�
	end

	--1��ʾ��Ƭ������0��ʾ����������. ��ЩCPU��Ƭ�����ٶȿ�ܶ࣬��Щ���ܶ�
	ERASE_CHIP_ENABLE = 1

	RESET_TYPE = 0				-- 0��ʾ�����λ  1��ʾӲ����λ

	--�Ƿ�˶�CPU�ں�ID
	CHECK_MCU_ID = 0

	VERIFY_MODE = 0				--У��ģʽ: 0:�Զ�(FLM�ṩУ�麯�������) 1:����  2:���CRC32  3:STM32Ӳ��CRC32

	--��̽�����λ 0��ʾ����λ  1��ʾӲ����λ
	RESET_AFTER_COMPLETE = 0

	AUTO_REMOVE_PROTECT = 1		--1��ʾ�Զ������������д����

	--OPTION BYTES ����
	OB_ENABLE	= 0 				--1��ʾ�����Ϻ�дOPTION BYTES
	SECURE_ENABLE  = 0				--ѡ����ܻ��ǲ�����

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
