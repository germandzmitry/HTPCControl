unit uOMouse;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellApi, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, uDatabase,
  uLine, Vcl.GraphUtil, Vcl.Tabs, Vcl.DockTabSet, GDIPAPI, GDIPOBJ, System.UITypes;

type
  TmoType = (moAdd, moEdit);
  TdmState = (dmNone, dmLeftClick, dmRightClick, dmWheelClick, dmScrollWheel, dmMoveLeft, dmMoveUp,
    dmMoveRight, dmMoveDown);

type
  TfrmOMouse = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    pTop: TPanel;
    lPSort: TLabel;
    lForApplication: TLabel;
    sbtnForApplication: TSpeedButton;
    lWait: TLabel;
    lWaitSecond: TLabel;
    edPSort: TEdit;
    udPSort: TUpDown;
    edForApplication: TEdit;
    edWait: TEdit;
    udWait: TUpDown;
    pMouse: TPanel;
    dtsMouseType: TDockTabSet;
    procedure FormCreate(Sender: TObject);
    procedure udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbtnForApplicationClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure dtsMouseTypeClick(Sender: TObject);
    procedure pMouseClick(Sender: TObject);
  private
    { Private declarations }
    FLineTop: TLine;
    FpMouseType: TPanel;
    FmoType: TmoType;

    FID: Integer;
    FCommand: string;

    FMouseEvent: Integer;
    FMouseWheel: Integer;
    FMouseX: Integer;
    FMouseY: Integer;

    FpbMouse: TPaintBox;

    FlEvent: TLabel;
    FlX: TLabel;
    FlY: TLabel;
    FlWheel: TLabel;
    FlbEvent: TListBox;
    FedX: TEdit;
    FudX: TUpDown;
    FedY: TEdit;
    FudY: TUpDown;
    FedWheel: TEdit;
    FudWheel: TUpDown;
    FMouseEvents: TMouseEvents;

    clPen, clSelPen, clBrush, clSelBrush: ARGB;

    procedure DrawMouse;
    procedure DropMouse;

    procedure DrawManual;
    procedure DropManual;

    procedure FormatMouseEvent;
    procedure CreatePolygonMouse(X, Y: Integer);
    procedure MoveMouse(X, Y: Integer);
    function DrawMouseState: TdmState;

    procedure pbMouseClick(Sender: TObject);
    procedure pbMousePaint(Sender: TObject);

    procedure lbMouseClick(Sender: TObject);
    procedure lbMouseDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);

    procedure udXChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
    procedure udYChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
    procedure udWheelChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
  public
    { Public declarations }
    property moType: TmoType read FmoType write FmoType;
    property ID: Integer write FID;
    property Command: string write FCommand;

    property MouseEvent: Integer read FMouseEvent write FMouseEvent;
    property MouseWheel: Integer read FMouseWheel write FMouseWheel;
    property MouseX: Integer read FMouseX write FMouseX;
    property MouseY: Integer read FMouseY write FMouseY;
  end;

var
  frmOMouse: TfrmOMouse;
  OffsetX, OffsetY: Integer;
  PolygonLeftClick, PolygonRightClick, PolygonScrollWheel, PolygonMoveL, PolygonMoveR, PolygonMoveU,
    PolygonMoveD: array of TGPPoint;

implementation

{$R *.dfm}

uses uMain, uLanguage, uIcon;

procedure TfrmOMouse.FormatMouseEvent;
begin
  case dtsMouseType.TabIndex of
    0:
      begin
        case DrawMouseState of
          dmMoveLeft:
            begin
              OffsetX := 0;
              OffsetY := 20;
            end;
          dmMoveRight:
            begin
              OffsetX := 40;
              OffsetY := 20;
            end;
          dmMoveUp:
            begin
              OffsetX := 20;
              OffsetY := 0;
            end;
          dmMoveDown:
            begin
              OffsetX := 20;
              OffsetY := 40;
            end;
        else
          OffsetX := 20;
          OffsetY := 20;
        end;
      end;
    1:
      begin
        FlbEvent.ItemIndex := FlbEvent.Items.IndexOfObject(TObject(FMouseEvent));
        FudX.Position := FMouseX;
        FudY.Position := FMouseY;
        FudWheel.Position := FMouseWheel;

        lbMouseClick(FlbEvent);
      end;
  end;
