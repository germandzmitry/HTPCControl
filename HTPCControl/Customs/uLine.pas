unit uLine;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Graphics, Vcl.ExtCtrls, Vcl.Controls, GraphUtil;

type
  TLine = class
  private
    FLine: TPaintBox;
    FColorFrom: TColor;
    FColorTo: TColor;
    FAlign: TAlign;
    FSize: integer;
    FDirection: TGradientDirection;
    procedure LinePaint(Sender: TObject);
    procedure SetAlign(const Value: TAlign);
    procedure SetSize(const Value: integer);
    procedure SetColorFrom(const Value: TColor);
    procedure SetColorTo(const Value: TColor);
  public
    constructor Create(Parent: TPanel); overload;
    constructor Create(Parent: TPanel; Align: TAlign); overload;
    constructor Create(Parent: TPanel; ColorFrom, ColorTo: TColor); overload;
    constructor Create(Parent: TPanel; Align: TAlign; ColorFrom, ColorTo: TColor); overload;
    destructor Destroy; override;

    property Align: TAlign read FAlign write SetAlign;
    property Size: integer read FSize write SetSize;
    property ColorFrom: TColor read FColorFrom write SetColorFrom;
    property ColorTo: TColor read FColorTo write SetColorTo;
  end;

implementation

{ TLine }

constructor TLine.Create(Parent: TPanel);
begin
  FSize := 1;
  FAlign := alTop;
  FDirection := gdHorizontal;
  FColorFrom := clBtnFace;
  FColorTo := clHotLight;

  // Создаем PaintBox
  FLine := TPaintBox.Create(Parent);
  FLine.Parent := Parent;
  FLine.Align := alTop;
  FLine.Height := 1;
  FLine.OnPaint := LinePaint;
end;

constructor TLine.Create(Parent: TPanel; Align: TAlign);
begin
  Create(Parent);
  FLine.Align := alBottom;
end;

constructor TLine.Create(Parent: TPanel; ColorFrom, ColorTo: TColor);
begin
  Create(Parent);
  FColorFrom := ColorFrom;
  FColorTo := ColorTo;
end;

constructor TLine.Create(Parent: TPanel; Align: TAlign; ColorFrom, ColorTo: TColor);
begin
  Create(Parent);
  FLine.Align := alBottom;
  FColorFrom := ColorFrom;
  FColorTo := ColorTo;
end;

destructor TLine.Destroy;
begin
  FLine.Free;
  inherited;
end;

procedure TLine.LinePaint(Sender: TObject);
var
  R: TRect;
  Center: integer;
begin
  case FDirection of
    gdHorizontal:
      begin
        Center := FLine.Width div 2;
        SetRect(R, 0, 0, Center, FLine.Height);
        GradientFillCanvas(FLine.Canvas, FColorFrom, FColorTo, R, FDirection);

        SetRect(R, FLine.Width - Center - 1, 0, FLine.Width, FLine.Height);
        GradientFillCanvas(FLine.Canvas, FColorTo, FColorFrom, R, FDirection);
      end;
    gdVertical:
      begin
        Center := FLine.Height div 2;
        SetRect(R, 0, 0, FLine.Width, Center);
        GradientFillCanvas(FLine.Canvas, FColorFrom, FColorTo, R, FDirection);

        SetRect(R, 0, FLine.Height - Center - 1, FLine.Width, FLine.Height);
        GradientFillCanvas(FLine.Canvas, FColorTo, FColorFrom, R, FDirection);
      end;
  end;
end;

procedure TLine.SetAlign(const Value: TAlign);
begin
  FAlign := Value;
  FLine.Align := FAlign;
end;

procedure TLine.SetColorFrom(const Value: TColor);
begin
  FColorFrom := Value;
  LinePaint(FLine);
end;

procedure TLine.SetColorTo(const Value: TColor);
begin
  FColorTo := Value;
  LinePaint(FLine);
end;

procedure TLine.SetSize(const Value: integer);
begin
  FSize := Value;
  case FAlign of
    alTop, alBottom:
      begin
        FDirection := gdHorizontal;
        FLine.Height := FSize;
      end;
    alLeft, alRight:
      begin
        FDirection := gdVertical;
        FLine.Width := FSize;
      end;
  end;
end;

end.
