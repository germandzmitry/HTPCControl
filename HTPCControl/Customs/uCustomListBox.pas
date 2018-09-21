unit uCustomListBox;

interface

uses
  Winapi.Windows, Winapi.Messages, Vcl.StdCtrls, Vcl.Controls, Vcl.Graphics, Vcl.Themes,
  Vcl.Dialogs, Vcl.GraphUtil, System.Classes, System.SysUtils, uExecuteCommand,
  System.UITypes;

type
  TCustomListBox = class(TListBox)
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure Resize(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{ TCustomListBox }

constructor TCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Style := lbOwnerDrawVariable;
  OnMeasureItem := MeasureItem;
  OnResize := Resize;
end;

destructor TCustomListBox.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  DrawRect: TRect;
  LDetails: TThemedElementDetails;
  ObjRCommand: TObjectRemoteCommand;
begin

  ObjRCommand := (Self.Items.Objects[Index] as TObjectRemoteCommand);

  if ObjRCommand = nil then
    exit;

  // зебра
  if (Index mod 2) = 0 then
    Self.Canvas.Brush.Color := clWhite
  else
    Self.Canvas.Brush.Color := clBtnFace;

  if odSelected in State then
    Self.Canvas.Brush.Color := GetShadowColor(clHighlight, 115);

  if ObjRCommand.State = ecBegin then
    if odSelected in State then
      Self.Canvas.Brush.Color := $E6CBD5
    else
      Self.Canvas.Brush.Color := GetShadowColor(clRed, 80);

  Self.Canvas.FillRect(Rect);
  Self.Canvas.Font.Color := clBlack;

  // Команда
  DrawRect := Rect;
  inc(DrawRect.Left, 4);
  inc(DrawRect.Top, 4);
  DrawRect.Right := DrawRect.Left + 90;
  Dec(DrawRect.Bottom, 4);

  Self.Canvas.Font.Style := Self.Canvas.Font.Style + [fsBold];
  DrawText(Self.Canvas.Handle, PChar(ObjRCommand.Command), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_RIGHT);
  Self.Canvas.Font.Style := Self.Canvas.Font.Style - [fsBold];

  // Иконка
  Self.Canvas.Draw(Rect.Left + 5, Rect.Top + round(Rect.Height / 2) -
    round(ObjRCommand.FIcon.Height / 2), ObjRCommand.FIcon);

  // Разделитель
  DrawRect := Rect;
  inc(DrawRect.Left, 98);
  inc(DrawRect.Top, 2);
  DrawRect.Right := DrawRect.Left + 2;
  Dec(DrawRect.Bottom, 2);
  LDetails := StyleServices.GetElementDetails(ttbSeparatorDisabled);
  StyleServices.DrawElement(Self.Canvas.Handle, LDetails, DrawRect);

  // Текст операции
  DrawRect := Rect;
  inc(DrawRect.Left, 105);
  inc(DrawRect.Top, 4);
  Dec(DrawRect.Right, 4);
  Dec(DrawRect.Bottom, 4);

  DrawText(Self.Canvas.Handle, PChar(Self.Items[Index]), -1, DrawRect,
    DT_WORDBREAK or DT_EDITCONTROL);

  // Порядковый номер
  { DrawRect := Rect;
    inc(DrawRect.Left, 4);
    inc(DrawRect.Top, 4);
    Dec(DrawRect.Right, 94);
    Dec(DrawRect.Bottom, 4);

    DrawText(Self.Canvas.Handle, PChar(IntToStr(ObjRCommand.EIndex)), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_LEFT); }

  // Рамка
  { if odSelected in State then
    begin
    DrawRect := Rect;
    inc(DrawRect.Left, 1);
    Dec(DrawRect.Right, 1);
    inc(DrawRect.Bottom, 1);
    LDetails := StyleServices.GetElementDetails(ttbButtonPressed);
    StyleServices.DrawElement(Self.Canvas.Handle, LDetails, DrawRect);
    end; }

  if odFocused in State then
    Self.Canvas.DrawFocusRect(Rect);
end;

procedure TCustomListBox.MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
var
  Rect: TRect;
  s: string;
begin
  Rect.Left := 105;
  Rect.Top := 0;
  Rect.Right := TCustomListBox(Control).ClientWidth - 4;
  Rect.Bottom := TCustomListBox(Control).ItemHeight;
  s := TCustomListBox(Control).Items[Index];

  Height := DrawText(TCustomListBox(Control).Canvas.Handle, PChar(s), Length(s), Rect,
    DT_WORDBREAK or DT_EDITCONTROL or DT_CALCRECT) + 8;
end;

procedure TCustomListBox.Resize(Sender: TObject);
var
  i, h: Integer;
  MeasureItemEvent: TMeasureItemEvent;
begin
  if Assigned(Sender) and TCustomListBox(Sender).HandleAllocated then
    with TCustomListBox(Sender) do
    begin
      MeasureItemEvent := OnMeasureItem;
      if Assigned(MeasureItemEvent) then
        for i := 0 to Items.Count - 1 do
        begin
          MeasureItemEvent(TCustomListBox(Sender), i, h);
          SendMessage(Handle, LB_SETITEMHEIGHT, i, h);
        end;
    end;

  TCustomListBox(Sender).Repaint;
end;

end.
