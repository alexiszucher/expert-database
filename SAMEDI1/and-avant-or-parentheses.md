SELECT count(*) FROM commandes_null
WHERE statut <> 'annulee' OR statut IS NULL
  AND date_commande >= '2025-03-01' AND date_commande < '2025-04-01';
-- 3771539 : les 3/4 de la table pour un seul mois

AND passe avant OR (comme × avant + en maths). La base lit :

WHERE statut <> 'annulee'
   OR (statut IS NULL AND date_commande >= ... AND date_commande < ...)

Donc toutes les commandes non annulées de la table (3 750 228),
plus les NULL de mars seulement (21 311).

Avec des parenthèses autour du OR :

WHERE date_commande >= '2025-03-01' AND date_commande < '2025-04-01'
  AND (statut <> 'annulee' OR statut IS NULL);
-- 180764 (en UTC)

Règle : dès qu'un OR est mélangé à des AND, mettre des parenthèses.
Et vérifier l'ordre de grandeur : 5 M sur 24 mois = environ 210 000 par mois.
Un chiffre 18 fois trop gros, ou deux requêtes différentes qui donnent le même chiffre,
c'est un bug à chercher avant d'aller plus loin.
