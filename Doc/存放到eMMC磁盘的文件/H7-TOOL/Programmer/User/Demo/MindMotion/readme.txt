
---------------------------------------------------------------------------------
2020-05-16

MM32L373、MM32W395实测发现解除读保护有时候不成功, 必须完全断电后重试才能通过.
demo_MM32L37x.lua
demo_MM32W395.lua

解决办法: 添加断电复位的代码
function config_chip1(void)

	config_cpu()

	--如果解除读保护后，必须断电才能生效，则添加如下代码
	REMOVE_RDP_POWEROFF = 1
	POWEROFF_TIME1 = 2000	--写完OB延迟时间 2000ms
	POWEROFF_TIME2 = 100	--断电时间 100ms
	POWEROFF_TIME3 = 100	--上电后等待时间 100ms

---------------------------------------------------------------------------------