end;

procedure TfrmOMouse.FormCreate(Sender: TObject);
var
  i: Integer;
  Icon: TIcon;
begin

  // чистим контролы
  for i := 0 to self.ComponentCount - 1 do
  begin
    // Label
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
    // Edit
    if self.Components[i] is TEdit then
      TEdit(self.Components[i]).Text := '';
    // Button
    if self.Components[i] is TButton then
      TButton(self.Components[i]).Caption := '';
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

  UpdateLanguage(self, lngRus);

  Icon := TIcon.Create;
  try
    StockIcon(SIID_FOLDER, Icon);
    sbtnForApplication.Glyph.Width := Icon.Width;
    sbtnForApplication.Glyph.Height := Icon.Height;
    sbtnForApplication.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnForApplication.Flat := True;
  finally
    Icon.Free;
  end;

  FMouseEvents := Main.DataBase.getMouseEvents;

  clPen := MakeColor(255, 173, 173, 173);
  clBrush := MakeColor(255, 225, 225, 225);

  clSelPen := MakeColor(255, 0, 84, 153);
  clSelBrush := MakeColor(255, 204, 228, 247);
end;

procedure TfrmOMouse.FormShow(Sender: TObject);
begin

  FLineTop := TLine.Create(pTop, alBottom, clBlack, clBlack);
  dtsMouseType.Top := 0;

  // GetHighlightColor(rgb(217, 217, 220)) = clBtnFace
  dtsMouseType.BackgroundColor := rgb(217, 217, 220);

  FpMouseType := TPanel.Create(pMouse);
  with FpMouseType do
  begin
    parent := pMouse;
    left := 0;
    Top := dtsMouseType.Top;
    Width := dtsMouseType.Width;
    Height := 2;
    ParentBackground := False;
    Color := clWhite;
    BevelOuter := bvNone;
    Caption := '';
    BringToFront;
  end;

  OffsetX := 20;
  OffsetY := 20;

  if FmoType = moEdit then
    FormatMouseEvent;

  DrawMouse;
end;

procedure TfrmOMouse.MoveMouse(X, Y: Integer);
var
  i: Integer;
begin
  i := 0;
  while i < 40 do
  begin
    if X < OffsetX then
      dec(OffsetX)
    else if X > OffsetX then
      inc(OffsetX);

    if Y < OffsetY then
      dec(OffsetY)
    else if Y > OffsetY then
      inc(OffsetY);

    inc(i);

    FpbMouse.Repaint;
    Sleep(20);

    if (X = OffsetX) and (Y = OffsetY) then
      Break;
  end;

end;

procedure TfrmOMouse.pbMouseClick(Sender: TObject);
var
  m: TPoint;
begin
  GetCursorPos(m);
  m := (Sender as TPaintBox).ScreenToClient(m);

  FMouseX := 0;
  FMouseY := 0;
  FMouseWheel := 0;

  if PtInRegion(CreatePolygonRgn(PolygonLeftClick[0], length(PolygonLeftClick), WINDING), m.X, m.Y)
  then
  begin
    FMouseEvent := 2;
    MoveMouse(20, 20);
  end
  else if PtInRegion(CreatePolygonRgn(PolygonRightClick[0], length(PolygonRightClick), WINDING),
    m.X, m.Y) then
  begin
    FMouseEvent := 3;
    MoveMouse(20, 20);
  end
  else if PtInRegion(CreatePolygonRgn(PolygonScrollWheel[0], length(PolygonScrollWheel), WINDING),
    m.X, m.Y) then
  begin
    FMouseEvent := 5;
    MoveMouse(20, 20);
  end
  else if PtInRegion(CreatePolygonRgn(PolygonMoveL[0], length(PolygonMoveL), WINDING), m.X, m.Y)
  then
  begin
    FMouseEvent := 1;
    FMouseX := -10;
    FMouseY := 0;
    MoveMouse(0, 20);
  end
  else if PtInRegion(CreatePolygonRgn(PolygonMoveU[0], length(PolygonMoveU), WINDING), m.X, m.Y)
  then
  begin
    FMouseEvent := 1;
    FMouseX := 0;
    FMouseY := -10;
    MoveMouse(20, 0);
  end
  else if PtInRegion(CreatePolygonRgn(PolygonMoveR[0], length(PolygonMoveR), WINDING), m.X, m.Y)
  then
  begin
    FMouseEvent := 1;
    FMouseX := 10;
    FMouseY := 0;
    MoveMouse(40, 20);
  end
  else if PtInRegion(CreatePolygonRgn(PolygonMoveD[0], length(PolygonMoveD), WINDING), m.X, m.Y)
  then
  begin
    FMouseEvent := 1;
    FMouseX := 0;
    FMouseY := 10;
    MoveMouse(20, 40);
  end
  else
  begin
    FMouseEvent := -1;
    MoveMouse(20, 20);
  end;

  FormatMouseEvent;
  (Sender as TPaintBox).Repaint;
