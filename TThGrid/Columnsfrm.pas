unit Columnsfrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin;

type
  TColumnsForm = class(TForm)
    CBColumns: TComboBox;
    FontDialog1: TFontDialog;
    CBCanSelect: TCheckBox;
    GroupBox1: TGroupBox;
    CBCanEdit: TCheckBox;
    CBCellType: TComboBox;
    Label1: TLabel;
    GroupBox3: TGroupBox;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    CBGradation: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox4: TGroupBox;
    CBHorzAlignment: TComboBox;
    CBVertAlignment: TComboBox;
    FontBtn: TButton;
    CBMultiLines: TCheckBox;
    CBEllipsis: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    EditLeftOffset: TSpinEdit;
    EditBottomOffset: TSpinEdit;
    EditRightOffset: TSpinEdit;
    EditTopOffset: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    EditMaxLength: TSpinEdit;
    Label13: TLabel;
    Label14: TLabel;
    CBCharcase: TComboBox;
    CBRightVertLine: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure CBColumnsChange(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure CBHorzAlignmentChange(Sender: TObject);
    procedure CBCanSelectClick(Sender: TObject);
    procedure CBCanEditClick(Sender: TObject);
    procedure CBEllipsisClick(Sender: TObject);
    procedure EditLeftOffsetChange(Sender: TObject);
    procedure CBCellTypeChange(Sender: TObject);
    procedure CBMultiLinesClick(Sender: TObject);
    procedure CBRightVertLineClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  ColumnsForm: TColumnsForm;

implementation

uses Mainfrm, ThGrids;

var
  Actif: integer;
  First: boolean;

{$R *.dfm}

procedure TColumnsForm.FormShow(Sender: TObject);
var
  I: integer;
begin
  CBColumns.Clear;
  for I:= 1 to Grid.ColumnsCount - 1 do
    CBColumns.Items.Add(IntToStr(I));
  CBColumns.ItemIndex:= 0;
  CBColumnsChange(nil);
end;

procedure TColumnsForm.CBColumnsChange(Sender: TObject);
begin
  Actif:= CBColumns.ItemIndex + 1;
  First:= true;
  CBCellType.ItemIndex:= ord(Grid.Columns[Actif].EditingParams.CellType);
  CBMultiLines.Checked:= Grid.Columns[Actif].TextMultiLines;
  ColorBox1.Selected:= Grid.Columns[Actif].Color.Color1;
  ColorBox2.Selected:= Grid.Columns[Actif].Color.Color2;
  CBGradation.ItemIndex:= ord(Grid.Columns[Actif].Color.Gradation);
  CBHorzAlignment.ItemIndex:= ord(Grid.Columns[Actif].HorzAlignment);
  CBVertAlignment.ItemIndex:= ord(Grid.Columns[Actif].VertAlignment);
  CBCanSelect.Checked:= Grid.Columns[Actif].CanSelect;
  CBCanEdit.Checked:= Grid.Columns[Actif].EditingParams.CanEdit;
  CBRightVertLine.Checked:= Grid.Columns[Actif].RightVertLine;
  CBEllipsis.ItemIndex:= ord(Grid.Columns[Actif].TextEllipsis);
  EditLeftOffset.Value:= Grid.Columns[Actif].Offset.Left;
  EditTopOffset.Value:= Grid.Columns[Actif].Offset.Top;
  EditRightOffset.Value:= Grid.Columns[Actif].Offset.Right;
  EditBottomOffset.Value:= Grid.Columns[Actif].Offset.Bottom;
  EditMaxLength.Value:= Grid.Columns[Actif].EditingParams.MaxLength;
  CBCharCase.ItemIndex:= ord(Grid.Columns[Actif].EditingParams.CharCase);
  First:= false;
end;

procedure TColumnsForm.FontBtnClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(Grid.Columns[Actif].Font);
  if FontDialog1.Execute then
    Grid.Columns[Actif].Font.Assign(FontDialog1.Font);
end;

procedure TColumnsForm.ColorBox1Change(Sender: TObject);
begin
  with Grid.Columns[Actif].Color do
  begin
     Color1:= ColorBox1.Selected;
     Color2:= ColorBox2.Selected;
     case CBGradation.ItemIndex of
        0: Gradation:= gtNone;
        1: Gradation:= gtHorizontal;
        2: Gradation:= gtVertical;
     end;
  end;
end;

procedure TColumnsForm.CBHorzAlignmentChange(Sender: TObject);
begin
  with Grid.Columns[Actif] do
     case CBHorzAlignment.ItemIndex of
       0: HorzAlignment:= taLeftJustify;
       1: HorzAlignment:= taRightJustify;
       2: HorzAlignment:= taCenter;
     end;
  with Grid.Columns[Actif] do
     case CBVertAlignment.ItemIndex of
       0: VertAlignment:= vaBottom;
       1: VertAlignment:= vaCenter;
       2: VertAlignment:= vaTop;
     end;
end;

procedure TColumnsForm.CBCanSelectClick(Sender: TObject);
begin
  Grid.Columns[Actif].CanSelect:= CBCanSelect.Checked;
end;

procedure TColumnsForm.CBCanEditClick(Sender: TObject);
begin
  Grid.Columns[Actif].EditingParams.CanEdit:= CBCanEdit.Checked;
end;

procedure TColumnsForm.CBEllipsisClick(Sender: TObject);
begin
  with Grid.Columns[Actif] do
   case CBEllipsis.ItemIndex of
     0: TextEllipsis:= teNone;
     1: TextEllipsis:= teEndEllipsis;
     2: TextEllipsis:= tePathEllipsis;
   end;
end;

procedure TColumnsForm.EditLeftOffsetChange(Sender: TObject);
begin
  if First then Exit;
  with Grid.Columns[Actif].Offset do
   begin
      Left:= EditLeftOffset.Value;
      Top:= EditTopOffset.Value;
      Right:= EditRightOffset.Value;
      Bottom:= EditBottomOffset.Value;
   end;
end;

procedure TColumnsForm.CBCellTypeChange(Sender: TObject);
begin
  if First then Exit;
  with Grid.Columns[Actif].EditingParams do
  begin
      case CBCellType.ItemIndex of
        0: CellType:= ctText;
        1: CellType:= ctInteger;
        2: CellType:= ctFloat;
        3: CellType:= ctDateTime;
        4: CellType:= ctBoolean;
      end;
      MaxLength:= EditMaxLength.Value;
      case CBCharCase.ItemIndex of
        0: CharCase:= ecNormal;
        1: CharCase:= ecUpperCase;
        2: CharCase:= ecLowerCase;
      end;
  end;
end;

procedure TColumnsForm.CBMultiLinesClick(Sender: TObject);
begin
  Grid.Columns[Actif].TextMultiLines:= CBMultiLines.Checked;
end;

procedure TColumnsForm.CBRightVertLineClick(Sender: TObject);
begin
  Grid.Columns[Actif].RightVertLine:= CBRightVertLine.Checked;
end;

end.
