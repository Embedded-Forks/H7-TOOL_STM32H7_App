
-------------------------------------------------------
-- �ļ��� : STM8S105_005_007.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� :
-------------------------------------------------------
function config_cpu(void)
	DeviceList = {
		"STM8S105K4",  16 * 1024, 1024,
		"STM8S105C4",  16 * 1024, 1024,
		"STM8S105S4",  16 * 1024, 1024,
		"STM8S105K6",  32 * 1024, 1024,
		"STM8S105C6",  32 * 1024, 1024,
		"STM8S105S6",  32 * 1024, 1024,

		"STM8S005C6",  32 * 1024, 128,
		"STM8S005K6",  32 * 1024, 128,

		"STM8S007C8",  64 * 1024, 128,
	}

	CHIP_TYPE = "SWIM"			--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C"

	STM8_SERIAL = "STM8S"		--ѡ��2��ϵ��: "STM8S" �� "STM8L"

	FLASH_ADDRESS = 0x008000	--����FLASH��ʼ��ַ

	EEPROM_ADDRESS = 0x004000 	--����FLASH��ʼ��ַ(STM8S��STM8L��ͬ��

	for i = 1, #DeviceList, 3 do
		if (CHIP_NAME == DeviceList[i]) then
			FLASH_SIZE  = DeviceList[i + 1]	--FLASH������
			EEPROM_SIZE = DeviceList[i + 2]	--EEPROM����

			--����BLOCK SIZE, ֻ��64��128����
			if (FLASH_SIZE <= 8 * 1024) then
				FLASH_BLOCK_SIZE = 64
			else
				FLASH_BLOCK_SIZE = 128
			end

			break
		end
	end

	UID_ADDR = 0x48CD			--UID��ַ��105 = 0x48CD   005 007δ�鵽

	OB_ADDRESS     = "4800 4801 FFFF 4803 FFFF 4805 FFFF 4807 FFFF 4809 FFFF 480B FFFF 480D FFFF 487E FFFF "

	OB_SECURE_OFF  = "00 00 00 00 00 00 00 00 00"	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ (���������ֽڣ�
	OB_SECURE_ON   = "AA 00 00 00 00 00 00 00 00"	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ
end

---------------------------����-----------------------------------
