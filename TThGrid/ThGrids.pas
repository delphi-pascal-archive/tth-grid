{ ThGrids
  auteur : ThWilliam
  mai 2008}

unit ThGrids;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, StdCtrls, Math;

type

  TTHGridTextEllipsis = (teNone, teEndEllipsis, tePathEllipsis);
  TTHGridGradationType = (gtNone, gtHorizontal, gtVertical);
  TTHGridVertAlignment = (vaBottom, vaCenter, vaTop);

  TTHBasicGrid = class;

  TTHGridFillColor = class(TPersistent)
  private
    FOwner: TTHBasicGrid;
    FColor1: TColor;
    FColor2: TColor;
    FGradation: TTHGridGradationType;
    procedure SetColor(Index: integer; AValue: TColor);
    procedure SetGradation(AValue: TTHGridGradationType);
  public
    constructor Create(AOwner: TTHBasicGrid);
    procedure Paint(R: TRect);
  published
    property Color1: TColor index 0 read FColor1 write SetColor default clWhite;
    property Color2: TColor index 1 read FColor2 write SetColor default clWhite;
    property Gradation: TTHGridGradationType read FGradation write SetGradation default gtNone;
  end;

  TTHGridOffset = class(TPersistent)
  private
    FOwner: TTHBasicGrid;
    FLeft: integer;
    FTop: integer;
    FRight: integer;
    FBottom: integer;
  public
    constructor Create(Aowner: TTHBasicGrid);
    procedure SetOffset(Index: integer; AValue: integer);
  published
    property Left: integer index 0 read FLeft write SetOffset default 2;
    property Top: integer index 1 read FTop write SetOffset default 2;
    property Right: integer index 2 read FRight write SetOffset default 2;
    property Bottom: integer index 3 read FBottom write SetOffset default 2;
  end;

  TTHGridColumnHeader = class(TPersistent)
  private
    FOwner: TTHBasicGrid;
    FTitle: string;
    FFont: TFont;
    FHorzAlignment: TAlignment;
    FOffset: TTHGridOffset;
    procedure SetTitle(AValue: string);
    procedure SetHorzAlignment(AValue: TAlignment);
    procedure FontChanged(Sender: Tobject);
    procedure SetHeaderFont(AFont: TFont);
  public
    constructor Create(AOwner: TTHBasicGrid);
    destructor Destroy; override;
  published
    property Title: string read FTitle write SetTitle;
    property Font: TFont read FFont write SetHeaderFont;
    property HorzAlignment: TAlignment read FHorzAlignment write SetHorzAlignment default taLeftJustify;
    property Offset: TTHGridOffset read FOffset write FOffset;
  end;

  TTHGridCellType = (ctText, ctInteger, ctFloat, ctDateTime, ctBoolean);

  TTHGridEditingParams = class(TPersistent)
  private
    FCanEdit: boolean;
    FCellType: TTHGridCellType;
    FMaxLength: integer;
    FCharCase: TEditCharCase;
  public
    constructor Create;
  published
    property CanEdit: boolean read FCanEdit write FCanEdit default true;
    property CellType: TTHGridCellType read FCellType write FCellType default ctText;
    property MaxLength: integer read FMaxLength write FMaxLength default 0;
    property CharCase: TEditCharCase read FCharCase write FCharCase default ecNormal;
  end;

  TTHGridColumnItem = class(TCollectionItem)
  private
    FOwner: TTHBasicGrid;
    FColIdx: integer;
    FColor: TTHGridFillColor;
    FFont: TFont;
    FHorzAlignment: TAlignment;
    FVertAlignment: TTHGridVertAlignment;
    FHeader: TTHGridColumnHeader;
    FTextEllipsis: TTHGridTextEllipsis;
    FTextMultiLines: boolean;
    FCanSelect: boolean;
    FOffset : TTHGridOffset;
    FEditingParams: TTHGridEditingParams;
    FRightVertLine: boolean;
    procedure SetColFont(AFont: TFont);
    procedure FontChanged(Sender: Tobject);
    procedure SetHorzAlignment(AValue: TAlignment);
    procedure SetVertAlignment(AValue: TTHGridVertAlignment);
    procedure SetTextEllipsis(AValue: TTHGridTextEllipsis);
    procedure SetTextMultiLines(AValue: boolean);
    procedure SetCanSelect(AValue: boolean);
    procedure SetRightVertLine(AValue: boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property ColIdx: integer read FColIdx write FColIdx default -1;
    property Color: TTHGridFillColor read FColor write FColor;
    property Font: TFont read FFont write SetColFont;
    property HorzAlignment: TAlignment read FHorzAlignment write SetHorzAlignment default taLeftJustify;
    property VertAlignment: TTHGridVertAlignment read FVertAlignment write SetVertAlignment default vaCenter;
    property Header: TTHGridColumnHeader read FHeader write FHeader;
    property TextEllipsis: TTHGridTextEllipsis read FTextEllipsis write SetTextEllipsis default teNone;
    property TextMultiLines: boolean read FTextMultiLines write SetTextMultiLines default false;
    property CanSelect: boolean read FCanSelect write SetCanSelect default true;
    property Offset: TTHGridOffset read FOffset write FOffset;
    property EditingParams: TTHGridEditingParams read FEditingParams  write FEditingParams;
    property RightVertLine: boolean read FRightVertLine write SetRightVertLine default true;
  end;

  TTHGridColumns = class(TCollection)
  private
    FOwner: TTHBasicGrid;
    function GetItem(Index: integer): TTHGridColumnItem;
    procedure SetItem(Index: integer; AValue: TTHGridColumnItem);
  protected
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TTHBasicGrid);
    property Item[Index: integer]: TTHGridColumnItem read GetItem write SetItem; default;
    function Add: TTHGridColumnItem;
    function Insert(Index: Integer): TTHGridColumnItem;
    procedure Delete(Index: Integer);
    procedure Clear;
    property CollOwner: TTHBasicGrid read FOwner;
  end;

  TTHGridOption = (mgoFixedVertLine, mgoFixedHorzLine, mgoVertLine, mgoHorzLine, mgoRangeSelect,
                   mgoColSizing, mgoRowSizing, mgoColMoving, mgoRowMoving, mgoTabs, mgoRowSelect, mgoThumbTracking,
                   mgoAutoRowHeight, mgoDrawFocusRect, mgoEditing);

  TTHGridOptions = set of TTHGridOption;
  TTHGridCalcRowHeightEvent = procedure(Sender: TObject; ADataRow: integer; var ARowHeight: integer) of object;
  TTHGridCellClickEvent = procedure(Sender: TObject; Shift: TShiftState; ACol, ADataRow: integer; ARect: TRect; X, Y: integer) of object;
  TTHGridNeedData = procedure(Sender: TObject; ACol, ADataRow: integer; var AValue: string) of object;
  TTHGridDrawDataCellEvent = procedure(Sender: TObject; ACol, ADataRow: integer; ARect: TRect; AState: TGridDrawState; var AValue: string) of object;
  TTHGridDrawHeaderCellEvent = procedure(Sender: TObject; ACol, ARow: integer; ARect: TRect; var AValue: string) of object;
  TTHGridBeforeSelectCellEvent = procedure(Sender: TObject; CurCol, CurDataRow, NewCol, NewDataRow: integer; var CanSelect: boolean) of object;
  TTHGridAfterSelectCellEvent = procedure(Sender: TObject; OldCol, OldDataRow, CurCol, CurDataRow: integer) of object;
  TTHGridChangeCellTextEvent = procedure(Sender: TObject; ACol, ADataRow: integer; CellValue: string) of object;
  TTHGridCanAcceptKeyEvent = procedure(Sender: TObject; ACol, ADataRow: integer; Key: Char; var Accept: boolean) of object;
  TTHGridColRowMovedEvent = procedure (Sender: TObject; FromIndex, ToIndex: integer) of object;

  TTHBasicGrid = class(TCustomGrid)
  private
    FColumns: TTHGridColumns;
    FTimer: TTimer;
    FDataRowCount: integer;
    FColor_Fixed: TTHGridFillColor;
    FColor_Selected: TTHGridFillColor;
    FColor3D_Fixed: TColor;
    FFontColor_Selected: TColor;
    FHeaderRowCount: integer;
    FHeaderRowHeight: integer;
    FMinRowHeight: integer;
    FGridOptions: TTHGridOptions;
    FOnCalcRowHeight: TTHGridCalcRowHeightEvent;
    FOnCellClick: TTHGridCellClickEvent;
    FOnNeedData: TTHGridNeedData;
    FOnDrawDataCell: TTHGridDrawDataCellEvent;
    FOnDrawHeaderCell: TTHGridDrawHeaderCellEvent;
    FOnBeforeSelectCell: TTHGridBeforeSelectCellEvent;
    FOnAfterSelectCell: TTHGridAfterSelectCellEvent;
    FOnChangeCellText: TTHGridChangeCellTextEvent;
    FOnCanAcceptKey: TTHGridCanAcceptKeyEvent;
    FOnColumnMoved: TTHGridColRowMovedEvent;
    FOnDataRowMoved: TTHGridColRowMovedEvent;
    OldCell, NewCell: TPoint;
    CellBuffer: string;
    function GetColumnsCount: integer;
    procedure SetColumnsCount(AValue: integer);
    procedure SetMinRowHeight(AValue: integer);
    procedure CanvasFontAssign(ACol, ARow: integer);
    function ReturnRowHeight(ARow: integer): integer;
    function ReturnCellHeight(ACol: integer; S: string): integer;
    procedure SetHeaderRowCount(AValue: integer);
    procedure SetHeaderRowHeight(AValue: integer);
    procedure SetDataRowCount(AValue: integer);
    function GetFixedColumns: integer;
    procedure SetFixedColumns(AValue: integer);
    procedure DrawCellValue(S: string; Acol, ARow: integer; R: TRect; AState: TGridDrawState);
    function GetDataRow: integer;
    procedure SetDataRow(ADataRow: integer);
    function ReturnHeaderHeight: integer;
    procedure DoAfterSelectCell(Sender: TObject);
    procedure DoChangeCellText(ACol, ARow: integer);
    procedure SetColor3D_Fixed(AValue: TColor);
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure Paint; override;
    procedure ColumnMoved(FromIndex, ToIndex: integer); override;
    procedure RowMoved(FromIndex, ToIndex: integer); override;
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function GetEditText(ACol, ARow: integer): string; override;
    procedure SetEditText(ACol, ARow: integer; const Value: string); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function CanEditModify: Boolean; override;
    function CanEditShow: Boolean; override;
    function CanEditAcceptKey(Key: Char): Boolean; override;
    function GetEditLimit: Integer; override;
    procedure KeyPress(var Key: Char); override;
    procedure SetGridOptions(AValue: TTHGridOptions);
    property OnCellClick: TTHGridCellClickEvent read FOnCellClick write FOnCellClick;
    property OnNeedData: TTHGridNeedData read FOnNeedData write FOnNeedData;
    property OnChangeCellText: TTHGridChangeCellTextEvent read FOnChangeCellText write FOnChangeCellText;
    property OnCalcRowHeight: TTHGridCalcRowHeightEvent read FOnCalcRowHeight write FOnCalcRowHeight;
    property OnDrawDataCell: TTHGridDrawDataCellEvent read FOnDrawDataCell write FOnDrawDataCell;
    property OnDrawHeaderCell: TTHGridDrawHeaderCellEvent read FOnDrawHeaderCell write FOnDrawHeaderCell;
    property OnBeforeSelectCell: TTHGridBeforeSelectCellEvent read FOnBeforeSelectCell write FOnBeforeSelectCell;
    property OnAfterSelectCell: TTHGridAfterSelectCellEvent read FOnAfterSelectCell write FOnAfterSelectCell;
    property OnCanAcceptKey: TTHGridCanAcceptKeyEvent read FOnCanAcceptKey write FOnCanAcceptKey;
    property OnColumnMoved: TTHGridColRowMovedEvent read FOnColumnMoved write FOnColumnMoved;
    property OnDataRowMoved: TTHGridColRowMovedEvent read FOnDataRowMoved write FOnDataRowMoved;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DataRow: integer read GetDataRow write SetDataRow;
    function DrawBitmap(Bitmap: TBitmap; CellRect: TRect; BmpRect: TRect; Transparent: boolean; CalcRect: boolean): TRect;
  published
    property Color;
    property Color_Fixed: TTHGridFillColor read FColor_Fixed write FColor_Fixed;
    property Color_Selected: TTHGridFillColor read FColor_Selected write FColor_Selected;
    property Color3D_Fixed: TColor read FColor3D_Fixed write SetColor3D_Fixed default clSilver;
    property FontColor_Selected: TColor read FFontColor_Selected write FFontColor_Selected default clBlack;
    property Columns: TTHGridColumns read FColumns write FColumns;
    property ColumnsCount: integer read GetColumnsCount write SetColumnsCount;
    property HeaderRowCount: integer read FHeaderRowCount write SetHeaderRowCount default 1;
    property HeaderRowHeight: integer read FHeaderRowHeight write SetHeaderRowHeight default 19;
    property MinRowHeight: integer read FMinRowHeight write SetMinRowHeight default 19;
    property FixedColumns: integer read GetFixedColumns write SetFixedColumns default 0;
    property GridOptions: TTHGridOptions read FGridOptions write SetGridOptions;
    property DataRowCount: integer read FDataRowCount write SetDataRowCount;
    property Align;
    property Anchors;
    property Constraints;
    property Cursor;
    property Enabled;
    property Hint;
    property ParentColor;
    property ParentShowHint;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
  end;

  TTHGrid = class(TTHBasicGrid)
  public
    property Canvas;
    property ColWidths;
    property RowHeights;
    property Col;
    property Row;
    property Selection;
  published
    property OnCellClick;
    property OnNeedData;
    property OnChangeCellText;
    property OnCalcRowHeight;
    property OnDrawDataCell;
    property OnDrawHeaderCell;
    property OnBeforeSelectCell;
    property OnAfterSelectCell;
    property OnCanAcceptKey;
    property OnColumnMoved;
    property OnDataRowMoved;
    property PopUpMenu;
    property BorderStyle;
    property Ctl3D;
    property ParentCtl3D;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseMove;
    property OnStartDrag;
  end;

