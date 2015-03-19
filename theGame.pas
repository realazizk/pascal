(* Simple jeu réalise par Mohamed Aziz Knani 
 * Email : medazizknani@gmail.com
 * Blog  : http://mohamedazizknani.wordpress.com
 *)

program theGame; 
uses ncurses;

type
  Ship = record 
  posx       : integer;
  shape      : string;
  ammunition : integer;
  ammupos    : array [1..50] of byte; { contient la postion des missiles }
  end;

  Enemy = record
  shape : char;
  nbr   : integer;
  enepos : array[1..50] of byte; {contient la postion des ennemies}
  end;

var
  max_y, max_x : integer; { les resolutions de la fenetre }
  BShip  : Ship;
  BEnemy : Enemy;
  rk     : integer;
  i, k   : integer; { des compteurs pour ralentir }

function newPos(Posi : char) : integer;
begin
  if (Posi = 'L')  and (1+BShip.posx <= max_x) then
    newPos := 1+BShip.posx
  else if (Posi = 'R') and (BShip.posx-1 >= 0) then
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
    if (i mod 100 = 0) and (BEnemy.enepos[j] in [1..25]) then begin
      Inc(BEnemy.enepos[j]); 
      mvprintw(BEnemy.enepos[j], j, 'X');
      refresh();
    end;
    i := 0;
  end;
end;

procedure init(var BShip : Ship);
var
  i : integer;
begin
  BShip.ammunition := 20;
  {Initialisation des position des missiles par la derniere ligne (max_y)}
  for i:=1 to BShip.ammunition do
    BShip.ammupos[i] := max_y;
  BShip.posx := max_x div 2;
  BShip.shape := 'O';
end;

procedure Shoot(var BShip : Ship);
var
  j : byte;
begin
  for j:=1 to max_x do begin
    {un hack pour ralentir l'ennemi}
    if (k mod 100 = 0) and (BShip.ammupos[j] <> 0) then begin
      Dec(BShip.ammupos[j]); 
      mvprintw(BShip.ammupos[j], j, '|');
      refresh();
      napms(30);
    end;
    k := 0;
  end;
end;

BEGIN
  initscr();
  noecho();
  curs_set(0);
  init(BShip);
  getmaxyx(stdscr, max_y, max_x);  {stdscr est la fenetre par default}
  { des petits problemes sous les terminal linux (XFCE et Gnome) 
    un decalage d'un pixel (ou c'est juste moi) a essayer sous windows}
  Dec(max_y); Dec(max_x);
  i := 0; k:=0;
  { la procedure permet de ne pas attendre l'utilisateur d'entrer une touche
    par contre elle retourne ERR si il n'entre rien}
  nodelay(stdscr, true);
  while True do begin
    Inc(i); Inc(k);
    clear();
    rk := getch();
    case rk  of 
      67 : BShip.posx :=newPos('L');
      68 : BShip.posx :=newPos('R');
      32 : begin
             with BShip do
               if ammunition > 0 then begin
                 ammupos[posx] := max_y;
                 Dec(ammunition);
               end;
             Shoot(BShip);
           end;
    end; 
    mvprintw(max_y, BShip.posx, 'O');
    refresh();
    Shoot(BShip);
    Enemys(BEnemy);
    {un petit dodo pour 3 millisecondes}
    napms(3);
  end;
  endwin();
END.
