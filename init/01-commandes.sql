-- Exécuté une seule fois, à la création du volume.
-- Pour repartir de zéro : docker compose down -v && docker compose up -d

CREATE TABLE commandes AS
SELECT
  g AS id,
  (random() * 100000)::int AS client_id,
  now() - (random() * interval '730 days') AS date_commande,
  (random() * 500)::numeric(10,2) AS montant,
  (ARRAY['nouvelle','payee','expediee','annulee'])[1 + floor(random()*4)::int] AS statut
FROM generate_series(1, 5000000) g;

ANALYZE commandes;