end;

procedure TfrmOMouse.pbMousePaint(Sender: TObject);

  procedure SetPenBrush(CState, DState: TdmState; var APen: TGPPen; var ABrush: TGPSolidBrush);
  begin
    if (CState = DState) and (CState <> dmNone) then
    begin
      APen.SetColor(clSelPen);
      ABrush.SetColor(clSelBrush);
    end
    else
    begin
      APen.SetColor(clPen);
      ABrush.SetColor(clBrush);
    end;
  end;

var
  r, DrawR, MouseR: TGPRect;
  graphicsGDIPlus: TGPGraphics;
  Pen, PenRed: TGPPen;
  Brush, BrushWhite: TGPSolidBrush;
  points: array of TGPPoint;
  DrawPolygon: Boolean;
  DrawState: TdmState;
begin

  CreatePolygonMouse(OffsetX, OffsetY);
  DrawPolygon := False;

  graphicsGDIPlus := TGPGraphics.Create((Sender as TPaintBox).Canvas.Handle);
  Pen := TGPPen.Create(clPen, 1);
  PenRed := TGPPen.Create(MakeColor(255, 255, 0, 0), 1);

  Brush := TGPSolidBrush.Create(clBrush);
  BrushWhite := TGPSolidBrush.Create(MakeColor(255, 255, 255, 255));

  DrawState := DrawMouseState;

  try
    r := MakeRect(0, 0, (Sender as TPaintBox).Width - 1, (Sender as TPaintBox).Height - 1);
    MouseR := MakeRect(r.X + OffsetX, r.Y + OffsetY, 101, 200);
    graphicsGDIPlus.SetSmoothingMode(SmoothingMode.SmoothingModeAntiAlias);

    // провод ------------------------------------------------------------------
    SetLength(points, 3);
    points[0] := MakePoint(MouseR.X + 50, MouseR.Y + 28);
    points[1] := MakePoint(MouseR.X + 70, 20);
    points[2] := MakePoint(70, 0);
    graphicsGDIPlus.DrawCurve(Pen, PGPPoint(@points[0]), 3, 1.0);

    // левая -------------------------------------------------------------------
    SetPenBrush(dmLeftClick, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X, MouseR.Y + 30, 93, 131);
    graphicsGDIPlus.FillPie(Brush, DrawR, 180, 90);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 180, 90);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X, DrawR.Y + 66, DrawR.X + 47, DrawR.Y + 66);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X + 47, DrawR.Y + 66, DrawR.X + 47, DrawR.Y);

    // левая - выемка под колесо
    DrawR := MakeRect(MouseR.X + 39, MouseR.Y + 37, 22, 22);
    graphicsGDIPlus.FillPie(BrushWhite, DrawR, 180, 90);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 180, 75);

    DrawR := MakeRect(MouseR.X + 39, MouseR.Y + 47, 9, 33);
    graphicsGDIPlus.FillRectangle(BrushWhite, DrawR);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X, DrawR.Y, DrawR.X, DrawR.Y + DrawR.Height);

    DrawR := MakeRect(MouseR.X + 39, MouseR.Y + 68, 22, 22);
    graphicsGDIPlus.FillPie(BrushWhite, DrawR, 90, 90);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 105, 75);

    // правая ------------------------------------------------------------------
    SetPenBrush(dmRightClick, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X + 7, MouseR.Y + 30, 93, 131);
    graphicsGDIPlus.FillPie(Brush, DrawR, 270, 90);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 270, 90);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X + 46, DrawR.Y + 66, DrawR.X + 93, DrawR.Y + 66);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X + 46, DrawR.Y + 66, DrawR.X + 46, DrawR.Y);

    // правая - выемка под колесо
    DrawR := MakeRect(MouseR.X + 39, MouseR.Y + 37, 22, 22);
    graphicsGDIPlus.FillPie(BrushWhite, DrawR, 285, 75);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 285, 75);

    DrawR := MakeRect(MouseR.X + 52, MouseR.Y + 47, 9, 33);
    graphicsGDIPlus.FillRectangle(BrushWhite, DrawR);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X + DrawR.Width, DrawR.Y, DrawR.X + DrawR.Width,
      DrawR.Y + DrawR.Height);

    DrawR := MakeRect(MouseR.X + 39, MouseR.Y + 68, 22, 22);
    graphicsGDIPlus.FillPie(BrushWhite, DrawR, 0, 75);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 0, 75);

    // Колесо ------------------------------------------------------------------
    SetPenBrush(dmWheelClick, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X + 43, MouseR.Y + 40, 14, 14);
    graphicsGDIPlus.FillEllipse(Brush, DrawR);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 180, 180);

    DrawR := MakeRect(MouseR.X + 43, MouseR.Y + 73, 14, 14);
    graphicsGDIPlus.FillEllipse(Brush, DrawR);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 0, 180);

    DrawR := MakeRect(MouseR.X + 43, MouseR.Y + 47, 14, 33);
    graphicsGDIPlus.FillRectangle(Brush, DrawR);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X, DrawR.Y, DrawR.X, DrawR.Y + DrawR.Height);
    graphicsGDIPlus.DrawLine(Pen, DrawR.X + DrawR.Width, DrawR.Y, DrawR.X + DrawR.Width,
      DrawR.Y + DrawR.Height);

    // тело --------------------------------------------------------------------
    SetPenBrush(dmNone, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X, MouseR.Y + 101, 100, 50);
    graphicsGDIPlus.FillRectangle(Brush, DrawR);
    graphicsGDIPlus.DrawRectangle(Pen, DrawR);

    // тело - низ
    DrawR := MakeRect(MouseR.X, MouseR.Y + 100, 100, 99);
    graphicsGDIPlus.FillPie(Brush, DrawR, 0, 180);
    graphicsGDIPlus.DrawArc(Pen, DrawR, 0, 180);

    // Стрелки -----------------------------------------------------------------
    SetPenBrush(dmNone, DrawState, Pen, Brush);

    graphicsGDIPlus.FillEllipse(BrushWhite, MouseR.X + 18, MouseR.Y + 118, 64, 64);
    graphicsGDIPlus.DrawEllipse(Pen, MouseR.X + 18, MouseR.Y + 118, 64, 64);

    // Стрелки - вверх ---------------------------------------------------------
    SetPenBrush(dmMoveUp, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X + 20 + 20, MouseR.Y + 120 + 0, 64, 64);
    SetLength(PolygonMoveU, 7);
    PolygonMoveU[0] := MakePoint(DrawR.X + 20, DrawR.Y + 10);
    PolygonMoveU[1] := MakePoint(DrawR.X + 10, DrawR.Y + 0);
    PolygonMoveU[2] := MakePoint(DrawR.X + 0, DrawR.Y + 10);
    PolygonMoveU[3] := MakePoint(DrawR.X + 5, DrawR.Y + 10);
    PolygonMoveU[4] := MakePoint(DrawR.X + 5, DrawR.Y + 20);
    PolygonMoveU[5] := MakePoint(DrawR.X + 15, DrawR.Y + 20);
    PolygonMoveU[6] := MakePoint(DrawR.X + 15, DrawR.Y + 10);
    graphicsGDIPlus.FillPolygon(Brush, PGPPoint(@PolygonMoveU[0]), length(PolygonMoveU));
    graphicsGDIPlus.DrawPolygon(Pen, PGPPoint(@PolygonMoveU[0]), length(PolygonMoveU));

    // Стрелки - вниз ----------------------------------------------------------
    SetPenBrush(dmMoveDown, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X + 20 + 20, MouseR.Y + 120 + 40, 64, 64);
    SetLength(PolygonMoveD, 7);
    PolygonMoveD[0] := MakePoint(DrawR.X + 0, DrawR.Y + 10);
    PolygonMoveD[1] := MakePoint(DrawR.X + 10, DrawR.Y + 20);
    PolygonMoveD[2] := MakePoint(DrawR.X + 20, DrawR.Y + 10);
    PolygonMoveD[3] := MakePoint(DrawR.X + 15, DrawR.Y + 10);
    PolygonMoveD[4] := MakePoint(DrawR.X + 15, DrawR.Y + 0);
    PolygonMoveD[5] := MakePoint(DrawR.X + 5, DrawR.Y + 0);
    PolygonMoveD[6] := MakePoint(DrawR.X + 5, DrawR.Y + 10);
    graphicsGDIPlus.FillPolygon(Brush, PGPPoint(@PolygonMoveD[0]), length(PolygonMoveD));
    graphicsGDIPlus.DrawPolygon(Pen, PGPPoint(@PolygonMoveD[0]), length(PolygonMoveD));

    // Стрелки - налево --------------------------------------------------------
    SetPenBrush(dmMoveLeft, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X + 20 + 0, MouseR.Y + 120 + 20, 64, 64);
    SetLength(PolygonMoveL, 7);
    PolygonMoveL[0] := MakePoint(DrawR.X + 10, DrawR.Y + 0);
    PolygonMoveL[1] := MakePoint(DrawR.X + 0, DrawR.Y + 10);
    PolygonMoveL[2] := MakePoint(DrawR.X + 10, DrawR.Y + 20);
    PolygonMoveL[3] := MakePoint(DrawR.X + 10, DrawR.Y + 15);
    PolygonMoveL[4] := MakePoint(DrawR.X + 20, DrawR.Y + 15);
    PolygonMoveL[5] := MakePoint(DrawR.X + 20, DrawR.Y + 5);
    PolygonMoveL[6] := MakePoint(DrawR.X + 10, DrawR.Y + 5);
    graphicsGDIPlus.FillPolygon(Brush, PGPPoint(@PolygonMoveL[0]), length(PolygonMoveL));
    graphicsGDIPlus.DrawPolygon(Pen, PGPPoint(@PolygonMoveL[0]), length(PolygonMoveL));

    // Стрелки - направо -------------------------------------------------------
    SetPenBrush(dmMoveRight, DrawState, Pen, Brush);

    DrawR := MakeRect(MouseR.X + 20 + 40, MouseR.Y + 120 + 20, 64, 64);
    SetLength(PolygonMoveR, 7);
    PolygonMoveR[0] := MakePoint(DrawR.X + 10, DrawR.Y + 20);
    PolygonMoveR[1] := MakePoint(DrawR.X + 20, DrawR.Y + 10);
    PolygonMoveR[2] := MakePoint(DrawR.X + 10, DrawR.Y + 0);
    PolygonMoveR[3] := MakePoint(DrawR.X + 10, DrawR.Y + 5);
    PolygonMoveR[4] := MakePoint(DrawR.X + 0, DrawR.Y + 5);
    PolygonMoveR[5] := MakePoint(DrawR.X + 0, DrawR.Y + 15);
    PolygonMoveR[6] := MakePoint(DrawR.X + 10, DrawR.Y + 15);
    graphicsGDIPlus.FillPolygon(Brush, PGPPoint(@PolygonMoveR[0]), length(PolygonMoveR));
    graphicsGDIPlus.DrawPolygon(Pen, PGPPoint(@PolygonMoveR[0]), length(PolygonMoveR));

    // Стрелки - центр ---------------------------------------------------------
    SetPenBrush(dmNone, DrawState, Pen, Brush);

    graphicsGDIPlus.FillEllipse(Brush, MouseR.X + 20 + 23, MouseR.Y + 120 + 23, 14, 14);
    graphicsGDIPlus.DrawEllipse(Pen, MouseR.X + 20 + 23, MouseR.Y + 120 + 23, 14, 14);

    // рамка
    if DrawPolygon then
    begin
      graphicsGDIPlus.DrawRectangle(PenRed, r);
    end;

  finally
    Pen.Free;
    PenRed.Free;
    Brush.Free;
    BrushWhite.Free;
    graphicsGDIPlus.Free;
  end;
