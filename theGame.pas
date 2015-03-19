(* Simple jeu réalise par Mohamed Aziz Knani 
 * Email : medazizknani@gmail.com
 * Blog  : http://mohamedazizknani.wordpress.com
 * Sorry for the spaghetti code :v
 *)

program theGame; 
uses ncurses,strings;
{$H+}
type
  Ship = record 
  posx       : integer;
  shape      : string;
  ammunition : integer;
  ammupos    : array [1..100] of byte; { contient la postion des missiles }
  end;

  Enemy = record
  shape : char;
  nbr   : integer;
  enepos : array[1..100] of byte; {contient la postion des ennemies}
  end;

var
  max_y, max_x : integer; { les resolutions de la fenetre }
  BShip            : Ship;
  BEnemy           : Enemy;
  rk               : integer;
  i, k, new_x, new_y             : integer; { des compteurs pour ralentir }
  dashboard, field : Pwindow;

function newPos(Posi : char) : integer;
begin
  if (Posi = 'L')  and (3+BShip.posx <= max_x) then
    newPos := 1+BShip.posx
  else if (Posi = 'R') and (BShip.posx-2 >= 0) then
    newPos := BShip.posx-1
  else newPos := BShip.posx;
end;

function collision(posm, pose : integer) : Boolean;
begin
  if (posm = pose) then collision := True
  else collision := False;
end;

procedure Enemys(var BEnemy : Enemy);
var
  j : byte;
begin
  {Affichage}
  for j:=1 to max_x do begin
    {un hack pour ralentir l'ennemi}
    if (i mod 100 = 0) and (BEnemy.enepos[j] in [2..max_y-5]) then begin
      Inc(BEnemy.enepos[j]); 
      mvprintw(BEnemy.enepos[j], j, 'X');
      refresh;
      napms(50);
    end
    else if (BEnemy.enepos[j] > max_y) then BEnemy.enepos[j] := 0;
    i := 0;
  end;
end;

procedure init(var BShip : Ship; var BEnemy : Enemy);
var
  i : integer;
begin
  BShip.ammunition := 20;
  {Initialisation des position des missiles par la derniere ligne (max_y)}
  {for i:=1 to 50 do
    BEnemy.enepos[i] := -1;}
  BShip.posx := max_x div 2;
  BShip.shape := 'O';
  BEnemy.nbr := 15;
end;

procedure Shoot(var BShip : Ship);
var
  j : byte;
begin
  for j:=1 to max_x do
    { un hack pour ralentir l'ennemi }
    if (BShip.ammupos[j] in [1..max_y-5]) then begin
      Dec(BShip.ammupos[j]); 
      mvprintw(BShip.ammupos[j], j, '|');
      refresh();
      {ralentir la missile pour un intervalle de 5 ms pour chaque une }
      napms(5);
    end;
end;

Function IntToStr (I : Longint) : String;
var 
  s : String;
begin
   Str(I,S);
    IntToStr:=s;
end;

procedure drawBox(win :PWINDOW);
var
  x, y, i : integer;
begin
  getmaxyx(win, y, x);
  mvwprintw(win, 0, 0, '+');
  mvwprintw(win, y - 1, 0, '+');
  mvwprintw(win, 0, x - 1, '+');
  mvwprintw(win, y - 1, x - 1, '+');
  for i := 1 to (y - 2) do begin
    mvwprintw(win, i, 0, '|');
    mvwprintw(win, i, x - 1, '|');
  end;
  for i := 1 to (x - 2) do begin
    mvwprintw(win, 0, i, '-');
    mvwprintw(win, y - 1, i, '-');
  end;
end;

BEGIN
  initscr();
  noecho();
  curs_set(0);
  {cbreak(); }
  getmaxyx(stdscr, max_y, max_x);  {stdscr est la fenetre par default}
  { des petits problemes sous les terminal linux (XFCE et Gnome) 
    un decalage d'un pixel (ou c'est juste moi) a essayer sous windows}
  {Dec(max_y); Dec(max_x);}
  init(BShip, BEnemy);
  i := 0; k:=0;
  { la procedure permet de ne pas attendre l'utilisateur d'entrer une touche
    par contre elle retourne ERR si il n'entre rien}
  field := newwin(max_y-3, max_x, 0, 0);
  dashboard := newwin(3, max_x, max_y - 3, 0);
  mvwprintw(field, 0, 0, 'Field');
  mvwprintw(dashboard, 0, 0, 'Score');
  drawBox(field);
  drawBox(dashboard);
  refresh();
  nodelay(stdscr, true);
  nodelay(field, true);
  while True do begin
    Inc(i); Inc(k);
    rk := getch();
    case rk  of 
      67 : BShip.posx :=newPos('L');
      68 : BShip.posx :=newPos('R');
      32 : begin
             with BShip do
               if ammunition > 0 then begin
                 ammupos[posx] := max_y-5;
                 Dec(ammunition);
               end;
             Shoot(BShip);
           end;
    end; 
    { nettoyage la fenetre field }
    wclear(field);
    wclear(dashboard);
    drawBox(field);
    drawBox(dashboard);
    //mvwprintw(field, 1, 1, 'Field');
    mvwprintw(dashboard, 1, max_x div 2 , PChar(concat('| Ammo : ', IntToStr(BShip.ammunition))));
    // refresh each window
    wrefresh(field);
    wrefresh(dashboard);
    mvprintw(max_y-5, BShip.posx, 'O');
    refresh;
    if (BEnemy.nbr > 0) then begin
      randomize;
      BEnemy.enepos[random(max_x)+1] := 2;
      Dec(BEnemy.nbr);
    end;
    Shoot(BShip);
    //Enemys(BEnemy);
    {un petit dodo pour 3 millisecondes}
    napms(5);
  end;
  endwin();
END.
