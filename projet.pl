/* syntaxe : verbe(x,y) : x "verbe" y 
 syntaxe : adjectif(x,y) : x est adjectif y */ 



/**************************************************************************************************


										P A R T I E          0
									      FONCTIONS USUELLES DU PROGRAMMES


**************************************************************************************************/
	
	/* ------------------ Règles générales ------- -------------
	   --------------------------------------------------------- */

plateau_initial([[2,3,1,2,2,3],[2,1,3,1,3,1],[1,3,2,3,1,2],[3,1,2,1,3,2],[2,3,1,3,1,3],[2,1,3,2,2,1]]).
plateau90([[3,1,2,2,3,1],[2,3,1,3,1,2],[2,1,3,1,3,2],[1,3,2,2,1,3],[3,1,3,1,3,1],[2,2,1,3,2,2]]). /* sens trigo */
plateau180([[1,2,2,3,1,2],[3,1,3,1,3,2],[2,3,1,2,1,3],[2,1,3,2,3,1],[1,3,1,3,1,2],[3,2,2,1,3,2]]).
plateau270([[2,2,3,1,2,2],[1,3,1,3,1,3],[3,1,2,2,3,1],[2,3,1,3,1,2],[2,1,3,1,3,2],[1,3,2,2,1,3]]).

taille(plateau_initial,6).
taille(plateau90,6).
taille(plateau180,6).
taille(plateau270,6).


	/* ------------------ Prédicats sur les listes -------------
	   --------------------------------------------------------- */
	
nb_elem([],0).
nb_elem([T|Q],N) :- nb_elem(Q,NQ), N is NQ + 1.

/* elem_liste(I,L,E) <= E est l'élement I de la liste L */

elem_liste(1,[Z|Q],Z).
elem_liste(N,[T|Q],Z) :- N>1, M is N-1, elem_liste(M,Q,Z).

/* valeur_case(Z,X,Y,P) <= Z est l'élement [X,Y] du plateau P */ 
valeur_case(Z,X,Y,P) :- X>0, Y>0, X<7, Y<7, elem_liste(X,P,Ligne), elem_liste(Y,Ligne,Z), !.

/* dans_liste(E,L) <= E peut être unifié avec un elem de la liste Q */
dans_liste(T,[T|Q]):- !.
dans_liste(E,[T|Q]):- dans_liste(E,Q).

/* dans_liste(E,L) <= E peut être unifié avec un ou plusieurs elem de la liste Q*/
dans_liste_nocut(T,[T|Q]).
dans_liste_nocut(E,[T|Q]):- dans_liste_nocut(E,Q).


	/* -------------- Methodes d'affichage plateau -------------
	   --------------------------------------------------------- */
	   
	   
	 /* afficher_ligne[L] <= L est une liste qui est affichée en finissant par '\n' */
 
afficher_ligne([]) :- write('\n'), !.
afficher_ligne([T|Q]) :- write(T), write(' '), afficher_ligne(Q).
 
 /* afficher_tab[T] <= T est une liste de liste qui est affichée  */
 afficher_tab([]):- !.
 afficher_tab([T|Q]) :- write('\n'), afficher_ligne(T), afficher_tab(Q).   
	   
egalite_liste([],[]).
egalite_liste([T|Q],[T|S]) :- egalite_liste(Q,S).

afficherSiKhan([_,_,_,_,[I,J]],I2,J2) :- I is I2, J is J2, write('*'), !.
afficherSiKhan(_,_,_) :- write(' ').

afficher_element(E,I,J,Etat) :- ValI is I, ValJ is J, get_kalista_J1(Etat,Pj1), egalite_liste([ValI,ValJ], Pj1), write(E), write('K1'), afficherSiKhan(Etat,I,J), write(' '),  !.
afficher_element(E,I,J,Etat) :- ValI is I, ValJ is J, get_kalista_J2(Etat,Pj2), egalite_liste([ValI,ValJ], Pj2), write(E), write('K2'), afficherSiKhan(Etat,I,J), write(' '),  !.

afficher_element(E,I,J,Etat) :- ValI is I, ValJ is J, get_pion_J1(Etat,Pj1), dans_liste([ValI,ValJ],Pj1), write(E), write('P1'), afficherSiKhan(Etat,I,J),  write(' '),  !.
afficher_element(E,I,J,Etat) :- ValI is I, ValJ is J, get_pion_J2(Etat,Pj2), dans_liste([ValI,ValJ],Pj2), write(E), write('P2'), afficherSiKhan(Etat,I,J), write(' '),  !.
afficher_element(E,I,J,Etat) :- write(E), write(' '), write(' '), write(' '), write(' ').

/* afficher_ligne_plateau([T],I,J,E) Chaque element J de la ligne I est affiché */
afficher_ligne_plateau([],_,_,_) :- write('\n'), !.
afficher_ligne_plateau([T|Q],I,J,Etat) :- afficher_element(T,I,J,Etat), Jinc is J+1, afficher_ligne_plateau(Q,I,Jinc,Etat).

/* afficher_plateau_from([T],J,E) <= T est affiché dans l'état E à partir de la ligne J*/
afficher_plateau_from([],_,_):- !.
afficher_plateau_from([T|Q],I,Etat) :- afficher_ligne_plateau(T,I,1,Etat), afficher_plateau_from(Q,I+1,Etat).

afficher_plateau(P,E) :- write('\n'), afficher_plateau_from(P,1,E).


get_pion_J1(Etat,J1):- elem_liste(1, Etat, J1).
get_pion_J2(Etat,J2):- elem_liste(2, Etat, J2).
get_kalista_J1(Etat, K):- elem_liste(3, Etat, K).
get_kalista_J2(Etat, K):- elem_liste(4, Etat, K).
get_khan(Etat, K):- elem_liste(5, Etat, K).



