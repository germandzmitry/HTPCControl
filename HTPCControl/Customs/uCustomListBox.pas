unit uCustomListBox;

interface

uses
  Winapi.Windows, Winapi.Messages, Vcl.StdCtrls, Vcl.Controls, Vcl.Graphics,
  Vcl.Themes, Vcl.Dialogs, Vcl.GraphUtil, Vcl.ExtCtrls, System.Classes,
  System.SysUtils, uExecuteCommand, System.UITypes;

const
  NumberWidth = 30;

type
  TCustomListBox = class(TListBox)
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  protected
    procedure Resize(Sender: TObject);
  private
    FTitle: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Title: string read FTitle write FTitle;
  end;

type
  TCustomListBoxRC = class(TCustomListBox)
  protected
    procedure MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TCustomListBox }

constructor TCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  OnResize := Resize;
end;

destructor TCustomListBox.Destroy;
begin
  inherited;
end;

procedure TCustomListBox.Resize(Sender: TObject);
var
  i, h: Integer;
  MeasureItemEvent: TMeasureItemEvent;
begin
  if Assigned(Sender) and TCustomListBox(Sender).HandleAllocated and
    (TCustomListBox(Sender).Style = lbOwnerDrawVariable) then
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

procedure TCustomListBox.WMPaint(var Message: TWMPaint);
var
  DrawRect, R: TRect;
  y, i, h: Integer;
begin
  inherited;

  DrawRect := Rect(0, 0, NumberWidth, Self.ClientHeight);

  if Items.Count = 0 then
  begin
    GradientFillCanvas(Self.Canvas, clBtnFace, clWhite, DrawRect, gdHorizontal);
    // Self.Canvas.MoveTo(NumberWidth, 0);
    // Self.Canvas.LineTo(NumberWidth, Self.ClientHeight);

    Self.Canvas.Font.Size := 10;

    R := Rect(0, 0, Self.ClientWidth, Self.ClientHeight);
    R.Inflate(-4, -4);
    h := (R.Bottom - R.Top) div 2 + DrawText(Self.Canvas.Handle, PChar(FTitle), -1, R,
      DT_WORDBREAK or DT_CALCRECT) div 2;

    R := Rect(0, 0, Self.ClientWidth, Self.ClientHeight);
    R.Inflate(-4, -4);
    R.Top := (R.Bottom - R.Top) div 2 - h div 2;

    Self.Canvas.Brush.Color := Self.Color;
    DrawText(Self.Canvas.Handle, PChar(FTitle), -1, R, DT_CENTER or DT_WORDBREAK);
    Self.Canvas.Font.Size := 8;

    exit;
  end;

  y := 0;
  i := TopIndex;
  h := Height;
  while y < h do
  begin
    inc(y, Self.ItemRect(i).Height);
    inc(i);

    if i >= Items.Count then
      Break;
  end;

  if y < h then
  begin
    DrawRect.Top := y;
    GradientFillCanvas(Self.Canvas, clBtnFace, clWhite, DrawRect, gdHorizontal);
    // Self.Canvas.MoveTo(NumberWidth, y);
    // Self.Canvas.LineTo(NumberWidth, Self.ClientHeight);
  end;

end;

{ TCustomListBoxRC }

constructor TCustomListBoxRC.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Style := lbOwnerDrawVariable;
  OnMeasureItem := MeasureItem;
end;

procedure TCustomListBoxRC.MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
var
  Rect: TRect;
  S: string;
begin
  Rect.left := 135;
  Rect.Top := 0;
  Rect.Right := TCustomListBoxRC(Control).ClientWidth - 4;
  Rect.Bottom := TCustomListBoxRC(Control).ItemHeight;
  S := TCustomListBoxRC(Control).Items[Index];

  Height := DrawText(TCustomListBox(Control).Canvas.Handle, PChar(S), Length(S), Rect,
    DT_WORDBREAK or DT_EDITCONTROL or DT_CALCRECT) + 8;
end;

procedure TCustomListBoxRC.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  DrawRect: TRect;
  LDetails: TThemedElementDetails;
  ObjRCommand: TObjectRemoteCommand;
  LRight: Integer;
  LColorZebra: TColor;
  ColorGradientTo: TColor;
