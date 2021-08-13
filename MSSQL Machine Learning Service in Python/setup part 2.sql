-- After the completion of setup procedure.

-- Checking external configuration
sp_configure

-- Changing 'external scripts enabled' to 1
EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE WITH OVERRIDE

-- ReChecking external configuration status
sp_configure -- now the configuration is turned on

-- Now that the desired configuration is achieved, Restart the server.

-- Now we will try some basic python command to see if everything's okay!

/* 
Let's call a store procedure.
It has 2 parameters primarily.
	1. Language
	2. Script
*/
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
print("Hello World")
'

-- Let;s check out system information
EXEC sp_execute_external_script
@LANGUAGE = N'Python',
@SCRIPT = N'
import sys
print(sys.version)
'