/**************************************************************************************************


										P A R T I E          1
									      INITIALISER LE PLATEAU


**************************************************************************************************/

/* initialiserPlateau(Plateau,Etat) <= Plateau et Etat sont le résultat de l'initialisation */

initialiserPlateau(Plateau,Etat,ModeDeJeu) :-  plateau_initial(P),afficher_plateau(P,[]), demander_mode(ModeDeJeu), 
demanderOrientationPlateau(Plateau), placerPiecesJ1(Plateau, [[[]],[[]],[],[],[]], ModeDeJeu, EtatIntermediaire),
afficher_plateau(Plateau, EtatIntermediaire), placerPiecesJ2(Plateau, EtatIntermediaire, ModeDeJeu, Etat),
write('\n-----------------------------------------------------\n  Plateau final \n \n'),
 afficher_plateau(Plateau,Etat).


/* placerPiecesJ1(P,E, M, ERes) <= si M correspond à un mode où J1 est humain,
 ses pièces sont ajoutées par lui dans ERes à partir de E jusqu'à ce qu'il y en ait 6 */
placerPiecesJ1(Plateau,[Pj1,Pj2,_,_,_], ModeDeJeu, EtatRes) :- ModeDeJeu < 3, nb_elem(Pj1,N), N < 5,  !,
repeat, write('\n-----------------------------------------------------\n Le Joueur 1 place ses sbires'),
write('\n\n'), afficher_plateau(Plateau,[Pj1,Pj2,[],[],[]]),
write('\nJoueur 1 : entrez la ligne où insérer le sbire  {5. ou 6.} : \n >'), read(I), I =< 6, I >=5, 
write('\nChoisissez maintenant la colonne \n >'), read(J), 
insererPiecePlateau(I,J,Pj1,NewPj1), !, placerPiecesJ1(Plateau,[NewPj1,Pj2,[],[],[]], ModeDeJeu, EtatRes).

placerPiecesJ1(Plateau,[Pj1,Pj2,_,_,_], ModeDeJeu, EtatRes) :- ModeDeJeu < 3, nb_elem(Pj1,N), N is 5, !,
repeat, write('\n-----------------------------------------------------\n Le Joueur 1 place sa Kalista'),
write('\n\n'), afficher_plateau(Plateau,[Pj1,Pj2,[],[],[]]),
write('\nJoueur 1 : entrez la ligne où insérer la Kalista  {5. ou 6.} : \n >'), read(I), I =< 6, I >=5, 
write('\nChoisissez maintenant la colonne \n >'), read(J), 
insererPiecePlateau(I,J,Pj1,NewPj1), !, placerPiecesJ1(Plateau,[NewPj1,Pj2, [I,J],[],[]], ModeDeJeu, EtatRes).

placerPiecesJ1(Plateau,_,3, [[[5,1],[5,2],[6,2],[6,1],[6,5],[5,4]],[],[6,1],[],[]]) :- write('\n\n Ordi 1 place ses pions. \n\n '), !.

placerPiecesJ1(_,E, _,E).

/* placerPiecesJ2(P,E, M, Eres) <=  si M correspond à un mode où J2 est humain,
 ses pièces sont ajoutées par lui dans Eres à partir de E jusqu'à ce qu'il y en ait 6 */
placerPiecesJ2(Plateau,[Pj1,Pj2,K1,_,_], ModeDeJeu, EtatRes) :- ModeDeJeu < 2, nb_elem(Pj2,N), write(N), N < 5,  !,
repeat, write('\n-----------------------------------------------------\n Le Joueur 2 place ses pions'), 
write('\n\n'), afficher_plateau(Plateau,[Pj1,Pj2,K1,[],[]]),
write('\nJoueur 2 : entrez la ligne où insérer la pièce  {1. ou 2.} : \n >'), read(I), I >= 1, I =< 2,
write('\nChoisissez maintenant la colonne \n >'), read(J), 
insererPiecePlateau(I,J,Pj2,NewPj2), !, placerPiecesJ2(Plateau,[Pj1,NewPj2,K1,[],[]], ModeDeJeu, EtatRes).

placerPiecesJ2(Plateau,[Pj1,Pj2,K1,_,_], ModeDeJeu, EtatRes) :- ModeDeJeu < 2, nb_elem(Pj2,N), write(N), N is 5,  !,
repeat, write('\n-----------------------------------------------------\n Le Joueur 2 place sa Kalista'), 
write('\n\n'), afficher_plateau(Plateau,[Pj1,Pj2,K1,[],[]]),
write('\nJoueur 2 : entrez la ligne où insérer la Kalista  {5. ou 6.} : \n >'), read(I), I >= 1, I =< 2,
write('\nChoisissez maintenant la colonne \n >'), read(J), 
insererPiecePlateau(I,J,Pj2,NewPj2), !, placerPiecesJ2(Plateau,[Pj1,NewPj2,K1,[I,J],[]], ModeDeJeu, EtatRes).


placerPiecesJ2(Plateau,[J1,_,K1,_,_], MdJ , [J1,[[1,6],[2,6],[1,5],[2,5],[1,2],[2,1]],K1,[1,6],[]]) :-  MdJ >= 2, write('\n\n Ordi 2 place ses pions. \n\n '), !.
 
placerPiecesJ2(_,E,_,E).

/* insererPiecePlateau(I,J,P,E) <= Si le couple [I,J] n'est pas dans l'ensemble de pièces P alors on met ([I,J]|P) dans E, sinon erreur */
insererPiecePlateau(I,J,[[]],[[I,J]]) :- !.
insererPiecePlateau(I,J,Pieces,[[I,J]|Pieces]) :- \+dans_liste([I,J],Pieces),!.
insererPiecePlateau(I,J,Pieces,Pieces) :- write('\n Erreur : La pièce est déjà ici') ,!.

