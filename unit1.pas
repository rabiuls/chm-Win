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
unit Unit1; 

{$mode objfpc}{$H+}
//{$mode delphi}
interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Unit2, chmfilewriter, Unit3, Unit4, Unit5, Menus, Unit6;

type

  { TMyThread }

  TMyThread = class(TThread)
  private
    fStatusText: string;
    FileNo: Integer;
    procedure ShowStatus;
  protected
    procedure Execute; override;
  public
    CHM:TChmProject;
    FS:TFileStream;
    constructor Create(CreateSuspended: boolean);
    Procedure Prog(Proj: TChmProject; Fname: String);
  end;

  { TForm1 }


  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn4Exit: TBitBtn;
    BitBtn4Make: TBitBtn;
    BitBtn5: TBitBtn;
    Button1Temp: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckNoCompile: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    Edit1SelDir: TEdit;
    Edit2SaveAs: TEdit;
    Edit3Title: TEdit;
    GroupBox1: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    ProgressBar1: TProgressBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SaveDialog1: TSaveDialog;
    SpeedButton2MoveDown: TBitBtn;
    SpeedButton3: TBitBtn;
    SpeedButtonMoveUp: TBitBtn;
    StatusBar1: TStatusBar;
    TreeView1: TTreeView;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn4ExitClick(Sender: TObject);
    procedure BitBtn4MakeClick(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure Button1TempClick(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckNoCompileChange(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label10MouseEnter(Sender: TObject);
    procedure Label10MouseLeave(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure GetDirectories(Tree: TTreeView; Directory: string; Item: TTreeNode; IncludeFiles: Boolean);
    Procedure LoadTree(Dirname: String; FileFirst: Boolean);
    function RevCustomSortProc(Node1, Node2: TTreeNode): Integer;
    procedure SpeedButton2MoveDownClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButtonMoveUpClick(Sender: TObject);
    function VerCustomSortProc(Node1, Node2: TTreeNode): Integer;
    Procedure Run();
    procedure MyThreadTerminate(Sender: TObject);
    Procedure AutoWriteHHK(WriteToFile: String);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 
  PreviousNode: Integer;
  Dir: string;
  MainFileName, DefPage, HHCFile, HHKFile, ProjFile, StartPage, xTitle: string;
  MyThread : TMyThread;
  MyThreadActive: Boolean;
  FileList: TStringList;
  List: TStringList;
  HKKList: TStringList;
implementation

{ TForm1 }

Function UniqTempFile(BaseDir, Prefix: String): String;
Var
X: String;
SR: TSearchRec;
IsFound: Boolean;
i: Int64;
begin
i:= 10000;
(*
if BaseDir[length(basedir)] <> '\' then
BaseDir:= basedir+'\';
*)
BaseDir:=IncludeTrailingPathDelimiter(BaseDir);
repeat
IsFound := FindFirst(Basedir + Prefix + '-' + IntToStr(i) + '*', faAnyFile - faDirectory, SR) = 0;
X:=Basedir + Prefix + '-' + IntToStr(i);
i:= i+1;
until Not IsFound;

Result:=X;

end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  if RadioButton1.Checked then
  RadioButton2.Checked:= False;
end;

function Tform1.RevCustomSortProc(Node1, Node2: TTreeNode): Integer;
var
x,y: string;
begin

  if Node1.HasChildren then
    X := 'B'
  else
    X := 'A';

  if Node2.HasChildren then
    Y := 'B'
  else
    Y := 'A';

  //Result := -AnsiStrIComp(PChar(Node1.Text), PChar(Node2.Text));
  Result := -AnsiCompareStr(X, Y);

end;

procedure TForm1.SpeedButton2MoveDownClick(Sender: TObject);
var
  NextItem, CurrItem: TTreeNode;
begin
  if TreeView1.Items.Count = 0 then
    exit;

  if TreeView1.Selected = nil then
    exit;

  CurrItem := TreeView1.Selected;
  NextItem := TreeView1.Selected.getNextSibling;

  if CurrItem = nil then
    exit;
  if NextItem = nil then
    exit;

  NextItem.MoveTo(CurrItem, naInsert);
  TreeView1.SetFocus;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  If TreeView1.Selected <> nil then
  TreeView1.Selected.Delete;
end;

procedure TForm1.SpeedButtonMoveUpClick(Sender: TObject);
var
 PrevItem, CurrItem: TTreeNode;
begin
  if TreeView1.Items.Count = 0 then
    exit;

  if TreeView1.Selected = nil then
    exit;

  CurrItem := TreeView1.Selected;
  PrevItem := TreeView1.Selected.getPrevSibling;

  if CurrItem = nil then
    exit;
  if PrevItem = nil then
    exit;

  CurrItem.MoveTo(PrevItem, naInsert);
  TreeView1.SetFocus;

end;


function Tform1.VerCustomSortProc(Node1, Node2: TTreeNode): Integer;
var
x,y: string;
begin

  if Node1.HasChildren then
    X := 'A'
  else
    X := 'B';

  if Node2.HasChildren then
    Y := 'A'
  else
    Y := 'B';

  //Result := -AnsiStrIComp(PChar(Node1.Text), PChar(Node2.Text));
  Result := -AnsiCompareStr(X, Y);

end;

Procedure TForm1.LoadTree(Dirname: String; FileFirst: Boolean);
begin
  Screen.Cursor := crHourGlass;
  TreeView1.Items.BeginUpdate;
  try
    TreeView1.Items.Clear;
    GetDirectories(TreeView1, Dirname, nil, True);
  finally
    Screen.Cursor := crDefault;
    if FileFirst then
    TreeView1.CustomSort(@RevCustomSortProc)
    else
    TreeView1.CustomSort(@VerCustomSortProc);
    TreeView1.Items.EndUpdate;
  end;

  if TreeView1.Items.Count > 0 then
  TreeView1.Items.GetFirstNode.Selected:= true;
  //Treeview1.SetFocus;//if invisible

end;


procedure TForm1.GetDirectories(Tree: TTreeView; Directory: string; Item: TTreeNode; IncludeFiles: Boolean);
var
  SearchRec: TSearchRec;
  ItemTemp, ImTmp: TTreeNode;
begin
  Tree.Items.BeginUpdate;
//  if Directory[Length(Directory)] <> '/' then
//    Directory := Directory + '/';
Directory:= IncludeTrailingPathDelimiter(Directory);
  if FindFirst(Directory + '*', faDirectory, SearchRec) = 0 then
    begin
      repeat
        if (SearchRec.Attr and faDirectory = faDirectory) and (SearchRec.Name[1] <> '.') then
          begin
            if (SearchRec.Attr and faDirectory > 0) then
              Item := Tree.Items.AddChild(Item, SearchRec.Name);
              Item.ImageIndex := 0; //Adding Image Rabiul
              Item.SelectedIndex := 1; //Adding Image while selected Rabiul

            ItemTemp := Item.Parent;
            GetDirectories(Tree, Directory + SearchRec.Name, Item, IncludeFiles);
            Item := ItemTemp;
          end
        else if IncludeFiles then
          if SearchRec.Name[1] <> '.' then
            begin
            //Tree.Items.AddChild(Item, SearchRec.Name);
              ImTmp := Tree.Items.AddChild(Item, SearchRec.Name); //Adding image Rabiul
              ImTmp.ImageIndex := 2; //Rabiul
              ImTmp.SelectedIndex := 2; //Adding Image while selected Rabiul

            end;
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;
  Tree.Items.EndUpdate;
end;
var
LstDir: String;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
    if not SelectDirectory('Select a directory to convert', LstDir, Dir) then
    exit;
    Edit1SelDir.Text:=Dir;
    LstDir:= Dir; //keep record for next click

    If MenuItem1.Checked then
    Form1.Visible:=False;

    If RadioButton1.Checked then
    LoadTree(Dir, False)
    else
    LoadTree(Dir, True);

    If MenuItem1.Checked then
    begin
    Form1.Visible:=True;
    Application.ProcessMessages;
    form1.WindowState:=wsNormal;
    Form1.BringToFront;
    end;
    
    TreeView1.SetFocus;

    Edit3Title.Text:=ExtractFileName(dir);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  SaveDialog1.InitialDir:= IncludeTrailingPathDelimiter(Edit1SelDir.Text) ;
  If Not SaveDialog1.Execute then exit;
  Edit2SaveAs.Text:=SaveDialog1.FileName;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
    If Not DirectoryExists(Edit1SelDir.Text) then
  begin
      ShowMessage('Please Select A Directory First.');
      exit;
  end;
  
    If RadioButton1.Checked then
    LoadTree(Dir, False)
    else
    LoadTree(Dir, True);

end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
i: integer;
str: string;
begin
  if TreeView1.Items.Count = 0 then
  begin
  Showmessage('Directory is not selected.');
  exit;
  end;

  If Not Assigned(Form2) then
  Application.CreateForm(TForm2, Form2);
   Application.CreateForm(TForm3, Form3); //For edit, can't place it on form2 due to some problems
  Form2.TreeView1.Items.Assign(TreeView1.Items);
  //Form2.Label1.Visible:=True;
  Form2.MenuItem1.Visible:=True;
  Form2.MenuItem1.Enabled:=True;
  Form2.BitBtn1.Visible:=False;
  Form2.BitBtn2.Caption:='Close';
  Form2.BitBtn2.Left:= Round(Form2.Width / 2) - Round(Form2.BitBtn2.Width / 2);
  Form2.Caption:= 'Edit Content File';
  Form2.RadioButton1.Enabled:=True;
  Form2.RadioButton1.Visible:=True;
  Form2.RadioButton2.Enabled:=True;
  Form2.RadioButton2.Visible:=True;


  for i:= 0 to (form2.TreeView1.Items.Count - 1) do
  begin
      str:= form2.TreeView1.Items[i].Text;
      if ( (form2.TreeView1.Items[i].HasChildren) OR (Pos('HTM', Uppercase(RightStr(str, 4))) > 0) OR (Pos('TXT', Uppercase(RightStr(str, 4))) > 0) ) then
      begin
         form2.TreeView1.Items[i].ImageIndex:=3;
         form2.TreeView1.Items[i].SelectedIndex:=3;
      end
      else
      begin
         form2.TreeView1.Items[i].ImageIndex:=-1;
         form2.TreeView1.Items[i].SelectedIndex:=-1;
      end;
      //str:= StringReplace(str, ExtractFileExt(str), '',[]);
      form2.TreeView1.Items[i].Text:=str;//Edit keyword while knowing file ext.
  end;

  Try
  If Form2.ShowModal = mrok then
  sleep(2)
  else
  sleep(3);
  Finally
  Form2.free;
  Form2:=nil;
  Form3.Free;
  form3:=nil;
  end;
 end;


procedure TForm1.BitBtn4ExitClick(Sender: TObject);
begin
  Close;
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


procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if not DirectoryExists(StartDir) then
    exit;
    
//  if StartDir[length(StartDir)] <> '/' then //Rabiul Note
//    StartDir := StartDir + '/';
StartDir := IncludeTrailingPathDelimiter(StartDir);

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  IsFound :=
    FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do
    begin
      FilesList.Add(StartDir + SR.Name);
      IsFound := FindNext(SR) = 0;
    end;
  FindClose(SR);

  // Build a list of subdirectories
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir + '*', faAnyFile, SR) = 0;
  while IsFound do
    begin
      if ((SR.Attr and faDirectory) <> 0) and
        (SR.Name[1] <> '.') then
        DirList.Add(StartDir + SR.Name);
      IsFound := FindNext(SR) = 0;
    end;
  FindClose(SR);

  // Scan the list of subdirectories
  for i := 0 to DirList.Count - 1 do
    FindFiles(FilesList, DirList[i], FileMask);

  DirList.Free;
end;
(*
procedure FindFiles(filespec, Mask:string;recursive:boolean;fn:TStrings);
var d : TSearchRec;
begin
  filespec:=includetrailingpathdelimiter(filespec);
  if findfirst(filespec + Mask, faanyfile and fadirectory,d)=0 then
    begin
      repeat
        if (d.attr and fadirectory = fadirectory)  then
        begin
          // if recursive
	  writeln('skipping '+d.name);
	end
        else
         begin
          fn.add(filespec+d.name);
          writeln(filespec+d.name);
         end;
      until findnext(d)<>0;
     findclose(d);
    end;
end;
  *)
Procedure TForm1.AutoWriteHHK(WriteToFile: String);
var
HK: TextFile;
i: integer;
BDR, NDR: String;
Begin
      AssignFile(HK, WriteToFile);
      Rewrite(HK);

      writeln(HK, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">');
      writeln(HK, '<HTML>');
      writeln(HK, '<HEAD>');
      writeln(HK, '<meta name="GENERATOR" content="Microsoft&reg; HTML Help Workshop 4.1">');
      writeln(HK, '<!-- Sitemap 1.0 -->');
      writeln(HK, '</HEAD><BODY>');
//      writeln(HK, '<OBJECT type="text/site properties">'); //frame not defined
//      writeln(HK, '	<param name="FrameName" value="MyIndex">');
//      writeln(HK, '	<param name="WindowName" value="Rabiul">');
//      writeln(HK, '</OBJECT>');
      writeln(HK, '<UL>');
      
        //htm/html index
        for i := 0 to HKKList.Count - 1 do
         If (Pos('.', HKKList[i]) > 0) Then
         If (Length(HKKList[i]) > 4) then
         if (Pos( UpperCase('htm'), Uppercase(RightStr(HKKList[i], 4)) ) > 0) then
          begin
            BDR := HKKList[i];
            if BDR[1] = '\' then
              BDR := StringReplace(BDR, '\', '', []); //Rabiul
            if BDR[1] = '/' then
              BDR := StringReplace(BDR, '/', '', []); //Rabiul
            //Memo1.Lines.add(BDR);
            NDR:= ExtractFileName(BDR);
            //Memo1.Lines.add(StringReplace(NDR, ExtractFileExt(NDR),'',[]));
            writeln(HK, '<LI> <OBJECT type="text/sitemap">');
            writeln(HK, '<param name="Name" value="' + StringReplace(NDR, ExtractFileExt(HKKList[i]), '', []) + '">');
            writeln(HK, '<param name="Local" value="' + BDR + '">');
            writeln(HK, '</OBJECT>');
          end;
          
        //Text File Index
        for i := 0 to HKKList.Count - 1 do
         If (Pos('.', HKKList[i]) > 0) Then
         If (Length(HKKList[i]) > 4) then
         if (Pos( UpperCase('txt'), Uppercase(RightStr(HKKList[i], 4)) ) > 0) then
          begin
            BDR := HKKList[i];
            if BDR[1] = '\' then
             BDR := StringReplace(BDR, '\', '', []); //Rabiul
            if BDR[1] = '/' then
              BDR := StringReplace(BDR, '/', '', []); //Rabiul
            //Memo1.Lines.add(BDR);
            NDR:= ExtractFileName(BDR);
            //Memo1.Lines.add(StringReplace(NDR, ExtractFileExt(NDR),'',[]));
            writeln(HK, '<LI> <OBJECT type="text/sitemap">');
            writeln(HK, '<param name="Name" value="' + StringReplace(NDR, ExtractFileExt(HKKList[i]), '', []) + '">');
            writeln(HK, '<param name="Local" value="' + BDR + '">');
            writeln(HK, '</OBJECT>');
          end;


      writeln(HK, '</UL>');
      writeln(HK, '</BODY></HTML>');
      CloseFile(HK);
end;

procedure TForm1.BitBtn4MakeClick(Sender: TObject);
var
  i: integer;
  AnItem: TTreeNode;
  str, tstr, basedir, BDR: string;
  SF: TextFile;
begin
  if TreeView1.Items.Count = 0 then
    exit;

  if not DirectoryExists(Edit1SelDir.Text) then
  begin
      showmessage('Directory does not exist:' + #13#10 + Edit1SelDir.Text);
      Exit;
  end;
  
  If not DirectoryExists(ExtractFileDir(Edit2SaveAs.Text)) then
  begin
   showmessage('Error in Save As "filename"' + #13#10 + Edit2SaveAs.Text);
   exit;
  end;

  MainFileName:='';
  DefPage:='';
  HHCFile:='';
  HHKFile:='';
  ProjFile:='';
  StartPage:='';
  xTitle:='';
  FileList.Clear;
  List.Clear;
  HKKList.Clear;
  
//  Application.ProcessMessages;
  Screen.Cursor := crHourGlass;

  PreviousNode := 0;
  AnItem := nil;


  if FileExists(Edit2SaveAs.Text) then
  DeleteFile(Edit2SaveAs.Text);

  basedir := Edit1SelDir.Text;
  
  MainFileName:=UniqTempFile(basedir, 'Rahman');
  DefPage:= MainFileName + '.html';
  HHCFile:= MainFileName + '.hhc';
  HHKFile:= MainFileName + '.hhk';
  ProjFile:= MainFileName + '.xml';

  xTitle := Edit3Title.Text;
  if Combobox2.ItemIndex = 0 then //Make an empty start page
    begin
      StartPage := DefPage;
      assignfile(SF, StartPage);
      Rewrite(SF);
      Writeln(SF, '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">');
      Writeln(SF, '<html><head><meta content="text/html; charset=ISO-8859-1" http-equiv="content-type"><title>.</title></head><body><br></body></html>');
      CloseFile(SF);
      StartPage := ExtractFileName(StartPage);
    end
  else
    StartPage := ComboBox2.Text;
  //HHC Auto let it be done, even custom hhc selected, due to hhk is made in between
    If ComboBox3.ItemIndex = 0 then
    Wheader(HHCFile, False)
    else
    Wheader(HHCFile, True);

  for i := 0 to (TreeView1.Items.Count - 1) do
    begin
      str := treeview1.Items[i].text;
      AnItem := TreeView1.Items[i];

      if AnItem.Level < PreviousNode then
        AddSlash(HHCFile, (PreviousNode - Anitem.Level));
      PreviousNode := AnItem.Level;

      while Anitem.Level > 0 do
        begin
          AnItem := anitem.Parent;
          str := AnItem.Text + '/' + str;
          //Rabiul: on windows
          //??//str := AnItem.Text + '/' + str;
        end;
        
        //For Index
        HKKList.Add( StringReplace(str,'\','/',[rfReplaceAll]) );

      if TreeView1.Items[i].HasChildren then
        begin
          WDir(HHCFile, ExtractFileName(str))
        end
      else if ((Pos('HTM', Uppercase(RightStr(str, 4))) > 0) or (Pos('TXT', Uppercase(RightStr(str, 4))) > 0) and (str <> StartPage)) then
        begin
          WFile(HHCFile, Str, ExtractFileName(str))
        end;

    end;

  WFooter(HHCFile);
  
  //HHC Auto Done
  If ComboBox4.ItemIndex > 2 then
  HHCFile:= ComboBox4.Text;
  
  If ComboBox1.ItemIndex = 1 then
  AutoWriteHHK(HHKFile)
  else if ComboBox1.ItemIndex > 2 then
  HHKFile:= ComboBox1.Text;
  

  Screen.Cursor := crDefault;
  SetCurrentDir(basedir);
  

  FindFiles(List,basedir,'*');

  
  for i := 0 to (List.Count - 1) do
        begin
            BDR := StringReplace(List[i], Edit1SelDir.Text, '', []);//Rabiul
            if BDR[1] = '\' then
            BDR := StringReplace(BDR, '\', '', []);
            if BDR[1] = '/' then
            BDR := StringReplace(BDR, '/', '', []);
            BDR := StringReplace(BDR, '\', '/', [rfReplaceAll]);
            FileList.Add(BDR);
        end;

  ProgressBar1.Visible:=True;
Run();

List.Clear;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
var
i: integer;
begin
  TreeView1.Items.Clear;
  Edit1SelDir.Clear;
  Edit2SaveAs.Clear;
  Edit3Title.Clear;
  i:= ComboBox1.ItemIndex;
  ComboBox1.Clear;
  ComboBox1.Items.Add('No Index');
  ComboBox1.Items.Add('Automatic From Filename');
  ComboBox1.Items.Add('Select');
  if i <= 1 then
  ComboBox1.ItemIndex:=i
  else
  ComboBox1.ItemIndex:=0;
  ComboBox1.Hint:='';
  
  ComboBox2.Clear;
  ComboBox2.Items.Add('Blank');
  ComboBox2.Items.Add('Select');
  ComboBox2.ItemIndex:=0;
  ComboBox2.Hint:='';
  
  i:= ComboBox4.ItemIndex;
  ComboBox4.Clear;
  ComboBox4.Items.Add('None');
  ComboBox4.Items.Add('Automatic From Filename');
  ComboBox4.Items.Add('Select');
  if i <= 1 then
  ComboBox4.ItemIndex:=i
  else
  ComboBox4.ItemIndex:=1;
  ComboBox4.Hint:='';
  StatusBar1.SimpleText:='';
end;


procedure TForm1.Button1TempClick(Sender: TObject);
var
i: Integer;
isl: TstringList;
istr: String;
iITem: TTreeNode;
begin

  if TreeView1.Items.Count = 0 then
  begin
  Showmessage('Directory is not selected.');
  exit;
  end;


If Not Assigned(Form3Index) then
Begin
 Application.CreateForm(TForm3Index, Form3Index);
 Form3Index.BsDir:= IncludeTrailingPathDelimiter(Edit1SelDir.Text);

    for i := 0 to (TreeView1.Items.Count - 1) do
    begin
      istr := treeview1.Items[i].text;
      iItem := TreeView1.Items[i];

        while iItem.Level > 0 do
        begin
          iItem := iItem.Parent;
          istr := iItem.Text + '/' + istr;
          //Rabiul: on windows
          //??//str := AnItem.Text + '/' + str;
        end;
        if Length(istr) > 4 then
        if ( (Pos( UpperCase('txt'), Uppercase(RightStr(istr, 4)) ) > 0) OR (Pos( UpperCase('htm'), Uppercase(RightStr(istr, 4)) ) > 0) ) then
        begin
        Form3Index.StringGrid1.InsertColRow(False, Form3Index.StringGrid1.RowCount);
        Form3Index.StringGrid1.Cells[1, (Form3Index.StringGrid1.RowCount -1)]:=istr;
        Form3Index.StringGrid1.Cells[0, (Form3Index.StringGrid1.RowCount -1)]:=StringReplace(ExtractFileName(istr), ExtractFileExt(istr), '',[]);
        
        end;
    end;


End;
Form3Index.Show;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
  if CheckBox2.Checked then
  CheckNoCompile.Checked:= False;
end;

procedure TForm1.CheckNoCompileChange(Sender: TObject);
begin
  if CheckNoCompile.Checked then
     begin
     CheckBox2.Checked:= False;
     BitBtn4Make.Hint:='Only make project files.';
     end
     else
     BitBtn4Make.Hint:='Compile CHM';

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var
xOpenDialog1: TOpenDialog;
begin
      ComboBox1.Hint := ComboBox1.Text;
  if ((ComboBox1.ItemIndex = 0) or (ComboBox1.ItemIndex = 1)) then
    exit;

  if ComboBox1.ItemIndex = 2 then
    begin
    xOpenDialog1:= TOpenDialog.Create(nil); //new, because sometimes opendialog1 holding filter of previous or none
    xOpenDialog1.Filter:= 'Index file (*.hhk)|*.hhk';
    Try
      if not xOpenDialog1.Execute then
        begin
          ComboBox1.ItemIndex := 0;
          Exit;
        end
        else
        begin
      ComboBox1.Items.Add(xOpenDialog1.FileName);
      ComboBox1.ItemIndex := ComboBox1.Items.Count - 1;
      ComboBox1.Hint := ComboBox1.Text;
      end;
      Finally
      xOpenDialog1.Free;
      End;
    end;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var
  AnItem: TTreenode;
  str: string;
begin
  ComboBox2.Hint := ComboBox2.Text;

   if TreeView1.Items.Count = 0 then
   begin
   ComboBox2.ItemIndex := 0;
   ComboBox2.Hint := '';
   exit;
   end;

  if ComboBox2.ItemIndex = 0 then
  begin
   ComboBox2.Hint := '';
   exit;
  end;

  if ComboBox2.ItemIndex > 2 then
  begin
   ComboBox2.Hint := ComboBox2.Text;
   exit;
  end;


  (*Change
    v.1.2 > proj option + about
    combobox item index add : "Make Index Like Start Page"
  *)

  if ComboBox2.ItemIndex = 2 then
  begin
   If Not Assigned(Form5IndexStart) then
   Application.CreateForm(TForm5IndexStart, Form5IndexStart);
   Form5IndexStart.LabeledEdit1.Text:=IncludeTrailingPathDelimiter(Edit1SelDir.Text);
   Try
     Form5IndexStart.ShowModal;
     Finally
     Form5IndexStart.Free;
     Form5IndexStart:= nil;
     ShowMessage('If you have saved any start page and want to use that then' + #13#10 + 'keep the file in : "' + IncludeTrailingPathDelimiter(Edit1SelDir.Text) + '"' + #13#10 + 'Click on "Reload" button, and finally' + #13#10 + 'select the file for Start Page, from this combobox again.');
     ComboBox2.ItemIndex := 0;
     ComboBox2.Hint := '';
     end;

  end;

  if ComboBox2.ItemIndex = 1 then
  begin
  If Not Assigned(Form2) then
  Application.CreateForm(TForm2, Form2);
  Form2.Label1.Caption:='Select Default Start Page.';
  Form2.TreeView1.Items.Assign(TreeView1.Items);


  try
    if Form2.ShowModal = mrOk then
      begin
        AnItem := Form2.TreeView1.Selected;
        while Anitem.Level > 0 do
          begin
            AnItem := anitem.Parent;
            str := AnItem.Text + '/' + str;   //Rabiul Note CHMSee
          end;
        ComboBox2.Items.Add(str + Form2.TreeView1.Selected.Text);
        ComboBox2.ItemIndex := ComboBox2.Items.Count - 1;
        end
    else
      ComboBox2.ItemIndex := 0;
  finally
    Form2.Free;
    Form2:=nil;
  end;

  ComboBox2.Hint := ComboBox2.Text;
  end; //if index=1
end;


procedure TForm1.ComboBox4Change(Sender: TObject);
begin
        ComboBox4.Hint := ComboBox4.Text;
  if ((ComboBox4.ItemIndex = 0) or (ComboBox4.ItemIndex = 1)) then
    exit;
    
  OpenDialog1.Filter:= 'CHM Content file (*.hhc)|*.hhc';;
  if ComboBox4.ItemIndex = 2 then
    begin
      if not OpenDialog1.Execute then
        begin
          ComboBox4.ItemIndex := 0;
          Exit;
        end;
      ComboBox4.Items.Add(OpenDialog1.FileName);
      ComboBox4.ItemIndex := ComboBox4.Items.Count - 1;
      ComboBox4.Hint := ComboBox4.Text;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FileList:= TStringList.Create;
  List:= TStringList.Create;
  HKKList:= TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FileList.Free;
  List.Free;
  HKKList.Free;
//  FreeAndNil(MyThread);
end;

procedure TForm1.Label10Click(Sender: TObject);
begin
  If Not Assigned(Form4) then
  begin
   Application.CreateForm(TForm4, Form4);
   end;
   Form4.Show;
   Form4.BringToFront;
end;

procedure TForm1.Label10MouseEnter(Sender: TObject);
begin
  Label10.Font.Color:=clBlue;
end;

procedure TForm1.Label10MouseLeave(Sender: TObject);
begin
  Label10.Font.Color:=clWindowText;
end;

procedure TForm1.Label12Click(Sender: TObject);
begin
    ShowMessage('Check this if you only want to generate project file, and other files needed to compile from commandline compiler.');
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  if Not MenuItem1.Checked then
  begin
  MenuItem1.Checked:= True;
  MenuItem2.Checked:= False;
  end;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if Not MenuItem2.Checked then
  begin
  MenuItem2.Checked:= True;
  MenuItem1.Checked:= False;
  end;

end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
    if RadioButton2.Checked then
  RadioButton1.Checked:= False;

end;

{ TMyThread }
procedure TMyThread.Prog(Proj: TChmProject; Fname: String);
var
i,j: integer;
begin
i:= Proj.Files.IndexOf(Fname);
FileNo:= Round( (i / (proj.Files.Count-1)) * 100);
fStatusText:=Fname;
Synchronize(@ShowStatus);
end;

procedure TMyThread.ShowStatus;
var
i: integer;
begin
 Form1.ProgressBar1.Position:=FileNo;
 form1.StatusBar1.SimpleText:=fStatusText;
 
end;

procedure TMyThread.Execute;
begin
CHM:=TChmProject.Create;
CHM.Title:=xTitle;
//CHM.DefaultFont:='Arial';
CHM.DefaultPage:=StartPage;
CHM.MakeSearchable:=Form1.CheckBox1.Checked;
CHM.AutoFollowLinks:=Form1.CheckBox3.Checked;
if Form1.ComboBox4.ItemIndex > 0 then
 if FileExists(HHCFile) then
 CHM.TableOfContentsFileName:=HHCFile;
 If form1.ComboBox1.ItemIndex > 0 then
  if FileExists(HHKFile) then
   CHM.IndexFileName:=HHKFile;
CHM.FileName:=ProjFile;
CHM.Files.Assign(FileList);
CHM.OutputFileName:=ExtractFileName(form1.Edit2SaveAs.Text);
CHM.OnProgress:=@Prog;

 If Not Form1.CheckBox2.Checked then
 CHM.SaveToFile(ProjFile);

 if Not Form1.CheckNoCompile.Checked then
 begin
 FS:=TFileStream.Create(Form1.Edit2SaveAs.Text,fmcreate);
 CHM.writechm(FS);
 FS.free;
 end;

  FreeAndNil(CHM);
  FileList.Clear;
end;

constructor TMyThread.Create(CreateSuspended: boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

Procedure TForm1.Run();
begin
  MyThread := TMyThread.Create(True); // With the True parameter it doesn't start automatically
  if Assigned(MyThread.FatalException) then
    raise MyThread.FatalException;

  // Here the code initialises anything required before the threads starts executing
  MyThread.OnTerminate:=@MyThreadTerminate;
  MyThread.Resume;
end;

procedure TForm1.MyThreadTerminate(Sender: TObject);
begin
 ProgressBar1.Position:=ProgressBar1.Max; //Progressbar Max is given to 110 instead of 100 to look good.
 FileList.Clear;
 List.Clear;

 if Not CheckNoCompile.Checked then
  If CheckBox2.Checked then
 begin
   if ComboBox4.ItemIndex = 1 then
   DeleteFile(HHCFile);
   if ComboBox1.ItemIndex = 1 then
   DeleteFile(HHKFile);
   If ComboBox2.ItemIndex = 0 then
   DeleteFile(StartPage);
   DeleteFile(ProjFile);
 end;

 ShowMessage('Done');
 
 ProgressBar1.Position:=0;
 ProgressBar1.Visible:=False;
 StatusBar1.SimpleText:='';
end;

initialization
  {$I unit1.lrs}

end.

