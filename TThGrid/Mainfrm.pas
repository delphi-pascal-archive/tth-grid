unit Mainfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ThGrids, Grids, StdCtrls, ExtCtrls, Math, ShellApi;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    CBGridEditing: TCheckBox;
    CBRowSelect: TCheckBox;
    Memo1: TMemo;
    ModifyByMemoBtn: TButton;
    AddRowBtn: TButton;
    InsertRowBtn: TButton;
    DeleteRowBtn: TButton;
    AddColumnBtn: TButton;
    ColOptionsBtn: TButton;
    RBAutoRowHeight: TRadioButton;
    RBManualResize: TRadioButton;
    SaveToFileBtn: TButton;
    SaveDialog1: TSaveDialog;
    LoadFromFileBtn: TButton;
    OpenDialog1: TOpenDialog;
    SortBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridNeedData(Sender: TObject; ACol, ADataRow: Integer;
      var AValue: String);
    procedure GridChangeCellText(Sender: TObject; ACol, ADataRow: Integer;
      CellValue: String);
    procedure AddRowBtnClick(Sender: TObject);
    procedure InsertRowBtnClick(Sender: TObject);
    procedure DeleteRowBtnClick(Sender: TObject);
    procedure AddColumnBtnClick(Sender: TObject);
    procedure ColOptionsBtnClick(Sender: TObject);
    procedure CBGridEditingClick(Sender: TObject);
    procedure GridCellClick(Sender: TObject; Shift: TShiftState; ACol,
      ADataRow: Integer; ARect: TRect; X, Y: Integer);
    procedure GridBeforeSelectCell(Sender: TObject; CurCol, CurDataRow,
      NewCol, NewDataRow: Integer; var CanSelect: Boolean);
    procedure GridCalcRowHeight(Sender: TObject; ADataRow: Integer;
      var ARowHeight: Integer);
    procedure GridDrawDataCell(Sender: TObject; ACol, ADataRow: Integer;
      ARect: TRect; AState: TGridDrawState; var AValue: String);
    procedure GridAfterSelectCell(Sender: TObject; OldCol, OldDataRow,
      CurCol, CurDataRow: Integer);
    procedure CBRowSelectClick(Sender: TObject);
    procedure GridDataRowMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    procedure ModifyByMemoBtnClick(Sender: TObject);
    procedure SaveToFileBtnClick(Sender: TObject);
    procedure LoadFromFileBtnClick(Sender: TObject);
    procedure SortBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
    procedure CreateGrid;
    procedure InsertRow(ARow: integer);
    procedure SetGridOptions;
    procedure UpdateMemo;
    procedure LoadFromFile(S: string);
  public
    { Déclarations publiques }
  end;

var
  MainForm: TMainForm;
  TestFileName: string;
  Grid: TThGrid;

implementation

{$R *.dfm}
{$R DemoRessources.res}

uses RecList, Columnsfrm;

const
  F_FREE = 0;
  F_TITRE = 1;
  F_DATE = 2;
  F_COMMENT = 3;
  F_BOOL = 4;
  F_FILE = 5;
  F_FLOAT = 6;
  F_GRAPH = 7;

var
  RecordsList: TRecordsList;
  Bmp1, Bmp2, Bmp3 : TBitmap;
  CheckBmp, FileBmp: TBitmap;



procedure TMainForm.FormCreate(Sender: TObject);
begin
   Bmp1:= TBitmap.Create;
   Bmp2:= TBitmap.Create;
   Bmp3:= TBitmap.Create;
   CheckBmp:= TBitmap.Create;
   FileBmp:= TBitmap.Create;
   try
      Bmp1.LoadFromResourceName(HInstance, 'BMP1');
      Bmp2.LoadFromResourceName(HInstance, 'BMP2');
      Bmp3.LoadFromResourceName(HInstance, 'BMP3');
      CheckBmp.LoadFromResourceName(HInstance, 'CHECKBMP');
      FileBmp.LoadFromResourceName(HInstance, 'FILEBMP');
   except
     raise;
   end;
   RecordsList:= TRecordsList.Create;
   CreateGrid;
   Grid.DoubleBuffered:= true;
   LoadFromFile(TestFileName);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   RecordsList.Free;
   Bmp1.Free;
   Bmp2.Free;
   Bmp3.Free;
   CheckBmp.Free;
   FileBmp.Free;