/* demande_mode(ModeDejeu) <= ModeDeJeu est le mode de jeu choisi parmi humain/humain, humain/machine", etc... */
demander_mode(ModeDeJeu) :- repeat, write('\n\nChoisissez le mode de jeu en tapant parmi parmi {"1.","2.","3.","4."} \n 1. Humain vs Humain\n 2. Humain vs IA \n 3. IA vs IA \n >'), read(ModeDeJeu), mode_valide(ModeDeJeu),!.

/* mode_valide(X) <= X peut être unifié avec une valeur qui correspond à un mode */
mode_valide(X) :- X is 1,!. /* HvH !! */
mode_valide(X) :- X is 2,!. /* HvO !! */
mode_valide(X) :- X is 3,!.  /* OvO !! */


/* demanderOrientationPlateau(Plateau) <= Plateau est le résultat de la boucle qui demande l'orientation choisie */
demanderOrientationPlateau(Plateau) :- write('\n\nOrientez le plateau en écrivant l\'angle, parmi {1,2,3,4} : \n D\'en haut  (Tapez "1.")\n D\'en bas (Tapez "2.") [par défaut]\n De la gauche (Tapez "3.")\n De la droite (Tapez "4.")\n\n\n') ,
  read(X), orienterPlateau(X,Plateau), write('\n'), afficher_tab(Plateau), !. 
demanderOrientationPlateau(Plateau) :- repeat, write('\n\n /!\\ Veillez à rentrer une valeur parmi {"1.","2.","3.","4."} \n\n') , 
 read(X),  orienterPlateau(X,Plateau), write('\n'), afficher_tab(Plateau), !.

/* orienterPlateau(X,Plateau) <= Plateau est plateau_initial orienté dans la direction X */
orienterPlateau(X,Plateau) :- X is 1, write('\n Vue du dessus séléctionnée. \n'), plateau180(Plateau), !.
orienterPlateau(X,Plateau) :- X is 2, write('\n Vue du dessous séléctionnée. \n'), plateau_initial(Plateau), !.
orienterPlateau(X,Plateau) :- X is 3, write('\n Vue de la gauche séléctionnée. \n'), plateau90(Plateau), !.
orienterPlateau(X,Plateau) :- X is 4, write('\n Vue de la droite séléctionnée. \n'), plateau270(Plateau), !.



/**************************************************************************************************


										P A R T I E          2
									      DETERMINER LES COUPS POSSIBLES


**************************************************************************************************/
				  
				  
/* mouvement_une_case(I,J,L) => Retourne une liste L des coordonnées des cases voisines à [I,J] */
mouvement_une_case(I,J,[ [I,J1], [I,J2], [I1,J], [I2,J] ]) :- J1 is J-1, J2 is J+1, I1 is I-1, I2 is I+1. 

/* nettoyage_liste_limite(L,NL) => Retourne une liste NL à partir de L et qui n'a plus les valeurs qui sortent du plateau  */

nettoyage_liste_limite([],[]).
nettoyage_liste_limite([T|Q], NQ) :- egalite_liste(T,[0,_]), nettoyage_liste_limite(Q, NQ),!.
nettoyage_liste_limite([T|Q], NQ) :- egalite_liste(T,[_,0]), nettoyage_liste_limite(Q, NQ),!.
nettoyage_liste_limite([T|Q], NQ) :- egalite_liste(T,[7,_]), nettoyage_liste_limite(Q, NQ),!.
nettoyage_liste_limite([T|Q], NQ) :- egalite_liste(T,[_,7]), nettoyage_liste_limite(Q, NQ),!.
nettoyage_liste_limite([T|Q], [T|NQ]) :- nettoyage_liste_limite(Q, NQ).

/* concatenation de deux listes*/
concat([],L,L).
concat([T|Q], L, [T|NQ]) :- concat(Q, L, NQ), !.

/* nettoyage_liste_blocage(I, J, L, Nb, Etat, NL) => Retourne une liste NL à partir de L et qui n'a plus les valeurs qui sont deja occupé par un pions quand ce n'est pas son dernier coups */
/* prend en compte le fait que le pion [I,J] ne puisse pas se deplacer sur un case occupé par un pion de son equipe lors de son dernier coups */
nettoyage_liste_blocage([], Nb, Etat, []).
nettoyage_liste_blocage([T|Q], Nb, [J1,J2,K1,K2,Khan], NQ):- \+dans_liste(Khan,J1), Nb=:=1, dans_liste(T, J1), nettoyage_liste_blocage(Q, Nb, [J1,J2,K1,K2,Khan], NQ), !.
nettoyage_liste_blocage([T|Q], Nb, [J1,J2,K1,K2,Khan], NQ):- dans_liste(Khan,J1), Nb=:=1, dans_liste(T, J2), nettoyage_liste_blocage(Q, Nb, [J1,J2,K1,K2,Khan], NQ), !.
nettoyage_liste_blocage([T|Q], Nb, [J1,J2,K1,K2,Khan], NQ):- concat(J1, J2, Pions), Nb > 1, dans_liste(T, Pions), nettoyage_liste_blocage(Q, Nb, [J1,J2,K1,K2,Khan], NQ), !.
nettoyage_liste_blocage([T|Q], Nb, [J1,J2,K1,K2,Khan], [T|NQ]):- nettoyage_liste_blocage(Q, Nb, [J1,J2,K1,K2,Khan], NQ).

