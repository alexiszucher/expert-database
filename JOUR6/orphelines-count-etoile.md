SELECT co.client_id, count(*)
FROM commandes_null co
LEFT JOIN clients c ON co.client_id = c.id
WHERE c.id IS NULL
GROUP BY co.client_id;
-- client_id 0 : 23 (toutes les orphelines)

Pourquoi 0 : random() * 100000 donne [0, 100000[, et ::int arrondit (Jour 1).
Seul [0 ; 0,5[ tombe sur 0 : deux fois moins de chances qu'un autre client.
Attendu : 5 000 000 x 0,5 / 100 000 = 25. Trouvé : 23.
Pareil pour 100000 ([99999,5 ; 100000[) : 23 commandes aussi, mais ce client existe.

Le GROUP BY prouve que les 23 sont toutes à 0.
Un ORDER BY sur 5 M de lignes lu à l'œil ne prouve rien (et envoie 5 M de lignes).

Pour compter des orphelines : count(*), pas count(co.client_id).
Une commande avec client_id NULL est orpheline (le = du ON ne trouve rien),
mais count(co.client_id) ne la compterait pas (les agrégats ignorent NULL, Jour 4).
Ici 0 client_id NULL, donc même chiffre : le bug ne se voit pas.