end;

procedure TMainForm.CreateGrid;
var
  I: integer;
begin
   // ceci peut se faire en mode conception
   Grid:= TTHgrid.Create(Self);
   with Grid do
   begin
     Parent:= MainForm;
     Left:= 8;
     Top:= 8;
     Width:= 700;
     Height:= 609;
     Anchors:= [akLeft, akTop, akBottom, akRight];
     Ctl3D:= false;
     ColumnsCount:= 8;
     FixedColumns:= 1;
     for I:= 0 to ColumnsCount - 1 do Columns[I].ColIdx:= I;
     ColWidths[F_FREE]:= 21;
     ColWidths[F_TITRE]:= 110;
     ColWidths[F_COMMENT]:= 167;
     ColWidths[F_BOOL]:= 33;
     ColWidths[F_FILE]:= 56;
     ColWidths[F_GRAPH]:= 145;
     with Columns[F_TITRE] do
     begin
        Header.Title:= 'Titre';
        Font.Style:= [fsBold];
        TextEllipsis:= teEndEllipsis;
        Color.Color1:= $00FFEBD7;
        Color.Color2:= clWhite;
        Color.Gradation:= gtHorizontal;
     end;
     with Columns[F_DATE] do
     begin
        Header.Title:= 'Date';
        Header.HorzAlignment:= taCenter;
        EditingParams.CellType:= ctDateTime;
        HorzAlignment:= taCenter;
     end;
     with Columns[F_COMMENT] do
     begin
        Header.Title:= 'Descriptif';
        TextMultiLines:= true;
        TextEllipsis:= teEndEllipsis;
        RightVertLine:= false;
        Offset.Left:= 4;
        Offset.Top:= 4;
        Offset.Right:= 4;
        Color.Color1:= $00D2F0F9;
        Color.Color2:= clCream;
        Color.Gradation:= gtHorizontal;
     end;
     with Columns[F_BOOL] do
     begin
        Header.Title:= 'B';
        Header.HorzAlignment:= taCenter;
        EditingParams.CellType:= ctBoolean;
        Color.Color1:= clCream;
        Color.Color2:= $00D2F0F9;
        Color.Gradation:= gtHorizontal;
     end;
     with Columns[F_FILE] do
     begin
        Header.Title:= 'Lien';
        TextMultiLines:= true;
        EditingParams.CanEdit:= false;
     end;
     with Columns[F_FLOAT] do
     begin
        Header.Title:= 'Float';
        Header.HorzAlignment:= taRightJustify;
        Header.Offset.Right:= 4;
        HorzAlignment:= taRightJustify;
        VertAlignment:= vaBottom;
        Offset.Right:= 4;
        EditingParams.CellType:= ctFloat;
     end;
     with Columns[F_GRAPH] do
     begin
        Header.Title:= 'Images';
        Header.HorzAlignment:= taCenter;
        TextMultiLines:= true;
        Color.Color1:= clCream;
        Color.Color2:= $00D1CDDC;
        Color.Gradation:= gtHorizontal;
     end;
     GridOptions:= GridOptions + [mgoColMoving, mgoTabs];
     OnCellClick:= GridCellClick;
     OnNeedData:= GridNeedData;
     OnChangeCellText:= GridChangeCellText;
     OnCalcRowHeight:= GridCalcRowHeight;
     OnDrawDataCell:= GridDrawDataCell;
     OnBeforeSelectCell:= GridBeforeSelectCell;
     OnAfterSelectCell:= GridAfterSelectCell;
     OnDataRowMoved:= GridDataRowMoved;
   end;
end;


procedure TMainForm.GridNeedData(Sender: TObject; ACol, ADataRow: Integer;
  var AValue: String);
begin
  if ADataRow < RecordsList.Count then
    AValue:= RecordsList[Grid.Columns[ACol].ColIdx, ADataRow];
end;

procedure TMainForm.GridChangeCellText(Sender: TObject; ACol,
  ADataRow: Integer; CellValue: String);
begin
   // mise à jour de RecordsList après édition dans la grille
   RecordsList.EditField(Grid.Columns[ACol].ColIdx, ADataRow, CellValue);
   UpdateMemo;
end;