/* deplacement_possible_pion(I, J, Nb, Etat, Res) => Retourne la liste les deplacement possible pour 1 pion qui aun position initiale et  qui est acctuellement a la position [I,J]*/
deplacement_possible_pion(I, J, Nb, Etat, Res) :- mouvement_une_case(I,J,ListMvt), nettoyage_liste_limite(ListMvt, ListNet), nettoyage_liste_blocage(ListNet,Nb,Etat,Res),!.

/*  retirer_element(E, L, NL) => permet de retiere les elements E de la liste L et renvoie le resultat dans NL*/
retirer_element(E,[],[]).
retirer_element(E, [E|Q], NL) :- retirer_element(E,Q,NL) ,!.
retirer_element(E, [T|Q], [T|NL]) :- retirer_element(E,Q,NL). 

/* nettoyage_case_visite(LE, L, LN) => enleve tous les elements de la liste LE que peut contenir la liste L et renvoie le resultat dans LN */
nettoyage_case_visite([],L,L).
nettoyage_case_visite(L,[],[]).
nettoyage_case_visite([T|Q], LI, LF) :- dans_liste(T,LI), retirer_element(T,LI, LS), nettoyage_case_visite(Q,LS,LF),!.
nettoyage_case_visite([T|Q], LI, LF) :- nettoyage_case_visite(Q,LI,LF),!.	

/* permet de lancer la fonction explorer_chem_succ_elem sur plusieurs elements*/

explorer_chem_succ_elem(I,J,_,Nb,[],Etat).
explorer_chem_succ_elem(I,J,Histo,Nb,[[R,S]|Q],Etat) :- N is Nb-1, explorer_chem_elem(R,S,[[I,J] | Histo],N,Etat).
explorer_chem_succ_elem(I,J,Histo,Nb,[T|Q],Etat) :- explorer_chem_succ_elem(I,J,Histo,Nb,Q,Etat).


/* explorer_chem_elem(I,J,Histo,Nb,Etat) : permet de d'explorer le chemin à partir d'un element vers tous ses successeurs
Ici [I,J] => correspond a la position du pion actuelle
Histo => correspond a l'historique des cases parcourues (evite de faire des retours en arriere)
Nb => correspond au nombre de case restant à parcourir
Etat => etat courant du jeu */
	
explorer_chem_elem(I,J,Histo,Nb,Etat):- Nb =:= 1, deplacement_possible_pion(I,J,Nb,Etat,L), 
nettoyage_case_visite(Histo, L, NL), asserta(solution(NL)), fail.
explorer_chem_elem(I,J,Histo,Nb,Etat):- Nb > 1, deplacement_possible_pion(I,J,Nb,Etat,L), 
nettoyage_case_visite(Histo, L, NL), explorer_chem_succ_elem(I,J,Histo,Nb,NL,Etat), fail.


reorganiser_liste([],[]).
reorganiser_liste([T|Q],Res) :- reorganiser_liste(Q,NL), concat(T, NL, Res).

enlever_doublons([],[]).
enlever_doublons([T|Q],[T|Res]) :- retirer_element(T,Q,NQ), enlever_doublons(NQ,Res),!.

recherche_coup_pion([I,J],Etat,P,Res) :- valeur_case(Nb,I,J,P), \+explorer_chem_elem(I,J,[],Nb,Etat), setof(X, solution(X), Temp1), retractall(solution(_)),
	reorganiser_liste(Temp1,Temp2), enlever_doublons(Temp2, Temp3), retirer_element([],Temp3,Res),!.

	
	
/* est_coup_possbile_obeir(P,E,Res) <= Res est un coup possible sur le plateau P,E en obeissant au Khan */

est_coup_possible_obeir(P,[J1,J2,K1,K2,[]],Res) :- dans_liste_nocut([I,J],J1),  recherche_coup_pion([I,J],[J1,J2,K1,K2,[]],P,Coups), reecrire_coups([I,J],Coups,Res).

est_coup_possible_obeir(P,[J1,J2,K1,K2,[IKh,JKh]],Res) :-  valeur_case(ValKh,IKh,JKh,P), dans_liste([IKh,JKh],J2), !, dans_liste_nocut([I,J],J1), valeur_case(ValKh,I,J,P), 
recherche_coup_pion([I,J],[J1,J2,K1,K2,[IKh,JKh]],P,Coups), reecrire_coups([I,J],Coups,Res).
 
est_coup_possible_obeir(P,[J1,J2,K1,K2,[IKh,JKh]],Res) :-  valeur_case(ValKh,IKh,JKh,P), dans_liste([IKh,JKh],J1), !, dans_liste_nocut([I,J],J2), valeur_case(ValKh,I,J,P), !, 
 recherche_coup_pion([I,J],[J1,J2,K1,K2,[IKh,JKh]],P,Coups), reecrire_coups([I,J],Coups,Res).
 
/* est_coup_possbile_desobeir(P,E,Res) <= Res est un coup possible sur le plateau P,E en desobeissant au Khan */

est_coup_possible_desobeir(P,[J1,J2,K1,K2,[]],Res) :- dans_liste_nocut([I,J],J1),  recherche_coup_pion([I,J],[J1,J2,K1,K2,[]],P,Coups), reecrire_coups([I,J],Coups,Res).

est_coup_possible_desobeir(P,[J1,J2,K1,K2,Kh],Res) :-   dans_liste(Kh,J2), !, dans_liste_nocut([I,J],J1),
recherche_coup_pion([I,J],[J1,J2,K1,K2,Kh],P,Coups), reecrire_coups([I,J],Coups,Res).
 
est_coup_possible_desobeir(P,[J1,J2,K1,K2,Kh],Res) :-  dans_liste(Kh,J1),!, dans_liste_nocut([I,J],J2),
 recherche_coup_pion([I,J],[J1,J2,K1,K2,Kh],P,Coups), reecrire_coups([I,J],Coups,Res).