procedure Register;

implementation

const
  EMPTYCELLBUFFER = #4;


procedure Register;
begin
  RegisterComponents('Exemples', [TTHGrid]);
end;

{ ------------------------------------------------------------------
                         TTHGRIDFILLCOLOR
  ------------------------------------------------------------------}

constructor TTHGridFillColor.Create(AOwner: TTHBasicGrid);
begin
  inherited Create;
  FOwner:= AOwner;
  FColor1:= clWhite;
  FColor2:= clWhite;
  FGradation:= gtNone;
end;

procedure TTHGridFillColor.SetColor(Index: integer; AValue: TColor);
begin
  case Index of
     0 : FColor1:= AValue;
     1 : FColor2:= AValue;
  end;
  FOwner.Invalidate;
end;

procedure TTHGridFillColor.SetGradation(AValue: TTHGridGradationType);
begin
  if FGradation <> AValue then
  begin
    FGradation:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridFillColor.Paint(R: TRect);

   function CtrlByte(N: integer): byte;
   begin
      if N < 0 then Result:= 0
      else if N > 255 then Result:= 255
      else Result:= N;
   end;

type
   TRGBArray = array[0..0] of TRGBTriple;
   PRGBArray = ^TRGBArray;
var
  GSize, X, Y, N: integer;
  Red, Green, Blue: byte;
  StepR, StepG, StepB: extended;
  Line: PRGBArray;
  Bmp: TBitmap;
