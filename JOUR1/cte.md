SELECT montant * 1.2 AS ttc FROM commandes WHERE ttc > 500;

Cette requête ne fonctionne pas, car le WHERE est exécuté avant le Select.
Mais alors comment fait pour éviter de dupliquer ce calcul dans le Where ? On peut utiliser
une table CTE :

WITH calculate_ttc AS (SELECT commandes.montant * 1.2 as ttc FROM commandes)
SELECT COUNT(*) FROM calculate_ttc WHERE ttc > 500;