type
  mat = array [1..20, 1..20] of Byte;
var
  f : text;
  m : mat;
  n : Byte;
procedure saisie(var m : mat; var n : byte);
var
  i, j : Integer;
begin
  readln(n)  ;
  for i := 1 to n do begin
    for j:=1 to n do 
      readln(m[i, j]);
  end;
end;

procedure Trait(n : Integer; m  : mat; var f : text);
  procedure ecrireln(var f : text; k : Integer);
  var
    j : Integer;
  begin
      write(f, 'L', k, '*');
      for j:=1 to n do begin
        write(f, m[k, j], '-');
      end;
      writeln(f);
  end;
  procedure ecrirecol(var f : text; k : Integer);
  var
    j : Integer;
  begin
      write(f, 'C', k, '*');
      for j:=1 to n do begin
        write(f, m[j, k], '-');
      end;
      writeln(f);
  end;
  var
    i, c : Integer;
begin
  rewrite(f) ;
  for i := 1 to n do begin
    c := 1;
    {ordre croissant}
    while (c<n) and (m[i, c]<m[i, c+1]) do
      c := c+1;
    if (c=n) then begin
      ecrireln(f, i);
    end;
    {ordre decroissant}
    c := 1;
    while (c<n) and (m[i, c]>m[i, c+1]) do 
      c := c+1;
    if (c=n) then begin
      ecrireln(f, i);
    end;
    c:= 1;
    while (c<n) and (m[c, i]>m[c+1, i]) do 
      c := c+1;
    if (c=n) then begin
      ecrirecol(f, i);
    end;
    c := 1;
    while (c<n) and (m[c, i]<m[c+1, i]) do 
      c := c+1;
    if (c=n) then begin
      ecrirecol(f, i);
    end;
  end;
end;

BEGIN
  assign(f, 'ft.txt');
  saisie(m, n);
  Trait(n, m, f);
  close(f);
END.
