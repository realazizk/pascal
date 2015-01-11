program tictactoe;
{
  Simple jeu realise par mohamed Aziz knani
}
uses wincrt;

type
  tab = array [1..9] of string;
  
var
  countPartie, i, scoreJoueur1, scoreJoueur2   : integer;
  nomJoueur1, nomJoueur2    : string;
  symJoueur1, symJoueur2, rep    : char;
  bool   : boolean;
  t                         : tab;
  
procedure joueur(var nom : string; var sym, symJoueur1 : char; nbJoueur : byte) ;
begin
  write('Entrer le nom du joueur ', nbJoueur, ' -> ');
  readln(nom);
  if nbJoueur = 1 then 
    repeat
      write('X ou O -> ');
      readln(sym);
      sym := upCase(sym);
    until (sym = 'X') or (sym = 'O')
  else 
    if symJoueur1 = 'O' then
      sym := 'X'
    else sym := 'O';
end;


procedure jeu(var t : tab; nomJoueur1, nomJoueur2 : string; symJoueur1, symJoueur2 : char;
               var scoreJoueur1, scoreJoueur2 : integer);
var
  i, choix : integer;
  e   : integer;
  ega, st              : string;
  a, tourJoueur1, tourJoueur2,cho                : boolean;

function compare(valeur1, valeur2, valeur3 : string; var st : string) : boolean;
begin
  compare := false;
  (*writeln(valeur1, valeur2, valeur3); *)
  if ((valeur1 <> '') and (valeur2 <> '')) and (valeur3 <> '') then
      if ((valeur1 = valeur2) and (valeur1 = valeur3)) and (valeur2 = valeur3) then
        begin
          compare := true;
          st := valeur1;
        end
  else
    compare := false;
end;


procedure affichage(t : tab; scoreJoueur1, scoreJoueur2 : integer);
var
  i, x, y: byte;
begin
  clrscr;
  write('       ', symJoueur1, ' % ', nomJoueur1, ' : ', scoreJoueur1, ' | ', 
         symJoueur2, ' % ', nomJoueur2, ' : ', scoreJoueur2);
  writeln;
  writeln;
  writeln('---|---|---');
  writeln(' 1 | 2 | 3 ');
  writeln('---|---|---');
  writeln(' 4 | 5 | 6 ');
  writeln('---|---|---');
  writeln(' 7 | 8 | 9 ');
  writeln('---|---|---');
  for i:=1 to 9 do
    begin
      if t[i] <> '' then 
      begin
          case i of
            1..3 : x := 4;
            4..6 : x := 6;
            7..9 : x := 8;
          end;
          case i of
            1, 4, 7 : y := 2;
            2, 5, 8 : y := 6;
            3, 6, 9 : y := 10;
          end;
        if t[i] = '1' then
          begin
            gotoxy(y, x);
            write(symJoueur1);
            gotoxy(1, 10);
          end
        else
          begin
            gotoxy(y, x);
            write(symJoueur2);
            gotoxy(1, 10);
          end; 
      end;
    end;
end;

procedure check(t : tab;var a: boolean;var scoreJoueur1, scoreJoueur2 : integer);
var
  ega, st : string;
  i   : integer;  
begin
  if compare(t[1], t[2], t[3], st) or compare(t[4], t[5], t[6], st) or compare(t[7], t[8], t[9], st)
   or compare(t[1], t[4], t[7], st) or compare(t[2], t[5], t[8], st) or compare(t[3], t[6], t[9], st)
   or compare(t[1], t[5], t[9], st) or compare(t[3], t[5], t[7], st) then
    begin
      a := false;
      if st = '1' then
        begin
          scoreJoueur1 := scoreJoueur1 + 1;
          Writeln(nomJoueur1, ' vous avez gagner !'); 
        end
       else
         begin
           scoreJoueur2 := scoreJoueur2 + 1;
           Writeln(nomJoueur2, ' vous avez gagner !'); 
         end;
   end;
   ega := '';
   for i:=1 to 9 do
     ega := ega + t[i];
     if (length(ega) = 9 ) and (st = '') then
       begin
         a := false;
         writeln('Egalite !');
       end;
end;

begin
  a := true;
  while a do
    begin
      tourJoueur1 := true;
      tourJoueur2 := false;
      affichage(t, scoreJoueur1, scoreJoueur2);
      if tourJoueur1 then
        begin
          repeat
            cho := false;
            write(nomJoueur1, ' entrer un nombre entre [1, 9] -> ');readln(choix);
            if t[choix] = '' then
              begin
                t[choix] := '1';
                cho := true;
              end;
            tourJoueur1 := false;
            tourJoueur2 := true;
          until (choix in [1..9]) and cho;
        end;
      affichage(t, scoreJoueur1, scoreJoueur2);
      check(t, a, scoreJoueur1, scoreJoueur2);
      if a then
        begin
          if tourJoueur2 then
            begin
              repeat
              cho := false;
              write(nomJoueur2, ' entrer un nombre entre [1, 9] -> ');readln(choix);
              if t[choix] = '' then
                begin
                  t[choix] := '0';
                  cho := true;
                end;
                tourJoueur2 := false;
                tourJoueur1 := true;
              until (choix in [1..9]) and cho;
            end;
        affichage(t, scoreJoueur1, scoreJoueur2);
        check(t, a, scoreJoueur1, scoreJoueur2);
    end;

   end;
end;

BEGIN
  repeat
    countPartie := countPartie + 1;
    if countPartie = 1 then 
      begin
        joueur(nomJoueur1, symJoueur1, symJoueur1, 1);
        joueur(nomJoueur2, symJoueur2, symJoueur1, 2);
      end;
    for i:=1 to 9 do
      t[i] := '';
    jeu(t, nomJoueur1, nomJoueur2, symJoueur1, symJoueur2, scoreJoueur1, scoreJoueur2);
    write('Une autre partie [Y/n] -> ');
    read (rep); 
    rep := upCase(rep);
    if rep = 'Y' then 
      bool := true
    else bool := false;
  until bool = false ;
END.