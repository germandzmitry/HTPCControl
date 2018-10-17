unit uCustomCategoryPanelGroup;

interface

uses
  Winapi.Windows,
  // Winapi.Messages, Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.Graphics,
  // Vcl.Themes, Vcl.Dialogs, Vcl.GraphUtil,
  Vcl.ExtCtrls,
  System.SysUtils,
  System.Classes;
// uExecuteCommand, System.UITypes;

type
  TCustomCategoryPanelGroup = class(Vcl.ExtCtrls.TCategoryPanelGroup)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

type
  TCustomCategoryPanel = class(Vcl.ExtCtrls.TCategoryPanel)
  private
    procedure DrawHeaderCaption(ACanvas: TCanvas); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawCollapsedPanel(ACanvas: TCanvas); override;
    procedure DrawHeaderBackground(ACanvas: TCanvas); override;
    function GetCollapsedHeight: Integer; override;
  end;

implementation

{ TCategoryPanelGroup }

procedure TCustomCategoryPanelGroup.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style and (not WS_BORDER);
end;

{ TCustomCategoryPanel }

constructor TCustomCategoryPanel.Create(AOwner: TComponent);
begin
  inherited;
  self.BevelOuter := bvNone;
end;

procedure TCustomCategoryPanel.DrawCollapsedPanel(ACanvas: TCanvas);
begin
  // inherited;
end;

procedure TCustomCategoryPanel.DrawHeaderBackground(ACanvas: TCanvas);
begin
  inherited;

end;

procedure TCustomCategoryPanel.DrawHeaderCaption(ACanvas: TCanvas);
begin
  inherited;

end;

function TCustomCategoryPanel.GetCollapsedHeight: Integer;
begin
  Result := HeaderHeight;
end;

end.
