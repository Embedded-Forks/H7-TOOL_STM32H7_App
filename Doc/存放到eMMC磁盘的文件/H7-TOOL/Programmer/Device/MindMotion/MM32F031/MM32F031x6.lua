
-------------------------------------------------------
-- �ļ��� : MM32F031x6.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� :
-------------------------------------------------------
function config_cpu(void)
	CHIP_TYPE = "SWD"		--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C", "UART"

	AlgoFile_FLASH = "0:/H7-TOOL/Programmer/Device/MindMotion/MM32F031/MM32xx_32.FLM"
	AlgoFile_OTP   = ""
	AlgoFile_OPT   = "0:/H7-TOOL/Programmer/Device/MindMotion/OPT/MM32_M0_npq_OPT.FLM"
	AlgoFile_QSPI  = ""

	FLASH_ADDRESS = 0x08000000		--CPU�ڲ�FLASH��ʼ��ַ

	RAM_ADDRESS = 0x20000000		--CPU�ڲ�RAM��ʼ��ַ

	--Flash�㷨�ļ������ڴ��ַ�ʹ�С
	AlgoRamAddr = RAM_ADDRESS
	AlgoRamSize = 4 * 1024

	MCU_ID = 0x0BB11477

	UID_ADDR = 0x1FFFF7E8	   	--UID��ַ����ͬ��CPU��ͬ
	UID_BYTES = 12

	--ȱʡУ��ģʽ
	VERIFY_MODE = 0				-- 0:����У��, 1:���CRC32У��, ����:��չӲ��CRC(��Ҫ��Ƭ��֧�֣�

	--��ַ���е�FFFFFFFF��ʾԭʼ�����в���һ��ȡ�����ֽ�
	OB_ADDRESS     = "1FFFF800 FFFFFFFF 1FFFF802 FFFFFFFF 1FFFF804 FFFFFFFF 1FFFF806 FFFFFFFF 1FFFF808 FFFFFFFF 1FFFF80A FFFFFFFF 1FFFF80C FFFFFFFF 1FFFF80E FFFFFFFF "
			       .."1FFE0000 1FFE0001 1FFE0002 1FFE0003 "
	OB_SECURE_OFF  = "A5 FF FF FF FF FF FF FF FF FF FF FF "	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ
	OB_SECURE_ON   = "A5 FF FF FF FF FF FF FF 80 7F 00 FF "	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ

	--�ж϶�������д����������(WRP = Write protection)
	OB_WRP_ADDRESS   = {0x1FFFF800, 0x1FFFF808, 0x1FFFF80A, 0x1FFFF80C, 0x1FFFF80E,		0x1FFE0000, 0x1FFE0002} 	--�ڴ��ַ
	OB_WRP_MASK  	 = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}		--�����������������
	OB_WRP_VALUE 	 = {0xA5, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}		--�����������Ƚϣ���ȱ�ʾû�б���
end

---------------------------����-----------------------------------
