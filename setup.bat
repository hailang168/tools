@ECHO OFF

REM �P ���L�̇@�A�A�̃t�@�C�������[�J�����Ƀ_�E�����[�h���܂��B
REM �@�@�c�[���̃_�E�����[�h
REM �@https://www.microsoft.com/en-us/download/details.aspx?id=49117
REM 
REM �@�A�\���t�@�C��(config.xml)�̃G�N�X�|�[�g
REM �@https://config.office.com/deploymentsettings
REM �@
REM �Q�uWindows�̌����Ɂu������]�Ɠ��͂��A�R�}���h�v�����v�g�i�Ǘ��҂Ƃ��Ď��s�j���N�����܂��B
REM �@�ȉ��̃R�����g�����s����
REM �@�B cd�R�}���h����͂��A�@�C�A�̃t�@�C����ۑ������t�H���_�ɓ���܂��B
REM      cd [�t�H���_�p�X]
REM      ��j cd C:\Office2021
REM �@�C setup /download config.xml
REM 
REM ��L�܂Ł@���{�ς݂Ȃ̂ŁA�Ď��{���v��Ȃ��ł��B
REM ----------------------------------------------------------------------


REM �Ǘ��҂Ƃ��ċN���̔��f
whoami /priv | find "SeDebugPrivilege" > nul
if %errorlevel% neq 0 (
    powershell start-process "%~0" -verb runas
	REM echo �Ǘ��� NG
    exit
)

REM echo �Ǘ��� OK

REM ���C������
:REC_MENU
cls
ECHO-----Office���i��蓱���̎菇-----
ECHO ���j���[��I����������
ECHO   1. Office�C���X�g�[��
ECHO   2. kms�ŔF�؎��s
ECHO   9. �����I��
ECHO.

SET /P MENU_REC=���j���[�����: 

REM �����͂̏ꍇ�A
IF "%MENU_REC%" EQU "1" (
    GOTO :INSTALL
) ELSE IF "%MENU_REC%" EQU "2" (
    GOTO :ACTIVE
) ELSE IF "%MENU_REC%" EQU "9" (
    EXIT /B 0
) ELSE (
    GOTO :REC_MENU
)

REM Office�C���X�g�[��
:INSTALL
�@setup /configure config.xml
�@
REM kms�ŔF�؎��s
:ACTIVE
REM Method 1�F�A�N�e�B�u��
�@cd C:\Program Files\Microsoft Office\Office16
�@REM slmgr /skms kms.03k.org
�@REM slmgr /ato
�@cscript ospp.vbs /sethst:kms.03k.org
�@cscript ospp.vbs /act
�@
REM Method 2�F - PowerShell (Recommended)
REM irm https://massgrave.dev/get | iex


pause