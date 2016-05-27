/* syntaxe : verbe(x,y) : x "verbe" y 
 syntaxe : adjectif(x,y) : x est adjectif y */ 




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
valeur_case(Z,X,Y,P) :- X>0, Y>0, X<6, Y<6, elem_liste(X,P,Ligne), elem_liste(Y,Ligne,Z), !.

/* dans_liste(E,L) <= E peut être unifié avec un elem de la liste Q */
dans_liste(T,[T|Q]):- !.
dans_liste(E,[T|Q]):- dans_liste(E,Q).


	/* -------------- Methodes d'affichage plateau -------------
	   --------------------------------------------------------- */
	   
afficher_element(E,I,J,[Pj1,Pj2]) :- ValI is I, ValJ is J, dans_liste([ValI,ValJ],Pj1), write(E), write('J'), write(' '),  !.
afficher_element(E,I,J,[Pj1,Pj2]) :- ValI is I, ValJ is J, dans_liste([ValI,ValJ],Pj2), write(E), write('O'), write(' '), !.
afficher_element(E,I,J,[Pj1,Pj2]) :- write(E), write(' '), write(' ').

/* afficher_ligne_plateau([T],I,J,E) La ligne J du plateau T est affichée à partir de l'élement I*/
afficher_ligne_plateau([],_,_,_) :- write('\n'), !.
afficher_ligne_plateau([T|Q],I,J,Etat) :- afficher_element(T,I,J,Etat), Iinc is I+1, afficher_ligne_plateau(Q,Iinc,J,Etat).

/* afficher_plateau_from([T],J,E) <= T est affiché dans l'état E à partir de la ligne J*/
afficher_plateau_from([],_,_):- !.
afficher_plateau_from([T|Q],J,Etat) :- afficher_ligne_plateau(T,1,J,Etat), afficher_plateau_from(Q,J+1,Etat).

afficher_plateau(P,E) :- write('\n'), afficher_plateau_from(P,1,E).

/* afficher_ligne[L] <= L est une liste qui est affichée en finissant par '\n' */
afficher_ligne([]) :- write('\n'), !.
afficher_ligne([T|Q]) :- write(T), write(' '), afficher_ligne(Q).

/* afficher_tab[T] <= T est une liste de liste qui est affichée  */
afficher_tab([]):- !.
afficher_tab([T|Q]) :- write('\n'), afficher_ligne(T), afficher_tab(Q).





	/* -------------------- PARTIE 1 -------------------
	              INITIALISATION DU PLATEAU */

/* initialiserPlateau(Plateau,Etat) <= Plateau et Etat sont le résultat de l'initialisation */

initialiserPlateau(Plateau,Etat) :-  plateau_initial(P),afficher_tab(P), demander_mode(ModeDeJeu), 
demanderOrientationPlateau(Plateau), placerPiecesJ1(Plateau, [[[]],[[]]], ModeDeJeu, EtatIntermediaire),
write(EtatIntermediaire), placerPiecesJ2(Plateau, EtatIntermediaire, ModeDeJeu, Etat),
write('\n-----------------------------------------------------\n  Plateau final \n \n'),
 afficher_plateau(Plateau,Etat).


/* placerPiecesJ1(P,E, M, ERes) <= si M correspond à un mode où J1 est humain,
 ses pièces sont ajoutées par lui dans ERes à partir de E jusqu'à ce qu'il y en ait 6 */
placerPiecesJ1(Plateau,[Pj1,Pj2], ModeDeJeu, EtatRes) :- ModeDeJeu < 3, nb_elem(Pj1,N), N < 6,  !,
repeat, write('\n-----------------------------------------------------\n Le Joueur 1 place ses pions'),
write('\n\n'), afficher_plateau(Plateau,[Pj1,Pj2]),
write('\nJoueur 1 : entrez la ligne où insérer la pièce  {5. ou 6.} : \n >'), read(J), J =< 6, J >=5, 
write('\nChoisissez maintenant la colonne \n >'), read(I), 
insererPiecePlateau(I,J,Pj1,NewPj1), !, placerPiecesJ1(Plateau,[NewPj1,Pj2], ModeDeJeu, EtatRes).

placerPiecesJ1(_,E, _,E).

/* placerPiecesJ2(P,E, M, Eres) <=  si M correspond à un mode où J2 est humain,
 ses pièces sont ajoutées par lui dans Eres à partir de E jusqu'à ce qu'il y en ait 6 */
placerPiecesJ2(Plateau,[Pj1,Pj2], ModeDeJeu, EtatRes) :- ModeDeJeu < 2, nb_elem(Pj2,N), write(N), N < 6,  !,
repeat, write('\n-----------------------------------------------------\n Le Joueur 2 place ses pions'), 
write('\n\n'), afficher_plateau(Plateau,[Pj1,Pj2]),
write('\nJoueur 2 : entrez la ligne où insérer la pièce  {1. ou 2.} : \n >'), read(J), J >= 1, J =< 2,
write('\nChoisissez maintenant la colonne \n >'), read(I), 
insererPiecePlateau(I,J,Pj2,NewPj2), !, placerPiecesJ2(Plateau,[Pj1,NewPj2], ModeDeJeu, EtatRes).

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
