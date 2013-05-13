; CFInstaller

; PRE-CHECK
; Verify that RubyVersion, RubyPatch, RubyPath and CFVersion
; are defined in "config.iss".
;
; Command Prompt:
;  iscc cfinstaller.iss 
;
; Editor:
;  Build -> Compile
;

#include "config.iss"

#if Defined(RubyVersion) == 0
  #error Please provide a RubyVersion definition edit the "config.iss".
#endif

#if Defined(RubyPatch) == 0
  #error Please provide a RubyPatch level definition edit the "config.iss".
#endif

#if Defined(RubyPath) == 0
  #error Please provide a RubyPath value to the Ruby files edit the "config.iss".
#else
  #if FileExists(RubyPath + '\bin\ruby.exe') == 0
    #error No Ruby installation (bin\ruby.exe) found inside defined RubyPath. Please verify.
  #endif
#endif

#if Defined(CFVersion) == 0
  #error Please provide a CFVersion level definition edit the "config.iss".
#endif 

#if Defined(InstVersion) == 0
  #define InstVersion GetDateTimeString('dd-mmm-yy"T"hhnn', '', '')
#endif

#define RubyBuildPlatform "i386-mingw32"
#define DefaultCannotUseSymbol '/ : * ? " < > |'
#define AddCannotUseSymbol '; [ ] { }'
#define CannotUseSymbol DefaultCannotUseSymbol + ' ' + AddCannotUseSymbol

; Grab MAJOR.MINOR info from RubyVersion (1.8)
#define RubyMajorMinor Copy(RubyVersion, 1, 3)
#define RubyFullVersion RubyVersion + '-p' + RubyPatch

; Build Installer details using above values
#define InstallerName "CF " + CFVersion + "-r" + RubyVersion
#define InstallerPublisher "Nippon Telegraph and Telephone Corporation"

#define CurrentYear GetDateTimeString('yyyy', '', '')

