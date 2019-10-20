%-------------------------------------------------------------------------------
% Fakten der Module
%-------------------------------------------------------------------------------

:-style_check(- discontiguous).

modul(assit).
bezeichnung(asssit,'Assessment IT').
ectsPunkte(assit,60).

modul(sisy1).
bezeichnung(sisy1,'Signale & Systeme 1').
voraussetzung(assit,sisy1).
ectsPunkte(sisy1,4).
semester(sisy1,3).

modul(dd1).
bezeichnung(dd1,'Digitale Datenübertragung 1').
voraussetzung(sisy1,dd1).
ectsPunkte(dd1,4).
semester(dd1,5).

modul(dd2).
bezeichnung(dd2,'Digitale Datenübertragung 2').
voraussetzung(dd1,dd2).
ectsPunkte(dd2,4).
semester(dd2,6).

modul(ood).
bezeichnung(ood,'Objektorienterte Analyse und Design für Informatiker').
voraussetzung(assit,ood).
ectsPunkte(ood,4).
semester(ood,3).

modul(dnet).
bezeichnung(dnet,'Dot-net-Technologie').
voraussetzung(ood,dnet).
ectsPunkte(dnet,4).
semester(dnet,4).

modul(sep).
bezeichnung(sep,'Software-Entwicklungspraxis').
voraussetzung(ood,sep).
ectsPunkte(sep,4).
semester(sep,4).

modul(swe).
bezeichnung(swe,'Software-Engineerung').
voraussetzung(ood,swe).
ectsPunkte(swe,4).
semester(swe,4).

modul(jff).
bezeichnung(jff,'Java für Fortgeschrittene').
voraussetzung(swe,jff).
ectsPunkte(jff,4).
semester(jff,5).

modul(vsy).
bezeichnung(vsy,'Verteilte Systeme').
voraussetzung(ood,vsy).
ectsPunkte(vsy,4).
semester(vsy,4).

modul(tin1).
bezeichnung(tin1,'Technische Informatik 1').
voraussetzung(assit,tin1).
ectsPunkte(tin1,4).
semester(tin1,3).

modul(tin2).
bezeichnung(tin2,'Technische Informatik 2').
voraussetzung(tin1,tin2).
ectsPunkte(tin2,4).
semester(tin2,4).

modul(psp).
bezeichnung(psp,'Programmiersprachen').
voraussetzung(assit,psp).
ectsPunkte(psp,4).
semester(psp,5).

modul(reesy).
bezeichnung(reesy,'Entwurf und Realisierung von Embedded Systems').
voraussetzung(tin1,reesy).
ectsPunkte(reesy,4).
semester(reesy,4).

modul(pra).
bezeichnung(pra,'Prozessorarchitekturen').
voraussetzung(tin2,pra).
ectsPunkte(pra,4).
semester(pra,5).

modul(mc).
bezeichnung(mc,'Mikrokontroller').
voraussetzung(tin2,mc).
ectsPunkte(mc,4).
semester(mc,5).

modul(cgr).
bezeichnung(cgr,'Computergrafik').
voraussetzung(tin2,cgr).
ectsPunkte(cgr,4).
semester(cgr,5).

modul(eesy).
bezeichnung(eesy,'Embedded Systems').
voraussetzung(pra,eesy).
ectsPunkte(eesy,4).
semester(eesy,6).

% check if data is consistent
inconsistent(X) :- voraussetzung(X,_),not(modul(X)).
inconsistent(Y) :- voraussetzung(_,Y),not(modul(Y)).
inconsistent(X) :- ectsPunkte(X,_),not(modul(X)).
inconsistent(X) :- semester(X,_),not(modul(X)).

modul3(X) :-  modul(X), semester(X,3).

% a2
% Usage: voraussetzungen(jff).
voraussetzungen(X) :- voraussetzungen(X,Y), write(Y), nl, fail.

% Usage: voraussetzungen(jff,Y).
voraussetzungen(X,Y) :-  voraussetzung(Y,X).
voraussetzungen(X,Y) :-  voraussetzung(Z,X), voraussetzungen(Z,Y).

% Reihenfolge umgekehrt
% Usage: voraussetzungen_reverse(Y,jff).
voraussetzungen_reverse(X,Y) :-  voraussetzung(X,Z), voraussetzungen_reverse(Z,Y).
voraussetzungen_reverse(X,Y) :-  voraussetzung(X,Y).

% a3
% Usage: voraussetzungen(X,tin2).
% Usage: voraussetzungen_reverse(tin2,X).
% Oder nachfolger(tin2).
nachfolger(X) :- voraussetzungen(Y,X), write(Y), nl, fail.

% a4
% Usage: liste_waehlbare_module(3,Y).
% Usage: output_waehlbare_module(3).
output_waehlbare_module(X) :- semester(Y,X), write(Y), nl, fail.
liste_waehlbare_module(X,Y) :- semester(Y,X).

% a5
% Usage: etcs([jff, swe, cgr], S).
etcs([],S) :- S is 0.
etcs([X|Y],S) :- etcs(Y, S1), ectsPunkte(X,Z), S is S1 + Z.

