unit uModernDialogs;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Math,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.StdCtrls;

type
  TAppMessageType = (mtInfo, mtSuccess, mtWarning, mtError, mtQuestion);
  TDialogLanguage = (dlEnglish, dlPortugueseBR, dlPersian, dlArabic, dlCustom);

  TDialogTranslation = record
    TitleInfo: string;
    TitleSuccess: string;
    TitleWarning: string;
    TitleError: string;
    TitleConfirm: string;
    TitleNotify: string;
    BtnOk: string;
    BtnClose: string;
    BtnYes: string;
    BtnNo: string;
    CountdownFmt: string;
    BiDiMode: TBiDiMode;
  end;

const
  TRANSLATIONS: array[TDialogLanguage] of TDialogTranslation = (
    { English }
    (TitleInfo: 'Information'; TitleSuccess: 'Success'; TitleWarning: 'Warning';
     TitleError: 'Error'; TitleConfirm: 'Confirm'; TitleNotify: 'System Message';
     BtnOk: 'OK'; BtnClose: 'Close'; BtnYes: 'Yes'; BtnNo: 'No';
     CountdownFmt: 'Closing in %d seconds'; BiDiMode: bdLeftToRight),

    { Portuguese - Brazil }
    (TitleInfo: 'Informação'; TitleSuccess: 'Sucesso'; TitleWarning: 'Aviso';
     TitleError: 'Erro'; TitleConfirm: 'Confirmação'; TitleNotify: 'Mensagem do Sistema';
     BtnOk: 'OK'; BtnClose: 'Fechar'; BtnYes: 'Sim'; BtnNo: 'Não';
     CountdownFmt: 'Fechando em %d segundos'; BiDiMode: bdLeftToRight),

    { Persian }
    (TitleInfo: 'اطلاعات'; TitleSuccess: 'موفقیت'; TitleWarning: 'هشدار';
     TitleError: 'خطا'; TitleConfirm: 'تأیید عملیات'; TitleNotify: 'پیام سیستم';
     BtnOk: 'متوجه شدم'; BtnClose: 'بستن'; BtnYes: 'بله'; BtnNo: 'خیر';
     CountdownFmt: 'بسته می‌شود در %d ثانیه'; BiDiMode: bdRightToLeft),

    { Arabic }
    (TitleInfo: 'معلومات'; TitleSuccess: 'نجاح'; TitleWarning: 'تحذير';
     TitleError: 'خطأ'; TitleConfirm: 'تأكيد'; TitleNotify: 'رسالة النظام';
     BtnOk: 'حسناً'; BtnClose: 'إغلاق'; BtnYes: 'نعم'; BtnNo: 'لا';
     CountdownFmt: 'سيتم الإغلاق خلال %d ثوانٍ'; BiDiMode: bdRightToLeft),

    { Custom }
    (TitleInfo: ''; TitleSuccess: ''; TitleWarning: ''; TitleError: '';
     TitleConfirm: ''; TitleNotify: ''; BtnOk: ''; BtnClose: ''; BtnYes: ''; BtnNo: '';
     CountdownFmt: ''; BiDiMode: bdLeftToRight)
  );

