unit uCustomListBox;

interface

uses
  Winapi.Windows, Winapi.Messages, Vcl.StdCtrls, Vcl.Controls, Vcl.Graphics,
  Vcl.Themes, Vcl.Dialogs, Vcl.GraphUtil, Vcl.ExtCtrls, System.Classes,
  System.SysUtils, uExecuteCommand, System.UITypes, uTypes;

const
  NumberWidth = 30;
  CommandWidth = 90;

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
  private

    FUserInterface: TuiType;
    FIconWaiting, FIconExecuting: TIcon;

    procedure DrawItemAnimation(ObjRCommand: TObjectRemoteCommand; Rect: TRect);
    procedure DrawItemIcon(ObjRCommand: TObjectRemoteCommand; Rect: TRect);
    procedure DrawItemNone(ObjRCommand: TObjectRemoteCommand; Rect: TRect);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property UserInterface: TuiType read FUserInterface write FUserInterface;
    property IconWaiting: TIcon read FIconWaiting write FIconWaiting;
    property IconExecuting: TIcon read FIconExecuting write FIconExecuting;
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
    // GradientFillCanvas(Self.Canvas, clBtnFace, clWhite, DrawRect, gdHorizontal);

    // Self.Canvas.Brush.Color := GetShadowColor(clSilver, 55);
    // GetShadowColor(rgb(217, 217, 220), 30); // clBtnFace;

    // Self.Canvas.FillRect(DrawRect);
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
    // DrawRect.Top := y;
    // GradientFillCanvas(Self.Canvas, clBtnFace, clWhite, DrawRect, gdHorizontal);
    Self.Canvas.Pen.Color := clSilver;
    Self.Canvas.MoveTo(NumberWidth, y);
    Self.Canvas.LineTo(NumberWidth, Self.ClientHeight);
    Self.Canvas.Pen.Color := clBlack;
  end;

end;

{ TCustomListBoxRC }

constructor TCustomListBoxRC.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Style := lbOwnerDrawVariable;
  OnMeasureItem := MeasureItem;
  UserInterface := TuiType(0);

  FIconWaiting := TIcon.Create;
  FIconExecuting := TIcon.Create;
end;

destructor TCustomListBoxRC.Destroy;
begin
  FIconWaiting.Destroy;
  FIconExecuting.Destroy;
  inherited;
end;

procedure TCustomListBoxRC.MeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
var
  Rect: TRect;
  S: string;
begin
  Rect.left := NumberWidth + CommandWidth + 2 + 4;
  Rect.Top := 0;
  Rect.Right := TCustomListBoxRC(Control).ClientWidth - 4;
  Rect.Bottom := TCustomListBoxRC(Control).ItemHeight;
  S := TCustomListBoxRC(Control).Items[Index];

  Height := DrawText(TCustomListBox(Control).Canvas.Handle, PChar(S), Length(S), Rect,
    DT_WORDBREAK or DT_EDITCONTROL or DT_CALCRECT) + 8;
end;

procedure TCustomListBoxRC.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ObjRCommand: TObjectRemoteCommand;
  DrawRect: TRect;
  LDetails: TThemedElementDetails;
