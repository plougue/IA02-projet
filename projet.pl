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

/* rotation90(A,B) <= A est la rotation à 90 de B 
rotation90(A,B) :-  valeur_case(Z_A, X,Y,A), valeur_case(Z_A,taille(A)+1-Y,X,B),  Z_A \= Z_B, !, fail.
rotation90(_,_). */

dans_liste(T,[T|Q]):- !.
dans_liste(E,[T|Q]):- dans_liste(E,Q).
/* CHANGER NOMS DE X ET Y !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */
afficher_element(E,X,Y,[Pj,Po]) :- dans_liste([X,Y],Pj), write(E), write('J'), write(' '),  !.
afficher_element(E,X,Y,[Pj,Po]) :- dans_liste([X,Y],Po), write(E), write('O'), write(' '), !.
afficher_element(E,X,Y,[Pj,Po]) :- write(E), write(' '), write(' ').

afficher_ligne([],_,_,_) :- write('\n'), !.
afficher_ligne([T|Q],X,Y,Etat) :- afficher_element(T,X,Y,Etat), Xinc is X+1, afficher_ligne(Q,Xinc,Y,Etat).
/* afficher_tab[T] <= T est une liste de liste qui est affichée*/
afficher_tab([],_):- !.
afficher_tab([T|Q],Y) :- afficher_ligne(T,1,Y), afficher_tab(Q,Y+1).

/* afficher_ligne[L] <= L est une liste qui est affichée en finissant par '\n' 
afficher_ligne([]) :- write('\n'), !.
afficher_ligne([T|Q]) :- write(T), write(' '), afficher_ligne(Q).
*/
/* afficher_tab[T] <= T est une liste de liste qui est affichée/
afficher_tab([]):- !.
afficher_tab([T|Q]) :- afficher_ligne(T), afficher_tab(Q).
*/


/* afficher(P) : affiche le plateau P */
afficher(P) :- afficher_depuis(P,1).

	/* -------------------- PARTIE 1 -------------------
	INITIALISATION DU PLATEAU */

/* initialiserPlateau(Plateau) <= Plateau est le résultat de l'initialisation */
initialiserPlateau(Plateau) :- plateau_initial(P),afficher_tab(P),  demanderOrientationPlateau(Plateau).

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
