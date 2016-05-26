/* syntaxe : verbe(x,y) : x "verbe" y 
 syntaxe : adjectif(x,y) : x est adjectif y 
taille(plateau_initial,Vmax-1), */ 



	/* ----------------- Règles générales  ------------*/

plateau_initial([[2,3,1,2,2,3],[2,1,3,1,3,1],[1,3,2,3,1,2],[3,1,2,1,3,2],[2,3,1,3,1,3],[2,1,3,2,2,1]]).
plateau90([[3,1,2,2,3,1],[2,3,1,3,1,2],[2,1,3,1,3,2],[1,3,2,2,1,3],[3,1,3,1,3,1],[2,2,1,3,2,2]]). /* sens trigo */
plateau180([[1,2,2,3,1,2],[3,1,3,1,3,2],[2,3,1,2,1,3],[2,1,3,2,3,1],[1,3,1,3,1,2],[3,2,2,1,3,2]]).
plateau270([[2,2,3,1,2,2],[1,3,1,3,1,3],[3,1,2,2,3,1],[2,3,1,3,1,2],[2,1,3,1,3,2],[1,3,2,2,1,3]]).

taille(plateau_initial,6).
taille(plateau90,6).
taille(plateau180,6).
taille(plateau270,6).
	/* ------------------ Prédicats généraux ------------- */


/* elem_liste(I,L,E) <= E est l'élement I de la liste L */

elem_liste(1,[Z|Q],Z).
elem_liste(N,[T|Q],Z) :- N>1, M is N-1, elem_liste(M,Q,Z).

/* valeur_case(Z,X,Y,P) <= Z est l'élement [X,Y] du plateau P */ 
valeur_case(Z,X,Y,P) :- X>0, Y>0, X<6, Y<6, elem_liste(X,P,Ligne), elem_liste(Y,Ligne,Z), !.

/* dans_liste(E,L) <= E est dans la liste L */
dans_liste(T,[T|Q]):- !.
dans_liste(E,[T|Q]):- dans_liste(E,Q).

/* CHANGER NOMS DE X ET Y !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
afficher_element(E,I,J,[Pj,Po]) :- dans_liste([I,J],Pj), write(E), write('J'), write(' '),  !.
afficher_element(E,I,J,[Pj,Po]) :- dans_liste([I,J],Po), write(E), write('O'), write(' '), !.
afficher_element(E,I,J,[Pj,Po]) :- write(E), write(' '), write(' ').

/* afficher_ligne_plateau([T],I,J,E) La ligne J du plateau T est affichée à partir de l'élement I*/
afficher_ligne_plateau([],_,_,_) :- write('\n'), !.
afficher_ligne_plateau([T|Q],I,J,Etat) :- afficher_element(T,I,J,Etat), Iinc is I+1, afficher_ligne_plateau(Q,Iinc,J,Etat).

/* afficher_plat([T],J,E) <= T est affiché dans l'état E à partir de la ligne J*/
afficher_plateau([],_,_):- !.
afficher_plateau([T|Q],J,Etat) :- afficher_ligne_plateau(T,1,J,Etat), afficher_plateau(Q,J+1,Etat).

/* afficher_ligne[L] <= L est une liste qui est affichée en finissant par '\n' */
afficher_ligne([]) :- write('\n'), !.
afficher_ligne([T|Q]) :- write(T), write(' '), afficher_ligne(Q).

/* afficher_tab[T] <= T est une liste de liste qui est affichée  */

afficher_tab([]):- !.
afficher_tab([T|Q]) :- afficher_ligne(T), afficher_tab(Q).



/* afficher(P) : affiche le plateau P */
afficher(P) :- afficher_depuis(P,1).

	/* -------------------- PARTIE 1 -------------------
	INITIALISATION DU PLATEAU */

/* initialiserPlateau(Plateau) <= Plateau est le résultat de l'initialisation */
initialiserPlateau(Plateau) :- plateau_initial(P),afficher_tab(P), demander_mode(ModeDeJeu), demanderOrientationPlateau(Plateau).

/* demande_mode(ModeDejeu) <= ModeDeJeu est le mode de jeu choisi parmi humain/humain, humain/machine", etc... */
demander_mode(ModeDeJeu) :- repeat, write('\n\nChoisissez le mode de jeu en tapant parmi parmi {"1.","2.","3.","4."} \n 1. Humain vs Humain\n 2. Humain vs IA \n 3. IA vs IA \n >'), read(ModeDeJeu), mode_valide(ModeDeJeu)!.

/* mode_valide(X) <= X peut être unifié avec une valeur qui correspond à un mode */
mode_valide(X) :- X is 1,!. /* HvH !! */
mode_valide(X) :- X is 2,!. /* HvO !! */
mode_valide(X) :- X is 3,!. 

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
