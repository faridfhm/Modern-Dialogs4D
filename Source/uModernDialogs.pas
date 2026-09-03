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
  TAppMessageType = (mtInfo, mtSuccess, mtWarning, mtError, mtQuestion, mtInput);
  TDialogLanguage = (dlEnglish, dlPortugueseBR, dlPersian, dlArabic, dlCustom);

  TDialogTranslation = record
    TitleInfo, TitleSuccess, TitleWarning, TitleError: string;
    TitleConfirm, TitleNotify, TitleInput: string;
    BtnOk, BtnClose, BtnYes, BtnNo, BtnCancel: string;
    CountdownFmt: string;
    BiDiMode: TBiDiMode;
  end;

const
  TRANSLATIONS: array[TDialogLanguage] of TDialogTranslation = (
    (TitleInfo: 'Information'; TitleSuccess: 'Success'; TitleWarning: 'Warning';
     TitleError: 'Error'; TitleConfirm: 'Confirm'; TitleNotify: 'System Message';
     TitleInput: 'Input';
     BtnOk: 'OK'; BtnClose: 'Close'; BtnYes: 'Yes'; BtnNo: 'No'; BtnCancel: 'Cancel';
     CountdownFmt: 'Closing in %d seconds'; BiDiMode: bdLeftToRight),

    (TitleInfo: 'Informação'; TitleSuccess: 'Sucesso'; TitleWarning: 'Aviso';
     TitleError: 'Erro'; TitleConfirm: 'Confirmação'; TitleNotify: 'Mensagem do Sistema';
     TitleInput: 'Entrada';
     BtnOk: 'OK'; BtnClose: 'Fechar'; BtnYes: 'Sim'; BtnNo: 'Não'; BtnCancel: 'Cancelar';
     CountdownFmt: 'Fechando em %d segundos'; BiDiMode: bdLeftToRight),

    (TitleInfo: 'اطلاعات'; TitleSuccess: 'موفقیت'; TitleWarning: 'هشدار';
     TitleError: 'خطا'; TitleConfirm: 'تأیید'; TitleNotify: 'پیام سیستم';
     TitleInput: 'ورود مقدار';
     BtnOk: 'متوجه شدم'; BtnClose: 'بستن'; BtnYes: 'بله'; BtnNo: 'خیر'; BtnCancel: 'لغو';
     CountdownFmt: 'بسته می‌شود در %d ثانیه'; BiDiMode: bdRightToLeft),

    (TitleInfo: 'معلومات'; TitleSuccess: 'نجاح'; TitleWarning: 'تحذير';
     TitleError: 'خطأ'; TitleConfirm: 'تأكيد'; TitleNotify: 'رسالة النظام';
     TitleInput: 'إدخال';
     BtnOk: 'حسناً'; BtnClose: 'إغلاق'; BtnYes: 'نعم'; BtnNo: 'لا'; BtnCancel: 'إلغاء';
     CountdownFmt: 'سيتم الإغلاق خلال %d ثوانٍ'; BiDiMode: bdRightToLeft),

    (TitleInfo: ''; TitleSuccess: ''; TitleWarning: ''; TitleError: '';
     TitleConfirm: ''; TitleNotify: ''; TitleInput: '';
     BtnOk: ''; BtnClose: ''; BtnYes: ''; BtnNo: ''; BtnCancel: '';
     CountdownFmt: ''; BiDiMode: bdLeftToRight)
  );

