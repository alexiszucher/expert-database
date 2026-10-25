SELECT client_id, sum(montant) AS total
FROM commandes_null
WHERE sum(montant) > 1000
GROUP BY client_id;

ERROR:  aggregate functions are not allowed in WHERE

Au Jour 1, répéter le calcul dans le WHERE marchait (montant * 1.2 > 500).
Avec un agrégat, non : le WHERE passe avant le GROUP BY, les groupes n'existent pas encore,
donc il n'y a rien à additionner.

Un filtre sur un agrégat va dans le HAVING :

SELECT client_id, sum(montant) AS total
FROM commandes_null
GROUP BY client_id
HAVING sum(montant) > 1000;

Ou dans une sous-requête / CTE, où total devient une vraie colonne :

SELECT * FROM (
  SELECT client_id, sum(montant) AS total
  FROM commandes_null
  GROUP BY client_id
) t
WHERE total > 1000;

Règle : WHERE filtre des lignes avant de grouper, HAVING filtre des groupes après.
