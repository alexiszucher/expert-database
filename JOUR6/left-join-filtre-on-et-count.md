Pour chaque client, ses commandes annulées en mars (Paris), clients à 0 compris :

SELECT clients.id, count(commandes_null.id) AS nb
FROM clients
LEFT JOIN commandes_null ON clients.id = commandes_null.client_id
                        AND statut = 'annulee'
                        AND date_commande >= '2025-03-01 Europe/Paris'
                        AND date_commande <  '2025-04-01 Europe/Paris'
GROUP BY clients.id;
-- 120000 lignes, 92893 clients à 0

1. Le sens : LEFT JOIN garde toutes les lignes de la table de GAUCHE.
   "nombre_commande_par_client LEFT JOIN clients" gardait les 27107 clients
   qui avaient des annulations, pas les 120000.

2. Filtre dans le WHERE = LEFT JOIN annulé.
   Un client sans annulation sort du LEFT JOIN avec statut = NULL.
   NULL = 'annulee' donne UNKNOWN, le WHERE ne garde que TRUE (Jour 2) : la ligne disparaît.
   Résultat : 27107 lignes, comme un INNER JOIN.
   Filtre dans le ON = il choisit quelles commandes on associe, les clients restent tous.

3. count(*) donne 1 aux clients sans commande.
   Le client garde une ligne remplie de NULL : count(*) compte les lignes, il trouve 1.
   count(commandes_null.id) compte les valeurs non NULL : 0.
   Ici on compte des commandes, pas des lignes de jointure.
   (À l'inverse, pour compter des orphelines, count(*) : exercice précédent.)

Autre façon : grouper les commandes dans une CTE d'abord, puis clients LEFT JOIN cte
et coalesce(nb, 0). Le filtre est enfermé dans la CTE, il ne peut pas casser le LEFT JOIN.