/* liste_coups_possibles(P,E,Res) <= Res est la liste des coups actuellement possible sur le plateau P,E */
liste_coups_possibles(P,E,Res) :- setof(X, est_coup_possible_obeir(P,E,X), ResTmp), reorganiser_liste(ResTmp,Res), !.
liste_coups_possibles(P,E,Res) :- setof(X, est_coup_possible_desobeir(P,E,X), ResTmp), reorganiser_liste(ResTmp,Res).

/* coups_du_pion(Pion,Coups,Res) <= Res = liste les coups parmi Coups qui correspondent au pion !  */
coups_du_pion(Pion,[[Pion,TCoup2]|Qcoup],[TCoup2|Qres]) :-  coups_du_pion(Pion,Qcoup,Qres), !.
coups_du_pion(Pion,[TCoup|Qcoup],Qres) :-  coups_du_pion(Pion,Qcoup,Qres).
coups_du_pion(Pion,[],[]).

/* afficher_coups_possibles(E)  <=  afficher une liste de liste de façon propre */
afficher_coups_possibles([]).
afficher_coups_possibles([[Ti,Tj]|Q]) :- write(Ti), write(' => '), write(Tj), write('\n'), afficher_coups_possibles(Q). 

/* afficher_coups_possibles(P,E) <= affiches les coups possibles actuellement sur le plateau P,E */
afficher_coups_possibles(P,E) :- liste_coups_possibles(P,E,Res), afficher_coups_possibles(Res).
afficher_coups_possibles_pion(P,E,[I,J]) :- recherche_coup_pion([I,J],E,P,Res), afficher_coups_possibles(Res).

/* reecrireCoup(A,B,Res)
plateauExemple(P,E), afficher_pieces_deplacables(P,E).
 afficher_coups_possibles(P,E)

si A = [I,J] 
et B = [[1,2],[3,4],[5,6]]
alrs Res = [ [[I,J],[1,2]],[[I,J],[3,4]],[[I,J],[5,6]] ]*/

reecrire_coups(Pos,[TC|C],[[Pos,TC]|Q]) :- reecrire_coups(Pos,C,Q).
reecrire_coups(Pos,[],[]).

/**************************************************************************************************


										P A R T I E          3
									      BOUCLAGE PRINCIPAL


**************************************************************************************************/
				  
/* effectuer_coup(P,E,NewE,MdJ) :- on effectue un coup selon le mode de jeu MdJ */
effectuer_coup(P,E,NewE,1) :- afficher_plateau(P,E),  demander_coup(P,E,NewE).
effectuer_coup(P,[J1,J2,K1,K2,Kh],NewE,2) :- \+ dans_liste(Kh,J1), afficher_plateau(P,[J1,J2,K1,K2,Kh]), demander_coup(P,[J1,J2,K1,K2,Kh],NewE), !.
effectuer_coup(P,[J1,J2,K1,K2,Kh],NewE,2) :- \+ dans_liste(Kh,J2), afficher_plateau(P,[J1,J2,K1,K2,Kh]), write('Le PC joue : \n'), effectuer_meilleur_coup(P,[J1,J2,K1,K2,Kh],NewE).
effectuer_coup(P,E,NewE,3) :- afficher_plateau(P,E), write('\n\n Ecrivez quelque chose suivi d\'un point pour continuer : \n'), read(_), effectuer_meilleur_coup(P,E,NewE).


/* demander_coup(P,E,NE) :- demande le coup au bout joueur suivant la position du khan et l'effectue dans NE*/


demander_coup(P,[J1,J2,K1,K2,Kh],NewE) :-  \+ dans_liste(Kh,J1), repeat,  write('\n Le joueur 1 choisit un pion à bouger sous la forme [I,J]: \n[0,0] = cimetiere\n'), 
read([I,J]), demander_coup_pion(P,[J1,J2,K1,K2,Kh], [I,J], NewE, joueur1). 


demander_coup(P,[J1,J2,K1,K2,Kh],NewE) :-  \+ dans_liste(Kh,J2), repeat,  write('\n Le joueur 2 choisit un pion à bouger sous la forme [I,J]: \n[0,0] = cimetiere\n'), 
read([I,J]), demander_coup_pion(P,[J1,J2,K1,K2,Kh], [I,J], NewE, joueur2). 




/* Soit le joueur a tapé 0,0 et on vérifie que le premier coup ne respecte possible ne respecte pas le khan,
soit on lui demande quel pion il veut bouger */

demander_coup_pion(P,[J1,J2,K1,K2,[IKh,JKh]], [0,0], [[[IC,JC]|J1],J2,K1,K2,[IC,JC]], joueur1) :-  nb_elem(J1,N), N < 6, liste_coups_possibles(P,[J1,J2,K1,K2,[IKh,JKh]],[[[IT,JT],_]|_]),  valeur_case(V,IKh,JKh,P), \+valeur_case(V,IT,JT,P),  
 write('\n Un pion revient a la vie ! Mais où ?  \n>'), read([IC,JC]), valeur_case(V,IC,JC, P).

demander_coup_pion(P,[J1,J2,K1,K2,Kh], [I,J], NewE, joueur1) :-   dans_liste([I,J],J1),  liste_coups_possibles(P,[J1,J2,K1,K2,Kh],Ctmp), coups_du_pion([I,J],Ctmp,C),
nb_elem(C,N), N > 0, !, 
repeat, write('\n Il choisit maintenant une position où aller parmi ceux ci :\n'),write(C), write('\n>'), read([I_,J_]), dans_liste([I_,J_],C), !, 
mouvement_pion([I,J],[I_,J_],[J1,J2,K1,K2,Kh],NewE).