type
  TAppMessageItemStyle = class(TPersistent)
  private
    FAccentColor: Cardinal;
    FBadgeColor: Cardinal;
    FIconChar: string;
    FIconColor: Cardinal;
    procedure SetAccentColor(const Value: TColor);
    procedure SetBadgeColor(const Value: TColor);
    procedure SetIconColor(const Value: TColor);
    function GetAccentColor: TColor;
    function GetBadgeColor: TColor;
    function GetIconColor: TColor;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property AccentColor: TColor read GetAccentColor write SetAccentColor;
    property BadgeColor:  TColor read GetBadgeColor write SetBadgeColor;
    property IconChar:    string read FIconChar write FIconChar;
    property IconColor:   TColor read GetIconColor write SetIconColor;
  end;

  TModernDialogs = class(TComponent)
  private
    FFont: TFont;
    FBackgroundColor: TColor;
    FLanguage: TDialogLanguage;
    FBiDiMode: TBiDiMode;
    FInfoStyle: TAppMessageItemStyle;
    FSuccessStyle: TAppMessageItemStyle;
    FWarningStyle: TAppMessageItemStyle;
    FErrorStyle: TAppMessageItemStyle;
    FQuestionStyle: TAppMessageItemStyle;
    procedure SetFont(const Value: TFont);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetLanguage(const Value: TDialogLanguage);
    procedure SetBiDiMode(const Value: TBiDiMode);
    procedure SetInfoStyle(const Value: TAppMessageItemStyle);
    procedure SetSuccessStyle(const Value: TAppMessageItemStyle);
    procedure SetWarningStyle(const Value: TAppMessageItemStyle);
    procedure SetErrorStyle(const Value: TAppMessageItemStyle);
    procedure SetQuestionStyle(const Value: TAppMessageItemStyle);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetTranslation: TDialogTranslation;
    function GetStyle(AType: TAppMessageType): TAppMessageItemStyle;
    function Ask(const ATitle, AMessage: string; AMsgType: TAppMessageType;
      const AButtons: array of string; ADefaultButtonIndex: Integer = 0): Integer;
    procedure Info(const Msg: string; const ATitle: string = '');
    procedure Success(const Msg: string; const ATitle: string = '');
    procedure Warning(const Msg: string; const ATitle: string = '');
    procedure Error(const Msg: string; const ATitle: string = '');
    function Confirm(const Msg: string; const ATitle: string = ''; ADefaultToNo: Boolean = False): Boolean;
    procedure ShowNotification(const Msg: string; TimeoutMs: Integer = 3000);
  published
    property Font: TFont read FFont write SetFont;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor default clWhite;
    property Language: TDialogLanguage read FLanguage write SetLanguage default dlEnglish;
    property BiDiMode: TBiDiMode read FBiDiMode write SetBiDiMode default bdLeftToRight;
    property StyleInfo: TAppMessageItemStyle read FInfoStyle write SetInfoStyle;
    property StyleSuccess: TAppMessageItemStyle read FSuccessStyle write SetSuccessStyle;
    property StyleWarning: TAppMessageItemStyle read FWarningStyle write SetWarningStyle;
    property StyleError: TAppMessageItemStyle read FErrorStyle write SetErrorStyle;
    property StyleQuestion: TAppMessageItemStyle read FQuestionStyle write SetQuestionStyle;
  end;

  TFlatButton = class(TCustomControl)
  private
    FCaption: string;
    FIsPrimary: Boolean;
    FIsHovered: Boolean;
    FIsPressed: Boolean;
    FAccentColor: TColor;
    FBtnFont: TFont;
    procedure SetCaptionText(const Value: string);
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    Tag2: Integer;
    constructor CreateStyled(AOwner: TComponent; const ACaption: string;
      IsPrimary: Boolean; AAccent: TColor; AFont: TFont);
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaptionText;
  end;

  TfrmModernDialog = class(TForm)
  private
    FComponent: TModernDialogs;
    FStyle: TAppMessageItemStyle;
    FAccentBar: TPanel;
    pnlClient: TPanel;
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    pnlButtons: TPanel;
    pnlBtnContainer: TPanel;
    pbBadge: TPaintBox;
    lblTitle: TLabel;
    lblMessage: TLabel;
    lblCountdown: TLabel;
    pnlProgressTrack: TPanel;
    pnlProgressFill: TPanel;
    FTimer: TTimer;
    FTotalMs: Integer;
    FElapsedMs: Integer;
    FLastSec: Integer;
    FButtons: array of TFlatButton;
    FBtnCount: Integer;
    FIsRTL: Boolean;

    procedure BuildUI;
    procedure BuildNotificationUI;
    procedure ApplyStyle(AMsgType: TAppMessageType);
    procedure DrawBadge(Sender: TObject);
    procedure CreateButtons(const Buttons: array of string; ADefaultIndex: Integer; out DefaultBtn: TFlatButton);
    procedure CenterButtons;
    procedure ButtonClick(Sender: TObject);
    procedure TimerTick(Sender: TObject);
    procedure ApplyRoundAndShadow;
    procedure ApplyNativeShadow;
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor CreateCustom(AOwner: TComponent; AComp: TModernDialogs);
    function Execute(AMsgType: TAppMessageType; const ATitle, AMessage: string;
      Buttons: array of string; TimeoutMs: Integer = 0; ADefaultButtonIndex: Integer = 0): Integer;
  end;

implementation

const
  DefaultCornerRadius = 14;
  DefaultBadgeRadius  = 40;
  HeaderRowHeight     = 52;
  BtnWidth            = 96;
  BtnHeight           = 32;
  BtnSpacing          = 8;

  COLOR_BORDER_NORMAL  = $00D1D5DB;
  COLOR_TEXT_DARK      = $00374151;
  COLOR_TEXT_TITLE     = $00333333;
  COLOR_TEXT_MSG       = $00555555;
  COLOR_TEXT_COUNTDOWN = $00999999;
  COLOR_PROGRESS_TRACK = $00F0F0F0;

function AlterColor(C: TColor; Percent: Integer): TColor;
var
  R, G, B: Byte;
  ColorRGB: Cardinal;
  NewR, NewG, NewB: Integer;
begin
  ColorRGB := Cardinal(ColorToRGB(C));
  R := GetRValue(ColorRGB);
  G := GetGValue(ColorRGB);
  B := GetBValue(ColorRGB);

  if Percent < 0 then
  begin
    NewR := R + MulDiv(R, Percent, 100);
    NewG := G + MulDiv(G, Percent, 100);
    NewB := B + MulDiv(B, Percent, 100);
  end
  else
  begin
    NewR := R + MulDiv(255 - R, Percent, 100);
    NewG := G + MulDiv(255 - G, Percent, 100);
    NewB := B + MulDiv(255 - B, Percent, 100);
  end;

  R := System.Math.EnsureRange(NewR, 0, 255);
  G := System.Math.EnsureRange(NewG, 0, 255);
  B := System.Math.EnsureRange(NewB, 0, 255);
  Result := TColor(RGB(R, G, B));
