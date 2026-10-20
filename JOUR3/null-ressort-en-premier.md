SELECT montant
FROM commandes_null
ORDER BY montant DESC
LIMIT 3;

La requête ressort les NULL en premier.
Pour éviter cela, soit on fait un WHERE IS NOT NULL,
Soit : 

SELECT montant
FROM commandes_null
ORDER BY montant DESC NULLS LAST
LIMIT 3;

NULLS LAST permet de mettre les NULL à la fin et donc de bien chercher
les commandes les plus cher.