type
  TAppMessageItemStyle = class(TPersistent)
  private
    FAccentColor, FBadgeColor, FIconColor: Cardinal;
    FIconChar: string;
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
    property BadgeColor: TColor read GetBadgeColor write SetBadgeColor;
    property IconChar: string read FIconChar write FIconChar;
    property IconColor: TColor read GetIconColor write SetIconColor;
  end;

  TModernDialogs = class(TComponent)
  private
    FFont: TFont;
    FBackgroundColor: TColor;
    FLanguage: TDialogLanguage;
    FBiDiMode: TBiDiMode;
    FInfoStyle, FSuccessStyle, FWarningStyle, FErrorStyle, FQuestionStyle, FInputStyle: TAppMessageItemStyle;
    procedure SetFont(const Value: TFont);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetLanguage(const Value: TDialogLanguage);
    procedure SetBiDiMode(const Value: TBiDiMode);
    procedure SetInfoStyle(const Value: TAppMessageItemStyle);
    procedure SetSuccessStyle(const Value: TAppMessageItemStyle);
    procedure SetWarningStyle(const Value: TAppMessageItemStyle);
    procedure SetErrorStyle(const Value: TAppMessageItemStyle);
    procedure SetQuestionStyle(const Value: TAppMessageItemStyle);
    procedure SetInputStyle(const Value: TAppMessageItemStyle);
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
    function InputBox(const ATitle, APrompt: string; const ADefault: string = ''): string;
    procedure ShowNotification(const Msg: string; TimeoutMs: Integer = 3000);
    procedure ShowToast(const Msg: string; AType: TAppMessageType = mtSuccess; TimeoutMs: Integer = 3000);

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
    property StyleInput: TAppMessageItemStyle read FInputStyle write SetInputStyle;
  end;

  TFlatButton = class(TCustomControl)
  private
    FCaption: string;
    FIsHovered, FIsPressed: Boolean;
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
    constructor CreateStyled(AOwner: TComponent; const ACaption: string; AAccent: TColor; AFont: TFont);
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaptionText;
  end;

  TModernInputEdit = class(TEdit)
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TfrmModernDialog = class(TForm)
  private
    FComponent: TModernDialogs;
    FStyle: TAppMessageItemStyle;
    FAccentBar: TPanel;
    pnlClient, pnlHeader, pnlFooter, pnlButtons, pnlBtnContainer: TPanel;
    pbBadge: TPaintBox;
    lblTitle, lblMessage, lblCountdown: TLabel;
    edInput: TModernInputEdit;
    pnlProgressTrack, pnlProgressFill: TPanel;
    FTimer: TTimer;
    FTotalMs, FElapsedMs, FLastSec: Integer;
    FButtons: array of TFlatButton;
    FBtnCount: Integer;
    FIsRTL, FIsInput: Boolean;
    FInputResult: string;

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
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ForceEditColors;
  public
    constructor CreateCustom(AOwner: TComponent; AComp: TModernDialogs);
    destructor Destroy; override;
    function Execute(AMsgType: TAppMessageType; const ATitle, AMessage: string;
      Buttons: array of string; TimeoutMs: Integer = 0; ADefaultButtonIndex: Integer = 0;
      AIsInput: Boolean = False; const ADefaultText: string = ''): Integer;
    property InputResult: string read FInputResult;
procedure ExecuteToast(AMsgType: TAppMessageType; const AMessage: string; TimeoutMs: Integer = 3000);

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
  COLOR_TEXT_DARK      = $00333333;
  COLOR_TEXT_TITLE     = $00333333;
  COLOR_TEXT_MSG       = $00555555;
  COLOR_TEXT_COUNTDOWN = $00999999;
  COLOR_PROGRESS_TRACK = $00F0F0F0;

function AlterColor(C: TColor; Percent: Integer): TColor;
var R, G, B: Byte; ColorRGB: Cardinal; NewR, NewG, NewB: Integer;
begin
  ColorRGB := Cardinal(ColorToRGB(C));
  R := GetRValue(ColorRGB); G := GetGValue(ColorRGB); B := GetBValue(ColorRGB);
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
  Result := TColor(RGB(EnsureRange(NewR, 0, 255), EnsureRange(NewG, 0, 255), EnsureRange(NewB, 0, 255)));
end;

function CalcTextHeight(ACanvas: TCanvas; const AText: string; AWidth: Integer; AFont: TFont): Integer;
var R: TRect;
begin
  ACanvas.Font.Assign(AFont);
  R := Rect(0, 0, AWidth, 0);
  DrawText(ACanvas.Handle, PChar(AText), Length(AText), R, DT_CALCRECT or DT_WORDBREAK or DT_NOPREFIX);
  Result := Max(18, R.Bottom - R.Top);
end;

{ TAppMessageItemStyle }

constructor TAppMessageItemStyle.Create;
begin
  inherited;
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
    inherited;
end;

function TAppMessageItemStyle.GetAccentColor: TColor; begin Result := TColor(FAccentColor); end;
function TAppMessageItemStyle.GetBadgeColor: TColor;  begin Result := TColor(FBadgeColor); end;
function TAppMessageItemStyle.GetIconColor: TColor;   begin Result := TColor(FIconColor); end;
procedure TAppMessageItemStyle.SetAccentColor(const Value: TColor); begin FAccentColor := Cardinal(ColorToRGB(Value)); end;
procedure TAppMessageItemStyle.SetBadgeColor(const Value: TColor);  begin FBadgeColor  := Cardinal(ColorToRGB(Value)); end;
procedure TAppMessageItemStyle.SetIconColor(const Value: TColor);   begin FIconColor   := Cardinal(ColorToRGB(Value)); end;

{ TModernDialogs }

constructor TModernDialogs.Create(AOwner: TComponent);
begin
  inherited;
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
  FInputStyle    := TAppMessageItemStyle.Create;

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

  FInputStyle.AccentColor    := TColor($00C47A32);
  FInputStyle.BadgeColor     := TColor($00E8F0FE);
  FInputStyle.IconColor      := TColor($00C47A32);
  FInputStyle.IconChar       := '⌨';
end;