end;

function CalcTextHeight(ACanvas: TCanvas; const AText: string; AWidth: Integer; AFont: TFont): Integer;
var
  R: TRect;
begin
  ACanvas.Font.Assign(AFont);
  R := Rect(0, 0, AWidth, 0);
  Winapi.Windows.DrawText(ACanvas.Handle, PChar(AText), Length(AText), R,
    DT_CALCRECT or DT_WORDBREAK or DT_NOPREFIX);
  Result := R.Bottom - R.Top;
end;

{ TAppMessageItemStyle }

constructor TAppMessageItemStyle.Create;
begin
  inherited Create;
end;

procedure TAppMessageItemStyle.Assign(Source: TPersistent);
begin
  if Source is TAppMessageItemStyle then
  begin
    FAccentColor := TAppMessageItemStyle(Source).FAccentColor;
    FBadgeColor  := TAppMessageItemStyle(Source).FBadgeColor;
    FIconChar    := TAppMessageItemStyle(Source).FIconChar;
    FIconColor   := TAppMessageItemStyle(Source).FIconColor;
  end
  else
    inherited Assign(Source);
end;

function TAppMessageItemStyle.GetAccentColor: TColor;
begin
  Result := TColor(FAccentColor);
end;

function TAppMessageItemStyle.GetBadgeColor: TColor;
begin
  Result := TColor(FBadgeColor);
end;

function TAppMessageItemStyle.GetIconColor: TColor;
begin
  Result := TColor(FIconColor);
end;

procedure TAppMessageItemStyle.SetAccentColor(const Value: TColor);
begin
  FAccentColor := Cardinal(ColorToRGB(Value));
end;

procedure TAppMessageItemStyle.SetBadgeColor(const Value: TColor);
begin
  FBadgeColor := Cardinal(ColorToRGB(Value));
end;

procedure TAppMessageItemStyle.SetIconColor(const Value: TColor);
begin
  FIconColor := Cardinal(ColorToRGB(Value));
end;

{ TModernDialogs }

constructor TModernDialogs.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackgroundColor := clWhite;
  FLanguage := dlEnglish;
  FBiDiMode := bdLeftToRight;

  FFont := TFont.Create;
  if (Screen <> nil) and (Screen.MessageFont.Name <> '') then
    FFont.Name := Screen.MessageFont.Name
  else
    FFont.Name := 'Segoe UI';
  FFont.Size := 9;

  FInfoStyle     := TAppMessageItemStyle.Create;
  FSuccessStyle  := TAppMessageItemStyle.Create;
  FWarningStyle  := TAppMessageItemStyle.Create;
  FErrorStyle    := TAppMessageItemStyle.Create;
  FQuestionStyle := TAppMessageItemStyle.Create;

  FInfoStyle.AccentColor     := TColor($00D97706);
  FInfoStyle.BadgeColor      := TColor($00FBEEDD);
  FInfoStyle.IconColor       := TColor($00D97706);
  FInfoStyle.IconChar        := 'i';

  FSuccessStyle.AccentColor  := TColor($0057A64C);
  FSuccessStyle.BadgeColor   := TColor($00E1F2DE);
  FSuccessStyle.IconColor    := TColor($0057A64C);
  FSuccessStyle.IconChar     := '✔';

  FWarningStyle.AccentColor  := TColor($000099E6);
  FWarningStyle.BadgeColor   := TColor($00D8F1FF);
  FWarningStyle.IconColor    := TColor($000099E6);
  FWarningStyle.IconChar     := '⚠';

  FErrorStyle.AccentColor    := TColor($003838DC);
  FErrorStyle.BadgeColor     := TColor($00DEDEFB);
  FErrorStyle.IconColor      := TColor($003838DC);
  FErrorStyle.IconChar       := '✘';

  FQuestionStyle.AccentColor := TColor($00AAAA00);
  FQuestionStyle.BadgeColor  := TColor($00FFFFC8);
  FQuestionStyle.IconColor   := TColor($00AAAA00);
  FQuestionStyle.IconChar    := '؟';
end;

destructor TModernDialogs.Destroy;
begin
  FFont.Free;
  FInfoStyle.Free;
  FSuccessStyle.Free;
  FWarningStyle.Free;
  FErrorStyle.Free;
  FQuestionStyle.Free;
  inherited Destroy;
end;

procedure TModernDialogs.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TModernDialogs.SetBackgroundColor(const Value: TColor);
begin
  if FBackgroundColor <> Value then
    FBackgroundColor := Value;
end;

procedure TModernDialogs.SetLanguage(const Value: TDialogLanguage);
begin
  if FLanguage <> Value then
  begin
    FLanguage := Value;
    if FLanguage <> dlCustom then
      FBiDiMode := TRANSLATIONS[FLanguage].BiDiMode;
  end;
end;

procedure TModernDialogs.SetBiDiMode(const Value: TBiDiMode);
begin
  if FBiDiMode <> Value then
  begin
    FBiDiMode := Value;
    FLanguage := dlCustom;
  end;
end;

procedure TModernDialogs.SetInfoStyle(const Value: TAppMessageItemStyle);
begin
  FInfoStyle.Assign(Value);
