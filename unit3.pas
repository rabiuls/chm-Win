(*****************************************************************************
** Copyright 2009, Rabiul Hassan Khan.                                      **
**                                                                          **
** This file is part of Rahman CHM Maker.                                   **
**                                                                          **
** Rahman CHM Maker is free software: you can redistribute it and/or modify **
** it under the terms of the GNU General Public License as published by     **
** the Free Software Foundation, either version 3 of the License, or        **
** (at your option) any later version.                                      **
**                                                                          **
** Rahman CHM Maker is distributed in the hope that it will be useful,      **
** but WITHOUT ANY WARRANTY; without even the implied warranty of           **
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            **
** GNU General Public License for more details.                             **
**                                                                          **
** You should have received a copy of the GNU General Public License        **
** along with Rahman CHM Maker.  If not, see <http://www.gnu.org/licenses/>.**
*****************************************************************************)

unit Unit3; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls, Buttons, Menus, Spin;

type

  { TForm3Index }

  TForm3Index = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    SaveDialog1: TSaveDialog;
    SpinEdit1: TSpinEdit;
    StringGrid1: TStringGrid;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    { private declarations }
  public
    { public declarations }
    LastSelected: Integer;
    BsDir: String;
    SL: TStringList;
  end; 

var
  Form3Index: TForm3Index;

implementation

{ TForm3Index }

procedure TForm3Index.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3Index.BitBtn2Click(Sender: TObject);
var
i: integer;
begin
  if SpinEdit1.Value <= 0 then exit;
  
  for i:= 1 to SpinEdit1.Value do
  StringGrid1.InsertColRow(False, StringGrid1.RowCount);
end;

function IsCellSelected(StringGrid: TStringGrid; X, Y: Longint): Boolean;
begin
  Result := False;
  try
    if (X >= StringGrid.Selection.Left) and (X <= StringGrid.Selection.Right) and
      (Y >= StringGrid.Selection.Top) and (Y <= StringGrid.Selection.Bottom) then
      Result := True;
  except
  end;
end;


procedure TForm3Index.BitBtn3Click(Sender: TObject);
var
i: integer;
begin
 for i:= (StringGrid1.RowCount - 1) DownTo 1 do
 if IsCellSelected(StringGrid1,0,i) then
 begin
       StringGrid1.Cells[0,i]:='';
       StringGrid1.Cells[1,i]:='';
 end;

  for i:= (StringGrid1.RowCount - 1) DownTo 1 do
   if StringGrid1.Cells[0,i]= '' then
   StringGrid1.DeleteColRow(False,i);

end;

procedure TForm3Index.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SL.Free;
  CloseAction:=caFree;
  Form3Index:= nil;
end;

procedure TForm3Index.FormCreate(Sender: TObject);
begin
  SL:= TStringList.Create;
  SpinEdit1.Value:=1;
End;

Function TextFromHTML(s: string):string;
//Extracts all the text between tags from an HTML string
var
  IsText: Boolean;
  i: Integer;
begin
  result := '';
  IsText := false;

  for i := 1 to Length(s) do begin
    if s[i] = '<' then IsText := false;
    if IsText then result := result + s[i];
    if s[i] = '>' then IsText := true;
  end;

  Result := StringReplace(Result, '&quot;', '"',  [rfReplaceAll]);
  Result := StringReplace(Result, '&apos;', '''', [rfReplaceAll]);
  Result := StringReplace(Result, '&gt;',   '>',  [rfReplaceAll]);
  Result := StringReplace(Result, '&lt;',   '<',  [rfReplaceAll]);
  Result := StringReplace(Result, '&amp;',  '&',  [rfReplaceAll]);
  Result := StringReplace(Result, '&nbsp;',  ' ',  [rfReplaceAll]);

end;

procedure TForm3Index.MenuItem2Click(Sender: TObject);
var
FName: String;
begin
  if StringGrid1.RowCount < 1 then exit;
  
  FName:= BsDir + StringGrid1.Cells[1, LastSelected];
  if Not FileExists(FName) then Exit;
  
   if Pos( UpperCase('txt'), Uppercase(RightStr(FName, 4)) ) > 0  then
   begin
      Memo1.Clear;
      Memo1.Lines.LoadFromFile(FName);
      Memo1.SelStart:=1;
      memo1.SelLength:=2;
   end
   else if Pos( UpperCase('htm'), Uppercase(RightStr(FName, 4)) ) > 0  then
   begin
      SL.Clear;
      SL.LoadFromFile(FName);
      Memo1.Clear;
      Memo1.Text:=TextFromHTML(SL.Text);
      Memo1.SelStart:=0;
      memo1.SelLength:=0;

   end;
   
end;

procedure TForm3Index.MenuItem3Click(Sender: TObject);
var
F: TextFile;
i: integer;
begin
    SaveDialog1.Filter:='CHM Index file (*.hhk)|*.hhk';
    SaveDialog1.DefaultExt:='hhk';
  if not SaveDialog1.Execute then exit;

  AssignFile(F, SaveDialog1.FileName);
rewrite(F);
      writeln(F, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">');
      writeln(F, '<HTML>');
      writeln(F, '<HEAD>');
      writeln(F, '<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">');
      writeln(F, '<!-- Sitemap 1.0 -->');
      writeln(F, '</HEAD><BODY>');
      //writeln(F, '<OBJECT type="text/site properties">');
      //writeln(F, '	<param name="FrameName" value="MyIndex">');
      //writeln(F, '	<param name="WindowName" value="Rabiul">');
      //writeln(F, '</OBJECT>');
      writeln(F, '<UL>');
      
       For i:= 1 to (StringGrid1.RowCount - 1) Do
 begin
      writeln(F, '<LI> <OBJECT type="text/sitemap">');
      writeln(F, '<param name="Name" value="' + StringGrid1.cells[0, i] + '">');
      writeln(F, '<param name="Local" value="' + StringGrid1.cells[1, i]  + '">');
      writeln(F, '</OBJECT>');
 end;

      writeln(F, '</UL>');
      writeln(F, '</BODY></HTML>');
closefile(F);
Showmessage('Done.');


end;

procedure TForm3Index.MenuItem4Click(Sender: TObject);
begin
  BitBtn2.Click;
end;

procedure TForm3Index.MenuItem5Click(Sender: TObject);
begin
  BitBtn3.Click;
end;

procedure TForm3Index.MenuItem6Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3Index.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  LastSelected:= aRow;
end;

initialization
  {$I unit3.lrs}

end.

