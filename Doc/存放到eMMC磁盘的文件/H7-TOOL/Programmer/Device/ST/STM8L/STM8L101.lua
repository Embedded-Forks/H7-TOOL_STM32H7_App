
-------------------------------------------------------
-- �ļ��� : STM8L101.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� :
-------------------------------------------------------
function config_cpu(void)
	DeviceList = {
		"STM8L101F1",  2 * 1024, 0,
		"STM8L101F2",  4 * 1024, 0,
		"STM8L101F3",  8 * 1024, 2 *  1024,

		"STM8L101G1",  2 * 1024, 0,
		"STM8L101G2",  4 * 1024, 0,
		"STM8L101G3",  8 * 1024, 2 *  1024,

		"STM8L101K1",  2 * 1024, 0,
		"STM8L101K2",  4 * 1024, 0,
		"STM8L101K3",  8 * 1024, 2 *  1024,
	}

	CHIP_TYPE = "SWIM"			--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C"

	STM8_SERIAL = "STM8L"		--ѡ��2��ϵ��: "STM8S" �� "STM8L"

	FLASH_ADDRESS = 0x008000	--����FLASH��ʼ��ַ

	EEPROM_ADDRESS = 0x009FC0 	--����EEPROM��ʼ��ַ(STM8S��STM8L��ͬ��

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

	UID_ADDR = 0x4925			--UID��ַ����ͬ��CPU��ͬ. STM8L101��STM8L151��ͬ

	OB_ADDRESS     = "4800 4802  4803 4807 4808"

	OB_SECURE_OFF  = "00 00 00 00 00"	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ (���������ֽڣ�
	OB_SECURE_ON   = "AA 00 00 00 00"	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ
end

---------------------------����-----------------------------------