destructor TModernDialogs.Destroy;
begin
  FFont.Free;
  FInfoStyle.Free;
  FSuccessStyle.Free;
  FWarningStyle.Free;
  FErrorStyle.Free;
  FQuestionStyle.Free;
  FInputStyle.Free;
  inherited;
end;

procedure TModernDialogs.SetFont(const Value: TFont); begin FFont.Assign(Value); end;
procedure TModernDialogs.SetBackgroundColor(const Value: TColor); begin if FBackgroundColor <> Value then FBackgroundColor := Value; end;

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

procedure TModernDialogs.SetInfoStyle(const Value: TAppMessageItemStyle); begin FInfoStyle.Assign(Value); end;
procedure TModernDialogs.SetSuccessStyle(const Value: TAppMessageItemStyle); begin FSuccessStyle.Assign(Value); end;
procedure TModernDialogs.SetWarningStyle(const Value: TAppMessageItemStyle); begin FWarningStyle.Assign(Value); end;
procedure TModernDialogs.SetErrorStyle(const Value: TAppMessageItemStyle); begin FErrorStyle.Assign(Value); end;
procedure TModernDialogs.SetQuestionStyle(const Value: TAppMessageItemStyle); begin FQuestionStyle.Assign(Value); end;
procedure TModernDialogs.SetInputStyle(const Value: TAppMessageItemStyle); begin FInputStyle.Assign(Value); end;

function TModernDialogs.GetTranslation: TDialogTranslation; begin Result := TRANSLATIONS[FLanguage]; end;

function TModernDialogs.GetStyle(AType: TAppMessageType): TAppMessageItemStyle;
begin
  case AType of
    mtInfo:     Result := FInfoStyle;
    mtSuccess:  Result := FSuccessStyle;
    mtWarning:  Result := FWarningStyle;
    mtError:    Result := FErrorStyle;
    mtQuestion: Result := FQuestionStyle;
    mtInput:    Result := FInputStyle;
  else
    Result := FInfoStyle;
  end;
end;

function TModernDialogs.Ask(const ATitle, AMessage: string; AMsgType: TAppMessageType;
  const AButtons: array of string; ADefaultButtonIndex: Integer): Integer;
var frm: TfrmModernDialog; LOwner: TComponent;
begin
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then LOwner := Screen.ActiveForm else LOwner := Application;
  frm := TfrmModernDialog.CreateCustom(LOwner, Self);
  try
    Result := frm.Execute(AMsgType, ATitle, AMessage, AButtons, 0, ADefaultButtonIndex);
  finally
    frm.Free;
  end;
end;

procedure TModernDialogs.Info(const Msg, ATitle: string);
var T: TDialogTranslation; LTitle: string;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleInfo else LTitle := ATitle;
  Ask(LTitle, Msg, mtInfo, [T.BtnOk]);
end;

procedure TModernDialogs.Success(const Msg, ATitle: string);
var T: TDialogTranslation; LTitle: string;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleSuccess else LTitle := ATitle;
  Ask(LTitle, Msg, mtSuccess, [T.BtnOk]);
end;

procedure TModernDialogs.Warning(const Msg, ATitle: string);
var T: TDialogTranslation; LTitle: string;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleWarning else LTitle := ATitle;
  Ask(LTitle, Msg, mtWarning, [T.BtnOk]);
end;

procedure TModernDialogs.Error(const Msg, ATitle: string);
var T: TDialogTranslation; LTitle: string;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleError else LTitle := ATitle;
  Ask(LTitle, Msg, mtError, [T.BtnOk]);
end;

function TModernDialogs.Confirm(const Msg, ATitle: string; ADefaultToNo: Boolean): Boolean;
var T: TDialogTranslation; LTitle: string; Idx: Integer;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleConfirm else LTitle := ATitle;
  if ADefaultToNo then Idx := 1 else Idx := 0;
  Result := Ask(LTitle, Msg, mtQuestion, [T.BtnYes, T.BtnNo], Idx) = 0;
end;

function TModernDialogs.InputBox(const ATitle, APrompt: string; const ADefault: string = ''): string;
var frm: TfrmModernDialog; LOwner: TComponent; LTitle: string; T: TDialogTranslation;
begin
  T := GetTranslation;
  if ATitle = '' then LTitle := T.TitleInput else LTitle := ATitle;
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then LOwner := Screen.ActiveForm else LOwner := Application;
  frm := TfrmModernDialog.CreateCustom(LOwner, Self);
  try
    frm.Execute(mtInput, LTitle, APrompt, [T.BtnYes, T.BtnCancel], 0, 0, True, ADefault);
    Result := frm.InputResult;
  finally
    frm.Free;
  end;
end;

