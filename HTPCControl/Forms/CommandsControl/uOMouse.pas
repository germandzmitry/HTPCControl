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

    procedure DrawMouse;
    procedure DropMouse;

    procedure DrawManual;
    procedure DropManual;

    procedure FormatMouseEvent;
    // procedure CreatePolygonMouse(X, Y: Integer);
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
  // PolygonLeftClick, PolygonRightClick, PolygonScrollWheel, PolygonMoveL, PolygonMoveR, PolygonMoveU,
  // PolygonMoveD: array of TGPPoint;
  PathLC, PathRC, PathWC, PathML, PathMR, PathMU, PathMD: TGPGraphicsPath;

implementation

{$R *.dfm}

uses uMain, uLanguage, uIcon;

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

  PathLC := TGPGraphicsPath.Create();
  PathRC := TGPGraphicsPath.Create();
  PathWC := TGPGraphicsPath.Create();
  PathML := TGPGraphicsPath.Create();
  PathMR := TGPGraphicsPath.Create();
  PathMU := TGPGraphicsPath.Create();
  PathMD := TGPGraphicsPath.Create();

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

procedure TfrmOMouse.FormDestroy(Sender: TObject);
begin
  PathLC.Free;
  PathRC.Free;
  PathWC.Free;
  PathML.Free;
  PathMR.Free;
  PathMU.Free;
  PathMD.Free;

  FLineTop.Free;
  FpMouseType.Free;
end;

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
    Sleep(10);

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

  if PathLC.IsVisible(m.X, m.Y) then
  begin
    FMouseEvent := 2;
    MoveMouse(20, 20);
  end
  else if PathRC.IsVisible(m.X, m.Y) then
  begin
    FMouseEvent := 3;
    MoveMouse(20, 20);
  end
  else if PathWC.IsVisible(m.X, m.Y) then
  begin
    FMouseEvent := 5;
    MoveMouse(20, 20);
  end
  else if PathML.IsVisible(m.X, m.Y) then
  begin
    FMouseEvent := 1;
    FMouseX := -10;
    FMouseY := 0;
    MoveMouse(0, 20);
  end
  else if PathMU.IsVisible(m.X, m.Y) then
  begin
    FMouseEvent := 1;
    FMouseX := 0;
    FMouseY := -10;
    MoveMouse(20, 0);
  end
  else if PathMR.IsVisible(m.X, m.Y) then
  begin
    FMouseEvent := 1;
    FMouseX := 10;
    FMouseY := 0;
    MoveMouse(40, 20);
  end
  else if PathMD.IsVisible(m.X, m.Y) then
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
var
  R, DrawR, MouseR: TGPRect;
  graphicsGDIPlus: TGPGraphics;
  Pen, PenRed: TGPPen;
  Brush, BrushWhite: TGPSolidBrush;
  Path, PathBody: TGPGraphicsPath;
  DrawPolygon: Boolean;
  DrawState: TdmState;
  Points: array of TGPPoint;
  clSelBrush: ARGB;
  i, j: Integer;
  lineCap: TLineCap;
  PathBodyRect: TGPRectF;
  X, Y, S: single;