end;

procedure TfrmOMouse.pMouseClick(Sender: TObject);
begin
  if Assigned(FpbMouse) then
    pbMouseClick(FpbMouse);
end;

procedure TfrmOMouse.FormDestroy(Sender: TObject);
begin
  FLineTop.Free;
  FpMouseType.Free;
  // FLineBottom.Free;
end;

procedure TfrmOMouse.btnSaveClick(Sender: TObject);
begin
  if FMouseEvent < 1 then
    exit;

  case FMouseEvent of
    meMoveMouse:
      FMouseWheel := 0;
    meScrollWheel:
      begin
        FMouseX := 0;
        FMouseY := 0;
      end;
  else
    begin
      FMouseX := 0;
      FMouseY := 0;
      FMouseWheel := 0;
    end;
  end;

  try
    case FmoType of
      moAdd:
        Main.DataBase.CreateMouse(FCommand, udPSort.Position, udWait.Position, FMouseEvent, FMouseX,
          FMouseY, FMouseWheel, edForApplication.Text);
      moEdit:
        Main.DataBase.UpdateMouse(FID, udPSort.Position, udWait.Position, FMouseEvent, FMouseX,
          FMouseY, FMouseWheel, edForApplication.Text);
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmOMouse.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmOMouse.lbMouseClick(Sender: TObject);
var
  XY, Wheel: Boolean;
  clXY, clWheel: TColor;
