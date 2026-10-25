SELECT count(*) FROM commandes_null
WHERE date_commande BETWEEN '2025-03-01' AND '2025-03-31 23:59:59';

Deux problèmes :
- un timestamptz a une précision à la microseconde : tout ce qui est entre 23:59:59.000001
  et minuit est raté.
- pas de fuseau dans les littéraux : ils sont lus dans le fuseau de la session (Jour 5).

Sur ma base, il y a 0 ligne entre 23:59:59 et minuit : le bug ne se voit pas en test.
Il apparaîtra en production, sur la commande qui tombe dans cette seconde.

Autre défaut : il faut connaître le dernier jour du mois (28, 29, 30 ou 31).
Avec [début, fin[ on écrit toujours "le 1er du mois suivant" :

WHERE date_commande >= '2025-03-01 Europe/Paris'
  AND date_commande <  '2025-04-01 Europe/Paris'
