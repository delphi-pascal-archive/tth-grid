object MainForm: TMainForm
  Left = 221
  Top = 130
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TThGrid'
  ClientHeight = 625
  ClientWidth = 1009
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 720
    Top = 8
    Width = 281
    Height = 609
    BorderStyle = bsSingle
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 15
      Top = 15
      Width = 252
      Height = 168
      Caption = ' Grid options '
      TabOrder = 0
      object CBGridEditing: TCheckBox
        Left = 15
        Top = 34
        Width = 159
        Height = 21
        Caption = 'Edition grid'
        TabOrder = 0
        OnClick = CBGridEditingClick
      end
      object CBRowSelect: TCheckBox
        Left = 15
        Top = 64
        Width = 99
        Height = 21
        Caption = 'RowSelect'
        TabOrder = 1
        OnClick = CBRowSelectClick
      end
      object RBAutoRowHeight: TRadioButton
        Left = 15
        Top = 103
        Width = 168
        Height = 21
        Caption = 'Auto height'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = CBGridEditingClick
      end
      object RBManualResize: TRadioButton
        Left = 15
        Top = 133
        Width = 139
        Height = 21
        Caption = 'Manual resize'
        TabOrder = 3
        OnClick = CBGridEditingClick
      end
    end
    object Memo1: TMemo
      Left = 15
      Top = 192
      Width = 252
      Height = 134
      TabOrder = 1
    end
    object ModifyByMemoBtn: TButton
      Left = 15
      Top = 335
      Width = 252
      Height = 31
      Caption = 'Modify cell by memo'
      TabOrder = 2
      OnClick = ModifyByMemoBtnClick
    end
    object AddRowBtn: TButton
      Left = 15
      Top = 384
      Width = 123
      Height = 31
      Caption = 'Add row'
      TabOrder = 3
      OnClick = AddRowBtnClick
    end
    object InsertRowBtn: TButton
      Left = 144
      Top = 384
      Width = 123
      Height = 31
      Caption = 'Insert row'
      TabOrder = 4
      OnClick = InsertRowBtnClick
    end
    object DeleteRowBtn: TButton
      Left = 15
      Top = 428
      Width = 123
      Height = 31
      Caption = 'Delete row'
      TabOrder = 5
      OnClick = DeleteRowBtnClick
    end
    object AddColumnBtn: TButton
      Left = 144
      Top = 428
      Width = 123
      Height = 31
      Caption = 'Add column'
      TabOrder = 6
      OnClick = AddColumnBtnClick
    end
    object ColOptionsBtn: TButton
      Left = 15
      Top = 473
      Width = 252
      Height = 30
      Caption = 'Columns properties ...'
      TabOrder = 7
      OnClick = ColOptionsBtnClick
    end
    object SaveToFileBtn: TButton
      Left = 15
      Top = 561
      Width = 123
      Height = 31
      Caption = 'Save to file'
      TabOrder = 9
      OnClick = SaveToFileBtnClick
    end
    object LoadFromFileBtn: TButton
      Left = 144
      Top = 561
      Width = 123
      Height = 31
      Caption = 'Load from file'
      TabOrder = 10
      OnClick = LoadFromFileBtnClick
    end
    object SortBtn: TButton
      Left = 15
      Top = 517
      Width = 252
      Height = 31
      Caption = 'Sort grid by title'
      TabOrder = 8
      OnClick = SortBtnClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'thg'
    Filter = '*.thg|*.thg|*.*|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 9
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.thg|*.thg|*.*|*.*'
    Left = 45
    Top = 152
  end
end