begin

  // if (Sender as TComboBox).ItemIndex > -1 then
  // FMouseEvent := Integer((Sender as TComboBox).Items.Objects[(Sender as TComboBox).ItemIndex]);

  if (Sender as TListBox).ItemIndex > -1 then
    FMouseEvent := Integer((Sender as TListBox).Items.Objects[(Sender as TListBox).ItemIndex]);

  XY := False;
  Wheel := False;

  clXY := clGrayText;
  clWheel := clGrayText;

  case FMouseEvent of
    meMoveMouse:
      begin
        XY := True;
        clXY := clWindowText;
      end;
    meScrollWheel:
      begin
        Wheel := True;
        clWheel := clWindowText;
      end;
  end;

  FlX.Font.Color := clXY;
  FlY.Font.Color := clXY;
  FlWheel.Font.Color := clWheel;

  FlX.Visible := XY;
  FedX.Visible := XY;
  FudX.Visible := XY;
  FlY.Visible := XY;
  FedY.Visible := XY;
  FudY.Visible := XY;
  FlWheel.Visible := Wheel;
  FedWheel.Visible := Wheel;
  FudWheel.Visible := Wheel;
end;

procedure TfrmOMouse.lbMouseDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  LB: TListBox;
  DrawR: TRect;
begin
  LB := (Control as TListBox);

  LB.Canvas.Font.Color := clBlack;
  LB.Canvas.Brush.Color := clWhite;

  if odSelected in State then
    LB.Canvas.Brush.Color := GetShadowColor(clHighlight, 115);

  LB.Canvas.FillRect(Rect);

  DrawR := Rect;
  DrawR.left := 4;
  DrawText(LB.Canvas.Handle, PChar(LB.Items[Index]), -1, DrawR,
    DT_VCENTER or DT_SINGLELINE or DT_LEFT);

  if odFocused in State then
    LB.Canvas.DrawFocusRect(Rect);
