--���¿�ݷ�ʽ����ʾ��PC�������(STM8)
--F01=�Զ����,start_prog()
--F03=����flash,erase_chip(0x08000)
--F04=����eeprom,erase_chip(0x04000)
--F05=��ӡflash,print_flash(0x08000,1024,32,0x08000)
--F06=��ӡeeprom,print_flash(0x04000,256,32,0x04000)
--F07=��ӡUID,print_flash(UID_ADDR,12)
--F08=��ӡ�ں�id,print_core_id()
--F09=�޸�RAM,pg_write_mem(0, "1234")
--F10=����RAM,print_flash(0, 16)
--F12=Ӳ����λ,pg_reset()
--F13=���ö�����, set_read_protect(1)
--F14=���������, set_read_protect(0)
--F15=��ӡOption Bytes,print_option_bytes()

--�����ע�ͽ���ʾ��H7-TOOLҺ����
Note01 = "STM8S208 ���Գ���"

beep()

--����оƬ�ӿںͲ�����ȫ�ֱ���)
function cofig_chip1(void)	
	CHIP_TYPE = "SWIM"		--ָ�������ӿ�����: "SWD", "SWIM", "SPI", "I2C" 	
	STM8_SERIAL = "STM8S"	--ѡ��2��ϵ��: "STM8S" �� "STM8L"	
	FLASH_BLOCK_SIZE = 128	--����BLOCK SIZE, ֻ��64��128���� 
	FLASH_ADDRESS = 0x008000	--����FLASH��ʼ��ַ
	FLASH_SIZE = 64 * 1024  --����FLASH������
	EEPROM_ADDRESS = 0x004000 	--����FLASH��ʼ��ַ(STM8S��STM8L��ͬ��
	EEPROM_SIZE = 2 * 1024  --����EEPROM����
	UID_ADDR = 0x48CD		--UID��ַ����ͬ��CPU��ͬ   		
	
	--�����б���������׷��
	--�����ļ���lua�ļ�ͬĿ¼.֧��../�ϼ�Ŀ¼,Ҳ����д����·��
	TaskList = {
		"0:/H7-TOOL/Programmer/User/TestBin/64K_55.bin",	--�����ļ� (""��ʾ����)
		0x008000,											--Ŀ���ַ (0x008000 Flash)
		
		"0:/H7-TOOL/Programmer/User/TestBin/512.bin",		--�����ļ� (""��ʾ����)
		0x004000,											--Ŀ���ַ (0x004000 EEPROM)	
	}	

	TVCC_VOLT = 3.3			--����CPU�����ѹTVCC
	
	--1��ʾ��Ƭ�������� 0��ʾ��BLOCK��̣�δ��BLOCK����ԭ״
	ERASE_CHIP_ENABLE = 0
	
	--��̽�����λ 0��ʾ����λ  1��ʾӲ����λ
	RESET_AFTER_COMPLETE = 0

	--OPTION BYTES ���ã�STM8S208x8)
	OB_ENABLE	= 0 				--1��ʾ�����Ϻ�дOPTION BYTES
	--��ַ���е�FFFFFFFF��ʾԭʼ�����в����ϸ��ֽڵķ��� FFFFFFFE��ʾԭʼ�����в���ǰ2���ֽڵķ���
	OB_ADDRESS     = "4800 4801 FFFF 4803 FFFF 4805 FFFF 4807 FFFF 4809 FFFF 480B FFFF 480D FFFF 487E FFFF"
	SECURE_ENABLE  = 0				--ѡ����ܻ��ǲ�����	
	
	OB_SECURE_OFF  = "00 00 00 00 00 00 00 00 00"	--SECURE_ENABLE = 0ʱ�������Ϻ�д���ֵ (���������ֽڣ�
	OB_SECURE_ON   = "AA 00 00 00 00 00 00 00 00"	--SECURE_ENABLE = 1ʱ�������Ϻ�д���ֵ
	
	OB_RDP_OFF     = "00 00 00 00 00 00 00 00 00"	--OPTIONȱʡֵ,���ڽ������
	OB_RDP_ON      = "AA 00 00 00 00 00 00 00 0"	--��������ֵ�����ڽ������		
	
	pg_reload_var()			--���ڸ���c�����ȫ�ֱ���
end

-------------------------------------------------------
-- ����Ĵ���һ���������(STM8��ARMоƬ��ͬ��
-------------------------------------------------------

cofig_chip1()				--ִ��һ�θ�ȫ�ֱ�������ֵ

--������
function start_prog(void)	
	local err = ""
	local core_id
	local str
	
	cofig_chip1()		--������¼����			
	set_tvcc(0)			--�ϵ�
	delayms(20)
	set_tvcc(TVCC_VOLT)	--����TVCC��ѹ	
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
		
		if (CHIP_TYPE == "SWD") then
			err = swd_start_prog()	--���ARM (SWD)
		else
			err = swim_start_prog()	--���STM8 (SWD)
		end
		if (err ~= "OK") then goto quit end		
		goto quit
	end
	
	err = "δ��⵽IC"	

::quit::
	if (err == "OK") then
		beep() --�ɹ���1��
		pg_print_text("��̳ɹ�")
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
	local core_id
	
	core_id = pg_detect_ic()
	if (core_id == 0) then
		return "removed"
	end
	
	return "no"
end

--�ж�оƬ���루����������¼��
function CheckChipInsert(void)
	cofig_chip1()
	core_id = pg_detect_ic()
	if (core_id > 0) then
		return "inserted"
	end
	
	return "no"
end

-------------------------------------------------------
-- ����Ĵ���������¼��Ʒ�ͳ���UID����
-------------------------------------------------------

--��ʼ���������ļ�����̬���SN UID USR����
function fix_data_begin(void)
	--��Ʒ���루���룩���ã��̶�4�ֽڣ�
	SN_ENABLE = 0				--1��ʾ����   0��ʾ������
	SN_SAVE_ADDR = 0			--��Ʒ��ű����ַ
	SN_INIT_VALUE = 1			--��Ʒ��ų�ʼֵ
	SN_LITTLE_ENDIN = 1			--0��ʾ��ˣ�1��ʾС��
	SN_DATA = ""				--������ݣ��ɺ���� sn_new() ��������
	SN_LEN = 0					--��ų���
	
	--UID���ܴ洢���ã�ֻ�����UID��MCU��
	UID_ENABLE = 0	       		--1��ʾ���ü���  0��ʾ������
	UID_BYTES = 12             	--UID����
	UID_SAVE_ADDR = 0 			--���ܽ��FLASH�洢��ַ
	UID_DATA = ""				--�����������ݣ��ɺ���� uid_encrypt() ��������
	UID_LEN = 0					--���ݳ���
	
	--�û��Զ������ݣ�������������ڣ��ͻ���ŵ����ݣ�Ҫ������������
	USR_ENABLE = 0	       		--1��ʾ����   0��ʾ������
	USR_SAVE_ADDR = 0 			--�Զ������ݴ洢��ַ
	USR_DATA = ""				--�Զ����������ݣ��ɺ���� make_user_data() ��������
	USR_LEN = 0					--���ݳ���
	
	local str
	local re
		
	--���ļ����ϴ�SN�������µ�SN����
	if (SN_ENABLE == 1) then
		SN_DATA = sn_new()	--�����ϴ�SN��4���µ�SN
		SN_LEN = string.len(SN_DATA)
		str = "new sn  = "..bin2hex(SN_DATA) print(str)
	end
	
	--��UID��unique device identifier) ������UID��������
	re,mcu_uid = pg_read_mem(UID_ADDR, UID_BYTES)
	if (re == 1) then
		str = "uid original = "..bin2hex(mcu_uid)
		print(str)

		if (UID_ENABLE == 1) then
			UID_DATA = uid_encrypt(mcu_uid)
			UID_LEN = string.len(UID_DATA)
			str = "uid encrypt  = "..bin2hex(UID_DATA)
			print(str)
		end
	end

	--��̬�����û�������
	if (USR_ENABLE == 1) then
		USR_DATA = make_user_data()
		USR_LEN = string.len(USR_DATA)
		str = "user data  = "..USR_DATA
		print(str)
	end	
end

--�������������ļ�
function fix_data_end(void)
	SN_ENABLE = 0
	UID_ENABLE = 0	
	USR_ENABLE = 0
end	

--��Ʒ���SN���ɺ��� ��last_sn��һ��UINT32�������룩����Ƕ������ַ���
function sn_new(void)
	local bin = {}
	local out = {}
	local sn1

	sn1 = pg_read_sn()	--���ϴ�SN ��������������
	str = string.format("last sn = %d", sn1) print(str)		
	if (sn1 == nil) then
		sn1 = SN_INIT_VALUE
	else
		sn1 = sn1 + 1	--��Ų���=1
	end
	
	pg_write_sn(sn1)	--��̳ɹ���Żᱣ�汾��SN

	--ƴ��Ϊ�����ƴ�����
	if (SN_LITTLE_ENDIN == 1) then
		s =    string.char(sn1)
		s = s..string.char(sn1 >> 8)
		s = s..string.char(sn1 >> 16)
		s = s..string.char(sn1 >> 24)	
	else
		s =    string.char(sn1 >> 24)
		s = s..string.char(sn1 >> 16)
		s = s..string.char(sn1 >> 8)
		s = s..string.char(sn1)
	end
	return s;
end

--UID���ܺ������û��������޸�
--	&	��λ��
--	|	��λ��
--	~	��λ���
--	>>	����
--	<<	����
--	~	��λ��
function uid_encrypt(uid)
	local bin = {}
	local out = {}
	local i

	--�������Ƶ�uid�ַ���ת��Ϊlua��������
	for i = 1,12,1 do
		bin[i] = tonumber(string.byte(uid, i,i))
	end

	--�����߼����� �û��������޸�Ϊ�����㷨
	out[1] = bin[1] ~ (bin[5] >> 1) ~ (bin[9]  >> 1)
	out[2] = bin[2] ~ (bin[6] >> 1) ~ (bin[10] >> 2)
	out[3] = bin[3] ~ (bin[7] >> 1) ~ (bin[11] >> 3)
	out[4] = bin[4] ~ (bin[8] >> 2) ~ (bin[12] >> 4)

    out[1] = out[4] ~ 0x12
    out[2] = out[3] ~ 0x34
    out[3] = out[1] ~ 0x56
    out[4] = out[2] ~ 0x78

	--ƴ��Ϊ�����ƴ�����
	s =    string.char(out[1])
	s = s..string.char(out[2])
	s = s..string.char(out[3])
	s = s..string.char(out[4])
	return s
end

--��̬�����û�������USR
function make_user_data(uid)
	s = os.date("%Y-%m-%d %H:%M:%S")	--����ASCII�ַ��� 2020-01-21 23:25:01
	s = s.." aaa"..string.char(0)
	return s
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
			
			re,ob_data = pg_read_mem(OB_WRP_ADDRESS[i], 1)
			if (re == 0) then
				pg_print_text("  �ѱ��������ö�����")	
				remove_protect = 1	
				break
			else
				wrp = tonumber(string.byte(ob_data,1,1))					
				str = string.format("  0x%08X �� 0x%02X & 0x%02X == 0x%02X", OB_WRP_ADDRESS[i], wrp, OB_WRP_MASK[i], OB_WRP_VALUE[i])
				print(str)
				if ((wrp & OB_WRP_MASK[i]) ~= OB_WRP_VALUE[i]) then
					pg_print_text("  �ѱ��������ö�����")	
					err = set_read_protect(1)		--���ö�����
					--if (err ~= "OK") then goto quit end  --����ط���Ҫ�˳���STM32F051)
					remove_protect = 1	
					break	
				end			
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
			
			fix_data_begin()				--��ʼ��̬���SN UID USR����
			re = pg_prog_file(TaskList[i + 1], TaskList[i + 2])
			fix_data_end()					--������̬���SN UID USR����
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

	--�����ö��������ٽ�����������Զ�����ȫƬ��
	pg_print_text("����ȫƬ")
	re = pg_prog_buf_ob(OB_ADDRESS, OB_RDP_ON)
	if (re == 0) then
		err = "����ʧ��"  goto quit
		goto quit	
	end	
	pg_init()	--������λ����Ч	
	re = pg_prog_buf_ob(OB_ADDRESS, OB_RDP_OFF)
	if (re == 0) then
		err = "����ʧ��"  goto quit
		goto quit	
	end		

	--����ļ�����ա���������̡�У�飩
	for i = 1, #TaskList, 2 do		
		if (TaskList[i] ~= "") then	
			print("------------------------")
			str = string.format("File : %s", TaskList[i])  print(str)		
			fix_data_begin()			--��ʼ��̬���SN UID USR����				
			re = pg_prog_file(TaskList[i], TaskList[i + 1])
			fix_data_end()				--������̬���SN UID USR����
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
	local str
	local core_id

	--����TVCC��ѹ
	set_tvcc(TVCC_VOLT)
	delayms(20)

	pg_init()
		
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