#define RubyInstallerBaseId "MRI"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications!
AppName={#InstallerName}
AppVerName={#InstallerName}
AppPublisher={#InstallerPublisher}
AppVersion={#CFVersion}
DefaultGroupName={#InstallerName}
DisableWelcomePage=true
DisableProgramGroupPage=true
LicenseFile=..\LICENSE
Compression=lzma2/ultra64
SolidCompression=true
AlwaysShowComponentsList=false
InternalCompressLevel=ultra64
VersionInfoCompany={#InstallerPublisher}
VersionInfoCopyright=(c) {#CurrentYear} {#InstallerPublisher}
VersionInfoDescription=VMware Cloud Client and Ruby Programming Language for Windows
VersionInfoTextVersion={#CFVersion}
VersionInfoVersion={#CFVersion}
UninstallDisplayIcon={app}\bin\ruby.exe
PrivilegesRequired=lowest
ChangesAssociations=yes
ChangesEnvironment=yes
MinVersion=0,5.1.2600
#if Defined(SignPackage) == 1
SignTool=risigntool sign /a /d $q{#InstallerName}$q /du $q{#InstallerHomepage}$q /t $qhttp://timestamp.comodoca.com/authenticode$q $f
#endif

DefaultDirName={sd}\cf_{#CFVersion}-r{#RubyVersion}
OutputDir={#OutputExeDir}
OutputBaseFilename=cfinstaller_{#CFVersion}-r{#RubyVersion}

[Files]
Source: {#RubyPath}\*; DestDir: {app}; Excludes: "\unins*"; Flags: recursesubdirs createallsubdirs
Source: ..\LICENSE; DestDir: {app}
Source: setrbvars.bat; DestDir: {app}\bin;
Source: README.txt; DestDir: {app}; Flags: isreadme

[Languages]
Name: en; MessagesFile: compiler:Default.isl

[Messages]
en.WelcomeLabel1=Welcome to the [name] Installer
en.WelcomeLabel2=This will install [name/ver] on your computer. Please close all other applications before continuing.
en.WizardLicense={#InstallerName} License Agreement
en.LicenseLabel=
en.LicenseLabel3=Please read the following License Agreement and accept the terms before continuing the installation.
en.LicenseAccepted=I &accept the License
en.LicenseNotAccepted=I &decline the License
en.WizardSelectDir=Installation Destination and Optional Tasks
en.SelectDirDesc=
en.SelectDirLabel3=Setup will install [name] into the following folder. Click Install to continue or click Browse to use a different one.
en.SelectDirBrowseLabel=Please avoid any folder name that contains spaces (e.g. Program Files).
en.DiskSpaceMBLabel=Required free disk space: ~[mb] MB
en.BadDirName32=Folder names cannot include any of the following characters:%n%n{#CannotUseSymbol}

[Registry]
; .rb file for admin
Root: HKLM; Subkey: Software\Classes\.rb; ValueType: string; ValueName: ; ValueData: RubyFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyFile; ValueType: string; ValueName: ; ValueData: Ruby File; Flags: uninsdeletekey; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\ruby.exe,0; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyFile\shell\open\command; ValueType: string; ValueData: """{app}\bin\ruby.exe"" ""%1"" %*"; Check: IsAdmin and IsAssociated

; .rbw file for admin
Root: HKLM; Subkey: Software\Classes\.rbw; ValueType: string; ValueName: ; ValueData: RubyWFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyWFile; ValueType: string; ValueName: ; ValueData: RubyW File; Flags: uninsdeletekey; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyWFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\rubyw.exe,0; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyWFile\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\rubyw.exe"" ""%1"" %*"; Check: IsAdmin and IsAssociated

; .rb file for non-admin
Root: HKCU; Subkey: Software\Classes\.rb; ValueType: string; ValueName: ; ValueData: RubyFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyFile; ValueType: string; ValueName: ; ValueData: Ruby File; Flags: uninsdeletekey; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\ruby.exe,0; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyFile\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\ruby.exe"" ""%1"" %*"; Check: IsNotAdmin and IsAssociated

; .rbw file for non-admin
Root: HKCU; Subkey: Software\Classes\.rbw; ValueType: string; ValueName: ; ValueData: RubyWFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyWFile; ValueType: string; ValueName: ; ValueData: RubyW File; Flags: uninsdeletekey; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyWFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\rubyw.exe,0; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyWFile\shell\open\command; ValueType: string; ValueData: """{app}\bin\rubyw.exe"" ""%1"" %*"; Check: IsNotAdmin and IsAssociated

; RubyInstaller identification for admin
Root: HKLM; Subkey: Software\RubyInstaller; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletekey; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallLocation ; ValueData: {app}; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallDate ; ValueData: {code:GetInstallDate}; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: PatchLevel ; ValueData: {#RubyPatch}; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: BuildPlatform ; ValueData: {#RubyBuildPlatform}; Check: IsAdmin

; RubyInstaller identification for non-admin
Root: HKCU; Subkey: Software\RubyInstaller; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletekey; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallLocation ; ValueData: {app}; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallDate ; ValueData: {code:GetInstallDate}; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: PatchLevel ; ValueData: {#RubyPatch}; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: BuildPlatform ; ValueData: {#RubyBuildPlatform}; Check: IsNotAdmin

[Icons]
Name: {group}\Interactive Ruby; Filename: {app}\bin\irb.bat; IconFilename: {app}\bin\ruby.exe; Flags: createonlyiffileexists
Name: {group}\RubyGems Documentation Server; Filename: {app}\bin\gem.bat; Parameters: server --launch; IconFilename: {app}\bin\ruby.exe; Flags: createonlyiffileexists runminimized
Name: {group}\Start Command Prompt with Ruby; Filename: {sys}\cmd.exe; Parameters: /E:ON /K {app}\bin\setrbvars.bat; WorkingDir: {%HOMEDRIVE}{%HOMEPATH}; IconFilename: {sys}\cmd.exe; Flags: createonlyiffileexists
Name: {group}\{cm:UninstallProgram,{#InstallerName}}; Filename: {uninstallexe}

Name: {group}\Documentation\Ruby {#RubyFullVersion} API Reference; Filename: {app}\doc\ruby{code:GetHelpVersion}.chm; Flags: createonlyiffileexists
Name: {group}\Documentation\The Book of Ruby; Filename: {app}\doc\bookofruby.pdf; Flags: createonlyiffileexists


[Code]
#include "util.iss"
#include "ri_gui.iss"

const
  MB_ERROR = $30;

function MessageBox(hWnd: Integer; lpText, lpCaption: AnsiString; uType: Cardinal): Integer;
external 'MessageBoxA@user32.dll stdcall';

function GetInstallDate(Param: String): String;
begin
  Result := GetDateTimeString('yyyymmdd', #0 , #0);
end;

function GetHelpVersion(Param: String): String;
var
  VersionList: TStringList;
  DocVersion: String;
  I: Integer;
begin
  VersionList := StrToList('{#RubyVersion}', '.');

  for I := 0 to 1 do begin
    DocVersion := DocVersion + VersionList[I];
  end;

  Result := DocVersion;
end;

procedure ModifyHttpProxyServer();
var
  RootKey: Integer;
  SubKey, ValueName: String;
begin
  RootKey := GetUserHive;
  SubKey := GetEnvironmentKey;
  ValueName := 'HTTP_PROXY';

  if not IsUninstaller then
    RegWriteStringValue(RootKey, SubKey, ValueName, ProxyPage.Values[0])
  else
    RegDeleteValue(RootKey, SubKey, ValueName);
end;

function DirNameValidation(): Boolean;
var
  M, N: Integer;
  CheckFlag: Boolean;
  SymbolList: TStringList;
  CheckChar, Drive, FolderName: String;
begin
  CheckFlag := True;
  SymbolList := StrToList('{#AddCannotUseSymbol}', ' ');
  FolderName := ExpandConstant('{app}');
  Drive := ExpandConstant('{drive:{app}}');
  
  StringChange(FolderName, Drive + ExpandConstant('{\}'), '');
  
  for M := 1 to Length(FolderName) do
  begin  
    if CharLength(FolderName, M) = 1 then
    begin
      CheckChar := Copy(FolderName, M, 1);

      for N := 0 to SymbolList.Count - 1 do
      begin
        if CompareText(CheckChar, SymbolList[N]) = 0 then
          CheckFlag := False;
      end;
    end else
      M := M + 1;
  end;

  Result := CheckFlag;
end;

function InitializeSetup(): Boolean;
var
  hWnd: Integer;
begin
  if CheckForMutexes('cfinstaller_{#CFVersion}-r{#RubyVersion}') then
  begin
    MessageBox(hWnd, 'cfinstaller_{#CFVersion}-r{#RubyVersion}.exe is already running.', 'Error', MB_OK or MB_ERROR);
    Result := False;
  end else
  begin
    CreateMutex('cfinstaller_{#CFVersion}-r{#RubyVersion}');
    Result := True;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  CheckFlag: Boolean;
  hWnd: Integer;
begin
  if CurPageID = wpSelectDir then
  begin
    hWnd := StrToInt(ExpandConstant('{wizardhwnd}'));
  
    CheckFlag := DirNameValidation;
    
    if not CheckFlag then
    begin
      MessageBox(hWnd, SetupMessage(msgBadDirName32), 'Error', MB_OK or MB_ERROR);
      Result := False;
    end else
      Result := True;
  end else
    Result := True;
end;

procedure CurStepChanged(const CurStep: TSetupStep);
begin
  // TODO move into ssPostInstall just after install completes?
  if CurStep = ssInstall then
  begin
    if UsingWinNT then
    begin
      Log(Format('Selected Tasks - Path: %d, Associate: %d', [PathChkBox.State, PathExtChkBox.State]));

      if IsModifyPath then
        ModifyPath([ExpandConstant('{app}') + '\bin']);

      if IsAssociated then
        ModifyFileExts(['.rb', '.rbw']);

    end else
      MsgBox('Looks like you''ve got on older, unsupported Windows version.' #13 +
             'Proceeding with a reduced feature set installation.',
             mbInformation, MB_OK);
  end;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
  InstallInfo: String;
begin
  InstallInfo := '';
  InstallInfo := InstallInfo + MemoDirInfo + NewLine;

  InstallInfo := InstallInfo + NewLine;

  InstallInfo := InstallInfo + 'Add CF executables to your PATH:';
  if IsModifyPath then
    InstallInfo := InstallInfo + ' on' + NewLine
  else
    InstallInfo := InstallInfo + ' off' + NewLine;

  InstallInfo := InstallInfo + NewLine;

  InstallInfo := InstallInfo + 'Associate .rb and .rbw files with this CF installation:'
  if IsAssociated then
    InstallInfo := InstallInfo + ' on' + NewLine
  else
    InstallInfo := InstallInfo + ' off' + NewLine;

  InstallInfo := InstallInfo + NewLine;
  
  InstallInfo := InstallInfo + 'Proxy Server Settings:' + NewLine;
  InstallInfo := InstallInfo + Space + ProxyPage.Values[0] + NewLine;

  Result := InstallInfo;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  {* store install choices so we can use during uninstall *}
  if IsModifyPath then
    SetPreviousData(PreviousDataKey, 'PathModified', 'yes');

  if IsAssociated then
    SetPreviousData(PreviousDataKey, 'FilesAssociated', 'yes');

  if (CompareText(ProxyPage.Values[0], '') <> 0) and not (IsHttpProxyEnv and (CompareText(ProxyPage.Values[0], GetHttpProxyEnv) = 0)) then
  begin
    ModifyHttpProxyServer;
    SetPreviousData(PreviousDataKey, 'ProxyModified', 'yes');
    SetPreviousData(PreviousDataKey, 'ProxyServerName', ProxyPage.Values[0]);
  end;
    
  SetPreviousData(PreviousDataKey, 'RubyInstallerId', ExpandConstant('{#RubyInstallerBaseId}\{#RubyVersion}'));
end;

procedure CurUninstallStepChanged(const CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    if UsingWinNT then
    begin
      if GetPreviousData('PathModified', 'no') = 'yes' then
        ModifyPath([ExpandConstant('{app}') + '\bin']);

      if GetPreviousData('FilesAssociated', 'no') = 'yes' then
        ModifyFileExts(['.rb', '.rbw']);

      if (GetPreviousData('ProxyModified', 'no') = 'yes') and (CompareText(GetPreviousData('ProxyServerName', ''), GetHttpProxyEnv) = 0) then
        ModifyHttpProxyServer;

    end;
  end;
end;