procedure TMainForm.GridDataRowMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
   // obligatoire si mgoRowMoving est dans les options
   RecordsList.Move(FromIndex, ToIndex);
end;

procedure TMainForm.GridBeforeSelectCell(Sender: TObject; CurCol,
  CurDataRow, NewCol, NewDataRow: Integer; var CanSelect: Boolean);
begin
   // vous pouvez essayer ceci
   // en cas de changement de ligne, vérification si la date n'est pas vide
   {if NewDataRow <> CurDataRow then
     if RecordsList.FieldValue[F_DATE, CurDataRow] = '' then
     begin
       beep;
       ShowMessage('Ligne ' + IntToStr(CurDataRow) + ' : la date ne peut être vide.');
       CanSelect:= false;
     end;}
end;

procedure TMainForm.GridAfterSelectCell(Sender: TObject; OldCol,
  OldDataRow, CurCol, CurDataRow: Integer);
begin
  // met à jour le memo avec la cellule nouvellement sélectionnée
  UpdateMemo;
end;

procedure TMainForm.GridCellClick(Sender: TObject; Shift: TShiftState;
  ACol, ADataRow: Integer; ARect: TRect; X, Y: Integer);
var
  R: TRect;
  S: string;
begin
    if Grid.Columns[ACol].ColIdx = F_FILE then
    begin
      S:= RecordsList.FieldValue[F_FILE, ADataRow];
      if FileExists(S) then
      begin
         {calcul de l'emplacement de l'icône}
         R:=Grid.DrawBitmap(FILEBMP, ARect, Rect(-1, -1,35,35), true, true);
         if PtInRect(R, Point(X,Y)) then // on a clicqué dans l'icône
           ShellExecute(Handle, 'open', PChar('"' + S + '"'), nil, nil, SW_SHOW);
      end;
    end;
end;

procedure TMainForm.GridDrawDataCell(Sender: TObject; ACol,
  ADataRow: Integer; ARect: TRect; AState: TGridDrawState; var AValue: String);
var
  R: TRect;
  ALeft: integer;
begin
   // cet événement est tout à fait facultatif
   // il permet de déroger au dessin par défaut du texte
   try
   case Grid.Columns[ACol].EditingParams.CellType of
     ctInteger: AValue:= FloatToStrF(StrToFloat(AValue), ffNumber, 12,0);
     ctFloat: AValue:= FloatToStrF(StrToFloat(AValue), ffNumber, 15,2);
     ctBoolean: if (AValue = '0') or (AValue = '1') then
                begin
                   if AValue = '1' then
                     Grid.DrawBitmap(CHECKBMP, ARect, Rect(-1, -1,25,25), true, false);
                   AValue:= '';
                end;
   end;
   except
   end;
   case Grid.Columns[ACol].ColIdx of
     F_FILE : if FileExists(AValue) then
              begin
                 AValue:= '';
                 Grid.DrawBitmap(FILEBMP, ARect, Rect(-1, -1,35,35), true, false);
              end;
     F_GRAPH : begin // l'emploi de Pos n'est pas terrible, mais ce n'est qu'une démo !
                 ALeft:= -1;
                 if Pos('BMP1', AnsiUpperCase(AValue))> 0 then
                 begin
                   ALeft:= ARect.Left + 2;
                   R:= Grid.DrawBitmap(BMP1, ARect,Rect(ALeft, -1,150,150), true, false);
                   ALeft:= R.Right + 5;
                 end;
                 if Pos('BMP2', AnsiUpperCase(AValue))> 0 then
                 begin
                   if ALeft = -1 then ALeft:= ARect.Left + 2;
                   R:= Grid.DrawBitmap(BMP2, ARect,Rect(ALeft, -1,150,150), true, false);
                   ALeft:= R.Right + 5;
                 end;
                 if Pos('BMP3', AnsiUpperCase(AValue))> 0 then
                 begin
                   if ALeft = -1 then ALeft:= ARect.Left + 2;
                   Grid.DrawBitmap(BMP3, ARect,Rect(ALeft, -1,150,150), true, false);
                 end;
                 if ALeft > -1 then AValue:= '';
               end;
   end;
end;

procedure TMainForm.GridCalcRowHeight(Sender: TObject; ADataRow: Integer;
  var ARowHeight: Integer);