end;

procedure TModernDialogs.SetSuccessStyle(const Value: TAppMessageItemStyle);
begin
  FSuccessStyle.Assign(Value);
end;

procedure TModernDialogs.SetWarningStyle(const Value: TAppMessageItemStyle);
begin
  FWarningStyle.Assign(Value);
end;

procedure TModernDialogs.SetErrorStyle(const Value: TAppMessageItemStyle);
begin
  FErrorStyle.Assign(Value);
end;

procedure TModernDialogs.SetQuestionStyle(const Value: TAppMessageItemStyle);
begin
  FQuestionStyle.Assign(Value);
end;

function TModernDialogs.GetTranslation: TDialogTranslation;
begin
  Result := TRANSLATIONS[FLanguage];
end;

function TModernDialogs.GetStyle(AType: TAppMessageType): TAppMessageItemStyle;
begin
  case AType of
    mtInfo:     Result := FInfoStyle;
    mtSuccess:  Result := FSuccessStyle;
    mtWarning:  Result := FWarningStyle;
    mtError:    Result := FErrorStyle;
    mtQuestion: Result := FQuestionStyle;
  else
    Result := FInfoStyle;
  end;
end;

function TModernDialogs.Ask(const ATitle, AMessage: string; AMsgType: TAppMessageType;
  const AButtons: array of string; ADefaultButtonIndex: Integer): Integer;
var
  frm: TfrmModernDialog;
  LOwner: TComponent;
begin
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then
    LOwner := Screen.ActiveForm
  else
    LOwner := Application;

  frm := TfrmModernDialog.CreateCustom(LOwner, Self);
  try
    Result := frm.Execute(AMsgType, ATitle, AMessage, AButtons, 0, ADefaultButtonIndex);
  finally
    frm.Free;
  end;
end;

procedure TModernDialogs.Info(const Msg, ATitle: string);
var
  LTitle: string;
  T: TDialogTranslation;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleInfo else LTitle := ATitle;
  Ask(LTitle, Msg, mtInfo, [T.BtnOk]);
end;

procedure TModernDialogs.Success(const Msg, ATitle: string);
var
  LTitle: string;
  T: TDialogTranslation;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleSuccess else LTitle := ATitle;
  Ask(LTitle, Msg, mtSuccess, [T.BtnOk]);
end;

procedure TModernDialogs.Warning(const Msg, ATitle: string);
var
  LTitle: string;
  T: TDialogTranslation;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleWarning else LTitle := ATitle;
  Ask(LTitle, Msg, mtWarning, [T.BtnOk]);
end;

procedure TModernDialogs.Error(const Msg, ATitle: string);
var
  LTitle: string;
  T: TDialogTranslation;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleError else LTitle := ATitle;
  Ask(LTitle, Msg, mtError, [T.BtnOk]);
end;

function TModernDialogs.Confirm(const Msg, ATitle: string; ADefaultToNo: Boolean): Boolean;
var
  LTitle: string;
  T: TDialogTranslation;
  LDefaultIndex: Integer;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleConfirm else LTitle := ATitle;
  if ADefaultToNo then LDefaultIndex := 1 else LDefaultIndex := 0;
  Result := Ask(LTitle, Msg, mtQuestion, [T.BtnYes, T.BtnNo], LDefaultIndex) = 0;
end;

procedure TModernDialogs.ShowNotification(const Msg: string; TimeoutMs: Integer);
var
  frm: TfrmModernDialog;
  T: TDialogTranslation;
  LOwner: TComponent;
begin
  T := GetTranslation;
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then
    LOwner := Screen.ActiveForm
  else
    LOwner := Application;

  frm := TfrmModernDialog.CreateCustom(LOwner, Self);
  try
    frm.Execute(mtInfo, T.TitleNotify, Msg, [], TimeoutMs);
  finally
    frm.Free;
  end;
end;

{ TFlatButton }

constructor TFlatButton.CreateStyled(AOwner: TComponent; const ACaption: string;
  IsPrimary: Boolean; AAccent: TColor; AFont: TFont);
begin
  inherited Create(AOwner);
  FIsPrimary   := IsPrimary;
  FAccentColor := AAccent;
  FIsHovered   := False;
  FIsPressed   := False;
  FCaption     := ACaption;
  TabStop      := True;

  FBtnFont := TFont.Create;
  FBtnFont.Assign(AFont);
  FBtnFont.Style := [fsBold];

  ControlStyle := ControlStyle + [csOpaque];
  Cursor := crHandPoint;
end;

destructor TFlatButton.Destroy;
begin
  FBtnFont.Free;
  inherited Destroy;
end;

