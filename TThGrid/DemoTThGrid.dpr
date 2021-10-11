program DemoTThGrid;

uses
  Forms,
  Mainfrm in 'Mainfrm.pas' {MainForm},
  Columnsfrm in 'Columnsfrm.pas' {ColumnsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TColumnsForm, ColumnsForm);
  Application.Run;
end.