demander_coup_pion(P,[J1,J2,K1,K2,[IKh,JKh]], [0,0], [J1, [[IC,JC]|J2] , K1,K2,[IC,JC]], joueur2) :-  nb_elem(J2,N), N < 6,
liste_coups_possibles(P,[J1,J2,K1,K2,[IKh,JKh]],[[[IT,JT],_]|_]),  valeur_case(V,IKh,JKh,P), \+valeur_case(V,IT,JT,P),  write('\n Un pion revient a la vie ! Mais où ?  \n>'), 
read([IC,JC]), valeur_case(V,IC,JC, P).

demander_coup_pion(P,[J1,J2,K1,K2,Kh], [I,J], NewE, joueur2) :-   dans_liste([I,J],J2),  liste_coups_possibles(P,[J1,J2,K1,K2,Kh],Ctmp), coups_du_pion([I,J],Ctmp,C),
nb_elem(C,N), N > 0, !, 
repeat, write('\n Il choisit maintenant une position où aller parmi ceux ci :\n'),write(C), write('\n>'), read([I_,J_]), dans_liste([I_,J_],C), !, 
mouvement_pion([I,J],[I_,J_],[J1,J2,K1,K2,Kh],NewE).



/* mouvement_pion(P,NP,E,NE) <= fais le mouvement du pion P à la case NP de l'état E à NE.  */
mouvement_pion(P,NP,[J1,J2,K1,K2,Kh],[NJ1,NJ2,NK1,K2,NP]) :-  \+dans_liste(Kh,J1),  supprimer_pion(NP,J2,NJ2),
   deplacer_pion(J1,P,NP,NJ1), deplacer_kalista(P,NP,K1,NK1), !.
mouvement_pion(P,NP,[J1,J2,K1,K2,Kh],[NJ1,NJ2,K1,NK2,NP]) :-  \+dans_liste(Kh,J2),  supprimer_pion(NP,J1,NJ1),
   deplacer_pion(J2,P,NP,NJ2), deplacer_kalista(P,NP,K2,NK2), !.

   
/* deplacer_kaliste(P,NP,K,NK) :- rafraichit la position de la kalista pour le coup P => NP  */
 deplacer_kalista(P,NP,P,NP) :- !.
 deplacer_kalista(_,_,K,K).
 
/* supprimer_pion(P,J,NJ]) <= supprime le pion P depuis une liste J dans NJ */
supprimer_pion(P,[P|J],J) :- !.
supprimer_pion(P,[T|Q],[T|NQ]) :- supprimer_pion(P,Q,NQ).
supprimer_pion(P,[],[]).
 
/* deplacer_pion(J,P,Pres,NewJ) :- Si le pion P est dans la liste des pions J on le remplace par Pres dans NewJ*/
deplacer_pion([P|Q],P,Pres,[Pres|Q]) :- !.
deplacer_pion([T|Q],P,Pres,[T|NQ]) :- deplacer_pion(Q,P,Pres,NQ), !.
deplacer_pion([],P,Pres,[]).



partie_finie(P,[J1,J2,K1,K2,Kh]) :- dans_liste(K2,J1), write('wb'), afficher_plateau(P,[J1,J2,K1,[],Kh]), write('\n\n\n LE JOUEUR 1 GAGNE !!!').
partie_finie(P,[J1,J2,K1,K2,Kh]) :- dans_liste(K1,J2), write('wa'), afficher_plateau(P,[J1,J2,[],K2,Kh]), write('\n\n\n LE JOUEUR 2 GAGNE !!!').

jouer_coup(P,E,MdJ) :- write('\n\n'), \+partie_finie(P,E),  effectuer_coup(P,E,NewE,MdJ), jouer_coup(P,NewE,MdJ), !.



/**************************************************************************************************


										P A R T I E          4
									      DETERMINER LE MEILLEUR COUPS POSSIBLE


**************************************************************************************************/

nettoyage_liste_blocage_bis(I,J,[], Nb, Etat, [], P).
nettoyage_liste_blocage_bis(I,J,[[Ib,Jb]|Q], Nb, Etat, NQ, P):- get_pion_J1(Etat, J1), get_pion_J2(Etat, J2), concat(J1, J2, Pions),
     dans_liste([Ib,Jb], Pions), valeur_case(Case,Ib,Jb,P), N is Nb -1, 4 is Case + N, asserta(sol([Ib,Jb])), fail.
nettoyage_liste_blocage_bis(I,J,[[Ib,Jb]|Q], Nb, Etat, NQ, P):- get_pion_J1(Etat, J1), get_pion_J2(Etat, J2), concat(J1, J2, Pions),
     dans_liste([Ib,Jb], Pions), valeur_case(Case,Ib,Jb,P),N is Nb -1, 6 is Case + N, asserta(sol([Ib,Jb])), fail.
nettoyage_liste_blocage_bis(I,J,[T|Q], Nb, Etat, NQ, P):- get_pion_J1(Etat, J1), get_pion_J2(Etat, J2), concat(J1, J2, Pions),
     dans_liste(T, Pions), nettoyage_liste_blocage_bis(I, J, Q, Nb, Etat, NQ, P), !.
nettoyage_liste_blocage_bis(I,J,[T|Q], Nb, Etat, [T|NQ], P):-nettoyage_liste_blocage_bis(I, J, Q, Nb, Etat, NQ, P).


/* supprimer le nettoyage_liste_blocage_bis si on veux toutes les solutions qui existent 
 changer avec nettoyage_liste_blocage sne prend pas en compte les case qui on un pion dessus 
changer avec nettoyage_liste_blocage_bis n'est pas parfait car quand certains pions son ajouté a la liste ils ne peuvent pas tjr sauter la kalista mais bon coup probable */