procedure TFlatButton.SetCaptionText(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;

procedure TFlatButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_BUTTON or DLGC_WANTALLKEYS;
end;

procedure TFlatButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  TME: TTrackMouseEvent;
begin
  inherited;
  if not FIsHovered then
  begin
    FIsHovered := True;
    if CanFocus and not Focused then
      SetFocus;
    Invalidate;

    TME.cbSize      := SizeOf(TME);
    TME.dwFlags     := TME_LEAVE;
    TME.hwndTrack   := Handle;
    TME.dwHoverTime := 0;
    TrackMouseEvent(TME);
  end;
end;

procedure TFlatButton.WMMouseLeave(var Message: TMessage);
begin
  inherited;
  FIsHovered := False;
  Invalidate;
end;

procedure TFlatButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
  begin
    FIsPressed := True;
    if CanFocus then
      SetFocus;
    Invalidate;
  end;
end;

procedure TFlatButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  WasPressed: Boolean;
begin
  inherited;
  WasPressed := FIsPressed;
  FIsPressed := False;
  Invalidate;
  if (Button = mbLeft) and WasPressed and PtInRect(ClientRect, Point(X, Y)) then
    Click;
end;

procedure TFlatButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    FIsPressed := True;
    Invalidate;
  end;
end;

procedure TFlatButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    if FIsPressed then
    begin
      FIsPressed := False;
      Invalidate;
      Click;
    end;
  end;
end;

procedure TFlatButton.DoEnter;
begin
  inherited DoEnter;
  Invalidate;
  Repaint;
end;

procedure TFlatButton.DoExit;
begin
  inherited DoExit;
  FIsPressed := False;
  Invalidate;
  Repaint;
end;

procedure TFlatButton.Paint;
var
  R: TRect;
  BGColor, BorderColor, TextColor: TColor;
  IsActive: Boolean;
begin
  R := ClientRect;
  IsActive := FIsHovered or Focused;

  { همه دکمه‌ها یکسان (بدون Primary پررنگ) }
  BGColor   := clWhite;
  TextColor := TColor(COLOR_TEXT_DARK);

  if FIsPressed then
    BorderColor := AlterColor(FAccentColor, -15)
  else if IsActive then
    BorderColor := FAccentColor
  else
    BorderColor := TColor(COLOR_BORDER_NORMAL);

  Canvas.Brush.Color := BGColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color   := BorderColor;
  Canvas.Pen.Width   := 1;
  Canvas.Pen.Style   := psSolid;
  Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 6, 6);

  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FBtnFont);
  Canvas.Font.Color := TextColor;
  Winapi.Windows.DrawText(Canvas.Handle, PChar(FCaption), Length(FCaption), R,
    DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
end;

{ TfrmModernDialog }

constructor TfrmModernDialog.CreateCustom(AOwner: TComponent; AComp: TModernDialogs);
begin
  inherited CreateNew(AOwner);
  FComponent := AComp;
  BorderStyle := bsNone;
  Position := poDesigned;
  Width := 380;
  Height := 220;
  Color := FComponent.BackgroundColor;
  DoubleBuffered := True;
  Font.Assign(FComponent.Font);
  KeyPreview := True;

  BiDiMode := bdLeftToRight;
  ParentBiDiMode := False;

  if Assigned(Screen.ActiveForm) then
  begin
    PopupParent := Screen.ActiveForm;
    PopupMode   := pmExplicit;
  end
  else if Assigned(Application.MainForm) then
  begin
    PopupParent := Application.MainForm;
    PopupMode   := pmExplicit;
  end;

  OnPaint   := FormPaint;
  OnResize  := FormResize;
  OnKeyDown := FormKeyDown;
end;

procedure TfrmModernDialog.ApplyNativeShadow;
type
  TDwmMargins = record
    cxLeftWidth, cxRightWidth, cyTopHeight, cyBottomHeight: Integer;
  end;
  TDwmIsCompositionEnabledProc = function(out pfEnabled: BOOL): HRESULT; stdcall;
  TDwmExtendFrameIntoClientAreaProc = function(hWnd: HWND; const pMarInset: TDwmMargins): HRESULT; stdcall;
  TDwmSetWindowAttributeProc = function(hwnd: HWND; dwAttribute: DWORD;
    pvAttribute: Pointer; cbAttribute: DWORD): HRESULT; stdcall;
const
  DWMWA_WINDOW_CORNER_PREFERENCE = 33;
  DWMWCP_ROUND = 2;
var
  DwmDLL: HMODULE;
  IsEnabledProc: TDwmIsCompositionEnabledProc;
  ExtendProc: TDwmExtendFrameIntoClientAreaProc;
  SetAttrProc: TDwmSetWindowAttributeProc;
  Margins: TDwmMargins;
  CompositionEnabled: BOOL;
  CornerPref: Integer;
begin
  DwmDLL := LoadLibrary('dwmapi.dll');
  if DwmDLL = 0 then Exit;
  try
    IsEnabledProc := TDwmIsCompositionEnabledProc(GetProcAddress(DwmDLL, 'DwmIsCompositionEnabled'));
    ExtendProc    := TDwmExtendFrameIntoClientAreaProc(GetProcAddress(DwmDLL, 'DwmExtendFrameIntoClientArea'));
    SetAttrProc   := TDwmSetWindowAttributeProc(GetProcAddress(DwmDLL, 'DwmSetWindowAttribute'));

    if not Assigned(IsEnabledProc) then Exit;

    CompositionEnabled := False;
    if Failed(IsEnabledProc(CompositionEnabled)) or not CompositionEnabled then Exit;

    if Assigned(ExtendProc) then
    begin
      Margins.cxLeftWidth    := -1;
      Margins.cxRightWidth   := -1;
      Margins.cyTopHeight    := -1;
      Margins.cyBottomHeight := -1;
      ExtendProc(Handle, Margins);
    end;

    if Assigned(SetAttrProc) then
    begin
      CornerPref := DWMWCP_ROUND;
      SetAttrProc(Handle, DWMWA_WINDOW_CORNER_PREFERENCE, @CornerPref, SizeOf(CornerPref));
    end;
  finally
    FreeLibrary(DwmDLL);
  end;
end;

procedure TfrmModernDialog.ApplyRoundAndShadow;
var
  Rgn: HRGN;
  IsWin11: Boolean;
begin
  IsWin11 := (TOSVersion.Major >= 10) and (TOSVersion.Build >= 22000);

  if not IsWin11 then
  begin
    Rgn := CreateRoundRectRgn(0, 0, Width, Height, DefaultCornerRadius, DefaultCornerRadius);
    if Rgn <> 0 then
      SetWindowRgn(Handle, Rgn, True);
  end;

  ApplyNativeShadow;
end;

procedure TfrmModernDialog.FormPaint(Sender: TObject);
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.Brush.Style := bsClear;

  if Assigned(FStyle) then
    Canvas.Pen.Color := AlterColor(FStyle.AccentColor, -20)
  else
    Canvas.Pen.Color := TColor(COLOR_BORDER_NORMAL);

  Canvas.Pen.Width := 1;
  Canvas.Pen.Style := psSolid;
  Canvas.RoundRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1, DefaultCornerRadius, DefaultCornerRadius);
