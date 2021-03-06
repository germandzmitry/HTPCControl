﻿unit uLanguage;

interface

uses
  System.SysUtils, Vcl.Forms, Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Tabs, Vcl.DockTabSet, IniFiles, System.Classes;

const
  lngRus: string = 'Russian';

function GetLanguageMsg(AMsg: string; ASelectedLanguage: string): string;
function GetLanguageText(ASection, AMsg: string; ASelectedLanguage: string): string;
procedure UpdateLanguage(AForm: TForm; ASelectedLanguage: string = ''); overload;

implementation

function GetLanguageMsg(AMsg: string; ASelectedLanguage: string): string;
begin
  result := GetLanguageText('MSG', AMsg, ASelectedLanguage);
end;

function GetLanguageText(ASection, AMsg: string; ASelectedLanguage: string): string;
var
  lng: TIniFile;
  LLanguagePath: string;
begin
  if ASelectedLanguage = '' then
    Exit;

  LLanguagePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Languages');

  if not DirectoryExists(LLanguagePath) then
    Exit;

  lng := TIniFile.Create(LLanguagePath + ASelectedLanguage + '.lng');
  try
    result := lng.ReadString(ASection, AMsg, 'Text not found');
  finally
    lng.Free;
  end;
end;

procedure UpdateLanguage(AForm: TForm; ASelectedLanguage: string = '');
var
  s: string;
  i, j: integer;
  lng: TIniFile;
  LLanguagePath: string;
