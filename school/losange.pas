
procedure Dessiner(n : byte);
var
  i, j : byte;
  nbespaces, nbetoiles, facteur : Integer;
begin
  nbespaces := n div 2;
  nbetoiles := 1;
  facteur := 1;
  for i:=1 to n do begin
    for j := 1 to nbespaces do begin
      write(' ');
    end;
    for j := 1 to nbetoiles do begin
      write('*')
    end;
    for j := 1 to nbespaces do begin
      write(' ');
    end;
    if (i=(n div 2) + 1) then facteur := -1;
    nbespaces:= nbespaces + (facteur*-1);
    nbetoiles := nbetoiles + (facteur*2);
    writeln;
  end;
end;

BEGIN
  Dessiner(17);
END.

