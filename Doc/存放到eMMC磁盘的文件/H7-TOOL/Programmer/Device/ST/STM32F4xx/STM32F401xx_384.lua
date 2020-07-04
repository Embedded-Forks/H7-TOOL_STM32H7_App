
-------------------------------------------------------
-- �ļ��� : STM32F401xx_384.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� : δ��֤��Option bytes ���ֻ�δ����
-------------------------------------------------------
function config_cpu(void)
	CHIP_TYPE = "SWD"		--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C", "UART"

	AlgoFile_FLASH = "0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F4xx_384.FLM"
	AlgoFile_OTP   = "0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F4xx_OTP.FLM"
	AlgoFile_OPT   = "0:/H7-TOOL/Programmer/Device/ST/STM32F4xx/STM32F401xx_OPT.FLM"
	AlgoFile_QSPI  = ""

	FLASH_ADDRESS = 0x08000000		--CPU�ڲ�FLASH��ʼ��ַ

	OTP_ADDRESS	= 0x1FFF7800		--CPU�ڲ�OTP(1�οɱ��)��ʼ��ַ

	RAM_ADDRESS = 0x20000000		--CPU�ڲ�RAM��ʼ��ַ

	--Flash�㷨�ļ������ڴ��ַ�ʹ�С
	AlgoRamAddr = RAM_ADDRESS
	AlgoRamSize = 8 * 1024

	MCU_ID = 0x2BA01477

	UID_ADDR = 0x1FFF7A10	   	--UID��ַ����ͬ��CPU��ͬ
	UID_BYTES = 12

	--ȱʡУ��ģʽ
	VERIFY_MODE = 0				-- 0:����У��, 1:���CRC32У��, ����:��չӲ��CRC(��Ҫ��Ƭ��֧�֣�

	ERASE_CHIP_TIME = 16000		--ȫƬ����ʱ��ms�������ڽ���ָʾ)

	OB_ADDRESS     = "1FFFC000 1FFFC001 1FFFC008 1FFFC009 "

	OB_SECURE_OFF  = "FF AA FF FF"	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ
	OB_SECURE_ON   = "FF 00 FF F1"	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ

	--�ж϶�������д����������(WRP = Write protection)
	OB_WRP_ADDRESS   = {0x1FFFC001, 0x1FFFC008, 0x1FFFC009} 	--�ڴ��ַ
	OB_WRP_MASK  	 = {0xFF, 0xFF, 0xFF}					--�����������������
	OB_WRP_VALUE 	 = {0xAA, 0xFF, 0xFF}					--�����������Ƚϣ���ȱ�ʾû�б���
end

---------------------------����-----------------------------------
