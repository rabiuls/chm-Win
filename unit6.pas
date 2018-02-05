unit Unit6; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ColorBox, Buttons, LCLIntf;

type

  { TForm5IndexStart }

  TForm5IndexStart = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    ColorDialog1: TColorDialog;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    SaveDialog1: TSaveDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form5IndexStart: TForm5IndexStart;

implementation

{ TForm5IndexStart }

procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if not DirectoryExists(StartDir) then
    exit;
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';

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
  IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
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




procedure TForm5IndexStart.BitBtn1Click(Sender: TObject);
begin
  Close;
end;


procedure TForm5IndexStart.BitBtn3Click(Sender: TObject);
var
d,nameis, linkis, str: string;
sl,tl, nl: TStringList;
i: integer;
F: TextFile;
begin
  if not DirectoryExists(LabeledEdit1.Text) then
  begin
      ShowMessage('Directory not found.');
      exit;
  end;


  SaveDialog1.InitialDir:=LabeledEdit1.Text;
  SaveDialog1.FileName:='Start.html';
  If Not SaveDialog1.Execute then exit;
  LabeledEdit3.Text:=SaveDialog1.FileName;

 Screen.Cursor:=crHourGlass;
 AssignFile(F, LabeledEdit3.Text);
 Rewrite(F);
//<div style="text-align: center;"><big><big>headline<br></big></big></div>

 writeln(F, '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><html><head><meta content="text/html; charset=ISO-8859-1"http-equiv="content-type"><title>' + LabeledEdit2.Text + '</title></head><body bgcolor="' + LabeledEdit4.Text + '"><font color="' + LabeledEdit5.Text + '">' +  '<div style="text-align: center;"><big><big>' + LabeledEdit2.Text + '<br></big></big></div>' + '<br>');
 d:= IncludeTrailingPathDelimiter(LabeledEdit1.Text);
 sl:= TStringList.Create;
 tl:= TStringList.Create;

 FindFiles(tl,d, '*.txt');
 FindFiles(sl,d, '*.htm');

 sl.AddStrings(tl);
 for i:= 0 to sl.Count-1 do
 begin
 nameis:= StringReplace(ExtractFileName(sl[i]), ExtractFileExt(sl[i]), '',[]);
 linkis:= StringReplace(sl[i], d, '',[]);
 sl[i]:= nameis + '#' + '<a href="' + linkis + '">' + nameis + '</a><br>';
 end;

 sl.Sort;

 for i:= 0 to sl.count-1 do
 begin
     str:= copy(sl[i], 1 + (Pos('#', sl[i])), Length(sl[i])  - Pos('#', sl[i]));
     str:= StringReplace(str, '\','/', [rfReplaceAll]);

     Repeat
     if str[1] = '/' then
      str:= StringReplace(str, '/','', []);
     Until str[1] <> '/';
     
     Writeln(F, Trim(str));
 end ;

 writeln(F, '<br>');
 writeln(F, '</body></html>');
 closefile(F);
 sl.Free;
 tl.Free;
 Screen.Cursor:=crDefault;
 showmessage('Done.');
  
end;

function TColorToHex(Color : TColor) : string;
begin
   Result :=
     IntToHex(GetRValue(Color), 2) +
     IntToHex(GetGValue(Color), 2) +
     IntToHex(GetBValue(Color), 2) ;
end;

//<body bgcolor="#C0C0C0">
//<font color="#000000">
//<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"><html><head><meta content="text/html; charset=ISO-8859-1"http-equiv="content-type"><title></title></head><body bgcolor="#808040"><font color="#FF0000"><br>Text writing</body></html>
procedure TForm5IndexStart.BitBtn4Click(Sender: TObject);
begin
  if not ColorDialog1.Execute then exit;

  LabeledEdit4.Text:= '#' + TColorToHex(ColorDialog1.Color);
end;

procedure TForm5IndexStart.BitBtn5Click(Sender: TObject);
begin
  if not ColorDialog1.Execute then exit;

  LabeledEdit5.Text:= '#' + TColorToHex(ColorDialog1.Color);
end;

initialization
  {$I unit6.lrs}

end.

