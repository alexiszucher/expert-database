SELECT count(clients.id)
FROM clients
LEFT JOIN commandes_null ON commandes_null.client_id = clients.id
WHERE commandes_null.client_id IS NULL;
-- 20000 (clients 100001 à 120000)

LEFT JOIN + WHERE droite IS NULL = "les lignes de gauche sans partenaire" (anti-jointure).

Quelle colonne tester dans le IS NULL ?
Une colonne qui ne peut pas être NULL quand il y a un partenaire.
Le plus sûr : la clé de jointure. Le = du ON ne marche jamais avec NULL,
donc si client_id est NULL dans le résultat, c'est forcément une ligne sans partenaire.