begin
  if FGradation = gtNone then
  begin
    FOwner.Canvas.Brush.Color:= FColor1;
    FOwner.Canvas.FillRect(R);
    Exit;
  end;

  if FGradation = gtHorizontal then
     GSize:= R.Right - R.Left
  else
     GSize:= R.Bottom - R.Top;
  Red:= GetRValue(FColor1);
  Green:= GetGValue(FColor1);
  Blue:= GetBValue(FColor1);
  StepR:= (GetRValue(FColor2) - Red) / GSize;
  StepG:= (GetGValue(FColor2) - Green) / GSize;
  StepB:= (GetBValue(FColor2) - Blue) / GSize;
  Bmp:= TBitmap.Create;
  try
     Bmp.Width:= R.Right - R.Left;
     Bmp.Height:= R.Bottom - R.Top;
     Bmp.PixelFormat:= pf24bit;
     for Y:= 0 to Bmp.Height -1 do
     begin
        Line := Bmp.ScanLine[Y];
        for X:= 0 to Bmp.Width - 1 do
        begin
           if FGradation = gtHorizontal then N:= X
              else N:= Y;
           Line[X].RGBTRed:= CtrlByte (Round(Red + (StepR * N)));
           Line[X].RGBTGreen:= CtrlByte (Round(Green + (StepG * N)));
           Line[X].RGBTBlue:= CtrlByte (Round(Blue + (StepB * N)));
        end;
     end;
     FOwner.Canvas.Draw(R.Left, R.Top, Bmp);
  finally
     Bmp.Free;
  end;
end;


{ ------------------------------------------------------------------
                         TTHGRIDOFFSET
  ------------------------------------------------------------------}

constructor TTHGridOffset.Create(AOwner: TTHBasicGrid);
begin
  inherited Create;
  FOwner:= AOwner;
  FLeft:= 2;
  FTop:= 2;
  FRight:= 2;
  FBottom:= 2;
end;

procedure TTHGridOffset.SetOffset(Index: integer; AValue: integer);
begin
  case Index of
     0 : FLeft:= AValue;
     1 : FTop:= AValue;
     2 : FRight:= AValue;
     3 : FBottom:= AValue;
  end;
  FOwner.Invalidate;