end;

procedure TfrmOMouse.CreatePolygonMouse(X, Y: Integer);
begin
  // Левая
  SetLength(PolygonLeftClick, 0);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 47, Y + 30);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 47, Y + 38);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 40, Y + 43);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 40, Y + 83);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 47, Y + 88);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 47, Y + 95);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 0, Y + 95);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 3, Y + 75);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 10, Y + 55);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 20, Y + 40);
  SetLength(PolygonLeftClick, length(PolygonLeftClick) + 1);
  PolygonLeftClick[length(PolygonLeftClick) - 1] := MakePoint(X + 30, Y + 35);

  // Правая
  SetLength(PolygonRightClick, 0);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 53, Y + 30);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 53, Y + 38);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 60, Y + 43);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 60, Y + 83);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 53, Y + 88);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 53, Y + 95);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 100, Y + 95);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 97, Y + 75);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 90, Y + 55);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 80, Y + 40);
  SetLength(PolygonRightClick, length(PolygonRightClick) + 1);
  PolygonRightClick[length(PolygonRightClick) - 1] := MakePoint(X + 70, Y + 35);

  // Колесо
  SetLength(PolygonScrollWheel, 0);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 43, Y + 47);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 43, Y + 79);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 48, Y + 86);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 52, Y + 86);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 57, Y + 79);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 57, Y + 47);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 52, Y + 40);
  SetLength(PolygonScrollWheel, length(PolygonScrollWheel) + 1);
  PolygonScrollWheel[length(PolygonScrollWheel) - 1] := MakePoint(X + 48, Y + 40);