deplacement_possible_pion_bis(I, J, [I2,J2], Nb, Etat, Res, P) :- mouvement_une_case(I,J,ListMvt), nettoyage_liste_limite(ListMvt, ListNet),
    nettoyage_liste_blocage_bis(I2,J2,ListNet,Nb,Etat,Res,P),!.

explorer_case_succ_elem(I,J,[I2,J2],_,Nb,[],Etat,P).
explorer_case_succ_elem(I,J,[I2,J2],Histo,Nb,[[R,S]|Q],Etat,P) :- N is Nb-1, explorer_case_elem(R,S,[I2,J2],[[I,J] | Histo],N,Etat,P).
explorer_case_succ_elem(I,J,[I2,J2],Histo,Nb,[T|Q],Etat,P) :- explorer_case_succ_elem(I,J,[I2,J2],Histo,Nb,Q,Etat,P).
	
explorer_case_elem(I,J,[I2,J2],Histo,Nb,Etat,P):- valeur_case(Case,I,J,P), 4 is Case + Nb, asserta(sol([I,J])), fail.
explorer_case_elem(I,J,[I2,J2],Histo,Nb,Etat,P):- valeur_case(Case,I,J,P), 6 is Case + Nb, asserta(sol([I,J])), fail.
explorer_case_elem(I,J,[I2,J2],Histo,Nb,Etat,P):- Nb > 0, deplacement_possible_pion_bis(I,J,[I2,J2],Nb,Etat,L,P),
     nettoyage_case_visite(Histo, L, NL), explorer_case_succ_elem(I,J,[I2,J2],Histo,Nb,NL,Etat,P),fail.

	 
recherche_case_pion(I,J,Etat,P,Res) :- \+explorer_case_elem(I,J,[I,J],[],4,Etat,P), setof(X, sol(X), Res), retractall(sol(_)),!. 

/* Permet de dire si le coup permet de manger la kalista adverse X,Y les coordonnes du coups ,Pts1 score av predicat ,Pts2 score apres prédicat */
manger_kalista(X,Y,Pts1,Pts2,Etat):- get_kalista_J1(Etat, K1),  [X,Y] == K1, Pts2 is Pts1+20,!.
manger_kalista(X,Y,Pts1,Pts2,Etat):- get_kalista_J2(Etat, K1),  [X,Y] == K1, Pts2 is Pts1+20,!.
manger_kalista(X,Y,Pts1,Pts1,Etat).

/* Permet de dire si le coup permettera d'attaquer la kalista adverse [Px,Py] est le pion de base, X,Y les coordonne d'un coups possible du pion de base ,Pts1 score av predicat ,Pts2 score apres prédicat */
attaquer_kalista([Px,Py],X,Y,Pts1,Pts2,P,Etat):- get_pion_J1(Etat,P1), dans_liste([Px,Py],P1), get_kalista_J2(Etat, [Kx,Ky]), recherche_case_pion(Kx,Ky,Etat,P,LF), dans_liste([X,Y], LF), Pts2 is Pts1 + 8, !.
attaquer_kalista([Px,Py],X,Y,Pts1,Pts2,P,Etat):- get_pion_J2(Etat,P2), dans_liste([Px,Py],P2), get_kalista_J1(Etat, [Kx,Ky]), recherche_case_pion(Kx,Ky,Etat,P,LF), dans_liste([X,Y], LF), Pts2 is Pts1 + 8, !.
attaquer_kalista([Px,Py],X,Y,Pts1,Pts1,P,Etat).

/* Permet de dire si le coup permettera de defendre la kalista adverse [Px,Py] est le pion de base, X,Y les coordonne d'un coups possible du pion de base ,Pts1 score av predicat ,Pts2 score apres prédicat */
defendre_kalista([Px,Py],X,Y,Pts1,Pts2,P,Etat):- get_pion_J1(Etat,P1), dans_liste([Px,Py],P1), get_kalista_J1(Etat, [Kx,Ky]), [Px,Py] \= [Kx,Ky], recherche_case_pion(Kx,Ky,Etat,P,LF), dans_liste([X,Y], LF), Pts2 is Pts1 + 6, !.
defendre_kalista([Px,Py],X,Y,Pts1,Pts2,P,Etat):- get_pion_J2(Etat,P2), dans_liste([Px,Py],P2), get_kalista_J2(Etat, [Kx,Ky]), [Px,Py] \= [Kx,Ky], recherche_case_pion(Kx,Ky,Etat,P,LF), dans_liste([X,Y], LF), Pts2 is Pts1 + 6, !.
defendre_kalista([Px,Py],X,Y,Pts1,Pts1,P,Etat).

/* Permet de dire si le coup permettera de faire deplacer la kalista adverse [Px,Py] (lié au khan) est le pion de base, X,Y les coordonne d'un coups possible du pion de base ,Pts1 score av predicat ,Pts2 score apres prédicat */
deplacer_kalista([Px,Py],X,Y,Pts1,Pts2,P,Etat):- get_pion_J1(Etat,P1), dans_liste([Px,Py],P1), get_kalista_J2(Etat, [Kx,Ky]), valeur_case(C1,Kx,Ky,P), 
	valeur_case(C2,X,Y,P), C1 is C2, Pts2 is Pts1 + 5, !.
deplacer_kalista([Px,Py],X,Y,Pts1,Pts2,P,Etat):- get_pion_J2(Etat,P2), dans_liste([Px,Py],P2), get_kalista_J1(Etat, [Kx,Ky]), valeur_case(C1,Kx,Ky,P), 
	valeur_case(C2,X,Y,P), C1 is C2, Pts2 is Pts1 + 5, !.