end;
{ ------------------------------------------------------------------
                         TTHGRIDEDITINGPARAMS
  ------------------------------------------------------------------}

constructor TTHGridEditingParams.Create;
begin
  inherited Create;
  FCanEdit:= true;
  FCellType:= ctText;
  FMaxLength:= 0;
  FCharCase:= ecNormal;
end;


{ ------------------------------------------------------------------
                         TTHGRIDCOLUMNHEADER
  ------------------------------------------------------------------}

constructor TTHGridColumnHeader.Create(AOwner: TTHBasicGrid);
begin
  inherited Create;
  FOwner:= AOwner;
  FFont:= TFont.Create;
  FFont.OnChange:= FontChanged;
  FFont.Color:= clBlack;
  FHorzAlignment:= taLeftJustify;
  FOffset:= TTHGridOffset.Create(FOwner);
  FTitle:= '';
end;

destructor TTHGridColumnHeader.Destroy;
begin
  FOffset.Free;
  FFont.Free;
  inherited Destroy;
end;

procedure TTHGridColumnHeader.SetTitle(AValue: string);
begin
  if FTitle <> AValue then
  begin
    FTitle:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnHeader.SetHorzAlignment(AValue: TAlignment);
begin
  if FHorzAlignment <> AValue then
  begin
     FHorzAlignment:= AValue;
     FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnHeader.SetHeaderFont(AFont: TFont);
begin
  if FFont <> AFont then
     FFont.Assign(AFont);
end;

procedure TTHGridColumnHeader.FontChanged(Sender: TObject);
begin
  FOwner.Invalidate;
end;

{ ------------------------------------------------------------------
                          TTHGRIDCOLUMNITEM
  ------------------------------------------------------------------}

constructor TTHGridColumnItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FOwner:= (GetOwner as TTHGridColumns).CollOwner;
  FColIdx:= -1;
  FColor:= TTHGridFillColor.Create(FOwner);
  FOffset:= TTHGridOffset.Create(FOwner);
  FEditingParams:= TTHGridEditingParams.Create;
  FHorzAlignment:= taLeftJustify;
  FVertAlignment:= vaCenter;
  FFont:= TFont.Create;
  FFont.Color:= clBlack;
  FFont.OnChange:= FontChanged;
  FHeader:= TTHGridColumnHeader.Create(FOwner);
  FTextEllipsis:= teNone;
  FTextMultiLines:= false;
  FCanSelect:= true;
  FRightVertLine:= true;
end;

destructor TTHGridColumnItem.Destroy;
begin
  FOffset.Free;
  FEditingParams.Free;
  FFont.Free;
  FColor.Free;
  FHeader.Free;
  inherited Destroy;
end;

procedure TTHGridColumnItem.SetColFont(AFont: TFont);
begin
  if FFont <> AFont then
      FFont.Assign(AFont);
end;

procedure TTHGridColumnItem.FontChanged(Sender: TObject);
begin
  FOwner.Invalidate;
end;

procedure TTHGridColumnItem.SetHorzAlignment(AValue: TAlignment);
begin
  if FHorzAlignment <> AValue then
  begin
    FHorzAlignment:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnItem.SetVertAlignment(AValue: TTHGridVertAlignment);
begin
  if FVertAlignment <> AValue then
  begin
    FVertAlignment:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnItem.SetTextEllipsis(AValue: TTHGridTextEllipsis);
begin
  if FTextEllipsis <> AValue then
  begin
    FTextEllipsis:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnItem.SetTextMultiLines(AValue: boolean);
begin
  if FTextMultiLines <> AValue then
  begin
    FTextMultiLines:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnItem.SetCanSelect(AValue: boolean);
begin
  if FCanSelect <> AValue then
  begin
    FCanSelect:= AValue;
    FOwner.Invalidate;
  end;
end;

procedure TTHGridColumnItem.SetRightVertLine(AValue: boolean);
begin
  if FRightVertLine <> AValue then
  begin
    FRightVertLine:= AValue;
    FOwner.Invalidate;
  end;
end;


{ ------------------------------------------------------------------
            TTHGRIDCOLUMNS : collection de TTHGridColumnItem
  ------------------------------------------------------------------}

constructor TTHGridColumns.Create(AOwner: TTHBasicGrid);
begin
  inherited Create(TTHGridColumnItem);
  FOwner:= AOwner;
end;

function TTHGridColumns.GetItem(Index: integer): TTHGridColumnItem;
begin
  Result:= TTHGridColumnItem(inherited GetItem(Index));
end;

procedure TTHGridColumns.SetItem(Index: integer; AValue: TTHGridColumnItem);
begin
  inherited SetItem(Index, AValue);
end;

function TTHGridColumns.Add: TTHGridColumnItem;
begin
  Result:= (inherited Add) as TTHGridColumnItem;

end;

function TTHGridColumns.Insert(Index: Integer): TTHGridColumnItem;
begin
  Result:= (inherited Insert(Index)) as TTHGridColumnItem;
end;

procedure TTHGridColumns.Delete(Index: Integer);
begin
  inherited Delete(Index);
end;

procedure TTHGridColumns.Clear;
begin
  inherited Clear;
end;

procedure TTHGridColumns.Update(Item: TCollectionItem);
begin
   if not(csDestroying in FOwner.ComponentState) then
      if csDesigning in FOwner.ComponentState then
      begin
         if Count <= FOwner.FixedCols then
         begin
            Add;
            ShowMessage('Il faut au moins une colonne non figée');
         end;
         if FOwner.ColCount <> Count then FOwner.ColCount:= Count;
      end;
end;

procedure TTHGridColumns.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  if not(csDestroying in FOwner.ComponentState) then
  case Action of
    cnAdded: if Count <= FOwner.FixedCols then FOwner.ColCount:= 2 else
                               FOwner.ColCount:= Count;
    cnDeleting: begin
                   if Count <= (FOwner.FixedCols + 1) then
                        raise Exception.Create('Il faut au moins une colonne non figée');
                   FOwner.ColCount:= Count - 1;
                end;
  end;
