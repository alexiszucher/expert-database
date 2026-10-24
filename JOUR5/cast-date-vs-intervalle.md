SELECT count(*) FROM commandes_null
WHERE date_commande::date = '2025-03-31';

SELECT count(*) FROM commandes_null
WHERE date_commande >= '2025-03-31' AND date_commande < '2025-04-01';

Même résultat (6803), mais seule la deuxième peut utiliser un index sur date_commande :
la colonne est nue. Avec ::date, la colonne est transformée ligne par ligne,
la base ne peut plus descendre dans l'arbre de l'index (même idée qu'au Jour 2).

On pourrait créer un index sur l'expression, mais sur un timestamptz ça échoue :

CREATE INDEX ON commandes_null ((date_commande::date));
ERROR:  functions in index expression must be marked IMMUTABLE

timestamptz::date n'est pas IMMUTABLE : le résultat dépend du fuseau de la session.
Il faut fixer le fuseau dans l'expression (et l'écrire pareil dans le WHERE) :

CREATE INDEX ON commandes_null (((date_commande AT TIME ZONE 'Europe/Paris')::date));

Le plus simple reste l'intervalle semi-ouvert sur la colonne nue :
un seul index sur date_commande sert pour un jour, un mois, une année.
