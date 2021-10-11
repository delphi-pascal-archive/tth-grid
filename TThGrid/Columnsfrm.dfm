object ColumnsForm: TColumnsForm
  Left = 265
  Top = 318
  BorderStyle = bsDialog
  Caption = 'ColumnsForm'
  ClientHeight = 431
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 123
    Height = 13
    Caption = 'Choisissez la colonne'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CBColumns: TComboBox
    Left = 8
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = CBColumnsChange
  end
  object CBCanSelect: TCheckBox
    Left = 8
    Top = 208
    Width = 193
    Height = 17
    Caption = 'Autoriser la s'#233'lection de la colonne'
    TabOrder = 1
    OnClick = CBCanSelectClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 256
    Width = 205
    Height = 165
    Caption = ' Param'#232'tres d'#39#233'dition '
    TabOrder = 2
    object Label12: TLabel
      Left = 12
      Top = 48
      Width = 78
      Height = 13
      Caption = 'Type de donn'#233'e'
    end
    object Label13: TLabel
      Left = 12
      Top = 96
      Width = 115
      Height = 26
      AutoSize = False
      Caption = 'Maximum de caract'#232'res. 0 = pas de limite.'
      WordWrap = True
    end
    object Label14: TLabel
      Left = 48
      Top = 136
      Width = 45
      Height = 13
      Caption = 'Charcase'
    end
    object CBCanEdit: TCheckBox
      Left = 12
      Top = 24
      Width = 177
      Height = 17
      Caption = 'Autoriser l'#39#233'dition de la colonne'
      TabOrder = 0
      OnClick = CBCanEditClick
    end
    object CBCellType: TComboBox
      Left = 12
      Top = 64
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = CBCellTypeChange
      Items.Strings = (
        'ctText'
        'ctInteger'
        'ctFloat'
        'ctDateTime'
        'ctBoolean')
    end
    object EditMaxLength: TSpinEdit
      Left = 136
      Top = 100
      Width = 61
      Height = 22
      MaxLength = 300
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
      OnChange = CBCellTypeChange
    end
    object CBCharcase: TComboBox
      Left = 112
      Top = 132
      Width = 85
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = CBCellTypeChange
      Items.Strings = (
        'ecNormal'
        'ecUpperCase'
        'ecLowerCase')
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 64
    Width = 205
    Height = 137
    Caption = ' Couleur de la colonne '
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 36
      Width = 30
      Height = 13
      Caption = 'Color1'
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 30
      Height = 13
      Caption = 'Color2'
    end
    object Label4: TLabel
      Left = 8
      Top = 108
      Width = 41
      Height = 13
      Caption = 'D'#233'grad'#233
    end
    object ColorBox1: TColorBox
      Left = 48
      Top = 32
      Width = 145
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
      ItemHeight = 16
      TabOrder = 0
      OnChange = ColorBox1Change
    end
    object ColorBox2: TColorBox
      Left = 48
      Top = 68
      Width = 145
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor]
      ItemHeight = 16
      TabOrder = 1
      OnChange = ColorBox1Change
    end
    object CBGradation: TComboBox
      Left = 60
      Top = 104
      Width = 133
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = ColorBox1Change
      Items.Strings = (
        'gtNone'
        'gtHorizontal'
        'gtVertical')
    end
  end
  object GroupBox4: TGroupBox
    Left = 224
    Top = 64
    Width = 185
    Height = 357
    Caption = ' Affichage du texte '
    TabOrder = 4
    object Label5: TLabel
      Left = 8
      Top = 20
      Width = 100
      Height = 13
      Caption = 'Alignement horizontal'
    end
    object Label6: TLabel
      Left = 8
      Top = 60
      Width = 89
      Height = 13
      Caption = 'Alignement vertical'
    end
    object Label7: TLabel
      Left = 8
      Top = 236
      Width = 120
      Height = 13
      Caption = 'Ellipsis : coupure du texte'
    end
    object CBHorzAlignment: TComboBox
      Left = 8
      Top = 36
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = CBHorzAlignmentChange
      Items.Strings = (
        'taLeftJustify'
        'taRightJustify'
        'taCenter')
    end
    object CBVertAlignment: TComboBox
      Left = 8
      Top = 76
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = CBHorzAlignmentChange
      Items.Strings = (
        'vaBottom'
        'vaCenter'
        'vaTop')
    end
    object FontBtn: TButton
      Left = 44
      Top = 324
      Width = 75
      Height = 25
      Caption = 'Font'
      TabOrder = 2
      OnClick = FontBtnClick
    end
    object CBMultiLines: TCheckBox
      Left = 8
      Top = 296
      Width = 149
      Height = 17
      Caption = 'Texte sur plusieurs lignes'
      TabOrder = 3
      OnClick = CBMultiLinesClick
    end
    object CBEllipsis: TComboBox
      Left = 8
      Top = 252
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnClick = CBEllipsisClick
      Items.Strings = (
        'teNone'
        'teEndEllipsis'
        'tePathEllipsis')
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 108
      Width = 155
      Height = 117
      Caption = ' Ajustement du texte (Offset)  '
      TabOrder = 5
      object Label8: TLabel
        Left = 16
        Top = 24
        Width = 18
        Height = 13
        Caption = 'Left'
      end
      object Label9: TLabel
        Left = 72
        Top = 24
        Width = 19
        Height = 13
        Caption = 'Top'
      end
      object Label10: TLabel
        Left = 16
        Top = 72
        Width = 25
        Height = 13
        Caption = 'Right'
      end
      object Label11: TLabel
        Left = 72
        Top = 72
        Width = 33
        Height = 13
        Caption = 'Bottom'
      end
      object EditLeftOffset: TSpinEdit
        Left = 17
        Top = 39
        Width = 40
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 0
        Value = 0
        OnChange = EditLeftOffsetChange
      end
      object EditBottomOffset: TSpinEdit
        Left = 73
        Top = 87
        Width = 40
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 1
        Value = 0
        OnChange = EditLeftOffsetChange
      end
      object EditRightOffset: TSpinEdit
        Left = 17
        Top = 87
        Width = 40
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 2
        Value = 0
        OnChange = EditLeftOffsetChange
      end
      object EditTopOffset: TSpinEdit
        Left = 73
        Top = 39
        Width = 40
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 3
        Value = 0
        OnChange = EditLeftOffsetChange
      end
    end
  end
  object CBRightVertLine: TCheckBox
    Left = 8
    Top = 232
    Width = 181
    Height = 17
    Caption = 'Ligne verticale de fin de colonne'
    TabOrder = 5
    OnClick = CBRightVertLineClick
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 168
    Top = 12
  end
end