deplacer_kalista(Pion,X,Y,Pts1,Pts1,P,Etat).

/* Permet de dire si le coup permet de manger un pion adverse X,Y les coordonnes du coups ,Pts1 score av predicat ,Pts2 score apres prédicat */
manger_pion(X,Y,Pts1,Pts2,Etat):- get_pion_J1(Etat,P1), dans_liste([X,Y], P1), Pts2 is Pts1+4,!.
manger_pion(X,Y,Pts1,Pts2,Etat):- get_pion_J2(Etat,P1), dans_liste([X,Y], P1), Pts2 is Pts1+4,!.
manger_pion(X,Y,Pts1,Pts1,Etat).


/* Favorise les coups qui permette de se déplacer plus loin , X,Y les coordonne du coups ,Pts1 score av predicat ,Pts2 score apres prédicat */
deplacement_case_numero(X,Y,Pts1,Pts2,P):- valeur_case(C,X,Y,P), Pts2 is Pts1+C.

/* Cumules les différente stratégie pour obtenir les points d'un coups pour un pion. Pion est le pion de base ,[Cx, Cy] les coordonne d'un coups possible du pion de base  ,Pts0 score av predicat ,PtsFin score final */
score_coups(Pion,[Cx, Cy],Pts0,PtsFin,P,Etat):- manger_kalista(Cx,Cy,Pts0,Pts1,Etat), deplacement_case_numero(Cx,Cy,Pts1,Pts2,P), manger_pion(Cx,Cy,Pts2,Pts3,Etat), 
	deplacer_kalista(Pion,Cx,Cy,Pts3,Pts4,P,Etat), defendre_kalista(Pion,Cx,Cy,Pts4,Pts5,P,Etat), attaquer_kalista(Pion,Cx,Cy,Pts5,PtsFin,P,Etat) . 

/* Détermine quel est le meilleur coups pour un pion a partir d'une liste de coups
 Pion est le pion de base ,[T|Q] la liste de coups a vérifier ,AC le meilleur coups actuelle ,
 NC le meilleur coups à la fin de l'algo ,AScore le score de NC ,NScore le score du meilleur coups à la fin de l'algo 
Exemple meilleur_score([1,2],[[1,5],[6,3],[6,4]],[],NC,-1,FScore,P,E) */
meilleur_score(Pion,[],AC,AC,AScore,AScore,P,Etat):-!.
meilleur_score(Pion,[T|Q],AC,NC,AScore,NScore,P,Etat):- score_coups(Pion,T,0,Score,P,Etat) , Score > AScore, meilleur_score(Pion,Q,T,NC,Score,NScore,P,Etat),!.
meilleur_score(Pion,[T|Q],AC,NC,AScore,NScore,P,Etat):- meilleur_score(Pion,Q,AC,NC,AScore,NScore,P,Etat).

/* plateauExemple(P,E),choix_coups([[1,2]],[],PionChoix,[],NC,-1,NScore,P,E) */
choix_coups([],Pion,Pion,AC,AC,AScore,AScore,P,Etat):-!.
choix_coups([[X,Y]|Q],Pion,PionChoix,AC,NC,AScore,NScore,P,Etat):- recherche_coup_pion([X,Y],Etat,P,ListCoups), meilleur_score([X,Y],ListCoups,[],Coups, -1, Score,P,Etat),
	Score > AScore, choix_coups(Q,[X,Y],PionChoix,Coups,NC,Score,NScore,P,Etat),!.
choix_coups([[X,Y]|Q],Pion,PionChoix,AC,NC,AScore,NScore,P,Etat):- choix_coups(Q,Pion,PionChoix,AC,NC,AScore,NScore,P,Etat).


effectuer_meilleur_coup(P,[J1,J2,K1,K2,Kh],NewE) :- \+dans_liste(Kh,J1), choix_coups(J1,[],PionChoix,[],NC,-1,_,P,[J1,J2,K1,K2,Kh]), mouvement_pion(PionChoix, NC, [J1,J2,K1,K2,Kh], NewE), !.
effectuer_meilleur_coup(P,[J1,J2,K1,K2,Kh],NewE) :- \+dans_liste(Kh,J2), choix_coups(J2,[],PionChoix,[],NC,-1,_,P,[J1,J2,K1,K2,Kh]), mouvement_pion(PionChoix, NC, [J1,J2,K1,K2,Kh], NewE), !.



/**************************************************************************************************

								A N N N E X E S		l
										
										PREDICAT D'AMORCAGES
										EXEMPLES POUR LES TEST
										ETC...

**************************************************************************************************/

plateauExemple(P,[ [ [1,2], [2,3], [4,6] ,[5,2],[2,2] ], [ [4,5], [6,4], [6,6] , [5,3] ] , [2,2], [5,3], [4,5] ]) :- plateau_initial(P).
etatExemple( [
[ [1,1], [1,2], [4,1], [3,4], [2,1], [1,5] ],
[ [5,2], [3,6], [3,1],  [6,6], [2,2] ],
[1,1], [6,6] , [1,5] ] ).

test :- plateauExemple(P,E), jouer_coup(P,E,1).
test2 :- plateauExemple(P,E), liste_coups_possibles(P,E,Ctmp), write(Ctmp), write('\n'), coups_du_pion([4,5],Ctmp,C), write(C), write('\n').
afficherPE :- plateauExemple(P,E), afficher_plateau(P,E).


startExemple(X) :- plateau180(P), etatExemple(E), jouer_coup(P,E,X).
start :- initialiserPlateau(P,E,MdJ), jouer_coup(P,E,MdJ).
