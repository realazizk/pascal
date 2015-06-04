
uses Allegro5, Al5image,
     Al5acodec, Al5audio;

Const
  FPS = 60;
  frame_delay = 10;
  screen_h = 800;
  screen_w = 600;
type 
  projectiles = (Bullet, Rocket);
  bu = array [1..10] of record 
                         ID : projectiles;
                         live : Boolean;
                         x, y  : real;
                         rad, speed : real;
                         Bulletimage, Rocketimage : ALLEGRO_BITMAPptr;
                         
                       end;
  Ship = record
           s, x, y, rad : real;
           deg          : integer;
         end;
Var
  Display       : ALLEGRO_DISPLAYptr;
  redfighter,
  SpaceWall     : ALLEGRO_BITMAPptr;  
  cond          : boolean; 
  timer         : ALLEGRO_TIMERptr;
  event_queue   : ALLEGRO_EVENT_QUEUEptr;
  ev            : ALLEGRO_EVENT;
  i : byte;
  Up, Down, 
  redraw, Turbo  : Boolean;
  Bullets    : bu; 
  TShip : Ship;
  Mis   : boolean;
  song, bulletSound   : ALLEGRO_SAMPLEptr;
  songInstance : ALLEGRO_SAMPLE_INSTANCEptr;
procedure Initprojectiles(var Bullets : bu);
Var
  i : byte;
begin

  for i:=1 to 10 do begin
    Bullets[i].ID := Bullet;
    Bullets[i].Bulletimage := al_load_bitmap('bullet1.png');
    Bullets[i].live := False;
    Bullets[i].speed := 10;
  end;
end;

procedure Fireprojectile(var Bullets : bu; TShip : Ship);
var 
  i : byte;
begin
  for i:=1 to 10 do 
    if not(Bullets[i].live) then begin
      Bullets[i].rad := TShip.rad + (random(3) * 0.1) ;
      Bullets[i].live := True;
      Bullets[i].x := TShip.x;
      Bullets[i].y := TShip.y;
      break;
    end;
end;

procedure Updateprojectile(var Bullets : bu) ;
var 
  i : byte;
begin
  for i:=1 to 10 do 
    if Bullets[i].live then begin
      Bullets[i].x += trunc(cos(Bullets[i].rad)*Bullets[i].speed);
      Bullets[i].y += trunc(sin(Bullets[i].rad)*Bullets[i].speed); 
      if ((screen_h+16 < Bullets[i].x) or  (-16 > Bullets[i].y)) 
      or ((screen_w+16 < Bullets[i].y) or (-16 > Bullets[i].x)) then begin
        Bullets[i].live := False;
        continue;
      end;
      al_draw_rotated_bitmap(Bullets[i].Bulletimage, 16 / 2, 16 / 2, Bullets[i].x, Bullets[i].y, Bullets[i].rad, 0); 
      
    end;
end;


BEGIN
  TShip.s := 1;
  TShip.x := 200;
  TShip.y := 100;
  TShip.x := 100;
  cond := True;
  al_init();
  al_init_image_addon();
  al_init_acodec_addon();
  al_install_audio();
  al_install_keyboard(); 
  bulletSound := al_load_sample('bullet.wav');
  al_reserve_samples(2);

  Initprojectiles(Bullets);
  Display := al_create_display(screen_h, screen_w);
  timer := al_create_timer(1.0/FPS);
  event_queue := al_create_event_queue();
  al_register_event_source(event_queue, al_get_display_event_source(Display));
  al_register_event_source(event_queue, al_get_timer_event_source(timer));
  al_register_event_source(event_queue, al_get_keyboard_event_source());
  song := al_load_sample('music.ogg');
  songInstance := al_create_sample_instance(song);
  al_set_sample_instance_playmode(songInstance, ALLEGRO_PLAYMODE_LOOP);
  al_attach_sample_instance_to_mixer(songInstance, al_get_default_mixer());

  al_play_sample_instance(songInstance);

  al_start_timer(timer);

  redfighter := al_load_bitmap('redfighter.png');
  SpaceWall := al_load_bitmap('galaxy.jpg');
  while cond do begin
    al_wait_for_event(event_queue, ev);

    if (ev._type = ALLEGRO_EVENT_DISPLAY_CLOSE) then cond := False
    else if (ev._type = ALLEGRO_EVENT_KEY_DOWN) then 
      case ev.keyboard.keycode of 
        AlLEGRO_KEY_UP    : Up    := True;
        ALLEGRO_KEY_DOWN  : Down  := True;
        ALLEGRO_KEY_SPACE : Turbo := True;
        ALLEGRO_KEY_W     : begin 
                             al_play_sample(bulletSound, 1, 1, 0, ALLEGRO_PLAYMODE_ONCE, nil);
                             Mis   := True; 
                           end;
      end
    else if (ev._type = ALLEGRO_EVENT_KEY_UP) then 
       case ev.keyboard.keycode of 
        AlLEGRO_KEY_UP    : Up    := False;
        ALLEGRO_KEY_DOWN  : Down  := False;
        ALLEGRO_KEY_SPACE : Turbo := False;
        ALLEGRO_KEY_W     : Mis   := False;  
       end
    else if (ev._type = ALLEGRO_EVENT_TIMER) then begin 
      if Turbo then TShip.s += 0.1  
      else if TShip.s > 0 then TShip.s -= 0.1;
      if Up then TShip.deg -= 3 
      else if Down then TShip.deg += 3;
      if Mis then Fireprojectile(Bullets, TShip);
      TShip.rad := TShip.deg * pi /180;
     
      TShip.x += trunc(cos(TShip.rad)*TShip.s);
      TShip.y += trunc(sin(TShip.rad)*TShip.s);
      {object redirection} 
     if (screen_h+68 < TShip.x) then TShip.x := -68
     else if (-76 > TShip.y) then TShip.y := screen_w+76
     else if (screen_w+76 < TShip.y) then TShip.y := -76
     else if (-68 > TShip.x) then TShip.x := screen_h+68; 
     redraw := True;
     if redraw and al_is_event_queue_empty(event_queue) then begin
       al_draw_bitmap(SpaceWall, 0, 0, 0);
       {al_clear_to_color(al_map_rgb(0, 12, 11));}
       { Drawing the ship :3 }
       Updateprojectile(Bullets);
       al_draw_rotated_bitmap(redfighter, 68 / 2, 76 / 2, TShip.x , TShip.y, TShip.rad  , 0);
     al_flip_display();
     redraw := False;
     end; 
    end;

  end;
  al_destroy_sample(song);
  al_destroy_sample_instance(songInstance);
  al_destroy_bitmap(redfighter);
  al_destroy_event_queue(event_queue); 
  al_destroy_timer(timer);  
  al_destroy_display(Display); 
END.



