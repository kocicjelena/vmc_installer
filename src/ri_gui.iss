// CFInstaller Inno Setup GUI Customizations

const
  ChkBoxBaseY = 95;
  ChkBoxBaseHeight = 17;
  ChkBoxBaseLeft = 18;

var
  PathChkBox, PathExtChkBox: TCheckBox;
  Page: TWizardPage;
  ProxyPage: TInputQueryWizardPage;

function IsAssociated(): Boolean;
begin
  Result := PathExtChkBox.Checked;
end;

function IsModifyPath(): Boolean;
begin
  Result := PathChkBox.Checked;
end;

procedure ParseSilentTasks();
var
  I, N: Integer;
  Param: String;
  Tasks: TStringList;
begin
  {* parse command line args for silent install tasks *}
  for I := 0 to ParamCount do
  begin
    Param := AnsiUppercase(ParamStr(I));
    if Pos('/TASKS', Param) <> 0 then
    begin
      Param := Trim(Copy(Param, Pos('=', Param) + 1, Length(Param)));
      try
        // TODO check for too many tasks to prevent overflow??
        Tasks := StrToList(Param, ',');
        for N := 0 to Tasks.Count - 1 do
          case Trim(Tasks.Strings[N]) of
            'MODPATH': PathChkBox.State := cbChecked;
            'ASSOCFILES': PathExtChkBox.State := cbChecked;
          end;
      finally
        Tasks.Free;
      end;
    end;
  end;
end;

procedure URLText_OnClick(Sender: TObject);
var
  ErrorCode: Integer;
begin
  if Sender is TNewStaticText then
    ShellExec('open', TNewStaticText(Sender).Caption, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure InitializeWizard;
var
  ChkBoxCurrentY: Integer;
  TmpLabel: TNewStaticText;
begin
  {* Path, file association task check boxes *}

  Page := PageFromID(wpSelectDir);
  ChkBoxCurrentY := ChkBoxBaseY;

  PathChkBox := TCheckBox.Create(Page);
  PathChkBox.Parent := Page.Surface;
  PathChkBox.State := cbchecked;
  PathChkBox.Caption := 'Add CF executables to your PATH';
  PathChkBox.Hint := 'Select to make this CF installation available from everywhere.' #13 +
                     'This may affect existing Ruby or CF installations.';
  PathChkBox.ShowHint := True;
  PathChkBox.Alignment := taRightJustify;
  PathChkBox.Top := ScaleY(ChkBoxCurrentY);
  PathChkBox.Left := ScaleX(ChkBoxBaseLeft);
  PathChkBox.Width := Page.SurfaceWidth;
  PathChkBox.Height := ScaleY(ChkBoxBaseHeight);
  ChkBoxCurrentY := ChkBoxCurrentY + ChkBoxBaseHeight;

  PathExtChkBox := TCheckBox.Create(Page);
  PathExtChkBox.Parent := Page.Surface;
  PathExtChkBox.State := cbchecked;
  PathExtChkBox.Caption := 'Associate .rb and .rbw files with this CF installation';
  PathExtChkBox.Hint := 'Select to enable running your Ruby scripts by double clicking' #13 +
                        'or simply typing the script name at your shell prompt. This may' #13 +
                        'affect existing Ruby or CF installations.';
  PathExtChkBox.ShowHint := True;
  PathExtChkBox.Alignment := taRightJustify;
  PathExtChkBox.Top := ScaleY(ChkBoxCurrentY);
  PathExtChkBox.Left := ScaleX(ChkBoxBaseLeft);
  PathExtChkBox.Width := Page.SurfaceWidth;
  PathExtChkBox.Height := ScaleY(ChkBoxBaseHeight);
  ChkBoxCurrentY := ChkBoxCurrentY + ChkBoxBaseHeight;

  {* Single Ruby installation tip message *}

  TmpLabel := TNewStaticText.Create(Page);
  TmpLabel.Parent := Page.Surface;
  TmpLabel.Top := ScaleY(ChkBoxCurrentY + 30);
  TmpLabel.Left := ScaleX(6);
  TmpLabel.Width := Page.SurfaceWidth;
  TmpLabel.WordWrap := True;
  TmpLabel.Caption := 'TIP: Mouse over the above options for more detailed information.';

  ParseSilentTasks;

  {* Proxy Server Setting pages *}

  ProxyPage := CreateInputQueryPage(wpSelectDir,
    'Proxy Server Settings', '',
    'Please enter your proxy server information.' #13 +
    'The information wil be set and overwrite "HTTP_PROXY" environment variable. ' #13#13 +
    'Format:' #13 +
    '    "http://(UserName:Password@)ProxyServerName:Port"' #13#13 +
    '  * If authentication is required, please insert "UserName:Password@".' #13#13 +
    '  Example) http://proxy.example.com:8080' #13 +
    '                  http://username:password@proxy.example.com:8080' #13#13 +
    'When you connect the Internet directly, leave it blank.');
  ProxyPage.Add('Proxy Server :', False);
  
  if IsHttpProxyEnv then
    ProxyPage.Values[0] := GetHttpProxyEnv
  else
  begin
    if IsProxyServer then
      ProxyPage.Values[0] := GetProxyServer;
  end;
end;
