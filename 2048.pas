program 2048;
uses ncurses;
type
  game = record
  board       : [1..4, 1..4] of Longint;
  next, full  : boolean;
  score       : LongInt;
  dir         : char; 
  end;
var
  Pgame        : game;
  field, score : PWindow;
  rk           : byte;
function alive(Pgame : game) : boolean;
{ determines if there is a next move }
var 
  bool : boolean;
  i, j : byte;
begin
  bool := False;
  for i:=1 to 3 do
    for j:=1 to 3 do
      with Pgame do 
        if (board[i, j] = board[i, j+1]) 
        or (board[i, j] = board[i+1, j]) then
          bool := True;
  alive := bool;
end;

function Pfull(Pgame : game) : boolean;
var
  bool : boolean;
  i, j : byte;
begin
  bool := True;
  for i:=1 to 4 do
    for j:=1 to 4 do 
      if Pgame.board = 0 then bool := False; 
  full := bool;
end;

function wall()

procedure randpos(var Pgame : game);
var 
  rand_x, rand_y : byte;
begin
  repeat
    rand_x := random(4)+1;
    rand_y := random(4)+1;
  until (Pgame.board[rand_x, rand_y] = 0);
  Pgame.board[rand_x, rand_y] := 2;
end;

procedure move(var Pgame : game);
var 
  mvj, mvi : byte;
begin
  { this move the cells }
  for i:=1 to 4 do begin
    case Pgame.dir of 
      'L' : 
      'R' : 
    end;
    for j:=1 to 4 do begin
      case Pgame.dir of
        'U' : mvj := j-1;
        'D' : mvj := j+1;
      end;
      repeat
        Pgame[i, mvj] := Pgame[i, j];
        Pgame[i, j] := 0;
      until (Pgame.board[i, mvj] <> 0) or (mvj < 1);
    end;
end;

procedure draw;
begin
  
end;

procedure init;
{ initializei the board with 2 cells }
var
  rand_x, rand_y, i : byte;
begin
  for i:=1 to 2 begin
    repeat
      rand_x := random(4)+1;
      rand_y := random(4)+1;
    until (Pgame.board[rand_x, rand_y] = 0);
    Pgame.board[rand_x, rand_y] := 2;
  end;
  { as it is the first round there will be a next move :v }
  Pgame.next := True;
end;

BEGIN
  randomize;
  initscr;
  noecho;
  cur_set(0);
  field := newin(22, 80, 0, 0);
  score := newin(3, 80, 22, 0);
  init;
  { make a label here  }
  while True do begin
    wclear(field); { clears the field window }
    with Pgame do begin
      next := alive(Pgame);
      full := Pfull(Pgame);
    end;
    rk := wgetch(field);
    with Pgame do 
      case rk of 
        67 : dir := 'R';
        68 : dir := 'L';
        65 : dir := 'U';
        66 : dir := 'D';
      end;
    
    with Pgame do begin
      if not(next) then break; { if there is ne next combinaison then break the loop }
      if not(full) then randpos(Pgame);   { if it is not full then get new random cells }
    end;
    draw;
  end;
  { restart game if yes goto label }
END.