begin
  clSelBrush := MakeColor(255, 204, 228, 247);

  DrawPolygon := False;

  graphicsGDIPlus := TGPGraphics.Create((Sender as TPaintBox).Canvas.Handle);
  Path := TGPGraphicsPath.Create;
  PathBody := TGPGraphicsPath.Create;
  Pen := TGPPen.Create(MakeColor(255, 173, 173, 173), 1);
  PenRed := TGPPen.Create(MakeColor(255, 255, 0, 0), 1);

  Brush := TGPSolidBrush.Create(MakeColor(255, 225, 225, 225));
  BrushWhite := TGPSolidBrush.Create(MakeColor(255, 255, 255, 255));

  DrawState := DrawMouseState;

  try
    R := MakeRect(0, 0, (Sender as TPaintBox).Width - 1, (Sender as TPaintBox).Height - 1);
    MouseR := MakeRect(R.X + OffsetX, R.Y + OffsetY, 101, 200);
    graphicsGDIPlus.SetSmoothingMode(SmoothingMode.SmoothingModeAntiAlias);

    // -------------------------------------------------------------------------
    // Провод
    // -------------------------------------------------------------------------
    SetLength(Points, 3);
    Points[0] := MakePoint(MouseR.X + 50, MouseR.Y + 26);
    Points[1] := MakePoint(MouseR.X + 70, 20);
    Points[2] := MakePoint(70, 0);
    graphicsGDIPlus.DrawCurve(Pen, PGPPoint(@Points[0]), 3, 1.0);

    // -------------------------------------------------------------------------
    // Тело - только расчет для стрелочек, не вывод
    // -------------------------------------------------------------------------
    PathBody.StartFigure;
    PathBody.AddArc(MakeRect(MouseR.X - 50, MouseR.Y + 29, 200, 80), 216, 108); // перед
    PathBody.AddArc(MakeRect(MouseR.X + 96, MouseR.Y - 121, 200, 400), 204, -50); // право
    PathBody.AddArc(MakeRect(MouseR.X, MouseR.Y + 79, 100, 120), 343, 214); // низ
    PathBody.AddArc(MakeRect(MouseR.X - 196, MouseR.Y - 121, 200, 400), 25, -49); // лево
    PathBody.CloseFigure;

    // -------------------------------------------------------------------------
    // Стрелки движения
    // -------------------------------------------------------------------------

    Pen.SetColor(MakeColor(255, 90, 90, 90));
    Brush.SetColor(MakeColor(255, 225, 225, 225));

    // вверх
    Path.StartFigure;
    Path.AddLine(R.Width div 2 - 15, R.Y + 45, R.Width div 2 + 15, R.Y + 45);
    Path.AddLine(R.Width div 2 + 15, R.Y + 45, R.Width div 2, R.Y + 35);
    Path.CloseFigure;
    PathMU := Path.Clone;

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // вниз
    Path.StartFigure;
    Path.AddLine(R.Width div 2 - 15, R.Height - 15, R.Width div 2 + 15, R.Height - 15);
    Path.AddLine(R.Width div 2 + 15, R.Height - 15, R.Width div 2, R.Height - 5);
    Path.CloseFigure;
    PathMD := Path.Clone;

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // налево
    Path.StartFigure;
    Path.AddLine(R.X + 15, R.Height div 2 - 15, R.X + 15, R.Height div 2 + 15);
    Path.AddLine(R.X + 15, R.Height div 2 + 15, R.X + 5, R.Height div 2);
    Path.CloseFigure;
    PathML := Path.Clone;

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // направо
    Path.StartFigure;
    Path.AddLine(R.Width - 15, R.Height div 2 - 15, R.Width - 15, R.Height div 2 + 15);
    Path.AddLine(R.Width - 15, R.Height div 2 + 15, R.Width - 5, R.Height div 2);
    Path.CloseFigure;
    PathMR := Path.Clone;

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // -------------------------------------------------------------------------
    // Стрелочки направления движения
    // -------------------------------------------------------------------------
    lineCap := Pen.GetEndCap();
    Pen.SetWidth(3);
    Pen.SetEndCap(LineCapArrowAnchor);
    Pen.SetColor(clSelBrush);

    PathBody.GetBounds(PathBodyRect);
    j := round(PathBodyRect.Y) div 15 + 1;

    // налево
    if DrawState = dmMoveLeft then
      for i := j to j + 10 do
      begin
        X := PathBodyRect.X + PathBodyRect.Width;
        Y := R.Y + 5 + i * 15;
        while X > PathBodyRect.X do
        begin
          if PathBody.IsVisible(X, Y) then
          begin
            S := PathBodyRect.X + PathBodyRect.Width - X;
            graphicsGDIPlus.DrawLine(Pen, R.Width - S - 15, Y, R.Width - S - 30, Y);
            Break;
          end;
          X := X - 1;
        end;
      end;

    // направо
    if DrawState = dmMoveRight then
      for i := j to j + 10 do
      begin
        X := PathBodyRect.X;
        Y := R.Y + 5 + i * 15;
        while X < PathBodyRect.X + PathBodyRect.Width do
        begin
          if PathBody.IsVisible(X, Y) then
          begin
            S := X - PathBodyRect.X;
            graphicsGDIPlus.DrawLine(Pen, R.X + S + 20, Y, R.X + S + 35, Y);
            Break;
          end;
          X := X + 1;
        end;
      end;

    j := round(PathBodyRect.X) div 15 + 1;
    // вниз
    if DrawState = dmMoveDown then
      for i := j to j + 5 do
      begin
        X := R.X + 2 + i * 15;
        Y := PathBodyRect.Y;

        while Y < PathBodyRect.Y + PathBodyRect.Height do
        begin
          if PathBody.IsVisible(X, Y) then
          begin
            S := Y - PathBodyRect.Y;
            graphicsGDIPlus.DrawLine(Pen, X, R.Y + S + 48, X, R.Y + S + 63);
            Break;
          end;
          Y := Y + 1;
        end;
      end;

    // вверх
    if DrawState = dmMoveUp then
      for i := j to j + 5 do
      begin
        X := R.X + 2 + i * 15;
        Y := PathBodyRect.Y + PathBodyRect.Height;

        while Y > PathBodyRect.Y do
        begin
          if PathBody.IsVisible(X, Y) then
          begin
            S := PathBodyRect.Y + PathBodyRect.Height - Y;
            graphicsGDIPlus.DrawLine(Pen, X, R.Height - S - 13, X, R.Height - S - 28);
            Break;
          end;
          Y := Y - 1;
        end;
      end;

    Pen.SetWidth(1);
    Pen.SetEndCap(lineCap);

    // -------------------------------------------------------------------------
    // Тело - вывод
    // -------------------------------------------------------------------------

    // Перед
    Path.StartFigure;
    DrawR := MakeRect(MouseR.X - 50, MouseR.Y + 29, 200, 80);
    Path.AddArc(DrawR, 216, 4);
    Path.AddArc(MakeRect(MouseR.X + 7, MouseR.Y - 10, 86, 86), 180, -180);
    Path.AddArc(DrawR, 320, 4);
    Path.AddArc(MakeRect(MouseR.X + 96, MouseR.Y - 121, 200, 400), 204, -50); // право
    Path.AddArc(MakeRect(MouseR.X, MouseR.Y + 79, 100, 120), 343, 214); // низ
    Path.AddArc(MakeRect(MouseR.X - 196, MouseR.Y - 121, 200, 400), 25, -49); // лево
    Path.CloseFigure;
    Path.Reset;

    Pen.SetColor(MakeColor(255, 90, 90, 90));
    Brush.SetColor(MakeColor(255, 90, 90, 90));
    graphicsGDIPlus.FillPath(Brush, PathBody);
    graphicsGDIPlus.DrawPath(Pen, PathBody);
    Path.Reset;

    // 1 линия
    Path.StartFigure;
    Path.AddArc(MakeRect(MouseR.X - 50, MouseR.Y + 29, 200, 80), 220, 100); // перед
    Path.AddArc(MakeRect(MouseR.X + 7, MouseR.Y - 152, 86, 340), 20, 140); // линия
    Path.CloseFigure;

    Pen.SetColor(MakeColor(255, 225, 225, 225));
    Brush.SetColor(MakeColor(255, 225, 225, 225));
    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // 2 линия
    Path.StartFigure;
    Path.AddArc(MakeRect(MouseR.X + 10, MouseR.Y - 132, 80, 300), 66, 48); // линия
    Path.CloseFigure;

    Pen.SetColor(MakeColor(255, 173, 173, 173));
    Brush.SetColor(MakeColor(255, 173, 173, 173));
    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // -------------------------------------------------------------------------
    // Левая клавиша
    // -------------------------------------------------------------------------
    Path.StartFigure;
    Path.AddArc(MakeRect(MouseR.X - 50, MouseR.Y + 29, 200, 80), 224, 45);
    // дырка под колесо
    Path.AddLine(MouseR.X + 50, MouseR.Y + 29, MouseR.X + 50, MouseR.Y + 29 + 11);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 40, 14, 14), 270, -90);
    Path.AddLine(MouseR.X + 43, MouseR.Y + 48, MouseR.X + 43, MouseR.Y + 48 + 26);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 66, 14, 14), 180, -90);
    Path.AddLine(MouseR.X + 50, MouseR.Y + 82, MouseR.X + 50, MouseR.Y + 95);
    // дырка под колесо - конец
    Path.AddArc(MakeRect(MouseR.X + 10, MouseR.Y - 132, 80, 300), 114, 46);
    Path.CloseFigure;
    PathLC := Path.Clone;

    Pen.SetColor(MakeColor(255, 173, 173, 173));
    Brush.SetColor(MakeColor(255, 173, 173, 173));
    if DrawState = dmLeftClick then
    begin
      // Pen.SetColor(clSelBrush);
      Brush.SetColor(clSelBrush);
    end;

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // -------------------------------------------------------------------------
    // Правая клавиша
    // -------------------------------------------------------------------------
    Path.StartFigure;
    Path.AddArc(MakeRect(MouseR.X - 50, MouseR.Y + 29, 200, 80), 224 + 45 + 45 + 1, -45);
    // дырка под колесо
    Path.AddLine(MouseR.X + 50, MouseR.Y + 29, MouseR.X + 50, MouseR.Y + 29 + 11);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 40, 14, 14), 270, 90);
    Path.AddLine(MouseR.X + 43 + 14, MouseR.Y + 48, MouseR.X + 43 + 14, MouseR.Y + 48 + 26);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 66, 14, 14), 0, 90);
    Path.AddLine(MouseR.X + 50, MouseR.Y + 82, MouseR.X + 50, MouseR.Y + 95);
    // дырка под колесо - конец
    Path.AddArc(MakeRect(MouseR.X + 10, MouseR.Y - 132, 80, 300), 66, -46);
    Path.CloseFigure;
    PathRC := Path.Clone;

    Pen.SetColor(MakeColor(255, 173, 173, 173));
    Brush.SetColor(MakeColor(255, 173, 173, 173));
    if DrawState = dmRightClick then
    begin
      // Pen.SetColor(clSelBrush);
      Brush.SetColor(clSelBrush);
    end;

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // -------------------------------------------------------------------------
    // Колесо
    // -------------------------------------------------------------------------
    Path.StartFigure;
    Path.AddLine(MouseR.X + 50, MouseR.Y + 29, MouseR.X + 50, MouseR.Y + 40);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 40, 14, 14), 270, -90);
    Path.AddLine(MouseR.X + 43, MouseR.Y + 48, MouseR.X + 43, MouseR.Y + 48 + 26);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 66, 14, 14), 180, -90);
    Path.AddLine(MouseR.X + 50, MouseR.Y + 29 + 54, MouseR.X + 50, MouseR.Y + 29 + 54 + 11);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 66, 14, 14), 90, -90);
    Path.AddLine(MouseR.X + 43 + 14, MouseR.Y + 48 + 26, MouseR.X + 43 + 14, MouseR.Y + 48);
    Path.AddArc(MakeRect(MouseR.X + 43, MouseR.Y + 40, 14, 14), 0, -90);
    Path.CloseFigure;
    PathWC := Path.Clone;

    Pen.SetColor(MakeColor(255, 90, 90, 90));
    Brush.SetColor(MakeColor(255, 225, 225, 225));
    if DrawState = dmWheelClick then
      Brush.SetColor(clSelBrush);

    graphicsGDIPlus.FillPath(Brush, Path);
    graphicsGDIPlus.DrawPath(Pen, Path);
    Path.Reset;

    // -------------------------------------------------------------------------
    // Стрелочки
    // -------------------------------------------------------------------------
    { lineCap := Pen.GetEndCap();
      Pen.SetWidth(3);
      Pen.SetEndCap(LineCapArrowAnchor);
      Pen.SetColor(MakeColor(255, 255, 0, 0));

      PathBody.GetBounds(tt);

      for i := 3 to 13 do
      begin
      Y := MouseR.Y + i * 15;
      X := tt.X + tt.Width;
      while X > tt.X do
      begin

      if PathBody.IsVisible(X, Y) then
      begin
      graphicsGDIPlus.DrawLine(Pen, X + 20, Y, X + 5, Y);
      Break;
      end;

      X := X - 1;
      end;


      // for j := round(tt.Width + tt.X) downto round(tt.X) do
      // begin
      // X := round(tt.Width);
      // Y := MouseR.Y + i * 15;
      // if PathBody.IsVisible(X, Y) then
      // begin
      // FpbMouse.Canvas.Pixels[X, Y] := clRed;
      // // graphicsGDIPlus.DrawLine(Pen, tt.Width - j - 5, MouseR.Y + i * 15, tt.Width - j - 20,
      // // MouseR.Y + i * 15);
      // Break;
      // end;

      // end;

      end; }

    { if DrawState = dmMoveLeft then
      for i := 3 to 12 do
      graphicsGDIPlus.DrawLine(Pen, R.Width - 25, MouseR.Y + i * 15, R.Width - 40,
      MouseR.Y + i * 15); }

    Pen.SetWidth(1);
    Pen.SetEndCap(lineCap);

  finally
    Pen.Free;
    PenRed.Free;
    Brush.Free;
    BrushWhite.Free;
    Path.Free;
    PathBody.Free;
    graphicsGDIPlus.Free;
  end;
end;

procedure TfrmOMouse.pMouseClick(Sender: TObject);
begin
  if Assigned(FpbMouse) then
    pbMouseClick(FpbMouse);
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

{ procedure TfrmOMouse.CreatePolygonMouse(X, Y: Integer);
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
  end; }

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