procedure TModernDialogs.ShowNotification(const Msg: string; TimeoutMs: Integer);
var frm: TfrmModernDialog; T: TDialogTranslation; LOwner: TComponent;
begin
  T := GetTranslation;
  if Assigned(Screen) and Assigned(Screen.ActiveForm) then LOwner := Screen.ActiveForm else LOwner := Application;
  frm := TfrmModernDialog.CreateCustom(LOwner, Self);
  try
    frm.Execute(mtInfo, T.TitleNotify, Msg, [], TimeoutMs);
  finally
    frm.Free;
  end;
end;

{ TFlatButton }

constructor TFlatButton.CreateStyled(AOwner: TComponent; const ACaption: string; AAccent: TColor; AFont: TFont);
begin
  inherited Create(AOwner);
  FAccentColor := AAccent;
  FIsHovered := False;
  FIsPressed := False;
  FCaption := ACaption;
  TabStop := True;
  FBtnFont := TFont.Create;
  FBtnFont.Assign(AFont);
  FBtnFont.Style := [fsBold];
  ControlStyle := ControlStyle + [csOpaque];
  Cursor := crHandPoint;
end;

destructor TFlatButton.Destroy;
begin
  FBtnFont.Free;
  inherited;
end;

procedure TFlatButton.SetCaptionText(const Value: string);
begin
  if FCaption <> Value then begin FCaption := Value; Invalidate; end;
end;

procedure TFlatButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_BUTTON or DLGC_WANTALLKEYS;
end;

procedure TFlatButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var TME: TTrackMouseEvent;
begin
  inherited;
  if not FIsHovered then
  begin
    FIsHovered := True;
    if CanFocus and not Focused then SetFocus;
    Invalidate;
    TME.cbSize := SizeOf(TME);
    TME.dwFlags := TME_LEAVE;
    TME.hwndTrack := Handle;
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
    if CanFocus then SetFocus;
    Invalidate;
  end;
end;

procedure TFlatButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var WasPressed: Boolean;
begin
  inherited;
  WasPressed := FIsPressed;
  FIsPressed := False;
  Invalidate;
  if (Button = mbLeft) and WasPressed and PtInRect(ClientRect, Point(X, Y)) then Click;
end;

procedure TFlatButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Key = VK_RETURN) or (Key = VK_SPACE) then begin FIsPressed := True; Invalidate; end;
end;

procedure TFlatButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if ((Key = VK_RETURN) or (Key = VK_SPACE)) and FIsPressed then
  begin
    FIsPressed := False;
    Invalidate;
    Click;
  end;
end;

procedure TFlatButton.DoEnter; begin inherited; Invalidate; end;
procedure TFlatButton.DoExit; begin inherited; FIsPressed := False; Invalidate; end;