end;

{ ------------------------------------------------------------------
                            TTHBasicGrid
  ------------------------------------------------------------------}

constructor TTHBasicGrid.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  FColor_Fixed:= TTHGridFillColor.Create(self);
  with FColor_Fixed do
  begin
    Color1:= clWhite;
    Color2:= $00DCEBEE;
    Gradation:= gtVertical;
  end;
  FColor_Selected:= TTHGridFillColor.Create(self);
  with FColor_Selected do
  begin
    Color1:= clWhite;
    Color2:= clSilver;
    Gradation:= gtVertical;
  end;
  FColor3D_Fixed:= clSilver;
  FFontColor_Selected:= clBlack;
  DefaultDrawing:= false;
  ColCount:= 2;
  FixedCols:= 0;
  FixedRows:= 1;
  SetGridoptions([mgoFixedVertLine, mgoFixedHorzLine, mgoVertLine, mgoHorzLine, mgoColSizing, mgoThumbTracking, mgoAutoRowHeight]);
  DefaultRowHeight:= 19;
  FHeaderRowHeight:= 19;
  FMinRowHeight:= 19;
  FHeaderRowCount:= 1;
  FDataRowCount:= 1;
  RowCount:= 2;
  Width:= 300;
  Height:= 100;
  FTimer:= TTimer.Create(self);
  with FTimer do
  begin
    Enabled:= false;
    Interval:= 60;
    OnTimer:= DoAfterSelectCell;
  end;
  CellBuffer:= EMPTYCELLBUFFER;
  FColumns:= TTHGridColumns.Create(self);
  SetColumnsCount(2);
end;

destructor TTHBasicGrid.Destroy;
begin
  FTimer.Free;
  FColumns.Clear;
  FColumns.Free;
  FColor_Fixed.Free;
  FColor_Selected.Free;
  inherited Destroy;
end;

function TTHBasicGrid.GetColumnsCount: integer;
begin
  Result:= FColumns.Count;
end;

procedure TTHBasicGrid.ColumnMoved(FromIndex, ToIndex: integer);
begin
  //ColumMoved répond uniquement au déplacement par la souris
  FColumns[FromIndex].Index:= ToIndex;
  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);
  Invalidate;
end;

procedure TTHBasicGrid.RowMoved(FromIndex, ToIndex: integer);
//RowMoved répond uniquement au déplacement par la souris
begin
  if Assigned(FOnDataRowMoved) then FOnDataRowMoved(Self, FromIndex - FixedRows, ToIndex - FixedRows);
  Invalidate;
end;

procedure TTHBasicGrid.SetColumnsCount(AValue: integer);
var
  I: integer;
begin
  if AValue <= 0 then AValue := 1;
  if FColumns.Count < AValue then
     for I:= FColumns.Count to AValue -1 do
       FColumns.Add
  else
     for I:= (FColumns.Count -1) downto AValue do
       FColumns.Delete(I);
  ColCount:= FColumns.Count;
  Invalidate;
end;

procedure TTHBasicGrid.SetDataRowCount(AValue: integer);
begin
  if AValue < 1 then AValue:= 1;
  FDataRowCount:= AValue;
  RowCount:= FDataRowCount + FHeaderRowCount;
  Invalidate;
end;

function TTHBasicGrid.GetFixedColumns: integer;
begin
  Result:= FixedCols;
end;

procedure TTHBasicGrid.SetFixedColumns(AValue: integer);
begin
  FixedCols:= AValue;
end;

procedure TTHBasicGrid.CanvasFontAssign(ACol, ARow: integer);
begin
  with FColumns[ACol] do
    if ARow < FixedRows then
      Canvas.Font.Assign(FHeader.Font)
    else Canvas.Font.Assign(Font);
end;

procedure TTHBasicGrid.DrawCellValue(S: string; Acol, ARow: integer; R: TRect; AState: TGridDrawState);
var
  DTParam, H: integer;
  AEllipsis: TTHGridTextEllipsis;
  AMultiLines: boolean;
  AHorzAlignment: TAlignment;
  AVertAlignment: TTHGridVertAlignment;
  CalcR: TRect;
begin
  Canvas.Brush.Style:= bsClear;
  if (gdSelected in AState) or (gdFocused in AState) then
     Canvas.Font.Color:= FFontColor_Selected;
  DTParam:= DT_NOPREFIX;
  if ARow < FixedRows then   // header
  begin
     with FColumns[ACol].Header do
     begin
        R.Left:= R.Left + Offset.Left;
        R.Right:= R.Right - Offset.Right;
        R.Top:= R.Top + Offset.Top;
        R.Bottom:= R.Bottom - Offset.Bottom;
        AEllipsis:= teEndEllipsis;
        AMultiLines:= false;
        AHorzAlignment:= HorzAlignment;
        AVertAlignment:= vaCenter;
     end;
  end
  else
     with FColumns[ACol] do
     begin
        R.Left:= R.Left + Offset.Left;
        R.Right:= R.Right - Offset.Right;
        R.Top:= R.Top + Offset.Top;
        R.Bottom:= R.Bottom - Offset.Bottom;
        AEllipsis:= TextEllipsis;
        AMultiLines:= TextMultiLines;
        AHorzAlignment:= HorzAlignment;
        AVertAlignment:= VertAlignment;
      end;

  // Ellipsis
  if AEllipsis = teEndEllipsis then
      DTParam:= DTParam or DT_END_ELLIPSIS
  else
  if AEllipsis = tePathEllipsis then
      DTParam:= DTParam or DT_PATH_ELLIPSIS;
  // Alignement horizontal
  case AHorzAlignment of
     taLeftJustify : DTParam:= DTParam or DT_LEFT;
           taCenter: DTParam:= DTParam or DT_CENTER;
     taRightJustify: DTParam:= DTParam or DT_RIGHT;
  end;
  // Alignement vertical
  if AMultiLines then
  begin
     DTParam:= DTParam or DT_WORDBREAK;
     if AVertAlignment <> vaTop then
     begin
        H:= R.Bottom - R.Top;
        CalcR:= Rect(0,0, R.Right - R.Left, 0);
        Drawtext(Canvas.Handle, PChar(S), -1, CalcR, DTParam or DT_CALCRECT);
        if CalcR.Bottom > H then CalcR.Bottom:= H;
        if AVertAlignment = vaCenter then
           R.Top:= R.Top + ((H - CalcR.Bottom) div 2)
        else R.Top:= R.Bottom - CalcR.Bottom;
     end;
  end
  else
     case AVertAlignment of
        vaBottom: DTParam:= DTParam or DT_BOTTOM or DT_SINGLELINE;
        vaCenter: DTParam:= DTParam or DT_VCENTER or DT_SINGLELINE;
           vaTop: DTParam:= DTParam or DT_TOP or DT_SINGLELINE;
      end;
  Drawtext(Canvas.Handle, PChar(S), -1, R, DTParam);
  Canvas.Brush.Style:= bsSolid;
