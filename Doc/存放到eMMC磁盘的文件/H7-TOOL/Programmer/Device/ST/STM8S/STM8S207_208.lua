
-------------------------------------------------------
-- �ļ��� : STM8S207_208.lua
-- ��  �� : V1.0  2020-04-28
-- ˵  �� :
-------------------------------------------------------
function config_cpu(void)
	DeviceList = {
		"STM8S207R6",  32 * 1024, 1024,
		"STM8S207C6",  32 * 1024, 1024,
		"STM8S207S6",  32 * 1024, 1024,
		"STM8S207K6",  32 * 1024, 1024,
		"STM8S207M8",  64 * 1024, 2048,
		"STM8S207K8",  64 * 1024, 1024,
		"STM8S207C8",  64 * 1024, 1536,
		"STM8S207S8",  64 * 1024, 1536,
		"STM8S207R8",  64 * 1024, 1536,
		"STM8S207SB", 128 * 1024, 1536,
		"STM8S207MB", 128 * 1024, 2048,
		"STM8S207RB", 128 * 1024, 2048,
		"STM8S207CB", 128 * 1024, 2048,

		"STM8S208S6",  32 * 1024, 1536,
		"STM8S208R6",  32 * 1024, 2048,
		"STM8S208C6",  32 * 1024, 2048,
		"STM8S208R8",  64 * 1024, 2048,
		"STM8S208C8",  64 * 1024, 2048,
		"STM8S208S8",  64 * 1024, 1536,
		"STM8S208SB", 128 * 1024, 1536,
		"STM8S208MB", 128 * 1024, 2048,
		"STM8S208RB", 128 * 1024, 2048,
		"STM8S208CB", 128 * 1024, 2048,
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

	UID_ADDR = 0x48CD			--UID��ַ����ͬ��CPU��ͬ

	OB_ADDRESS     = "4800 4801 FFFF 4803 FFFF 4805 FFFF 4807 FFFF 4809 FFFF 480B FFFF 480D FFFF 487E FFFF"

	OB_SECURE_OFF  = "00 00 00 00 00 00 00 00 00"	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ (���������ֽڣ�
	OB_SECURE_ON   = "AA 00 00 00 00 00 00 00 00"	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ
end

---------------------------����-----------------------------------
