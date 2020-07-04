-------------------------------------------------------
-- �ļ��� : prog_lib.lua
-- ��  �� : V1.1  2020-06-03
-- ˵  �� :�ѻ���̹��ú�����
-------------------------------------------------------

--������
function start_prog(void)
	return prog_or_erase(0)
end

--�������
function erase_chip_mcu(void)
	return prog_or_erase(1)
end

--�������
function erase_chip_eeprom(void)
	return prog_or_erase(2)
end

--��̻��߲�����������
function prog_or_erase(mode)
	local err = ""
	local str

	if (MULTI_MODE == 0) then
		print("��·��¼")
	end
	if (MULTI_MODE == 1) then
		print("��·��¼ 1·")
	end
	if (MULTI_MODE == 2) then
		print("��·��¼ 1-2·")
	end

	if (MULTI_MODE == 3) then
		print("��·��¼ 1-3·")
	end
	if (MULTI_MODE == 4) then
		print("��·��¼ 1-4·")
	end

	config_chip1()		--������¼����

	if (CHIP_TYPE == "SWD") then
		print("SWCLKʱ���ӳ�: ", SWD_CLOCK_DELAY)
	else if (CHIP_TYPE == "SWIM") then
		print("CHIP_NAME = "..CHIP_NAME)
		print(" flash  size = ", FLASH_SIZE)
		print(" eeprom size = ", EEPROM_SIZE)
		if (FLASH_SIZE == nil or EEPROM_SIZE == nil) then
			err = "chip name is invalid"
			goto quit
		end
	end
	end

--	set_tvcc(0)			--�ϵ�
--	delayms(20)
	set_tvcc(TVCC_VOLT)	--����TVCC��ѹ
--	delayms(20)

	if (MULTI_MODE > 0) then
		local id1
		local id2
		local id3
		local id4
		local i

		id1,id2,id3,id4 = pg_detect_ic()
		str = string.format("core_id: = 0x%08X 0x%08X 0x%08X 0x%08X", id1, id2, id3, id4)
		print(str)
		if ((MULTI_MODE == 1 and id1 > 0) or
			(MULTI_MODE == 2 and id1 > 0 and id2 > 0) or
			(MULTI_MODE == 3 and id1 > 0 and id2 > 0 and id3 > 0) or
			(MULTI_MODE == 4 and id1 > 0 and id2 > 0 and id3 > 0 and id4 > 0)) then
			if (mode == 0) then --���
				if (CHIP_TYPE == "SWD") then
					err = swd_start_prog()	--���ARM (SWD)
				else
					err = swim_start_prog()	--���STM8 (SWD)
				end
			else	--����
				if (mode == 1) then
					err = erase_chip(FLASH_ADDRESS)	--����CPU Flash
				else
					if (EEPROM_ADDRESS ~= nil) then
						err = erase_chip(EEPROM_ADDRESS)	--����CPU EEPROM
					else
						print("MCUδ����EEPROM")
					end
				end
			end
			if (err ~= "OK") then goto quit end
			goto quit
		end

		err = "δ��⵽IC"

		if (MULTI_MODE >= 1) then
			if (id1 == 0) then
				err = err.." #1"
			end
		end

		if (MULTI_MODE >= 2)then
			if (id2 == 0) then
				err = err.." #2"
			end
		end

		if (MULTI_MODE >= 3) then
			if (id3 == 0) then
				err = err.." #3"
			end
		end

		if (MULTI_MODE >= 4) then
			if (id3 == 0) then
				err = err.." #4"
			end
		end
	else
		local core_id

		core_id = pg_detect_ic()
		if (core_id > 0) then
			str = string.format("core_id = 0x%08X", core_id)
			print(str)

			--�˶�core id
			if (CHECK_MCU_ID == 1) then
				if (core_id ~= MCU_ID) then
					err = "MCU ID����ȷ"
					pg_print_text(err)
					goto quit
				end
			end

			if (mode == 0) then --���
				if (CHIP_TYPE == "SWD") then
					err = swd_start_prog()	--���ARM (SWD)
				else
					err = swim_start_prog()	--���STM8 (SWD)
				end
			else	--����
				if (mode == 1) then
					err = erase_chip(FLASH_ADDRESS)	--����CPU Flash
				else
					if (EEPROM_ADDRESS ~= nil) then
						err = erase_chip(EEPROM_ADDRESS)	--����CPU EEPROM
					else
						print("MCUδ����EEPROM")
					end
				end
			end
			if (err ~= "OK") then goto quit end
			goto quit
		end

		err = "δ��⵽IC"
	end

