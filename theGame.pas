program theGame;
 
uses crt;
 
const
  Vposition = 25;
 
var 
  rk : char;
  Hposition : byte;
 
procedure attack;
var
  i : byte;
begin
  for i:=Vposition-1 DownTo 1 do
    begin
      gotoxy(Hposition+1, i);
      write('|');
      Delay(80);
      gotoxy(Hposition+1, i);
      write(' ');
    end;
  gotoxy(1, 1);
end;
 
procedure move(direction : char);
begin
  if direction = 'L' then
    begin
      gotoxy(Hposition+2, Vposition);
      write('    ');
      Hposition := Hposition - 1;
      gotoxy(Hposition, Vposition);
      write('-!-');
    end
  else 
    begin
      gotoxy(Hposition-3, Vposition);
      write('    ');
      Hposition := Hposition + 1;
      gotoxy(Hposition, Vposition);
      write('-!-');
    end;
  gotoxy(1, 1);
end;
 
procedure enemies;
var
  EHposition, i : byte;
begin
  Randomize;
  EHposition := Random(25)+1;
  for i:=1 to Vposition-1 do
    begin
      gotoxy(EHposition, i);
      write('O');
      Delay(60);
      gotoxy(EHposition, i);
      write(' ');
    end;
end;
 
BEGIN
  //cursoroff; {desactiver le cursor}
  Hposition := 39; {le milieu d'une fenere 80}
  gotoxy(Hposition, Vposition);
  write('-!-');
  enemies;
  while True do 
  begin
    rk := readkey;
    {writeln(rk);}
    case rk of
      'K' : move('L');
      'M' : move('R'); 
      ' ' : attack;
    end; 
  end;
END.