end;

procedure TTHBasicGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  AValue: string;
  R: TRect;
begin
   {dessin du fond de cellule}
   R:= ARect;
   if not(FColumns[ACol].RightVertLine) and not(gdFixed in AState) and (goVertLine in Options) then
     R.Right:= R.Right + 1;
   if (gdFixed in AState) or (not(FColumns[ACol].CanSelect) and not(gdSelected in AState)) then
       FColor_Fixed.Paint(R)
    else
    if (gdSelected in AState) or (gdFocused in AState) then
       FColor_Selected.Paint(R)
    else
       FColumns[ACol].Color.Paint(R);
   {dessin des lignes "3D"}
   if (gdFixed in AState) and (FColor3D_Fixed <> clNone) then
   begin
      Canvas.Pen.Color:= FColor3D_Fixed;
      Canvas.MoveTo(ARect.Left + 1, ARect.Bottom-1);
      Canvas.LineTo(ARect.Right-1, ARect.Bottom-1);
      Canvas.LineTo(ARect.Right-1, ARect.Top);
   end;
   {dessin du FocusRect}
   if (gdFocused in AState) then
     if ((mgoDrawFocusRect in FGridOptions) or (goRangeSelect in Options))
       and not(goRowSelect in Options) then
         Canvas.DrawFocusRect(ARect);
   {dessin du texte des lignes fixes (header)}
   if ARow < FixedRows then
   begin
     CanvasFontAssign(ACol, ARow);
     if ARow = 0 then AValue:= FColumns[Acol].Header.Title
       else AValue:= '';
     if Assigned(FOnDrawHeaderCell) then FOnDrawHeaderCell(Self, ACol, ARow, ARect, AValue);
     if AValue <> '' then
       DrawCellValue(AValue, ACol, ARow, ARect, AState);
     Exit;
   end;
   {dessin du texte des cellules de données}
   CanvasFontAssign(ACol, ARow);
   AValue:= '';
   if Assigned(FOnNeedData) then
     FOnNeedData(Self, ACol, ARow - FixedRows, AValue);
   if Assigned(FOnDrawDataCell) then
     FOnDrawDataCell(Self, ACol, ARow - FixedRows, ARect, AState, AValue);
   if AValue <> '' then
      DrawCellValue(AValue, ACol, ARow, ARect, AState);
end;


procedure TTHBasicGrid.SetMinRowHeight(AValue: integer);
begin
  if AValue < 13 then AValue:= 13;
  if FMinRowHeight <> AValue then
  begin
    FMinRowHeight:= AValue;
    DefaultRowHeight:= FMinRowHeight;
    if FHeaderRowCount > 0 then SetHeaderRowHeight(FHeaderRowHeight);
    Invalidate;
  end;
end;

procedure TTHBasicGrid.SetGridOptions(AValue: TTHGridOptions);
begin
  if FGridOptions <> AValue then
  begin
    FGridOptions := AValue;
    Options:= [];
    if mgoFixedVertLine in FGridOptions then Options:= Options + [goFixedVertLine];
    if mgoFixedHorzLine in FGridOptions then Options:= Options + [goFixedHorzLine];
    if mgoVertLine in FGridOptions then Options:= Options + [goVertLine];
    if mgoHorzLine in FGridOptions then Options:= Options + [goHorzLine];
    if mgoRangeSelect in FGridOptions then Options:= Options + [goRangeSelect];
    if mgoColSizing in FGridOptions then Options:= Options + [goColSizing];
    if mgoRowSizing in FGridOptions then Options:= Options + [goRowSizing];
    if mgoColMoving in FGridOptions then Options:= Options + [goColMoving];
    if mgoRowMoving in FGridOptions then Options:= Options + [goRowMoving];
    if mgoTabs in FGridOptions then Options:= Options + [goTabs];
    if mgoRowSelect in FGridOptions then Options:= Options + [goRowSelect];
    if mgoThumbTracking in FGridOptions then Options:= Options + [goThumbTracking];
    if mgoEditing in FGridOptions then Options:= Options + [goEditing];
  end;
end;

procedure TTHBasicGrid.Paint;
var
  I, H: integer;
  TotH: integer;
begin
  {calcul automatique des lignes}
  if (mgoAutoRowHeight in FGridOptions) and (not EditorMode) then
  begin
     TotH:= 0;
     try
       for I:= TopRow to RowCount-1 do
       begin
         H:= ReturnRowHeight(I);
         if RowHeights[I]<> H  then RowHeights[I]:= H; // <> empêche le resize manuel
         Inc(TotH, H);
         if TotH > ClientHeight then break;
       end;
     except
     end;
  end;
  inherited Paint;
end;

function TTHBasicGrid.ReturnRowHeight(ARow: integer): integer;
var
  I, H: integer;
  AValue: string;
  HH: integer;
