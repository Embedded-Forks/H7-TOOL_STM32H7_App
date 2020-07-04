
-------------------------------------------------------
-- �ļ��� : STM32G0x0x6.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� :
-------------------------------------------------------
function config_cpu(void)
	CHIP_TYPE = "SWD"		--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C", "UART"

	AlgoFile_FLASH = "0:/H7-TOOL/Programmer/Device/ST/STM32G0xx/STM32G0xx_32.FLM"
	AlgoFile_OTP   = "0:/H7-TOOL/Programmer/Device/ST/STM32G0xx/STM32G0xx_OTP.FLM"
	AlgoFile_OPT   = "0:/H7-TOOL/Programmer/Device/ST/STM32G0xx/STM32G0x0_OPT.FLM"
	AlgoFile_QSPI  = ""

	FLASH_ADDRESS = 0x08000000		--CPU�ڲ�FLASH��ʼ��ַ

	OTP_ADDRESS = 0x1FFF7000		--CPU�ڲ�OTP����ַ
	OTP_SIZE = 1024

	RAM_ADDRESS = 0x20000000		--CPU�ڲ�RAM��ʼ��ַ

	--Flash�㷨�ļ������ڴ��ַ�ʹ�С
	AlgoRamAddr = RAM_ADDRESS
	AlgoRamSize = 4 * 1024

	MCU_ID = 0x0BC11477

	UID_ADDR = 0x1FFF7590	   	--UID��ַ��STM32G0 �ֲ���û��UID
	UID_BYTES = 12

	--ȱʡУ��ģʽ
	VERIFY_MODE = 0				-- 0:����У��, 1:���CRC32У��, ����:��չӲ��CRC(��Ҫ��Ƭ��֧�֣�

	ERASE_CHIP_TIME = 500		--ȫƬ����ʱ��ms�������ڽ���ָʾ)

	OB_ADDRESS     =  "1FFF7800 1FFF7801 1FFF7802 1FFF7803 "
					.."1FFF7818 1FFF7819 1FFF781A 1FFF781B "
					.."1FFF7820 1FFF7821 1FFF7822 1FFF7823 "

	OB_SECURE_OFF  = "AA E1 FF DF 3F FF 00 FF 3F FF 00 FF "	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ(�������)
	OB_SECURE_ON   = "00 E1 FF DF 3F FF 00 FF 3F FF 00 FF "	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ(оƬ����)

	--�ж϶�������д����������(WRP = Write protection)
	OB_WRP_ADDRESS   = {0x1FFF7800, 0x1FFF7818, 0x1FFF781A, 0x1FFF7820, 0x1FFF7822} 	--�ڴ��ַ
	OB_WRP_MASK  	 = {0xFF, 0x3F, 0x3F, 0x3F, 0x3F}		--�����������������
	OB_WRP_VALUE 	 = {0xAA, 0x1F, 0x00, 0x1F, 0x00}		--�����������Ƚϣ���ȱ�ʾû�б���
end


---------------------------����-----------------------------------