begin
  ObjRCommand := (Self.Items.Objects[Index] as TObjectRemoteCommand);

  if ObjRCommand = nil then
    exit;

  Self.Canvas.Font.Color := clBlack;
  ColorGradientTo := clWhite;

  // зебра
  if (ObjRCommand.EIndex mod 2) <> 0 then
    Self.Canvas.Brush.Color := clWhite
  else
    Self.Canvas.Brush.Color := clBtnFace;
  LColorZebra := Self.Canvas.Brush.Color;

  if odSelected in State then
  begin
    Self.Canvas.Brush.Color := GetShadowColor(clHighlight, 115);
    ColorGradientTo := Self.Canvas.Brush.Color;
  end;

  Rect.left := NumberWidth;

  case ObjRCommand.State of
    ecBegin:
      begin
        Self.Canvas.Brush.Color := GetShadowColor(clYellow, 80);
        Self.Canvas.FillRect(Rect);

        ColorGradientTo := Self.Canvas.Brush.Color;
      end;
    ecExecuting:
      begin
        LRight := 0;
        if ObjRCommand.All > 0 then
          LRight := round((Rect.Right - Rect.left) / ObjRCommand.All * ObjRCommand.Current);

        DrawRect := Rect;
        DrawRect.left := DrawRect.left + LRight + 10;
        Self.Canvas.FillRect(DrawRect);

        DrawRect := Rect;
        DrawRect.Right := DrawRect.left + LRight + 10;
        DrawRect.left := DrawRect.Right - 20;
        GradientFillCanvas(Self.Canvas, GetShadowColor(clLime, 80), Self.Canvas.Brush.Color,
          DrawRect, gdHorizontal);

        DrawRect := Rect;
        DrawRect.Right := DrawRect.left + LRight - 10;
        Self.Canvas.Brush.Color := GetShadowColor(clLime, 80);
        Self.Canvas.FillRect(DrawRect);

        ColorGradientTo := Self.Canvas.Brush.Color;
      end;
    ecEnd:
      begin
        if odSelected in State then
          Self.Canvas.FillRect(Rect)
        else
        begin
          DrawRect := Rect;
          DrawRect.Right := DrawRect.left + 98;
          GradientFillCanvas(Self.Canvas, clWhite, LColorZebra, DrawRect, gdHorizontal);
          DrawRect := Rect;
          DrawRect.left := DrawRect.left + 98;
          GradientFillCanvas(Self.Canvas, LColorZebra, LColorZebra, DrawRect, gdHorizontal);
        end;
      end;
  end;

  // Градиент порядкового номера
  DrawRect := Rect;
  DrawRect.left := 0;
  DrawRect.Right := NumberWidth;
  GradientFillCanvas(Self.Canvas, clBtnFace, ColorGradientTo, DrawRect, gdHorizontal);
  // Self.Canvas.MoveTo(NumberWidth, DrawRect.Top);
  // Self.Canvas.LineTo(NumberWidth, DrawRect.Bottom);

  // Номер команды
  DrawRect := Rect;
  DrawRect.left := 4;
  inc(DrawRect.Top, 4);
  DrawRect.Right := NumberWidth - 4;
  dec(DrawRect.Bottom, 4);
  Self.Canvas.Font.Size := 6;
  SetBkMode(Self.Canvas.Handle, TRANSPARENT);
  DrawText(Self.Canvas.Handle, PChar(inttostr(ObjRCommand.EIndex)), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_CENTER);
  SetBkMode(Self.Canvas.Handle, OPAQUE);
  Self.Canvas.Font.Size := 8;

  // Команда
  DrawRect := Rect;
  inc(DrawRect.left, 4);
  inc(DrawRect.Top, 4);
  DrawRect.Right := DrawRect.left + 90;
  dec(DrawRect.Bottom, 4);

  SetBkMode(Self.Canvas.Handle, TRANSPARENT);
  Self.Canvas.Font.Style := Self.Canvas.Font.Style + [fsBold];
  DrawText(Self.Canvas.Handle, PChar(ObjRCommand.Command), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_RIGHT);
  Self.Canvas.Font.Style := Self.Canvas.Font.Style - [fsBold];
  SetBkMode(Self.Canvas.Handle, OPAQUE);

  // Иконка
  Self.Canvas.Draw(Rect.left + 5, Rect.Top + round(Rect.Height / 2) -
    round(ObjRCommand.FIcon.Height / 2), ObjRCommand.FIcon);

  // Разделитель
  DrawRect := Rect;
  inc(DrawRect.left, 98);
  inc(DrawRect.Top, 2);
  DrawRect.Right := DrawRect.left + 2;
  dec(DrawRect.Bottom, 2);
  LDetails := StyleServices.GetElementDetails(ttbSeparatorDisabled);
  StyleServices.DrawElement(Self.Canvas.Handle, LDetails, DrawRect);

  // Текст операции
  DrawRect := Rect;
  inc(DrawRect.left, 105);
  inc(DrawRect.Top, 4);
  dec(DrawRect.Right, 4);
  dec(DrawRect.Bottom, 4);

  SetBkMode(Self.Canvas.Handle, TRANSPARENT);
  DrawText(Self.Canvas.Handle, PChar(Self.Items[Index]), -1, DrawRect,
    DT_WORDBREAK or DT_EDITCONTROL);
  SetBkMode(Self.Canvas.Handle, OPAQUE);

  // Рамка
  { if odSelected in State then
    begin
    DrawRect := Rect;
    DrawRect.Left:= 1;
    dec(DrawRect.Right, 1);
    inc(DrawRect.Bottom, 1);
    LDetails := StyleServices.GetElementDetails(ttbButtonPressed);
    StyleServices.DrawElement(Self.Canvas.Handle, LDetails, DrawRect);
    end; }

  Rect.left := 0;
  if odFocused in State then
    Self.Canvas.DrawFocusRect(Rect);
end;

end.