end;

procedure TfrmOMouse.sbtnForApplicationClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    OpenDialog.Filter := 'Приложении|*.exe';
    if FileExists(edForApplication.Text) then
      OpenDialog.InitialDir := ExtractFileDir(edForApplication.Text)
    else
      OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
      edForApplication.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmOMouse.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    close;
end;

procedure TfrmOMouse.udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
  Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  lWaitSecond.Caption := Format(GetLanguageText(self.Name, 'lWaitSecond', lngRus),
    [FloatToStr(NewValue / 1000)]);
end;

procedure TfrmOMouse.udXChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
  Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  FMouseX := NewValue;
end;

procedure TfrmOMouse.udYChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
  Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  FMouseY := NewValue;
end;

procedure TfrmOMouse.udWheelChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
  Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  FMouseWheel := NewValue;
end;

procedure TfrmOMouse.DrawMouse;
begin
  FpbMouse := TPaintBox.Create(pMouse);
  with FpbMouse do
  begin
    parent := pMouse;
    Top := 0;
    left := (pMouse.Width div 2) - 70;
    Width := 141;
    Height := 240;

    DoubleBuffered := True;

    OnClick := pbMouseClick;
    OnPaint := pbMousePaint;
  end;
end;

function TfrmOMouse.DrawMouseState: TdmState;
begin
  result := dmNone;

  case FMouseEvent of
    meMoveMouse:
      begin
        if (FMouseX = 0) and (FMouseY < 0) then
          result := dmMoveUp
        else if (FMouseX = 0) and (FMouseY > 0) then
          result := dmMoveDown
        else if (FMouseX < 0) and (FMouseY = 0) then
          result := dmMoveLeft
        else if (FMouseX > 0) and (FMouseY = 0) then
          result := dmMoveRight;
      end;
    meLeftCLick:
      result := dmLeftClick;
    meRightCLick:
      result := dmRightClick;
    meScrollWheel:
      result := dmScrollWheel;
    meWheelClick:
      result := dmWheelClick;
  end;
end;

procedure TfrmOMouse.DropMouse;
begin
  if Assigned(FpbMouse) then
    FreeAndNil(FpbMouse);
end;

procedure TfrmOMouse.DrawManual;
var
  i: Integer;