procedure TFlatButton.Paint;
var R: TRect; BGColor, BorderColor, TextColor: TColor; IsActive: Boolean;
begin
  R := ClientRect;
  IsActive := FIsHovered or Focused;
  BGColor := clWhite;
  TextColor := TColor(COLOR_TEXT_DARK);
  if FIsPressed then BorderColor := AlterColor(FAccentColor, -15)
  else if IsActive then BorderColor := FAccentColor
  else BorderColor := TColor(COLOR_BORDER_NORMAL);

  Canvas.Brush.Color := BGColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := BorderColor;
  Canvas.Pen.Width := 1;
  Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 6, 6);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FBtnFont);
  Canvas.Font.Color := TextColor;
  DrawText(Canvas.Handle, PChar(FCaption), Length(FCaption), R, DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
end;

{ TModernInputEdit }

constructor TModernInputEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  { The edit remains a real native Windows EDIT control.
    We deliberately keep its painting local to the HWND and do not let
    the dialog's custom painting/theme machinery take over. }
  ParentFont := False;
  ParentColor := False;
  StyleElements := [];
  Ctl3D := False;
  BorderStyle := bsSingle;
  AutoSelect := False;
  HideSelection := False;
  Font.Color := clBlack;
  Color := clWhite;
end;

procedure TModernInputEdit.WndProc(var Message: TMessage);
var
  NeedsRepaint: Boolean;
begin
  NeedsRepaint := False;

  case Message.Msg of
    WM_CHAR, WM_KEYDOWN, WM_KEYUP,
    WM_PASTE, WM_CUT, WM_CLEAR, WM_UNDO, WM_SETTEXT:
      NeedsRepaint := True;
  end;

  inherited WndProc(Message);

  { Some custom borderless/dialog compositions can leave the native EDIT
    text in an invalidated region until another focus/window message occurs.
    Repaint only after messages which can alter the visible edit contents. }
  if NeedsRepaint and HandleAllocated then
  begin
    InvalidateRect(Handle, nil, False);
    UpdateWindow(Handle);
  end;
end;

{ TfrmModernDialog }

constructor TfrmModernDialog.CreateCustom(AOwner: TComponent; AComp: TModernDialogs);
begin
  inherited CreateNew(AOwner);
  FComponent := AComp;
  BorderStyle := bsNone;
  Position := poDesigned;
  Width := 400;
  Height := 200;
  Color := FComponent.BackgroundColor;
  DoubleBuffered := true;
  Font.Assign(FComponent.Font);
  KeyPreview := True;
  FIsInput := False;
  FInputResult := '';
  BiDiMode := bdLeftToRight;
  ParentBiDiMode := False;

  if Assigned(Screen.ActiveForm) then
  begin
    PopupParent := Screen.ActiveForm;
    PopupMode := pmExplicit;
  end
  else if Assigned(Application.MainForm) then
  begin
    PopupParent := Application.MainForm;
    PopupMode := pmExplicit;
  end;

  OnPaint := FormPaint;
  OnResize := FormResize;
  OnShow := FormShow;
  OnKeyDown := FormKeyDown;
end;

destructor TfrmModernDialog.Destroy;
begin
  inherited;
end;

procedure TfrmModernDialog.ApplyNativeShadow;
type
  TDwmMargins = record cxLeftWidth, cxRightWidth, cyTopHeight, cyBottomHeight: Integer; end;
  TDwmIsCompositionEnabledProc = function(out pfEnabled: BOOL): HRESULT; stdcall;
  TDwmExtendFrameIntoClientAreaProc = function(hWnd: HWND; const pMarInset: TDwmMargins): HRESULT; stdcall;
  TDwmSetWindowAttributeProc = function(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT; stdcall;
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
    IsEnabledProc := GetProcAddress(DwmDLL, 'DwmIsCompositionEnabled');
    ExtendProc := GetProcAddress(DwmDLL, 'DwmExtendFrameIntoClientArea');
    SetAttrProc := GetProcAddress(DwmDLL, 'DwmSetWindowAttribute');
    if not Assigned(IsEnabledProc) then Exit;
    CompositionEnabled := False;
    if Failed(IsEnabledProc(CompositionEnabled)) or not CompositionEnabled then Exit;
    if Assigned(ExtendProc) then
    begin
      Margins.cxLeftWidth := -1; Margins.cxRightWidth := -1;
      Margins.cyTopHeight := -1; Margins.cyBottomHeight := -1;
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
var Rgn: HRGN; IsWin11: Boolean;
begin
  IsWin11 := (TOSVersion.Major >= 10) and (TOSVersion.Build >= 22000);
  if not IsWin11 then
  begin
    Rgn := CreateRoundRectRgn(0, 0, Width, Height, DefaultCornerRadius, DefaultCornerRadius);
    if Rgn <> 0 then SetWindowRgn(Handle, Rgn, True);
  end;
  ApplyNativeShadow;
end;

procedure TfrmModernDialog.FormPaint(Sender: TObject);
var R: TRect;
begin
  R := ClientRect;
  Canvas.Brush.Style := bsClear;
  if Assigned(FStyle) then Canvas.Pen.Color := AlterColor(FStyle.AccentColor, -20)
  else Canvas.Pen.Color := TColor(COLOR_BORDER_NORMAL);
  Canvas.Pen.Width := 1;
  Canvas.RoundRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1, DefaultCornerRadius, DefaultCornerRadius);
end;

procedure TfrmModernDialog.FormResize(Sender: TObject);
begin
  CenterButtons;
  if Assigned(pnlProgressFill) and Assigned(pnlProgressTrack) and (FTotalMs > 0) then
    pnlProgressFill.Width := Round(pnlProgressTrack.Width * ((FTotalMs - FElapsedMs) / Max(FTotalMs, 1)));
end;

procedure TfrmModernDialog.FormShow(Sender: TObject);
begin
  CenterButtons;

  if FIsInput then
  begin
    ForceEditColors;
    edInput.HandleNeeded;
    edInput.Invalidate;
    edInput.Update;
    edInput.SetFocus;
    edInput.SelStart := Length(edInput.Text);
    edInput.SelLength := 0;
  end;
end;

procedure TfrmModernDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TfrmModernDialog.ForceEditColors;
begin
  if not Assigned(edInput) then
    Exit;

  { Keep the native EDIT painting isolated from the dialog.
    The specialized TModernInputEdit handles repaint after text messages. }
  edInput.ParentFont := False;
  edInput.ParentColor := False;
  edInput.StyleElements := [];

  edInput.Font.Assign(Font);
  edInput.Font.Style := [];
  edInput.Font.Color := clBlack;
  edInput.Color := clWhite;

  edInput.Ctl3D := False;
  edInput.BorderStyle := bsSingle;

  if FIsRTL then
  begin
    edInput.BiDiMode := bdRightToLeft;
    edInput.Alignment := taRightJustify;
  end
  else
  begin
    edInput.BiDiMode := bdLeftToRight;
    edInput.Alignment := taLeftJustify;
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
  if FIsRTL then FAccentBar.Align := alRight else FAccentBar.Align := alLeft;

  pnlClient := TPanel.Create(Self);
  pnlClient.Parent := Self;
  pnlClient.Align := alClient;
  pnlClient.BevelOuter := bvNone;
  pnlClient.Color := FComponent.BackgroundColor;
  pnlClient.ParentBackground := False;
  pnlClient.Padding.SetBounds(16, 10, 16, 6);

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

  pbBadge := TPaintBox.Create(Self);
  pbBadge.Parent := pnlHeader;
  pbBadge.Width := DefaultBadgeRadius + 16;
  pbBadge.Align := alLeft;
  pbBadge.OnPaint := DrawBadge;

  lblTitle := TLabel.Create(Self);
  lblTitle.Parent := pnlHeader;
  lblTitle.Align := alClient;
  lblTitle.AlignWithMargins := True;
  lblTitle.Font.Assign(Font);
  lblTitle.Font.Size := Font.Size + 3;
  lblTitle.Font.Style := [fsBold];
  lblTitle.Font.Color := TColor(COLOR_TEXT_TITLE);
  lblTitle.Layout := tlCenter;
  if FIsRTL then
  begin
    lblTitle.Alignment := taRightJustify;
    lblTitle.Margins.SetBounds(0, 0, 10, 0);
  end
  else
  begin
    lblTitle.Alignment := taLeftJustify;
    lblTitle.Margins.SetBounds(10, 0, 0, 0);
  end;

  lblMessage := TLabel.Create(Self);
  lblMessage.Parent := pnlClient;
  lblMessage.AlignWithMargins := True;
  lblMessage.WordWrap := True;
  lblMessage.AutoSize := False;
  lblMessage.Font.Assign(Font);
  lblMessage.Font.Color := TColor(COLOR_TEXT_MSG);
  lblMessage.Layout := tlTop;
  if FIsRTL then
  begin
    lblMessage.Alignment := taRightJustify;
    lblMessage.Margins.SetBounds(0, 4, 10, 4);
  end
  else
  begin
    lblMessage.Alignment := taLeftJustify;
    lblMessage.Margins.SetBounds(10, 4, 0, 4);
  end;

  edInput := TModernInputEdit.Create(Self);
  edInput.Parent := pnlClient;
  edInput.Visible := False;
  edInput.Align := alNone;
  edInput.Height := 30;
  edInput.TabOrder := 0;
  edInput.ParentBiDiMode := False;
  edInput.ParentFont := False;
  edInput.ParentColor := False;
  edInput.BorderStyle := bsSingle;
  edInput.Ctl3D := False;
  edInput.AutoSelect := False;
  edInput.HideSelection := False;
  edInput.Font.Assign(Font);
  edInput.Font.Style := [];
  edInput.Font.Color := clBlack;
  edInput.Color := clWhite;

  ForceEditColors;
end;

procedure TfrmModernDialog.BuildNotificationUI;
begin
  lblCountdown := TLabel.Create(Self);
  lblCountdown.Parent := pnlClient;
  lblCountdown.Align := alBottom;
  lblCountdown.Height := 20;
  if FIsRTL then lblCountdown.Alignment := taRightJustify else lblCountdown.Alignment := taLeftJustify;
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
  pnlProgressFill.Height := 4;
end;

procedure TfrmModernDialog.DrawBadge(Sender: TObject);
var CX, CY, R: Integer; TR: TRect;
begin
  CX := pbBadge.Width div 2;
  CY := pbBadge.Height div 2;
  R := DefaultBadgeRadius div 2;
  pbBadge.Canvas.Brush.Color := pnlClient.Color;
  pbBadge.Canvas.FillRect(pbBadge.ClientRect);
  pbBadge.Canvas.Brush.Color := FStyle.BadgeColor;
  pbBadge.Canvas.Pen.Color := FStyle.BadgeColor;
  pbBadge.Canvas.Ellipse(CX - R, CY - R, CX + R, CY + R);
  pbBadge.Canvas.Brush.Style := bsClear;
  pbBadge.Canvas.Font.Assign(Font);
  pbBadge.Canvas.Font.Size := Font.Size + 9;
  pbBadge.Canvas.Font.Style := [fsBold];
  pbBadge.Canvas.Font.Color := FStyle.IconColor;
  TR := Rect(CX - R, CY - R, CX + R, CY + R);
  DrawText(pbBadge.Canvas.Handle, PChar(FStyle.IconChar), Length(FStyle.IconChar), TR, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

procedure TfrmModernDialog.ApplyStyle(AMsgType: TAppMessageType);
begin
  FStyle := FComponent.GetStyle(AMsgType);
  FAccentBar.Color := FStyle.AccentColor;
  if Assigned(pbBadge) then pbBadge.Invalidate;
end;

procedure TfrmModernDialog.CreateButtons(const Buttons: array of string; ADefaultIndex: Integer; out DefaultBtn: TFlatButton);
var i, TotalWidth: Integer; Btn: TFlatButton;
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

  DefaultBtn := nil;
  for i := 0 to High(Buttons) do
  begin
    Btn := TFlatButton.CreateStyled(Self, Buttons[i], FStyle.AccentColor, Font);
    Btn.Parent := pnlBtnContainer;
    Btn.SetBounds(0, 0, BtnWidth, BtnHeight);
    Btn.Tag2 := i;
    Btn.TabOrder := i;
    Btn.OnClick := ButtonClick;
    if FIsRTL then
      Btn.Left := TotalWidth - (i + 1) * (BtnWidth + BtnSpacing) + BtnSpacing
    else
      Btn.Left := i * (BtnWidth + BtnSpacing);
    FButtons[i] := Btn;
    if i = ADefaultIndex then DefaultBtn := Btn;
  end;
  CenterButtons;
end;

procedure TfrmModernDialog.CenterButtons;
begin
  if (pnlBtnContainer = nil) or (pnlButtons = nil) then Exit;
  if pnlButtons.ClientWidth <= 0 then Exit;
  pnlBtnContainer.Left := (pnlButtons.ClientWidth - pnlBtnContainer.Width) div 2;
  pnlBtnContainer.Top := (pnlButtons.ClientHeight - pnlBtnContainer.Height) div 2;
end;

procedure TfrmModernDialog.ButtonClick(Sender: TObject);
begin
  ModalResult := (Sender as TFlatButton).Tag2 + 100;
end;

procedure TfrmModernDialog.TimerTick(Sender: TObject);
begin
  if Assigned(FTimer) then
    FTimer.Enabled := False;

  // اگر Toast است (فوتر مخفی) → ببند و آزاد کن
  if not pnlFooter.Visible then
  begin
    Close;
    Release;          // مهم
  end
  else
  begin
    // حالت Notification معمولی
    ModalResult := mrOk;
  end;
end;

function TfrmModernDialog.Execute(AMsgType: TAppMessageType; const ATitle, AMessage: string;
  Buttons: array of string; TimeoutMs: Integer = 0; ADefaultButtonIndex: Integer = 0;
  AIsInput: Boolean = False; const ADefaultText: string = ''): Integer;
var
  AvailWidth, MsgHeight, ContentHeight, BottomAreaHeight: Integer;
  InitialFocusBtn: TFlatButton;
  LDefaultIndex: Integer;
begin
  FIsInput := AIsInput;
  FInputResult := '';

  BuildUI;
  ApplyStyle(AMsgType);

  lblTitle.Caption := ATitle;
  lblMessage.Caption := AMessage;

  AvailWidth := Width - FAccentBar.Width - pnlClient.Padding.Left - pnlClient.Padding.Right - 28;
  MsgHeight := CalcTextHeight(Canvas, AMessage, AvailWidth, lblMessage.Font);

  if FIsInput then
  begin
    // ترتیب: Header → پیام → Edit
    lblMessage.Align := alNone;
    lblMessage.AutoSize := False;
    lblMessage.Width := pnlClient.ClientWidth - pnlClient.Padding.Left - pnlClient.Padding.Right
                        - lblMessage.Margins.Left - lblMessage.Margins.Right;
    lblMessage.Height := MsgHeight;
    lblMessage.Left := pnlClient.Padding.Left + lblMessage.Margins.Left;
    lblMessage.Top := HeaderRowHeight + 4;

    edInput.Visible := True;
    edInput.Align := alNone;
    edInput.Width := lblMessage.Width;
    edInput.Height := 30;
    edInput.Left := lblMessage.Left;
    edInput.Top := lblMessage.Top + lblMessage.Height + 8;

    edInput.Text := ADefaultText;
    edInput.SelStart := Length(edInput.Text);
    edInput.SelLength := 0;

    ForceEditColors;
    edInput.HandleNeeded;
    edInput.Invalidate;
    edInput.Update;

    ContentHeight := HeaderRowHeight + 4 + MsgHeight + 8 + edInput.Height + 10;
  end
  else
  begin
    edInput.Visible := False;
    edInput.Align := alNone;

    lblMessage.Align := alNone;
    lblMessage.AutoSize := False;
    lblMessage.Width := pnlClient.ClientWidth - pnlClient.Padding.Left - pnlClient.Padding.Right
                        - lblMessage.Margins.Left - lblMessage.Margins.Right;
    lblMessage.Height := MsgHeight;
    lblMessage.Left := pnlClient.Padding.Left + lblMessage.Margins.Left;
    lblMessage.Top := HeaderRowHeight + 4;

    ContentHeight := HeaderRowHeight + 4 + MsgHeight + 10;
  end;

  InitialFocusBtn := nil;

  if TimeoutMs > 0 then
  begin
    pnlFooter.Visible := False;
    BuildNotificationUI;
    BottomAreaHeight := 28;
    FTotalMs := TimeoutMs;
    FElapsedMs := 0;
    FLastSec := Ceil(TimeoutMs / 1000.0) + 1;
    FTimer := TTimer.Create(Self);
    FTimer.Interval := 50;
    FTimer.OnTimer := TimerTick;
    FTimer.Enabled := True;
  end
  else
  begin
    LDefaultIndex := EnsureRange(ADefaultButtonIndex, 0, High(Buttons));
    CreateButtons(Buttons, LDefaultIndex, InitialFocusBtn);
    BottomAreaHeight := pnlFooter.Height;
  end;

  // ارتفاع کاملاً خودکار
  Height := ContentHeight + BottomAreaHeight + pnlClient.Padding.Top + pnlClient.Padding.Bottom;

  if Assigned(Screen.ActiveForm) and (Screen.ActiveForm <> Self) then
  begin
    Left := Screen.ActiveForm.Left + (Screen.ActiveForm.Width - Width) div 2;
    Top := Screen.ActiveForm.Top + (Screen.ActiveForm.Height - Height) div 2;
  end
  else
    Position := poScreenCenter;

  ApplyRoundAndShadow;
  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER or SWP_FRAMECHANGED);
  CenterButtons;

  if FIsInput then
  begin
    ActiveControl := edInput;
    edInput.SetFocus;
    edInput.SelStart := Length(edInput.Text);
    edInput.SelLength := 0;
  end
  else if Assigned(InitialFocusBtn) then
    ActiveControl := InitialFocusBtn;

  ShowModal;

  if FIsInput then
  begin
    if ModalResult = 100 then
      FInputResult := Trim(edInput.Text)
    else
      FInputResult := '';
  end;

  if TimeoutMs > 0 then
    Result := 0
  else if ModalResult = mrCancel then
    Result := Max(0, High(Buttons))
  else
    Result := ModalResult - 100;
end;
procedure TModernDialogs.ShowToast(const Msg: string; AType: TAppMessageType = mtSuccess; TimeoutMs: Integer = 3000);
var
  frm: TfrmModernDialog;
  LOwner: TComponent;
begin
  if Assigned(Screen.ActiveForm) then
    LOwner := Screen.ActiveForm
  else
    LOwner := Application;

  frm := TfrmModernDialog.CreateCustom(LOwner, Self);
  frm.ExecuteToast(AType, Msg, TimeoutMs);
end;
procedure TfrmModernDialog.ExecuteToast(AMsgType: TAppMessageType; const AMessage: string; TimeoutMs: Integer = 3000);
var
  OwnerForm: TCustomForm;
begin
  FIsInput := False;
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Position := poDesigned;
  KeyPreview := True;

  BuildUI;
  ApplyStyle(AMsgType);

  // --- چیدمان یک‌خطی (آیکن + متن) ---
  pnlHeader.Align := alClient;
  pnlHeader.Height := 52;

  lblTitle.Caption := AMessage;
  lblTitle.Visible := True;
  lblTitle.Font.Size := Font.Size;
  lblTitle.Font.Style := [];
  lblTitle.Font.Color := TColor(COLOR_TEXT_MSG);
  lblTitle.Layout := tlCenter;
  lblTitle.AutoSize := False;

  lblMessage.Visible := False;

  pnlFooter.Visible := False;

  Width  := 340;
  Height := 56;

  // ---------- موقعیت دقیق روی فرم والد ----------
  OwnerForm := nil;

  if Assigned(Screen.ActiveForm) and (Screen.ActiveForm <> Self) then
    OwnerForm := Screen.ActiveForm
  else if Assigned(Application.MainForm) then
    OwnerForm := Application.MainForm
  else if (Owner is TCustomForm) and (TCustomForm(Owner) <> Self) then
    OwnerForm := TCustomForm(Owner);

  if OwnerForm <> nil then
  begin
    // بالا سمت راست فرم والد
    if FComponent.BiDiMode = bdRightToLeft then
      Left := OwnerForm.Left + 6
    else
      Left := OwnerForm.Left + OwnerForm.Width - Width - 6;

    Top := OwnerForm.Top + 1;
  end
  else
  begin
    // fallback
    if FComponent.BiDiMode = bdRightToLeft then
      Left := Screen.WorkAreaRect.Left + 6
    else
      Left := Screen.WorkAreaRect.Right - Width - 6;
    Top := Screen.WorkAreaRect.Top + 1;
  end;

  ApplyRoundAndShadow;

  FTotalMs   := TimeoutMs;
  FElapsedMs := 0;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := TimeoutMs;
  FTimer.OnTimer := TimerTick;
  FTimer.Enabled := True;

  Show;
  BringToFront;
end;
end.

