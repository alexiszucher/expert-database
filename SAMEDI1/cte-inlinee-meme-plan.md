WITH m AS (SELECT DISTINCT ON (client_id) ... ORDER BY client_id, montant DESC NULLS LAST, id)
SELECT ... FROM m ORDER BY montant DESC NULLS LAST, id LIMIT 5;

Même temps que la version sous-requête, parce que c'est le même plan.
EXPLAIN (COSTS OFF) donne exactement les mêmes noeuds :
Limit -> Sort -> Subquery Scan -> Unique -> Gather Merge -> Sort -> Parallel Seq Scan

Depuis PostgreSQL 12, une CTE utilisée une seule fois (et qui ne modifie rien)
est recopiée dans la requête comme une sous-requête : elle n'est plus une "barrière".
La CTE sert à la lisibilité, pas à la performance.

Pour forcer l'ancien comportement (calculer la CTE à part, puis la relire) :

WITH m AS MATERIALIZED (...)

Le plan change : un bloc "CTE m" calculé à part, puis un "CTE Scan on m".
C'est utile ou nuisible selon les cas (semaine 10).

Au passage, le Filter du Seq Scan montre les bornes Paris converties en UTC :
date_commande >= '2025-02-28 23:00:00+00' AND date_commande < '2025-03-31 22:00:00+00'
(la conversion est faite une fois, sur les bornes, pas sur chaque ligne : sargable).