end;

procedure TfrmModernDialog.FormResize(Sender: TObject);
begin
  CenterButtons;
  if Assigned(pnlProgressFill) and Assigned(pnlProgressTrack) and (FTotalMs > 0) then
    pnlProgressFill.Width := Round(pnlProgressTrack.Width * ((FTotalMs - FElapsedMs) / Max(FTotalMs, 1)));
end;

procedure TfrmModernDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  { فقط Escape را هندل می‌کنیم.
    جابه‌جایی با کلیدهای جهت‌دار و Tab توسط رفتار پیش‌فرض VCL انجام می‌شود
    (چون دکمه‌ها TabStop دارند و DLGC_WANTALLKEYS تنظیم شده). }
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TfrmModernDialog.BuildUI;
begin
  FIsRTL := (FComponent.BiDiMode = bdRightToLeft);

  FAccentBar := TPanel.Create(Self);
  FAccentBar.Parent := Self;
  FAccentBar.Width := 6;
  FAccentBar.BevelOuter := bvNone;
  FAccentBar.ParentBackground := False;
  if FIsRTL then
    FAccentBar.Align := alRight
  else
    FAccentBar.Align := alLeft;

  pnlClient := TPanel.Create(Self);
  pnlClient.Parent := Self;
  pnlClient.Align := alClient;
  pnlClient.BevelOuter := bvNone;
  pnlClient.Color := FComponent.BackgroundColor;
  pnlClient.ParentBackground := False;
  pnlClient.Padding.Left := 16;
  pnlClient.Padding.Right := 16;
  pnlClient.Padding.Top := 12;

  pnlFooter := TPanel.Create(Self);
  pnlFooter.Parent := Self;
  pnlFooter.Align := alBottom;
  pnlFooter.Height := 52;
  pnlFooter.BevelOuter := bvNone;
  pnlFooter.Color := AlterColor(FComponent.BackgroundColor, -3);
  pnlFooter.ParentBackground := False;

  pnlButtons := TPanel.Create(Self);
  pnlButtons.Parent := pnlFooter;
  pnlButtons.Align := alClient;
  pnlButtons.BevelOuter := bvNone;
  pnlButtons.Color := pnlFooter.Color;
  pnlButtons.ParentBackground := False;

  pnlHeader := TPanel.Create(Self);
  pnlHeader.Parent := pnlClient;
  pnlHeader.Align := alTop;
  pnlHeader.Height := HeaderRowHeight;
  pnlHeader.BevelOuter := bvNone;
  pnlHeader.Color := pnlClient.Color;
  pnlHeader.ParentBackground := False;

  { Badge همیشه سمت چپ (حالت قبلی) }
  pbBadge := TPaintBox.Create(Self);
  pbBadge.Parent := pnlHeader;
  pbBadge.Width := DefaultBadgeRadius + 16;
  pbBadge.OnPaint := DrawBadge;
  pbBadge.Align := alLeft;

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := pnlHeader;
  lblTitle.Font.Assign(Font);
  lblTitle.Font.Size := Font.Size + 3;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := TColor(COLOR_TEXT_TITLE);
  lblTitle.Layout := tlCenter;
  lblTitle.AlignWithMargins := True;
  lblTitle.Align := alClient;

  if FIsRTL then
  begin
    lblTitle.Alignment := taRightJustify;
    lblTitle.Margins.Left := 0;
    lblTitle.Margins.Right := 10;
  end
  else
  begin
    lblTitle.Alignment := taLeftJustify;
    lblTitle.Margins.Left := 10;
    lblTitle.Margins.Right := 0;
  end;

  lblMessage := TLabel.Create(Self);
  lblMessage.Parent := pnlClient;
  lblMessage.Align := alClient;
  lblMessage.AlignWithMargins := True;
  lblMessage.WordWrap := True;
  lblMessage.Font.Assign(Font);
  lblMessage.Font.Color := TColor(COLOR_TEXT_MSG);
  lblMessage.Layout := tlTop;

  if FIsRTL then
  begin
    lblMessage.Alignment := taRightJustify;
    lblMessage.Margins.Left := 0;
    lblMessage.Margins.Right := 10;
    lblMessage.Margins.Top := 2;
    lblMessage.Margins.Bottom := 12;
  end
  else
  begin
    lblMessage.Alignment := taLeftJustify;
    lblMessage.Margins.Left := 10;
    lblMessage.Margins.Right := 0;
    lblMessage.Margins.Top := 2;
    lblMessage.Margins.Bottom := 12;
  end;