::quit::
	if (err == "OK") then
		beep() --�ɹ���1��

		if (MULTI_MODE == 0) then
			pg_print_text("��̳ɹ�")
		end

		if (MULTI_MODE == 1) then
			pg_print_text("��̳ɹ� 1·")
		end
		if (MULTI_MODE == 2) then
			pg_print_text("��̳ɹ� 1-2·")
		end
		if (MULTI_MODE == 3) then
			pg_print_text("��̳ɹ� 1-3·")
		end
		if (MULTI_MODE == 4) then
			pg_print_text("��̳ɹ� 1-4·")
		end
	else
		beep(5, 5, 3) --ʧ�ܽ�3��
		if (err ~= "error") then
			pg_print_text(err)
		end
	end

	return err
end

--�ж�оƬ�Ƴ�������������¼��
function CheckChipRemove(void)
	if (MULTI_MODE > 0) then
		local id1
		local id2
		local id3
		local id4

		id1,id2,id3,id4 = pg_detect_ic()
		if (MULTI_MODE == 1) then
			if (id1 == 0) then
				return "removed"
			end
		end
		if (MULTI_MODE == 2) then
			if (id1 == 0 and id2 == 0) then
				return "removed"
			end
		end
		if (MULTI_MODE == 3) then
			if (id1 == 0 and id2 == 0 and id3 == 0) then
				return "removed"
			end
		end
		if (MULTI_MODE == 4) then
			if (id1 == 0 and id2 == 0 and id3 == 0 and id4 == 0) then
				return "removed"
			end
		end
	else
		local core_id

		core_id = pg_detect_ic()
		if (core_id == 0) then
			return "removed"
		end
	end

	return "no"
end

--�ж�оƬ���루����������¼��
function CheckChipInsert(void)
	config_chip1()

	if (MULTI_MODE > 0) then
		local id
		local id1
		local id2
		local id3
		local id4

		id1,id2,id3,id4 = pg_detect_ic()
		if (MULTI_MODE == 1) then
			if (id1 > 0) then
				return "inserted"
			end
		end
		if (MULTI_MODE == 2) then
			if (id1 > 0 and id2 > 0) then
				return "inserted"
			end
		end
		if (MULTI_MODE == 3) then
			if (id1 > 0 and id2 > 0 and id3 > 0) then
				return "inserted"
			end
		end
		if (MULTI_MODE == 4) then
			if (id1 > 0 and id2 > 0 and id3 > 0 and id4 > 0) then
				return "inserted"
			end
		end
	else
		local core_id

		core_id = pg_detect_ic()
		if (core_id > 0) then
			return "inserted"
		end
	end

	return "no"
end

-------------------------------------------------------
-- ����Ĵ���һ�������޸�
-------------------------------------------------------

