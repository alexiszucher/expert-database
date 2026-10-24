SELECT DISTINCT ON (client_id) client_id, date_commande, montant
FROM commandes_null
ORDER BY date_commande DESC;

ERROR:  SELECT DISTINCT ON expressions must match initial ORDER BY expressions

Le ORDER BY doit commencer par la colonne du DISTINCT ON :

ORDER BY client_id, date_commande DESC NULLS LAST, id DESC

Pourquoi : DISTINCT ON trie, puis le noeud Unique garde la 1re ligne de chaque groupe.
Il faut que les lignes d'un même client soient côte à côte, donc trier d'abord par client_id.
Les colonnes suivantes choisissent quelle ligne est gardée.

Sans aucun ORDER BY la requête passe, mais la ligne gardée est au hasard
(elle peut changer d'une exécution à l'autre). C'est presque toujours un bug.

Pour avoir le résultat final trié par date, il faut deux étapes :

SELECT * FROM (
  SELECT DISTINCT ON (client_id) client_id, date_commande, montant
  FROM commandes_null
  ORDER BY client_id, date_commande DESC NULLS LAST, id DESC
) t
ORDER BY date_commande DESC;