end;

procedure TfrmModernDialog.BuildNotificationUI;
begin
  lblCountdown := TLabel.Create(Self);
  lblCountdown.Parent := pnlClient;
  lblCountdown.Align := alBottom;
  lblCountdown.Height := 22;
  if FIsRTL then
    lblCountdown.Alignment := taRightJustify
  else
    lblCountdown.Alignment := taLeftJustify;
  lblCountdown.Layout := tlCenter;
  lblCountdown.Font.Assign(Font);
  lblCountdown.Font.Size := Font.Size - 1;
  lblCountdown.Font.Color := TColor(COLOR_TEXT_COUNTDOWN);

  pnlProgressTrack := TPanel.Create(Self);
  pnlProgressTrack.Parent := Self;
  pnlProgressTrack.Align := alBottom;
  pnlProgressTrack.Height := 4;
  pnlProgressTrack.BevelOuter := bvNone;
  pnlProgressTrack.Color := TColor(COLOR_PROGRESS_TRACK);
  pnlProgressTrack.ParentBackground := False;

  pnlProgressFill := TPanel.Create(Self);
  pnlProgressFill.Parent := pnlProgressTrack;
  pnlProgressFill.BevelOuter := bvNone;
  pnlProgressFill.ParentBackground := False;
  pnlProgressFill.Color := FStyle.AccentColor;
  pnlProgressFill.Top := 0;
  pnlProgressFill.Height := 4;
  pnlProgressFill.Left := 0;
  pnlProgressFill.Width := pnlProgressTrack.Width;
end;

procedure TfrmModernDialog.DrawBadge(Sender: TObject);
var
  CX, CY, R: Integer;
  TextRect: TRect;
