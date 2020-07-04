
-------------------------------------------------------
-- �ļ��� : STM32F2xxxE.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� :
-------------------------------------------------------

function config_cpu(void)
	CHIP_TYPE = "SWD"		--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C", "UART"

	AlgoFile_FLASH = "0:/H7-TOOL/Programmer/Device/ST/STM32F2xx/STM32F2xx_1024.FLM"
	AlgoFile_EEPROM = ""
	AlgoFile_OTP   = "0:/H7-TOOL/Programmer/Device/ST/STM32F2xx/STM32F2xx_OTP.FL"
	AlgoFile_OPT   = "0:/H7-TOOL/Programmer/Device/ST/STM32F2xx/STM32F2xx_OPT.FLM"
	AlgoFile_QSPI  = ""

	FLASH_ADDRESS = 0x08000000		--CPU�ڲ�FLASH��ʼ��ַ
	FLASH_SIZE = 512 * 1024			--����FLM�е� Device Size

	--EEPROM_ADDRESS = 0			--CPU�ڲ�EEPROM��ʼ��ַ
	--EEPROM_SIZE = 0

	OTP_ADDRESS	= 0x1FFF7800		--CPU�ڲ�OTP(1�οɱ��)��ʼ��ַ
	OTP_SIZE	= 0x210

	RAM_ADDRESS = 0x20000000		--CPU�ڲ�RAM��ʼ��ַ

	--Flash�㷨�ļ������ڴ��ַ�ʹ�С
	AlgoRamAddr = RAM_ADDRESS
	AlgoRamSize = 4 * 1024

	MCU_ID = 0x2BA01477

	UID_ADDR = 0x1FFF7A10	   	--UID��ַ����ͬ��CPU��ͬ
	UID_BYTES = 12

	ERASE_CHIP_TIME = 15000		--ȫƬ����ʱ��ms��STM32F207�����������ִ��ȫ��������ȴ�ʱ����15��)

	--��ַ���е�FFFFFFFF��ʾԭʼ�����в���һ��ȡ�����ֽ�
	OB_ADDRESS     =  "1FFFC000 1FFFC001 1FFFC008 1FFFC009 "

	OB_SECURE_OFF  = "FF AA FF FF"	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ
	OB_SECURE_ON   = "FF 00 FF FF"	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ

	--�ж϶�������д����������(WRP = Write protection)
	OB_WRP_ADDRESS   = {0x1FFFC001, 0x1FFFF808, 0x1FFFF809} 	--�ڴ��ַ
	OB_WRP_MASK  	 = {0xFF, 0xFF, 0xFF}		 --�����������������
	OB_WRP_VALUE 	 = {0xAA, 0xFF, 0xFF}		 --�����������Ƚϣ���ȱ�ʾû�б���
end

---------------------------����-----------------------------------
