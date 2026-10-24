SELECT count(*) FROM commandes_null
WHERE date_commande BETWEEN '2025-03-01' AND '2025-03-31';
-- 205713

SELECT count(*) FROM commandes_null
WHERE date_commande >= '2025-03-01' AND date_commande < '2025-04-01';
-- 212516 (le bon compte)

BETWEEN inclut ses deux bornes, et '2025-03-31' sur un timestamp veut dire 2025-03-31 00:00:00.
Le 31 mars n'est pris qu'à minuit pile : il manque tout le reste de la journée.

Les lignes ratées (6803, l'écart exact) :

SELECT count(*) FROM commandes_null
WHERE date_commande > '2025-03-31' AND date_commande < '2025-04-01';

(> et pas >= : minuit pile, BETWEEN l'a déjà compté.)

BETWEEN '2025-03-01' AND '2025-04-01' ne corrige rien : il compte le 1er avril à minuit dans mars.
Si on compte mars puis avril comme ça, ces lignes sont comptées deux fois.
Avec BETWEEN, c'est soit un trou, soit un recouvrement.

Règle : une plage de temps se filtre en [début, fin[ :
>= début du mois AND < début du mois suivant.
Ça marche quelle que soit la précision de la colonne (secondes, microsecondes).