begin
  if ASelectedLanguage = '' then
    Exit;

  LLanguagePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Languages');

  if not DirectoryExists(LLanguagePath) then
    Exit;

  lng := TIniFile.Create(LLanguagePath + ASelectedLanguage + '.lng');
  try
    s := lng.ReadString(AForm.Name, 'Caption', '');
    if s <> '' then
      AForm.Caption := s;

    for i := 0 to AForm.ComponentCount - 1 do
    begin
      if length(AForm.Components[i].Name) = 0 then
        Continue;

      { Button }
      if AForm.Components[i] is TButton then
      begin
        s := lng.ReadString(AForm.Name, TButton(AForm.Components[i]).Name, '');
        if s <> '' then
          TButton(AForm.Components[i]).Caption := s;
        s := lng.ReadString(AForm.Name, TButton(AForm.Components[i]).Name + ':h', '');
        if s <> '' then
          TButton(AForm.Components[i]).Hint := s;
      end
      { SpeedButton }
      else if AForm.Components[i] is TSpeedButton then
      begin
        s := lng.ReadString(AForm.Name, TSpeedButton(AForm.Components[i]).Name, '');
        if s <> '' then
          TSpeedButton(AForm.Components[i]).Caption := ' ' + s;
        s := lng.ReadString(AForm.Name, TSpeedButton(AForm.Components[i]).Name + ':h', '');
        if s <> '' then
          TSpeedButton(AForm.Components[i]).Hint := s;
      end
      { RadioButton }
      else if AForm.Components[i] is TRadioButton then
      begin
        s := lng.ReadString(AForm.Name, TRadioButton(AForm.Components[i]).Name, '');
        if s <> '' then
          TRadioButton(AForm.Components[i]).Caption := ' ' + s;
      end
      { CheckBox }
      else if AForm.Components[i] is TCheckBox then
      begin
        s := lng.ReadString(AForm.Name, TCheckBox(AForm.Components[i]).Name, '');
        if s <> '' then
          (AForm.Components[i] as TCheckBox).Caption := ' ' + s;
      end
      { Label }
      else if AForm.Components[i] is TLabel then
      begin
        s := lng.ReadString(AForm.Name, TLabel(AForm.Components[i]).Name, '');
        if s <> '' then
          TLabel(AForm.Components[i]).Caption := s
      end
      { LinkLabel }
      else if AForm.Components[i] is TLinkLabel then
      begin
        s := lng.ReadString(AForm.Name, TLinkLabel(AForm.Components[i]).Name, '');
        if s <> '' then
          TLinkLabel(AForm.Components[i]).Caption := s;
        s := lng.ReadString(AForm.Name, TLinkLabel(AForm.Components[i]).Name + ':h', '');
        if s <> '' then
          TLinkLabel(AForm.Components[i]).Hint := s;
      end
      { Memo }
      else if AForm.Components[i] is TMemo then
      begin
        s := lng.ReadString(AForm.Name, TMemo(AForm.Components[i]).Name, '');
        if s <> '' then
          TMemo(AForm.Components[i]).lines.Text := s
      end
      { Panel }
      else if AForm.Components[i] is TPanel then
      begin
        s := lng.ReadString(AForm.Name, AForm.Components[i].Name, '');
        if s <> '' then
          (AForm.Components[i] as TPanel).Caption := s
      end
      { CategoryPanel }
      else if AForm.Components[i] is TCategoryPanel then
      begin
        s := lng.ReadString(AForm.Name, AForm.Components[i].Name, '');
        if s <> '' then
          (AForm.Components[i] as TCategoryPanel).Caption := s
      end
      { GroupBox }
      else if AForm.Components[i] is TGroupBox then
      begin
        s := lng.ReadString(AForm.Name, AForm.Components[i].Name, '');
        if s <> '' then
          (AForm.Components[i] as TGroupBox).Caption := s
      end
      { RadioGroup }
      else if AForm.Components[i] is TRadioGroup then
      begin
        s := lng.ReadString(AForm.Name, AForm.Components[i].Name, '');
        if s <> '' then
          (AForm.Components[i] as TRadioGroup).Caption := s;

        for j := 0 to TRadioGroup(AForm.Components[i]).Items.Count - 1 do
        begin
          s := lng.ReadString(AForm.Name,
            Format('%s:%d', [TRadioGroup(AForm.Components[i]).Name, j]), '');
          if s <> '' then
            TRadioGroup(AForm.Components[i]).Items[j] := s;
        end;
      end
      { TTabSheet }
      else if AForm.Components[i] is TTabSheet then
      begin
        s := lng.ReadString(AForm.Name, TTabSheet(AForm.Components[i]).Name, '');
        if s <> '' then
          TTabSheet(AForm.Components[i]).Caption := s
      end
      { TreeView }
      else if AForm.Components[i] is TTreeView then
      begin

      end
      { ListView }
      else if AForm.Components[i] is TListView then
      begin
        for j := 0 to TListView(AForm.Components[i]).Columns.Count - 1 do
        begin
          s := lng.ReadString(AForm.Name,
            Format('%s:%d', [TListView(AForm.Components[i]).Name, j]), '');
          if s <> '' then
            TListView(AForm.Components[i]).Columns[j].Caption := s;
        end;
      end
      { TabSet }
      else if AForm.Components[i] is TTabSet then
      begin
        for j := 0 to TTabSet(AForm.Components[i]).Tabs.Count - 1 do
        begin
          s := lng.ReadString(AForm.Name,
            Format('%s:%d', [TTabSet(AForm.Components[i]).Name, j]), '');
          if s <> '' then
            TTabSet(AForm.Components[i]).Tabs[j] := s;
        end;
      end
      { DockTabSet }
      else if AForm.Components[i] is TDockTabSet then
      begin
        for j := 0 to TDockTabSet(AForm.Components[i]).Tabs.Count - 1 do
        begin
          s := lng.ReadString(AForm.Name,
            Format('%s:%d', [TDockTabSet(AForm.Components[i]).Name, j]), '');
          if s <> '' then
            TDockTabSet(AForm.Components[i]).Tabs[j] := s;
        end;
      end
      { Action }
      else if AForm.Components[i] is TAction then
      begin
        s := lng.ReadString(AForm.Name, TAction(AForm.Components[i]).Name, '');
        if (TAction(AForm.Components[i]).Caption <> '') and (s <> '') then
          TAction(AForm.Components[i]).Caption := s;
        s := lng.ReadString(AForm.Name, TAction(AForm.Components[i]).Name + ':h', '');
        if s <> '' then
          TAction(AForm.Components[i]).Hint := s;
      end;
    end;
  finally
    lng.Free;
  end;

end;

end.
