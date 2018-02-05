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

unit Unit2; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, StdCtrls, Menus, Unit4;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ImageList1: TImageList;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SaveDialog1: TSaveDialog;
    TreeView1: TTreeView;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    MistakeCount: Integer;
  end;

var
  Form2: TForm2;
  PreviousNode: Integer;

implementation

{ TForm2 }
Uses Unit1;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  If ( (TreeView1.Selected = nil) Or (TreeView1.Selected.HasChildren) ) then
begin
    showmessage('Please select a file for Start Page or click Cancel');
    exit;
end;
ModalResult:= mrOk;
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  PreviousNode:=0;
  MistakeCount:=0;
end;

procedure Wheader(FN: string; FolderIcon: Boolean = False);
var
  C: TextFile;
begin
  assignfile(C, FN);

  Rewrite(C);

  writeln(C, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">');
  writeln(C, '<HTML>');
  writeln(C, '<HEAD');
  writeln(C, '<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">');
  writeln(C, '<!-- Sitemap 1.0 -->');
  writeln(C, '</HEAD><BODY>');
  writeln(C, '<OBJECT type="text/site properties">');
//  writeln(C, '<param name="FrameName" value="This">');
//  writeln(C, '<param name="WindowName" value="Rabiul">');
  writeln(C, '<param name="Window Styles" value="0x800025">');
  if FolderIcon then
    writeln(C, '<param name="ImageType" value="Folder">');
  writeln(C, '</OBJECT>');
  writeln(C, '<UL>');
  writeln(C, '');

  closefile(c);
end;

procedure WFooter(FN: string);
var
  C: TextFile;
begin
  assignfile(C, FN);
  Append(C);
  writeln(C, '</UL>');
  writeln(C, '</BODY></HTML>');
  closefile(c);
end;

procedure WDir(filename, dirname: string);
var
  C: TextFile;
begin
  assignfile(C, filename);
  Append(C);

  writeln(C, '<LI> <OBJECT type="text/sitemap">');
  writeln(C, '<param name="Name" value="' + dirname + '">');
  writeln(C, '</OBJECT>');
  writeln(C, '<UL>');

  closefile(c);
end;

procedure WFile(filename, Fname, ShortFname: string);
var
  C: TextFile;
begin
  assignfile(C, filename);
  Append(C);

  writeln(C, '<LI> <OBJECT type="text/sitemap">');
  writeln(C, '<param name="Name" value="' + ShortFname + '">');
  writeln(C, '<param name="Local" value="' + Fname + '">');
  writeln(C, '</OBJECT>');
  closefile(c);
end;

procedure AddSlash(FN: string; NUM: Integer);
var
  C: TextFile;
  i: integer;
begin
  assignfile(C, FN);
  Append(C);

  for i := 1 to NUM do
    writeln(C, '</UL>');

  CloseFile(c);
end;


procedure TForm2.MenuItem2Click(Sender: TObject);
var
fname, str: string;
i: integer;
AnItem: TTreeNode;

begin
  if not SaveDialog1.Execute then exit;
  fname:= SaveDialog1.FileName;
      if RadioButton2.Checked then
      Wheader(fname, False)
      else
      Wheader(fname, True);
      
  for i := 0 to (Form1.treeview1.Items.Count - 1) do
    begin
      str := Form1.treeview1.Items[i].text;
      AnItem := Form1.treeview1.Items[i];

      if AnItem.Level < PreviousNode then
        AddSlash(fname, (PreviousNode - Anitem.Level));
      PreviousNode := AnItem.Level;

      while Anitem.Level > 0 do
        begin
          AnItem := anitem.Parent;
          str := AnItem.Text + '/' + str;
        end;


      if Form1.treeview1.Items[i].HasChildren then
        begin
          WDir(fname, treeview1.Items[i].Text)
        end
      else if ((Pos('HTM', Uppercase(RightStr(str, 4))) > 0) or (Pos('TXT', Uppercase(RightStr(str, 4))) > 0) and (str <> StartPage)) then
        begin
          WFile(fname, Str, treeview1.Items[i].Text)
        end;

    end;

  WFooter(fname);
  ShowMessage('Done.');
end;

procedure TForm2.MenuItem3Click(Sender: TObject);
begin
  Close;
end;

procedure TForm2.RadioButton1Change(Sender: TObject);
begin
  If RadioButton2.Checked then RadioButton1.Checked:= False;
end;

procedure TForm2.RadioButton2Change(Sender: TObject);
begin
  If RadioButton1.Checked then RadioButton2.Checked:= False;
end;


procedure TForm2.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if BitBtn1.Visible then exit;
  if TreeView1.Selected = nil then exit;
  
  if ((key = 32)OR(key = 13)) then
  if TreeView1.Selected.ImageIndex = 3 then
  begin
  if TreeView1.Selected.HasChildren then
   if TreeView1.Selected.Expanded then
    TreeView1.Selected.Collapse(false)
    else
    TreeView1.Selected.Expand(false);
    
  form3.Edit1.Text:=TreeView1.Selected.Text;
  if form3.ShowModal = mrok then
  TreeView1.Selected.Text:= form3.Edit1.Text;
  end
  else
  begin
    if MistakeCount > 3 then exit;
    MistakeCount:=MistakeCount+1;
    ShowMessage('This item will not be added in the content file.' + #13#10 + 'Edit the items having icons.' + #13#10 + '(*.html/*.htm + *.txt + Folder)' + #13#10 + 'This message will be shown for ' + IntToStr(3 - MistakeCount) + ' time more' + #13#10 + 'for next mistakes :).');
    exit;
  end;
end;


initialization
  {$I unit2.lrs}

end.

