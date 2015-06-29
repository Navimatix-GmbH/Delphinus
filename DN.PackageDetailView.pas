unit DN.PackageDetailView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DN.Package.Intf,
  DN.Controls,
  DN.Controls.Button;

type
  TPackageDetailView = class(TFrame)
    imgRepo: TImage;
    lbTitle: TLabel;
    lbDescription: TLabel;
    lbAuthor: TLabel;
    Label1: TLabel;
    pnlHeader: TPanel;
    pnlDetail: TPanel;
    procedure Button1Click(Sender: TObject);
  private
    FCanvas: TControlCanvas;
    FPackage: IDNPackage;
    FGui: TDNControlsController;
    FBackButton: TDNButton;
    procedure SetPackage(const Value: IDNPackage);
    { Private declarations }
  protected
    procedure PaintWindow(DC: HDC); override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    property Package: IDNPackage read FPackage write SetPackage;
  end;

implementation

{$R *.dfm}

const
  CDelphiNames: array[22..29] of string =
  ('XE', 'XE2', 'XE3', 'XE4', 'XE5', 'XE6', 'XE7', 'XE8');

  function GetDelphiName(const ACompilerVersion: Integer): string;
  begin
    if (ACompilerVersion >= Low(CDelphiNames)) and (ACompilerVersion <= High(CDelphiNames)) then
    begin
      Result := CDelphiNames[ACompilerVersion];
    end
    else
    begin
      Result := 'Compiler ' + IntToStr(ACompilerVersion);
    end;
  end;

  function GenerateSupportsString(const AMin, AMax: Integer): string;
  begin
    if AMin > 0 then
    begin
      if (AMax - AMin) =  0 then
        Result := 'Delphi ' + GetDelphiName(AMin)
      else if (AMax < AMin) then
        Result := 'Delphi ' + GetDelphiName(AMin) + ' and newer'
      else
        Result := 'Delphi ' + GetDelphiName(AMin) + ' to ' + GetDelphiName(AMax);
    end
    else
    begin
      Result := 'Unspecified';
    end;
  end;

{ TFrame1 }

procedure TPackageDetailView.Button1Click(Sender: TObject);
begin
  Visible := False;
end;

constructor TPackageDetailView.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TControlCanvas.Create();
  TControlCanvas(FCanvas).Control := Self;
  FGUI := TDNControlsController.Create();
  FGUI.Parent := Self;
  FBackButton := TDNButton.Create();
  FBackButton.Height := 25;
  FBackButton.Width := 150;
  FBackButton.Caption := 'Back';
  FBackButton.Left := 2;
  FBackButton.OnClick := Button1Click;
  FBackButton.Color := clSilver;
  FBackButton.HoverColor := clSilver;
  FGui.Controls.Add(FBackButton);
end;

destructor TPackageDetailView.Destroy;
begin
  FreeAndNil(FCanvas);
  FreeAndNil(FGUI);
  inherited;
end;

procedure TPackageDetailView.PaintWindow(DC: HDC);
begin
  inherited;
  FCanvas.Lock();
  try
    FCanvas.Handle := DC;
    TControlCanvas(FCanvas).UpdateTextFlags;
    FBackButton.Top := Height - FBackButton.Height - 2;
    FGui.PaintTo(FCanvas);
    FCanvas.Handle := 0;
  finally
    FCanvas.Unlock();
  end;
end;

procedure TPackageDetailView.SetPackage(const Value: IDNPackage);
begin
  FPackage := Value;
  if Assigned(FPackage) then
  begin
    lbTitle.Caption := FPackage.Name;
    lbAuthor.Caption := FPackage.Author;
    lbDescription.Caption := FPackage.Description;
    imgRepo.Picture := FPackage.Picture;
  end
  else
  begin
    lbTitle.Caption := '';
    lbAuthor.Caption := '';
    lbDescription.Caption := '';
    imgRepo.Picture := nil;
  end;
end;

end.