begin
  Result:= FMinRowHeight;
  if not Assigned(FOnNeedData) then Exit;
  for I:= 0 to FColumns.Count - 1 do
    with FColumns[I] do
    begin
       AValue:= '';
       FOnNeedData(Self, I, ARow - FixedRows, AValue);
       if AValue <> '' then
       begin
          CanvasFontAssign(I, ARow);
          H:= ReturnCellHeight(I, AValue);
          if Result < H then Result:= H;
       end;
    end;
  if Assigned(FOnCalcRowHeight) then FOnCalcRowHeight(Self, ARow - FixedRows, Result);
  if Result < FMinRowHeight then Result:= FMinRowHeight
  else
  try
     HH:= ReturnHeaderHeight;
     if Result > (ClientHeight - HH - 20) then Result:= ClientHeight - HH - 20;
  except
  end;
end;

function TTHBasicGrid.ReturnCellHeight(ACol: integer; S: string): integer;
var
  R: TRect;
begin
  if FColumns[ACol].TextMultiLines then
  begin
     R:= Rect(0, 0, ColWidths[ACol] - FColumns[ACol].Offset.Left - FColumns[ACol].Offset.Right , 10);
     DrawText(canvas.handle, PChar(S), -1, R, DT_LEFT or DT_CALCRECT or DT_WORDBREAK);
     Result:= R.Bottom + 1;
  end
  else
     Result:= Canvas.TextHeight('M');
  Inc(Result, FColumns[ACol].Offset.Top + FColumns[ACol].Offset.Bottom);
end;

procedure TTHBasicGrid.SetHeaderRowCount(AValue: integer);
begin
  if AValue < 0 then AValue:= 0;
  FHeaderRowCount:= AValue;
  RowCount:= FHeaderRowCount + FDataRowCount;
  FixedRows:= FHeaderRowCount;
  SetHeaderRowHeight(FHeaderRowHeight);
end;

procedure TTHBasicGrid.SetHeaderRowHeight(AValue: integer);
var
  I: integer;
begin
  FHeaderRowHeight:= AValue;
  for I:= 0 to FHeaderRowCount - 1 do
    RowHeights[I]:= FHeaderRowHeight;
end;

function TTHBasicGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  if (CellBuffer <>  EMPTYCELLBUFFER) then DoChangeCellText(Col, Row);
  if not(goRowSelect in Options) and not(FColumns[ACol].CanSelect) then
  begin
     Result:= false;
     Exit;
  end;
  if (goRowSelect in Options) and (ARow = Row) then Exit;
  Result:= true;
  if Assigned(FOnBeforeSelectCell) then
     FOnBeforeSelectCell(Self, Col, Row - FixedRows, ACol, ARow - FixedRows, Result);
  if Result then
     if Assigned(FOnAfterSelectCell) then
     begin
        OldCell:= Point(Col, Row);
        NewCell:= Point(ACol, ARow);
        FTimer.Enabled:= ((NewCell.X <> OldCell.X) or (NewCell.Y <> OldCell.Y));
     end;
end;

procedure TTHBasicGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  GC: TGridCoord;
  R: TRect;
begin
  inherited;
  if EditorMode then Exit;
  if (Button = mbLeft) and Assigned(FOnCellClick) then
  begin
     if (X < 0) or (X >= GridWidth) or (Y < 0) or (Y >= GridHeight) then exit;
     GC:= MouseCoord(X, Y);
     if GC.Y >= FixedRows then
     begin
        R:= CellRect(GC.X, GC.Y);
        FOnCellClick(Self, Shift, GC.X, GC.Y - FixedRows , R, X, Y);
     end;
  end;
end;

procedure TTHBasicGrid.DoAfterSelectCell(Sender: TObject);
begin
   FTimer.Enabled:= false;
   FOnAfterSelectCell(self, OldCell.X, OldCell.Y - FixedRows, NewCell.X, NewCell.Y - FixedRows);
end;

function TTHBasicGrid.GetEditText(ACol, ARow: integer): string;
var
  Value: string;
begin
  if CellBuffer <> EMPTYCELLBUFFER then
    Value:= CellBuffer
  else
  begin
     Value:= '';
     if Assigned(FOnNeedData) then FOnNeedData(Self, ACol, ARow - FixedRows, Value);
  end;
  Result := Value;
end;

procedure TTHBasicGrid.DoChangeCellText(ACol, ARow: integer);
var
  S, STest: string;
begin
  S:= CellBuffer;
  CellBuffer:= EMPTYCELLBUFFER;
  if not CanEditModify then Exit;
  if S <> '' then
    try
       case FColumns[ACol].EditingParams.CellType of
              ctText: case FColumns[ACol].EditingParams.CharCase of
                         ecLowerCase: S:= AnsiLowerCase(S);
                         ecUpperCase: S:= AnsiUpperCase(S);
                      end;
           ctInteger: STest:= IntToStr(StrToInt(S));
             ctFloat: STest:= FloatToStr(StrToFloat(S));
          ctDateTime: STest:= DateTimeToStr(StrToDateTime(S));
           ctBoolean: if (S <> '') and (S <> '0') and (S <> '1') then
                          raise Exception.Create('"' + S + '" : n''est pas une valeur booléenne correcte');
       end;
    except raise;
    end;
  if Assigned(FOnChangeCellText) then
     FOnChangeCellText(Self, ACol, ARow - FixedRows, S);
end;

procedure TTHBasicGrid.SetEditText(ACol, ARow: integer; const Value: string);
begin
  if EditorMode then // on attend la sortie de la cellule
     CellBuffer:= Value
  else
    if CellBuffer <> EMPTYCELLBUFFER then DoChangeCellText(ACol, ARow);

end;

procedure TTHBasicGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  if EditorMode then
  begin
     CellBuffer:= EMPTYCELLBUFFER;
     EditorMode:= false;
  end;
  inherited;
end;

function TTHBasicGrid.CanEditModify: Boolean;
begin
   Result:= (FColumns[Col].EditingParams.CanEdit);
end;

function TTHBasicGrid.GetDataRow: integer;
begin
   Result:= Row - FixedRows;
end;

procedure TTHBasicGrid.SetDataRow(ADataRow: integer);
begin
   if ADataRow < 0 then ADataRow:= 0
     else if ADataRow >= (RowCount - FixedRows) then ADataRow:= RowCount - FixedRows - 1;
   FocusCell(Col, ADataRow + FixedRows, true);
