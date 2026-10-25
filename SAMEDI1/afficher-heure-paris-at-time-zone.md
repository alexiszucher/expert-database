SELECT id,
       date_commande,
       date_commande AT TIME ZONE 'Europe/Paris' AS date_paris
FROM commandes_null WHERE id = 4994443;

date_commande : 2025-03-31 16:45:43.084583+00  (l'instant, affiché dans le fuseau de la session, UTC)
date_paris    : 2025-03-31 18:45:43.084583     (l'heure qu'il était à Paris)

timestamptz AT TIME ZONE 'Europe/Paris' renvoie un timestamp sans fuseau :
l'heure "sur l'horloge" à Paris à cet instant. Le +2 de l'heure d'été est calculé tout seul.

Autre façon : SET timezone = 'Europe/Paris'; et la colonne s'affiche en heure de Paris (+02).
Mais ça dépend de la session, comme pour les filtres (Jour 5).

La conversion va dans le SELECT, pour l'affichage.
Dans le WHERE, on laisse la colonne nue et on met le fuseau dans les bornes :
date_commande >= '2025-03-01 Europe/Paris' (sargable, Jour 2).
