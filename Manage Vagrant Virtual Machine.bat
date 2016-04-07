@ECHO OFF
TITLE Manage Vagrant Virtual Machine
SET VAGRANT_MACHINE_REQUIRES_ADMIN=True

CLS
IF %VAGRANT_MACHINE_REQUIRES_ADMIN% EQU False GOTO ChangeDirectory
fsutil dirty query %SystemDrive% > NUL
IF %ERRORLEVEL% NEQ 0 GOTO NotAdmin

:ChangeDirectory
CD /D %~dp0
IF NOT EXIST Vagrantfile GOTO NoVagrantfile

ECHO Please wait while the virtual machine's status is determined...

FOR /F "skip=1 tokens=2-4* delims=," %%A IN ('vagrant status --machine-readable') DO (
	IF %%B EQU state (
		SET VAGRANT_MACHINE_NAME=%%A
		SET VAGRANT_STATUS=%%C
		GOTO Continue
	)
)

:Continue
CLS
ECHO | SET /P UnusedVar="The "%VAGRANT_MACHINE_NAME%" virtual machine is currently "

IF %VAGRANT_STATUS% EQU not_created (
	ECHO not created.
) ELSE IF %VAGRANT_STATUS% EQU poweroff (
	ECHO powered off.
) ELSE IF %VAGRANT_STATUS% EQU aborted (
	ECHO aborted -- it was abruptly stopped.
) ELSE IF %VAGRANT_STATUS% EQU running (
	ECHO running.
) ELSE IF %VAGRANT_STATUS% EQU saved (
	ECHO suspended.
)

ECHO.
ECHO Choose an action to perform:
ECHO    1. Start the virtual machine
ECHO    2. Restart the virtual machine
ECHO    3. Suspend the virtual machine
ECHO    4. Shut down the virtual machine
ECHO    5. Destroy the virtual machine
ECHO    6. Display Vagrant version information
ECHO    7. Exit
ECHO.

:Prompt
SET /P num="Type a number and press enter: "

IF %num% EQU 1 (
	IF %VAGRANT_STATUS% NEQ running (
		vagrant up
	) ELSE (
		ECHO The virtual machine is already running.
		GOTO Prompt
	)
) ELSE IF %num% EQU 2 (
	IF %VAGRANT_STATUS% NEQ not_created (
		vagrant reload
	) ELSE (
		ECHO The virtual machine hasn't been created, so it can't be restarted.
		GOTO Prompt
	)
) ELSE IF %num% EQU 3 (
	IF %VAGRANT_STATUS% EQU running (
		vagrant suspend
	) ELSE (
		ECHO The virtual machine isn't running, so it can't be suspended.
		GOTO Prompt
	)
) ELSE IF %num% EQU 4 (
	IF %VAGRANT_STATUS% NEQ not_created IF %VAGRANT_STATUS% NEQ poweroff IF %VAGRANT_STATUS% NEQ aborted (
		vagrant halt
	) ELSE (
		ECHO The virtual machine isn't running or suspended, so it can't be shut down.
		GOTO Prompt
	)
) ELSE IF %num% EQU 5 (
	IF %VAGRANT_STATUS% NEQ not_created (
		vagrant destroy
	) ELSE (
		ECHO The virtual machine hasn't been created, so it can't be destroyed.
		GOTO Prompt
	)
) ELSE IF %num% EQU 6 (
	vagrant version
) ELSE IF %num% EQU 7 (
	GOTO Exit
) ELSE (
	ECHO Please enter a valid number.
	GOTO Prompt
)

GOTO Done

:NotAdmin
ECHO It appears that you do not have administrative privileges, so this batch file
ECHO can't continue. Please close this window, right-click this batch file's icon,
ECHO and choose "Run as administrator".
GOTO Done

:NoVagrantfile
ECHO The "Vagrantfile" file wasn't found, so this batch file can't continue.

:Done
ECHO.
ECHO --------------------------------------------------------------------------------
ECHO Done. This batch file will now exit.
ECHO.
PAUSE

:Exit
EXIT /B