end;

function TTHBasicGrid.ReturnHeaderHeight: integer;
var
  I: integer;
begin
  Result:= 0;
  for I:= 0 to FixedRows - 1 do
    Result:= Result + RowHeights[I];
end;

function TTHBasicGrid.CanEditAcceptKey(Key: Char): Boolean;
begin
  case FColumns[Col].EditingParams.CellType of
     ctInteger: Result:= (Key in ['0'..'9', '-']);
     ctFloat: Result:= (Key in ['0'..'9', '-', DecimalSeparator]);
     ctDateTime: Result:= (Key in ['0'..'9', DateSeparator, #32, TimeSeparator]);
     ctBoolean: Result:= (Key in ['0', '1']);
  else Result:= true;
  end;
  if Result and Assigned(FOnCanAcceptKey) then
    FOnCanAcceptKey(Self, Col, Row - FixedRows, Key, Result);
end;

function TTHBasicGrid.GetEditLimit: Integer;
begin
  Result:= FColumns[Col].EditingParams.MaxLength;
end;

function TTHBasicGrid.CanEditShow: Boolean;
begin
  Result:= (goEditing in Options) and not (goRowSelect in Options)
           and EditorMode
           and not (csDesigning in ComponentState) and HandleAllocated
           and (FColumns[Col].EditingParams.CanEdit)
           and (FColumns[Col].CanSelect);
  if not Result then EditorMode:= false;
end;

procedure TTHBasicGrid.KeyPress(var Key: Char);
var
  S: string;
begin
  if EditorMode and (Key > #32) then
    if (FColumns[Col].EditingParams.CellType = ctText)
      and(FColumns[Col].EditingParams.CharCase <> ecNormal) then
      try
         S:= Key;
         case FColumns[Col].EditingParams.CharCase of
            ecUpperCase: S:= AnsiUpperCase(S);
            ecLowerCase: S:= AnsiLowerCase(S);
         end;
         Key:= S[1];
      except
      end;
   inherited KeyPress(Key);
end;

procedure TTHBasicGrid.SetColor3D_Fixed(AValue: TColor);
begin
  if FColor3D_Fixed <> AValue then
  begin
    FColor3D_Fixed:= AValue;
    Invalidate;
  end;
end;

function TThBasicGrid.DrawBitmap(Bitmap: TBitmap; CellRect: TRect; BmpRect: TRect; Transparent: boolean; CalcRect: boolean): TRect;
{dessin d'un bitmap dans une cellule
  CellRect: rectangle de la cellule
  BmpRect: left = position gauche en valeur absolue dans le Canvas.
           top = position haute en valeur absolue.
           right = largeur maximale de l'affichage du bitmap.
           bottom = hauteur maximale de l'affichage du bitmap.
         si left = -1 : le bitmap sera centré horizontalement dans la cellule.
         si top = -1 : le bitmap sera centré verticalement dans la cellule.
  Transparent : si true, c'est le pixel inférieur gauche qui détermine la couleur de transparence.
  La fonction renvoie le rectangle du bitmap dessiné en valeur absolue.
  CalcRect : si true, la fonction ne dessine rien, elle ne fait que calculer le rect de retour.}
var
  Bmp: TBitmap;
  Percent: double;
  MaxWidth, MaxHeight: integer;
  NewWidth, NewHeight: integer;
  X, Y: integer;
begin
  Result:= Rect(-1,-1,-1,-1);
  if BmpRect.Left > CellRect.Right then Exit;
  if BmpRect.Top > CellRect.Bottom then Exit;
  if BmpRect.Left < 0 then
    MaxWidth:= Min(CellRect.Right - CellRect.Left - 4, BmpRect.Right - 4)
  else
  begin
     MaxWidth:= BmpRect.Right + 1;
     if MaxWidth > (CellRect.Right - BmpRect.Left -  4) then
       MaxWidth:= CellRect.Right - BmpRect.Left  - 4;
  end;
  if BmpRect.Top < 0 then
    MaxHeight:= Min(CellRect.Bottom - CellRect.Top - 4, BmpRect.Bottom - 4)
  else
  begin
     MaxHeight:= BmpRect.Bottom + 1;
     if MaxHeight > (CellRect.Bottom - BmpRect.Top - 4) then
       MaxHeight:= CellRect.Bottom - BmpRect.Top - 4;
  end;
  Percent:= Min(MaxWidth / Bitmap.Width, MaxHeight / Bitmap.Height);
  NewWidth:= Round(Bitmap.Width * Percent);
  NewHeight:= Round(Bitmap.Height * Percent);
  if (NewWidth <= 0) or (NewHeight <= 0) then Exit;
  if BmpRect.Left < 0 then X:= CellRect.Left + ((CellRect.Right - CellRect.Left - NewWidth) div 2)
       else X:= BmpRect.Left;
  if BmpRect.Top < 0 then Y:= CellRect.Top + ((CellRect.Bottom - CellRect.Top - NewHeight) div 2)
       else Y:= BmpRect.Top ;
  Result:= Rect(X, Y, X + NewWidth, Y + NewHeight);
  if CalcRect then Exit;
  Bmp:= TBitmap.Create;
  try
     Bmp.Width:= NewWidth;
     Bmp.Height:= NewHeight;
     Bmp.PixelFormat:= Bitmap.PixelFormat;
     Bmp.Transparent:= Transparent;
     if (Bmp.Width = Bitmap.Width) and (Bmp.Height = Bitmap.Height) then
        Bmp.Assign(Bitmap)
     else
     begin
        SetStretchBltMode(Bmp.Canvas.Handle, HALFTONE);
        StretchBlt(Bmp.Canvas.Handle,
                   0, 0, Bmp.Width, Bmp.Height,
                   Bitmap.Canvas.Handle,
                   0, 0, Bitmap.Width, Bitmap.Height,
                   SRCCOPY);
     end;
     Canvas.Draw(X, Y, Bmp);
  finally
     Bmp.Free;
  end;
end;


end.
