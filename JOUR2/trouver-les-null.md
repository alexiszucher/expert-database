SELECT count(*) FROM commandes_null WHERE statut IS DISTINCT FROM 'payee';

IS DISTINCT FROM 'string' permet de prendre les NULL aussi,
là ou != ne prend pas les null, <> non plus


SELECT COUNT(*) + (
SELECT COUNT(*) FROM commandes_null WHERE statut = 'payee'
) FROM commandes_null WHERE statut IS DISTINCT FROM 'payee';

Ici j'ai bien mes 5 000 000 de commandes en entier grâce au IS DISTINCT FROM qui prélève les valeurs NULL aussi.