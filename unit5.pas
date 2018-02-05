
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
unit unit5;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type

  { TForm4 }

  TForm4 = class(TForm)
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form4: TForm4; 

implementation

{ TForm4 }

procedure TForm4.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:=caFree;
  Form4:=nil;
end;


procedure TForm4.SpeedButton1Click(Sender: TObject);
begin
close;
end;



initialization
  {$I unit5.lrs}

end.