begin
  ObjRCommand := (Self.Items.Objects[Index] as TObjectRemoteCommand);

  if ObjRCommand = nil then
    exit;

  Self.Canvas.Font.Color := clBlack;

  // зебра
  if (ObjRCommand.EIndex mod 2) = 1 then
    Self.Canvas.Brush.Color := clWhite
  else
    Self.Canvas.Brush.Color := clBtnFace;

  // выделенная строка
  if odSelected in State then
    Self.Canvas.Brush.Color := GetShadowColor(clHighlight, 115);

  case FUserInterface of
    uiAnimation:
      DrawItemAnimation(ObjRCommand, Rect);
    uiIcon:
      DrawItemIcon(ObjRCommand, Rect);
    uiNone:
      DrawItemNone(ObjRCommand, Rect);
  end;

  // Рамка выделенной строки
  if odSelected in State then
  begin
    DrawRect := Rect;
    DrawRect.Right := NumberWidth;
    Self.Canvas.Pen.Color := clHighlight;
    Self.Canvas.Brush.Color := clHighlight;
    Self.Canvas.Rectangle(DrawRect);

    DrawRect := Rect;
    dec(DrawRect.Right);
    dec(DrawRect.Bottom);
    Self.Canvas.MoveTo(DrawRect.left, DrawRect.Top);
    Self.Canvas.LineTo(DrawRect.left, DrawRect.Bottom);
    Self.Canvas.LineTo(DrawRect.Right, DrawRect.Bottom);
    Self.Canvas.LineTo(DrawRect.Right, DrawRect.Top);
    Self.Canvas.LineTo(DrawRect.left, DrawRect.Top);
    Self.Canvas.Pen.Color := clBlack;

    Self.Canvas.Font.Color := clWhite;
  end;

  // прозрачный фон текста
  SetBkMode(Self.Canvas.Handle, TRANSPARENT);

  // Порядковый номер
  DrawRect := Rect;
  DrawRect.Right := NumberWidth;
  DrawRect.Inflate(-4, -4);
  Self.Canvas.Font.Size := 6;
  DrawText(Self.Canvas.Handle, PChar(inttostr(ObjRCommand.EIndex)), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_CENTER);
  Self.Canvas.Font.Size := 8;
  Self.Canvas.Font.Color := clBlack;

  // Веритакальная лини после порядкового номера
  DrawRect := Rect;
  if odSelected in State then
    DrawRect.Inflate(0, -1, 0, -1);
  Self.Canvas.Pen.Color := clSilver;
  Self.Canvas.MoveTo(NumberWidth, DrawRect.Top);
  Self.Canvas.LineTo(NumberWidth, DrawRect.Bottom);
  Self.Canvas.Pen.Color := clBlack;

  // Команда
  DrawRect := Rect;
  DrawRect.Right := NumberWidth + CommandWidth;
  DrawRect.Inflate(-4, -4);
  Self.Canvas.Font.Style := Self.Canvas.Font.Style + [fsBold];
  DrawText(Self.Canvas.Handle, PChar(ObjRCommand.Command), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_RIGHT);
  Self.Canvas.Font.Style := Self.Canvas.Font.Style - [fsBold];

  // Иконка повтора предыдущем команды
  // Self.Canvas.Draw(Rect.left + NumberWidth + 5, Rect.Top + round(Rect.Height / 2) -
  // round(ObjRCommand.FIcon.Height / 2), ObjRCommand.FIcon);
  Self.Canvas.Draw(Rect.Right - ObjRCommand.FIcon.Width - 4, Rect.Top + round(Rect.Height / 2) -
    round(ObjRCommand.FIcon.Height / 2), ObjRCommand.FIcon);

  // Разделитель
  DrawRect := Rect;
  DrawRect.left := NumberWidth + CommandWidth;
  DrawRect.Right := DrawRect.left + 2;
  DrawRect.Inflate(0, -2, 0, -2);
  LDetails := StyleServices.GetElementDetails(ttbSeparatorDisabled);
  StyleServices.DrawElement(Self.Canvas.Handle, LDetails, DrawRect);

  // Текст операции
  DrawRect := Rect;
  DrawRect.left := NumberWidth + CommandWidth + 2;
  DrawRect.Inflate(-4, -4);
  DrawText(Self.Canvas.Handle, PChar(ObjRCommand.Operations), -1, DrawRect,
    DT_WORDBREAK or DT_EDITCONTROL);

  SetBkMode(Self.Canvas.Handle, OPAQUE);

  if odFocused in State then
    Self.Canvas.DrawFocusRect(Rect);
end;