--��ӡOPTION BYTES
function print_option_bytes(void)
	local re
	local bin
	
	print("Option bytes Address:")
	print(OB_ADDRESS)

	print("Option bytes data:")
	re,obin = pg_read_ob(OB_ADDRESS)
	if (re == 1) then
		print_hex(obin)
	else
		print("error")
	end
end

--���ö����� 0 ��ʾ�����������1��ʾ���ö�����
function set_read_protect(on)
	local re
	local err = "OK"
	local time1
	local time2
	local str
	
	if (on == 1) then
		print("���ö�����...")
	else
		print("�رն�����...")
	end
	
	pg_reset()
	
	time1 = get_runtime()
	
	--����TVCC��ѹ
	set_tvcc(TVCC_VOLT)
	delayms(20)
	
	--���IC,��ӡ�ں�ID
	local core_id = pg_detect_ic()
	if (core_id == 0) then
		err = "δ��⵽IC"  print(err) return err
	else
		str = string.format("core_id = 0x%08X", core_id)
		print(str)
	end
	
	if (CHIP_TYPE == "SWD") then
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
			
		else
			print("��֧�ָù���")
			return "err"
		end	
	end
	
	if (on == 0) then
		re = pg_prog_buf_ob(OB_ADDRESS, OB_RDP_OFF)
		if (re == 0) then		--����оƬ��Ҫ2�β�����ȷ���Ƿ�ɹ� ��STM32L051)
			print("�ϵ�200ms")  
			set_tvcc(0)			--�ϵ�
			delayms(200)		--�ӳ�200ms
			set_tvcc(TVCC_VOLT) --�ϵ�
			print("�����ϵ�")	
			pg_reset()		
			re = pg_prog_buf_ob(OB_ADDRESS, OB_RDP_OFF)
		end	
	else 
		if (on == 1) then
			re = pg_prog_buf_ob(OB_ADDRESS, OB_RDP_ON)
		end
	end
	if (re == 0) then
		err = "дOPTION BYTESʧ��"
	end
	time2 = get_runtime()

	if (err == "OK") then
		print("д��ɹ�")
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
	
	print("��ʼ����flash..")

	--���IC,��ӡ�ں�ID
	local core_id = pg_detect_ic()
	if (core_id == 0) then
		err = "δ��⵽IC"  print(str) return err
	else
		str = string.format("core_id = 0x%08X", core_id)
		print(str)
	end
	
	if (CHIP_TYPE == "SWD") then
		--����flash�㷨�ļ�
		re = pg_load_algo_file(AlgoFile_FLASH, AlgoRamAddr, AlgoRamSize)
		if (re == 0) then
			err = "����flash�㷨ʧ��"  print(str) return err
		end
	else 
		if (CHIP_TYPE == "SWIM") then
			if (FlashAddr == 0x08000) then
				str = string.format("��ʼ����flash. ��ַ : 0x%X ���� : %dKB ", FlashAddr, FLASH_SIZE / 1024)
			else
				str = string.format("��ʼ����flash. ��ַ : 0x%X ���� : %dKB ", FlashAddr, EEPROM_SIZE / 1024)
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
	local core_id
	local str

	set_tvcc(TVCC_VOLT)

	--���IC,��ӡ�ں�ID
	core_id = pg_detect_ic()
	if (core_id == 0) then
		print("δ��⵽IC")
	else
		str = string.format("core_id = 0x%08X", core_id) print(str)
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
	
	print("��ʼ����QSPI Flash...")

	time1 = get_runtime()

	cofig_chip1()		--������¼����			
	set_tvcc(0)			--�ϵ�
	delayms(20)
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

--����CPUƬ�� FLASH
function erase_chip_mcu(void)
	local core_id
	local str
	local addr
	local i
	local nSector
	local percent
	local time1
	local time2
	
	time1 = get_runtime()

	cofig_chip1()		--������¼����			
	set_tvcc(0)			--�ϵ�
	delayms(20)
	set_tvcc(TVCC_VOLT)	--����TVCC��ѹ	
	
	erase_chip(FLASH_ADDRESS)	

	time2 = check_runtime(time1)
	str = string.format("��������  %0.3f ��", time2 / 1000)
	print(str)
end	

---------------------------����-----------------------------------