begin
  CX := pbBadge.Width div 2;
  CY := pbBadge.Height div 2;
  R  := DefaultBadgeRadius div 2;

  pbBadge.Canvas.Brush.Color := pnlClient.Color;
  pbBadge.Canvas.FillRect(pbBadge.ClientRect);

  pbBadge.Canvas.Brush.Color := FStyle.BadgeColor;
  pbBadge.Canvas.Pen.Color   := FStyle.BadgeColor;
  pbBadge.Canvas.Ellipse(CX - R, CY - R, CX + R, CY + R);

  pbBadge.Canvas.Brush.Style := bsClear;
  pbBadge.Canvas.Font.Assign(Font);
  pbBadge.Canvas.Font.Size   := Font.Size + 9;
  pbBadge.Canvas.Font.Style  := [fsBold];
  pbBadge.Canvas.Font.Color  := FStyle.IconColor;

  TextRect := Rect(CX - R, CY - R, CX + R, CY + R);
  Winapi.Windows.DrawText(pbBadge.Canvas.Handle, PChar(FStyle.IconChar),
    Length(FStyle.IconChar), TextRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

procedure TfrmModernDialog.ApplyStyle(AMsgType: TAppMessageType);
begin
  FStyle := FComponent.GetStyle(AMsgType);
  FAccentBar.Color := FStyle.AccentColor;
  if Assigned(pbBadge) then
    pbBadge.Invalidate;
end;

procedure TfrmModernDialog.CreateButtons(const Buttons: array of string;
  ADefaultIndex: Integer; out DefaultBtn: TFlatButton);
var
  i: Integer;
  Btn: TFlatButton;
  TotalWidth: Integer;
begin
  FBtnCount := Length(Buttons);
  SetLength(FButtons, FBtnCount);

  TotalWidth := FBtnCount * (BtnWidth + BtnSpacing) - BtnSpacing;

  pnlBtnContainer := TPanel.Create(Self);
  pnlBtnContainer.Parent := pnlButtons;
  pnlBtnContainer.BevelOuter := bvNone;
  pnlBtnContainer.Width := TotalWidth;
  pnlBtnContainer.Height := BtnHeight;
  pnlBtnContainer.Color := pnlButtons.Color;
  pnlBtnContainer.ParentBackground := False;
  pnlBtnContainer.Anchors := [];

  DefaultBtn := nil;

  for i := 0 to High(Buttons) do
  begin
    { IsPrimary فقط برای فوکوس اولیه استفاده می‌شود، ظاهر همه یکسان است }
    Btn := TFlatButton.CreateStyled(Self, Buttons[i], (i = ADefaultIndex), FStyle.AccentColor, Font);
    Btn.Parent := pnlBtnContainer;
    Btn.Width := BtnWidth;
    Btn.Height := BtnHeight;
    Btn.Tag2 := i;
    Btn.TabOrder := i;
    Btn.OnClick := ButtonClick;

    if FIsRTL then
      Btn.Left := TotalWidth - (i + 1) * (BtnWidth + BtnSpacing) + BtnSpacing
    else
      Btn.Left := i * (BtnWidth + BtnSpacing);

    FButtons[i] := Btn;

    if i = ADefaultIndex then
      DefaultBtn := Btn;
  end;

  CenterButtons;
end;

procedure TfrmModernDialog.CenterButtons;
begin
  if (pnlBtnContainer = nil) or (pnlButtons = nil) then Exit;

  pnlBtnContainer.Left := (pnlButtons.Width - pnlBtnContainer.Width) div 2;
  pnlBtnContainer.Top  := (pnlButtons.Height - pnlBtnContainer.Height) div 2;
end;

procedure TfrmModernDialog.ButtonClick(Sender: TObject);
begin
  ModalResult := (Sender as TFlatButton).Tag2 + 100;
end;

procedure TfrmModernDialog.TimerTick(Sender: TObject);
var
  RemainingMs, RemainingSec: Integer;
begin
  Inc(FElapsedMs, FTimer.Interval);
  RemainingMs := FTotalMs - FElapsedMs;

  if RemainingMs <= 0 then
  begin
    FTimer.Enabled := False;
    ModalResult := mrOk;
    Exit;
  end;

  if Assigned(pnlProgressFill) and Assigned(pnlProgressTrack) then
    pnlProgressFill.Width := Round(pnlProgressTrack.Width * (RemainingMs / FTotalMs));

  RemainingSec := Ceil(RemainingMs / 1000.0);
  if RemainingSec <> FLastSec then
  begin
    FLastSec := RemainingSec;
    lblCountdown.Caption := Format(FComponent.GetTranslation.CountdownFmt, [RemainingSec]);
  end;
end;

function TfrmModernDialog.Execute(AMsgType: TAppMessageType; const ATitle, AMessage: string;
  Buttons: array of string; TimeoutMs: Integer = 0; ADefaultButtonIndex: Integer = 0): Integer;
var
  AvailWidth, MsgHeight, ContentHeight, BottomAreaHeight: Integer;
  InitialFocusBtn: TFlatButton;
  LDefaultIndex: Integer;
begin
  BuildUI;
  ApplyStyle(AMsgType);

  lblTitle.Caption   := ATitle;
  lblMessage.Caption := AMessage;

  AvailWidth := Self.Width - FAccentBar.Width - pnlClient.Padding.Left -
                pnlClient.Padding.Right - 20;
  MsgHeight := CalcTextHeight(Self.Canvas, AMessage, AvailWidth, lblMessage.Font);
  ContentHeight := pnlClient.Padding.Top + HeaderRowHeight + lblMessage.Margins.Top +
                   MsgHeight + lblMessage.Margins.Bottom;

  InitialFocusBtn := nil;

  if TimeoutMs > 0 then
  begin
    pnlFooter.Visible := False;
    BuildNotificationUI;
    BottomAreaHeight := 30;
    FTotalMs   := TimeoutMs;
    FElapsedMs := 0;
    FLastSec   := Ceil(TimeoutMs / 1000.0) + 1;

    FTimer := TTimer.Create(Self);
    FTimer.Interval := 50;
    FTimer.OnTimer := TimerTick;
    FTimer.Enabled := True;
  end
  else
  begin
    LDefaultIndex := System.Math.EnsureRange(ADefaultButtonIndex, 0, High(Buttons));
    CreateButtons(Buttons, LDefaultIndex, InitialFocusBtn);
    BottomAreaHeight := pnlFooter.Height;
  end;

  Self.Height := Max(160, ContentHeight + BottomAreaHeight);

  if Assigned(Screen.ActiveForm) and (Screen.ActiveForm <> Self) then
  begin
    Left := Screen.ActiveForm.Left + (Screen.ActiveForm.Width - Width) div 2;
    Top  := Screen.ActiveForm.Top  + (Screen.ActiveForm.Height - Height) div 2;
  end
  else
    Position := poScreenCenter;

  ApplyRoundAndShadow;

  SetWindowPos(Handle, 0, 0, 0, 0, 0,
    SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED);

  CenterButtons;

  if Assigned(InitialFocusBtn) then
    ActiveControl := InitialFocusBtn;

  ShowModal;

  if TimeoutMs > 0 then
    Result := 0
  else if ModalResult = mrCancel then
    Result := Max(0, High(Buttons))
  else
    Result := ModalResult - 100;
end;

end.