procedure TCustomListBoxRC.DrawItemNone(ObjRCommand: TObjectRemoteCommand; Rect: TRect);
begin
  Self.Canvas.FillRect(Rect);
end;

procedure TCustomListBoxRC.DrawItemIcon(ObjRCommand: TObjectRemoteCommand; Rect: TRect);
begin
  Self.Canvas.FillRect(Rect);
  case ObjRCommand.State of
    ecCreating:
      ;
    ecWaiting:
      Self.Canvas.Draw(Rect.left + NumberWidth + 2, Rect.Top + 2, IconWaiting);
    ecExecuting:
      Self.Canvas.Draw(Rect.left + NumberWidth + 2, Rect.Top + 2, IconExecuting);
    ecEnd:
      ;
  end;
end;

procedure TCustomListBoxRC.DrawItemAnimation(ObjRCommand: TObjectRemoteCommand; Rect: TRect);
var
  DrawRect: TRect;
  LRight: Integer;
  bColor: TColor;
begin

  case ObjRCommand.State of
    ecCreating:
      begin
        Self.Canvas.FillRect(Rect);
      end;
    ecWaiting:
      begin
        bColor := Self.Canvas.Brush.Color;
        Self.Canvas.Brush.Color := GetShadowColor(clYellow, 80);
        Self.Canvas.FillRect(Rect);
        Self.Canvas.Brush.Color := bColor;
      end;
    ecExecuting:
      begin
        LRight := 0;
        if ObjRCommand.All > 0 then
          LRight := round((Rect.Right - NumberWidth - CommandWidth) / ObjRCommand.All *
            ObjRCommand.Current);

        DrawRect := Rect;
        DrawRect.Right := NumberWidth + CommandWidth + 1;
        Self.Canvas.FillRect(DrawRect);

        bColor := Self.Canvas.Brush.Color;
        Self.Canvas.Brush.Color := GetShadowColor(clLime, 80);

        { DrawRect := Rect;
          DrawRect.left := NumberWidth + CommandWidth + 1;
          Self.Canvas.Pen.Color := Self.Canvas.Brush.Color;
          Self.Canvas.Pen.Width := 2;
          Self.Canvas.MoveTo(DrawRect.left + 1, DrawRect.Top + 1);
          Self.Canvas.LineTo(DrawRect.left + 1, DrawRect.Bottom - 1);
          Self.Canvas.LineTo(DrawRect.Right - 1, DrawRect.Bottom - 1);
          Self.Canvas.LineTo(DrawRect.Right - 1, DrawRect.Top + 1);
          Self.Canvas.LineTo(DrawRect.left + 1, DrawRect.Top + 1);
          Self.Canvas.Pen.Width := 1;
          Self.Canvas.Pen.Color := clBlack; }

        // полоса выполнения
        DrawRect := Rect;
        DrawRect.left := NumberWidth + CommandWidth + 1;
        DrawRect.Right := NumberWidth + CommandWidth + 1 + LRight - 10;
        // DrawRect.Inflate(-2, -2, 0, -2);
        Self.Canvas.FillRect(DrawRect);

        // градиентный переход от выполненного процента к оставшемуся
        DrawRect := Rect;
        DrawRect.left := NumberWidth + CommandWidth + 1 + LRight - 10;
        DrawRect.Right := DrawRect.left + 20;
        // DrawRect.Inflate(0, -1, 0, -1);
        GradientFillCanvas(Self.Canvas, Self.Canvas.Brush.Color, bColor, DrawRect, gdHorizontal);

        Self.Canvas.Brush.Color := bColor;

        // невыполненная часть
        DrawRect := Rect;
        DrawRect.left := NumberWidth + CommandWidth + 1 + LRight;
        // DrawRect.Inflate(0, -2, -2, -2);
        Self.Canvas.FillRect(DrawRect);

      end;
    ecEnd:
      begin
        Self.Canvas.FillRect(Rect);
      end;
  end;

end;

end.