--��ʼ���SWD�ӿ�оƬ
--����-����ȫƬ-��̬����SN��UID�������ݡ��û�����
--����ļ�(�Զ���������̡�У��)
--дOPTION BYTES
function swd_start_prog(void)
	local err = "OK"
	local re
	local core_id
	local uid_bin
	local last_sn
	local str
	local mcu_uid
	local ob_data
	local i

	--�ж϶�������д�����������������ִ�н�������
	if (AUTO_REMOVE_PROTECT == 1) then
		local remove_protect

		print("����д����...")
		remove_protect = 0;
		for i = 1, #OB_WRP_ADDRESS, 1 do
			local wrp

			if (MCU_READ_OPTION == 1) then
				re,ob_data = MCU_ReadOptionsByte(OB_WRP_ADDRESS[i], 1)
			else
				re,ob_data = pg_read_mem(OB_WRP_ADDRESS[i], 1)
			end
			if (re == 0) then
				print("  ���Ĵ���ʧ��")
				pg_print_text("  �ѱ��������ö�����")
				remove_protect = 1
				break
			else
				if (MCU_READ_OPTION == 1) then
					wrp = ob_data
				else
					wrp = tonumber(string.byte(ob_data,1,1))
				end
				str = string.format("  0x%08X �� 0x%02X & 0x%02X == 0x%02X", OB_WRP_ADDRESS[i], wrp, OB_WRP_MASK[i], OB_WRP_VALUE[i])
				if ((wrp & OB_WRP_MASK[i]) ~= OB_WRP_VALUE[i]) then
					str = str.."(�ѱ���)"

					--pg_print_text("  �ѱ��������ö�����")
					--err = set_read_protect(1)		--���ö�����(���ֻ��д������?)
					--if (err ~= "OK") then goto quit end  --����ط���Ҫ�˳���STM32F051)
					remove_protect = 1
					--break
				end
				print(str)
			end
		end

		if (remove_protect == 1) then
			pg_print_text("���ڽ������...")
			err = set_read_protect(0)		--������������ڲ��и�λ����
			if (err ~= "OK") then goto quit end
		else
			print("  �ޱ���")
		end
	end

	fix_data_begin()				--��ʼ��̬���SN UID USR����

	for i = 1, #TaskList, 3 do
		if (TaskList[i] ~= "") then
			print("------------------------")
			str = string.format("FLM : %s", TaskList[i])  print(str)
			str = string.format("Data: %s", TaskList[i + 1]) print(str)
			str = string.format("Addr: 0x%08X", TaskList[i + 2]) print(str)

			pg_print_text("����ļ�")
			--����flash�㷨�ļ�

			re = pg_load_algo_file( TaskList[i], AlgoRamAddr, AlgoRamSize)
			if (re == 0) then
				err = "����flash�㷨ʧ��"  goto quit
			end

			re = pg_prog_file(TaskList[i + 1], TaskList[i + 2])

			if (re == 0) then
				err = "error" goto quit 	--pg_prog_file�ڲ�����ʾ������Ϣ
			end
		end
	end

	--дOPTION BYTES (������Ҳ���ڣ�
	if (OB_ENABLE == 1) then
		print("------------------------")
		str = string.format("FLM : %s", AlgoFile_OPT)  print(str)
		pg_print_text("���OPTION BYTES")
		re = pg_load_algo_file(AlgoFile_OPT, AlgoRamAddr, AlgoRamSize)
		if (re == 0) then
			err = "����OPT�㷨ʧ��"  goto quit
		end

		if (SECURE_ENABLE == 0) then
			str = string.format("OB_SECURE_OFF : %s", OB_SECURE_OFF)  print(str)
			re = pg_prog_buf_ob(OB_ADDRESS, OB_SECURE_OFF)
		else
			str = string.format("OB_SECURE_ON  : %s", OB_SECURE_ON)  print(str)
			re = pg_prog_buf_ob(OB_ADDRESS, OB_SECURE_ON)
		end
		if (re == 0) then
			err = "дOPTION BYTESʧ��"  goto quit
			goto quit
		else

		end
	end

	--��λ
	if (RESET_AFTER_COMPLETE == 1) then
		pg_reset()
	end

::quit::
	return err
end

--��ʼ���,���裺
--����-����ȫƬ-��̬����SN��UID�������ݡ��û�����
--����ļ�(�Զ���������̡�У��)
--дOPTION BYTES
function swim_start_prog(void)
	local err = "OK"
	local re
	local uid_bin
	local last_sn
	local str
	local mcu_uid
	local i
	local bin
	local ff

	--����TVCC��ѹ
	set_tvcc(TVCC_VOLT)
	delayms(20)

	pg_init()

	if (ERASE_CHIP_ENABLE == 1) then
		--�����ö��������ٽ�����������Զ�����ȫƬ��
		pg_print_text("����ȫƬ")
		--�ȼӱ����ٽ���������ﵽ���оƬ��Ŀ��
		set_read_protect(1)
		pg_init()
		set_read_protect(0)
	end

	--��̬���SN UID USR����
	fix_data_begin()

	--����ļ�����ա���������̡�У�飩
	for i = 1, #TaskList, 2 do
		if (TaskList[i] ~= "") then
			print("------------------------")
			str = string.format("File : %s", TaskList[i])  print(str)
			re = pg_prog_file(TaskList[i], TaskList[i + 1])
			if (re == 0) then
				err = "���ʧ��"  goto quit
				goto quit
			end
		end
	end

	--дOPTION BYTES (������Ҳ���ڣ�
	if (OB_ENABLE == 1) then
		print("------------------------")
		pg_print_text("дoption bytes")
		if (SECURE_ENABLE == 0) then
			str = string.format("OB_SECURE_OFF : %s", OB_SECURE_OFF)  print(str)
			re = pg_prog_buf_ob(OB_ADDRESS, OB_SECURE_OFF)
		else
			str = string.format("OB_SECURE_ON  : %s", OB_SECURE_ON)  print(str)
			re = pg_prog_buf_ob(OB_ADDRESS, OB_SECURE_ON)
		end
		if (re == 0) then
			err = "дOPTION BYTESʧ��"  goto quit
			goto quit
		else

		end
	end

	--��λ
	if (RESET_AFTER_COMPLETE == 1) then
		pg_reset()
	end

::quit::
	return err
end

--�������ַ���ת���ɼ���hex�ַ���
function bin2hex(s)
	s = string.gsub(s,"(.)", function (x) return string.format("%02X ",string.byte(x)) end)
	return s
end

--��ӡ�ڴ�����
function print_flash(addr, len, width, dispaddr)
	local re
	local bin
	local bin1
	local bin2
	local bin3
	local bin4
	local str
	local core_id

	--����TVCC��ѹ
	set_tvcc(TVCC_VOLT)
	delayms(20)

	pg_init()

	if (MULTI_MODE > 0) then
		re,bin1,bin2,bin3,bin4 = pg_read_mem(addr, len)
		if (re == 1) then
			if (MULTI_MODE >= 1) then
				str = string.format("#1 address = 0x%08X, len = %d", addr, len)
				print(str)
				if (width == nil) then
					print_hex(bin1,16)
				else
					if (dispaddr == nil) then
						print_hex(bin1,width)
					else
						print_hex(bin1,width, dispaddr)
					end
				end
				delayms(5)
			end

			if (MULTI_MODE >= 2) then
				str = string.format("#2 address = 0x%08X, len = %d", addr, len)
				print(str)
				if (width == nil) then
					print_hex(bin2,16)
				else
					if (dispaddr == nil) then
						print_hex(bin2,width)
					else
						print_hex(bin2,width, dispaddr)
					end
				end
				delayms(5)
			end

			if (MULTI_MODE >= 3) then
				str = string.format("#3 address = 0x%08X, len = %d", addr, len)
				print(str)
				if (width == nil) then
					print_hex(bin3,16)
				else
					if (dispaddr == nil) then
						print_hex(bin3,width)
					else
						print_hex(bin3,width, dispaddr)
					end
				end
				delayms(5)
			end

			if (MULTI_MODE == 4) then
				str = string.format("#4 address = 0x%08X, len = %d", addr, len)
				print(str)
				if (width == nil) then
					print_hex(bin4,16)
				else
					if (dispaddr == nil) then
						print_hex(bin4,width)
					else
						print_hex(bin4,width, dispaddr)
					end
				end
				delayms(5)
			end
		else
			str = "error"
			print(str)
		end
	else
		re,bin = pg_read_mem(addr, len)
		if (re == 1) then
			str = string.format("address = 0x%08X, len = %d", addr, len)
			print(str)
			if (width == nil) then
				print_hex(bin,16)
			else
				if (dispaddr == nil) then
					print_hex(bin,width)
				else
					print_hex(bin,width, dispaddr)
				end
			end
		else
			str = "error"
			print(str)
		end
	end
end

--��ӡOPTION BYTES
function print_option_bytes(void)
	if (MULTI_MODE > 0) then
		local re
		local bin1
		local bin2
		local bin3
		local bin4

		print("Option bytes Address:")
		print(OB_ADDRESS)

		re,bin1,bin2,bin3,bin4 = pg_read_ob(OB_ADDRESS)
		if (re == 1) then
			if (MULTI_MODE >= 1) then
				print("#1 Option bytes data:")
				print_hex(bin1)
			end

			if (MULTI_MODE >= 2) then
				print("#2 Option bytes data:")
				print_hex(bin2)
			end

			if (MULTI_MODE >= 3) then
				print("#3 Option bytes data:")
				print_hex(bin3)
			end

			if (MULTI_MODE >= 4) then
				print("#4 Option bytes data:")
				print_hex(bin4)
			end
		else
			print("error")
		end
	else
		local re
		local bin

		print("Option bytes Address:")
		print(OB_ADDRESS)

		print("Option bytes data:")
		re,bin = pg_read_ob(OB_ADDRESS)
		if (re == 1) then
			print_hex(bin)
		else
			print("error")
		end
	end
end

--���ö����� 0 ��ʾ�����������1��ʾ���ö�����
function set_read_protect(on)
	local re
	local err = "OK"
	local time1
	local time2
	local str

	if (REMOVE_RDP_POWEROFF == nil) then
		REMOVE_RDP_POWEROFF = 0
	end

	if (on == 1) then
		print("���ö�����...")
	else
		print("�رն�����...")
	end

	time1 = get_runtime()

--	--����TVCC��ѹ
--	set_tvcc(TVCC_VOLT)
--	delayms(20)
--
--	--���IC,��ӡ�ں�ID
--	local core_id = pg_detect_ic()
--	if (core_id == 0) then
--		err = "δ��⵽IC"  print(err) return err
--	else
--		str = string.format("core_id = 0x%08X", core_id)
--		print(str)
--	end

	if (CHIP_TYPE == "SWD") then

		--����ר�õĽ������
		if (MCU_REMOVE_PROTECT == 1) then
			if (on == 0) then
				print("MCU_RemoveProtect()")
				MCU_RemoveProtect()
			end
		end

		if (AlgoFile_OPT == "") then
			err = "û��OPT�㷨�ļ�"  print(err) return err
		end

		--����flash�㷨�ļ�
		re = pg_load_algo_file(AlgoFile_OPT, AlgoRamAddr, AlgoRamSize)
		if (re == 0) then
			err = "����flash�㷨ʧ��"  print(err) return err
		end
	else
		if (CHIP_TYPE == "SWIM") then
			--STM8ר�õĽ������
			if (MCU_REMOVE_PROTECT == 1) then
				if (on == 0) then
					print("MCU_RemoveProtect()")
					MCU_RemoveProtect()
				end
			end
		else
			print("��֧�ָù���")
			return "err"
		end
	end

	if (on == 0) then
		local i

		print("OB_SECURE_OFF = ", OB_SECURE_OFF)
		for i = 1, 3, 1 do
			re = pg_prog_buf_ob(OB_ADDRESS, OB_SECURE_OFF)
			if (re == 0) then		--����оƬ��Ҫ2�β�����ȷ���Ƿ�ɹ� ��STM32L051)
				if (REMOVE_RDP_POWEROFF > 0) then
					print("  prog ob failed", i)
					delayms(POWEROFF_TIME1)
					print("  �ϵ�")
					set_tvcc(0)			--�ϵ�
					delayms(POWEROFF_TIME2)
					set_tvcc(TVCC_VOLT) --�ϵ�
					pg_reset()
					delayms(POWEROFF_TIME3)
					core_id = pg_detect_ic()	--MM32��λ������һ��ID���ܷ����ڴ�
				else
					print("  prog ob failed", i)
					delayms(100)
					pg_reset()
					delayms(100)
					core_id = pg_detect_ic()	--MM32��λ������һ��ID���ܷ����ڴ�
				end
			else	--�ɹ�
				if (REMOVE_RDP_POWEROFF > 0) then
					delayms(POWEROFF_TIME1)
					print("  �ϵ�")
					set_tvcc(0)			--�ϵ�
					delayms(POWEROFF_TIME2)
					set_tvcc(TVCC_VOLT) --�ϵ�
					pg_reset()
					delayms(POWEROFF_TIME3)
					core_id = pg_detect_ic()	--MM32��λ������һ��ID���ܷ����ڴ�
				else
					pg_reset()
					delayms(100)
				end
				core_id = pg_detect_ic()	--MM32��λ������һ��ID���ܷ����ڴ�
				break
			end
		end
	else
		if (on == 1) then
			print("OB_SECURE_OFF = ", OB_SECURE_ON)
			re = pg_prog_buf_ob(OB_ADDRESS, OB_SECURE_ON)
		end
	end

	if (re == 0) then
		err = "дOPTION BYTESʧ��"
	end
	time2 = get_runtime()

	if (err == "OK") then
		print("дOption Bytes�ɹ�")
		str = string.format("ִ��ʱ�� = %d ms", time2 - time1);
		print(str)
	else

	end

	return err
end

--����оƬ=����оƬ
function erase_chip(FlashAddr)
	local re
	local err = "OK"
	local time1
	local time2
	local str

	pg_print_text("����...")

	if (CHIP_TYPE == "SWD") then
		if (FlashAddr == FLASH_ADDRESS) then
			re = pg_load_algo_file(AlgoFile_FLASH, AlgoRamAddr, AlgoRamSize)	--����flash�㷨�ļ�
		else
			re = pg_load_algo_file(AlgoFile_EEPROM, AlgoRamAddr, AlgoRamSize)	--����eeprom�㷨�ļ�
		end
		if (re == 0) then
			err = "����flash�㷨ʧ��"  print(str) return err
		end
	else
		if (CHIP_TYPE == "SWIM") then
			if (FlashAddr == FLASH_ADDRESS) then
				str = string.format("��ʼ����flash. ��ַ : 0x%X ���� : %dKB ", FlashAddr, FLASH_SIZE / 1024)
			else
				str = string.format("��ʼ����eeprom. ��ַ : 0x%X ���� : %dB ", FlashAddr, EEPROM_SIZE)
			end
			print(str)
		else
			print("δ֪�ӿ�")
		end
	end

	time1 = get_runtime()

	--����TVCC��ѹ
	set_tvcc(TVCC_VOLT)
	delayms(20)

	pg_init()

	re = pg_erase_chip(FlashAddr)
	if (re == 1) then
		pg_print_text("�����ɹ�")
	else
		pg_print_text("����ʧ��")
		err = "err"
	end
	time2 = get_runtime()

	str = string.format("ִ��ʱ�� = %d ms", time2 - time1);
	print(str)
	return err
end

--��ʾ�ں�id,
function print_core_id(void)
	local id
	local id1
	local id2
	local id3
	local id4
	local str

	set_tvcc(TVCC_VOLT)

	if (MULTI_MODE > 0) then
		id1,id2,id3,id4 = pg_detect_ic()
		str = string.format("core_id1 = 0x%08X", id1) print(str) delayms(5)
		str = string.format("core_id2 = 0x%08X", id2) print(str) delayms(5)
		str = string.format("core_id3 = 0x%08X", id3) print(str) delayms(5)
		str = string.format("core_id4 = 0x%08X", id4) print(str) delayms(5)
	else
		core_id = pg_detect_ic()
		if (core_id == 0) then
			print("δ��⵽IC")
		else
			str = string.format("core_id = 0x%08X", core_id) print(str)
		end
	end
end

--����CPUƬ��QSPI FLASH
function erase_chip_qspi(void)
	local core_id
	local str
	local addr
	local i
	local nSector
	local percent
	local time1
	local time2

	if (AlgoFile_QSPI == nil or AlgoFile_QSPI == "") then
		print("δ����QSPI Flash")
		return
	end

	print("��ʼ����QSPI Flash...")

	time1 = get_runtime()

	config_chip1()		--������¼����
	--set_tvcc(0)			--�ϵ�
	--delayms(20)
	set_tvcc(TVCC_VOLT)	--����TVCC��ѹ

	core_id = pg_detect_ic()
	if (core_id > 0) then
		str = string.format("swd : core_id = 0x%08X", core_id)
		print(str)
	end

	--����flash�㷨�ļ�
	re = pg_load_algo_file(AlgoFile_QSPI, AlgoRamAddr, AlgoRamSize)

	addr = 0x90000000
	nSector = 32 * 1024 / 64
	for i = 1, nSector,1 do
		pg_erase_sector(addr)

		percent = 100 * i / nSector;
		str = string.format("erase 0x%08X, %0.2f%%", addr, percent)
		print(str)
		addr = addr + 64 * 1024
	end

	time2 = check_runtime(time1)
	str = string.format("��������  %0.3f ��", time2 / 1000)
	print(str)
end

---------------------------����-----------------------------------