begin

  // Событие
  FlEvent := TLabel.Create(pMouse);
  with FlEvent do
  begin
    parent := pMouse;
    left := lForApplication.left;
    Top := 8;
    Width := 185;
    Height := 13;
    AutoSize := False;
    Caption := GetLanguageText(self.Name, 'lEvent', lngRus);
  end;

  FlbEvent := TListBox.Create(pMouse);
  with FlbEvent do
  begin
    left := 8;
    Top := 8 + FlEvent.Height + 6;
    Width := 185;
    Height := pMouse.Height - Top - dtsMouseType.Height - 8;
    parent := pMouse;
    ParentDoubleBuffered := True;

    ItemHeight := 20;
    Style := lbOwnerDrawFixed;

    OnClick := lbMouseClick;
    OnDrawItem := lbMouseDrawItem;

    Items.BeginUpdate;
    try
      Items.Clear;
      for i := 0 to length(FMouseEvents) - 1 do
        Items.AddObject(FMouseEvents[i].Desc, TObject(FMouseEvents[i].Event));
    finally
      Items.EndUpdate;
    end;
  end;

  // X
  FlX := TLabel.Create(pMouse);
  with FlX do
  begin
    parent := pMouse;
    left := FlbEvent.left + FlbEvent.Width + 9;
    Top := FlbEvent.Top;
    Width := 145;
    Height := 13;
    AutoSize := False;
    Caption := GetLanguageText(self.Name, 'lX', lngRus);
  end;

  FedX := TEdit.Create(pMouse);
  with FedX do
  begin
    left := FlX.left;
    Top := FlX.Top + FlX.Height + 6;
    Width := edPSort.Width;
    Height := 21;
    parent := pMouse;
    Alignment := taCenter;
    ReadOnly := True;
  end;

  FudX := TUpDown.Create(pMouse);
  with FudX do
  begin
    left := FlX.left;
    Top := FedX.Top;
    Width := 16;
    Height := 21;
    parent := pMouse;
    Associate := FedX;
    Min := -100;
    Max := 100;
    Increment := 1;
    Position := 0;

    OnChangingEx := udXChangingEx;
  end;

  // Y
  FlY := TLabel.Create(pMouse);
  with FlY do
  begin
    parent := pMouse;
    left := FlbEvent.left + FlbEvent.Width + 9;
    Top := FedX.Top + FedX.Height + 9;
    Width := 145;
    Height := 13;
    AutoSize := False;
    Caption := GetLanguageText(self.Name, 'lY', lngRus);
  end;

  FedY := TEdit.Create(pMouse);
  with FedY do
  begin
    left := FlY.left;
    Top := FlY.Top + FlY.Height + 6;
    Width := edPSort.Width;
    Height := 21;
    parent := pMouse;
    Alignment := taCenter;
    ReadOnly := True;
  end;

  FudY := TUpDown.Create(pMouse);
  with FudY do
  begin
    left := FlY.left;
    Top := FedY.Top;
    Width := 16;
    Height := 21;
    parent := pMouse;
    Associate := FedY;
    Min := -100;
    Max := 100;
    Increment := 1;
    Position := 0;

    OnChangingEx := udYChangingEx;
  end;

  // Wheel
  FlWheel := TLabel.Create(pMouse);
  with FlWheel do
  begin
    parent := pMouse;
    left := FlbEvent.left + FlbEvent.Width + 9;
    Top := FlbEvent.Top;
    Width := 145;
    Height := 13;
    // Alignment := taRightJustify;
    AutoSize := False;
    Caption := GetLanguageText(self.Name, 'lWheel', lngRus);
  end;

  FedWheel := TEdit.Create(pMouse);
  with FedWheel do
  begin
    left := FlWheel.left;
    Top := FlWheel.Top + FlWheel.Height + 6;
    Width := edPSort.Width;
    Height := 21;
    parent := pMouse;
    Alignment := taCenter;
    ReadOnly := True;
  end;

  FudWheel := TUpDown.Create(pMouse);
  with FudWheel do
  begin
    left := FlWheel.left;
    Top := FlWheel.Top + FlWheel.Height + 6;
    Width := 16;
    Height := 21;
    parent := pMouse;
    Associate := FedWheel;
    Min := -1200;
    Max := 1200;
    Increment := 120;
    Position := 0;

    OnChangingEx := udWheelChangingEx;
  end;
end;

procedure TfrmOMouse.DropManual;
var
  i: Integer;
begin

  for i := pMouse.ComponentCount - 1 downto 0 do
    if (pMouse.Components[i] is TEdit) //
      or (pMouse.Components[i] is TLabel) //
    // or (pMouse.Components[i] is TListBox) //
      or (pMouse.Components[i] is TUpDown) then
      pMouse.Components[i].Free;

  // Если не очищать парента, при Free падаем access_violation
  FlbEvent.parent := nil;
  FlbEvent.Free;

end;

procedure TfrmOMouse.dtsMouseTypeClick(Sender: TObject);
begin
  case dtsMouseType.TabIndex of
    0:
      begin
        DropManual;
        DrawMouse;
      end;
    1:
      begin
        DropMouse;
        DrawManual;
      end;
  end;
  FormatMouseEvent;
end;

end.