begin
   // facultatif : augmente la hauteur de ligne si un bitmap est à afficher
   if RecordsList[F_GRAPH, ADataRow] <> '' // il y en principe une image (code pas terrible)
     then if ARowHeight < 40 then
        ARowHeight := 40;
end;

procedure TMainForm.InsertRow(ARow: integer);
begin
  if ARow < 0 then RecordsList.Add([''])
    else RecordsList.Insert([''], ARow);
  Grid.DataRowCount:= RecordsList.Count;
end;

procedure TMainForm.AddRowBtnClick(Sender: TObject);
begin
   InsertRow(-1);
end;

procedure TMainForm.InsertRowBtnClick(Sender: TObject);
begin
   InsertRow(Grid.DataRow);
end;

procedure TMainForm.DeleteRowBtnClick(Sender: TObject);
begin
   RecordsList.Delete(Grid.DataRow);
   if RecordsList.Count = 0 then InsertRow(-1); // il faut au moins 1 ligne de données
   Grid.DataRowCount:= RecordsList.Count;
end;

procedure TMainForm.AddColumnBtnClick(Sender: TObject);
begin
   Grid.ColumnsCount:= Grid.ColumnsCount + 1;
   with Grid.Columns[Grid.ColumnsCount - 1] do ColIdx:= Grid.ColumnsCount - 1;
end;

procedure TMainForm.ColOptionsBtnClick(Sender: TObject);
begin
   ColumnsForm.ShowModal;
end;

procedure TMainForm.ModifyByMemoBtnClick(Sender: TObject);
begin
   RecordsList.EditField(Grid.Col, Grid.DataRow, Memo1.Text);
   Grid.Invalidate;
end;

procedure TMainForm.UpdateMemo;
begin
   Memo1.Clear;
   with Grid do Memo1.Text:= RecordsList[Columns[Col].ColIdx, DataRow];
end;

procedure TMainForm.SetGridOptions;
begin
  if CBGridEditing.Checked then
       Grid.GridOptions:= Grid.GridOptions + [mgoEditing]
       else Grid.GridOptions:= Grid.GridOptions - [mgoEditing];
   if CBRowSelect.Checked then
       Grid.GridOptions:= Grid.GridOptions + [mgoRowSelect]
       else Grid.GridOptions:= Grid.GridOptions - [mgoRowSelect];
   if RBAutoRowHeight.Checked then
       Grid.GridOptions:= Grid.GridOptions + [mgoAutoRowHeight]
       else Grid.GridOptions:= Grid.GridOptions - [mgoAutoRowHeight];
   if RBManualResize.Checked then
       Grid.GridOptions:= Grid.GridOptions + [mgoRowSizing]
       else Grid.GridOptions:= Grid.GridOptions - [mgoRowSizing];
   ModifyByMemoBtn.Enabled:= not(mgoRowSelect in Grid.GridOptions);
end;

procedure TMainForm.CBGridEditingClick(Sender: TObject);
begin
   if CBGridEditing.Checked then CBRowSelect.Checked:= false;
   SetGridOptions;
end;

procedure TMainForm.CBRowSelectClick(Sender: TObject);
begin
   if CBRowSelect.Checked then CBGridEditing.Checked:= false;
   SetGridOptions;
end;

procedure TMainForm.SaveToFileBtnClick(Sender: TObject);
begin
   if SaveDialog1.Execute then
      RecordsList.SaveToFile(SaveDialog1.FileName);
end;

procedure TMainForm.LoadFromFile(S: string);
begin
   if FileExists(S) then
     RecordsList.LoadFromFile(S);
   if RecordsList.Count > 0 then Grid.DataRowCount:= RecordsList.Count
   else
      InsertRow(-1);
   UpdateMemo;
end;

procedure TMainForm.LoadFromFileBtnClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
     LoadFromFile(OpenDialog1.FileName);
end;

procedure TMainForm.SortBtnClick(Sender: TObject);
begin
   With RecordsList do
   begin
     SetSortKey([F_TITRE]);
     Sort;
     SetSortKey([]);
   end;
   Grid.Invalidate;
   Grid.DataRow:= 0;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
   Grid.SetFocus;
end;

initialization
  TestFileName:= ExtractFilePath(Application.ExeName) + 'Test.thg'

end.
