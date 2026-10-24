SET timezone = 'Europe/Paris';

SELECT count(*) FROM commandes_null
WHERE date_commande >= '2025-03-01' AND date_commande < '2025-04-01';
-- 212277 (contre 212516 en UTC)

Les données n'ont pas bougé : un timestamptz est un instant absolu (stocké en UTC).
Ce qui bouge, c'est le littéral '2025-03-01' : sans fuseau écrit, il est lu
dans le fuseau de la session. Ce n'est pas toujours UTC.

En session Europe/Paris, mars devient :
- début : 2025-03-01 00:00 Paris = 2025-02-28 23:00 UTC (heure d'hiver, +1)
- fin   : 2025-04-01 00:00 Paris = 2025-03-31 22:00 UTC (heure d'été, +2)
Le décalage change dans le mois (passage à l'heure d'été le 30 mars) :
mars à Paris dure 30 jours 23 h.

Même requête, deux connexions avec un fuseau différent = deux chiffres différents.

Pour ne plus dépendre de la session, écrire le fuseau dans la borne :

WHERE date_commande >= '2025-03-01 Europe/Paris'
  AND date_commande <  '2025-04-01 Europe/Paris'
-- 212277 quel que soit le SET timezone

Stocker en UTC (timestamptz) : oui. Filtrer en UTC : seulement si la question est en UTC.
"Le CA de mars" pour une boutique française, c'est mars à Paris (212277), pas mars en UTC (212516).
Filtrer en UTC donnerait un chiffre faux de 239 commandes.
La règle : toujours écrire le fuseau de la question métier, ne jamais laisser la session décider.

Autre façon équivalente : l'application convertit les bornes Paris en UTC avant d'envoyer la requête.
- bornes = minuit Paris du 1er mars et minuit Paris du 1er avril (toujours [début, fin[)
- les envoyer avec le Z : '2025-02-28T23:00:00Z' et '2025-03-31T22:00:00Z'
  (sans Z, la session les relit dans son fuseau)
- jamais de +1 en dur : l'offset change dans le mois, utiliser une lib de fuseaux

C'est aussi pour ça que timestamptz::date n'est pas IMMUTABLE
(et ne peut pas servir dans un index) : le jour d'un instant dépend du fuseau.
