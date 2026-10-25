SELECT id, montant FROM commandes_null
ORDER BY montant
LIMIT 5;

Il y a 50 commandes à 0.00. Les 5 renvoyées sont prises au hasard parmi ces 50 :
le tri ne dit rien sur l'ordre des ex aequo, le résultat peut changer d'une exécution à l'autre
(ou après un VACUUM, un changement de plan, une requête parallèle).

Pour un résultat stable, finir le ORDER BY par une colonne unique :

SELECT id, montant FROM commandes_null
ORDER BY montant, id
LIMIT 5;

Même règle que pour DISTINCT ON (Jour 4) : dès qu'il y a un LIMIT ou un DISTINCT ON,
le ORDER BY doit départager toutes les lignes.
