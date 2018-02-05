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

unit Unit4; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form3: TForm3; 

implementation

{ TForm3 }

procedure TForm3.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if Key = 13 then
  begin
  key:=0;
  ModalResult:= mrok;
  end;
  
  if Key = 27 then
  begin
  key:=0;
  ModalResult:= mrCancel;
  end;
end;

initialization
  {$I unit4.lrs}

end.

