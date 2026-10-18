# Programme « Expert SGBD & optimisation SQL »

**Format :** 15 min/jour pendant 6 mois (26 semaines)
**SGBD :** PostgreSQL
**Niveau de départ :** basique à intermédiaire
**Objectif :** devenir capable de diagnostiquer, optimiser et concevoir des bases de données performantes, de la requête lente à l'architecture de production.

---

## 1. Le rituel quotidien (15 min)

| Durée | Activité |
|---|---|
| 3 min | **Rappel** : 1 à 2 questions sur la veille |
| 4 min | **Concept** : un seul par jour |
| 7 min | **Pratique** sur ta base (jamais de théorie sans requête) |
| 1 min | **Carnet** : une phrase « ce que j'ai compris » |

**Rythme hebdomadaire**

- **Lundi à vendredi :** contenu du jour
- **Samedi :** quiz de révision + mini-défi
- **Dimanche :** repos

**Comment on travaille ensemble :** écris « Jour 1 », « Jour 2 », etc. Je te donne la session du jour. Tu m'envoies ta requête ou ton `EXPLAIN ANALYZE`, je te corrige et te pousse d'un cran.

---

## 2. Ton terrain d'entraînement

Sans volume de données, tu ne verras jamais l'effet d'un index ou d'un plan d'exécution.

- Installe PostgreSQL (Docker ou installation locale).
- Génère **5 à 10 millions de lignes** avec `generate_series()`, ou charge un jeu de données comme *Pagila*.
- Outils conseillés : `psql`, DBeaver ou pgAdmin, et le visualiseur de plans **explain.dalibo.com**.

Exemple pour démarrer une grosse table :

```sql
CREATE TABLE commandes AS
SELECT
  g AS id,
  (random() * 100000)::int AS client_id,
  now() - (random() * interval '730 days') AS date_commande,
  (random() * 500)::numeric(10,2) AS montant,
  (ARRAY['nouvelle','payee','expediee','annulee'])[1 + (random()*3)::int] AS statut
FROM generate_series(1, 5000000) g;

ANALYZE commandes;
```

---

## 3. Vue d'ensemble des 5 phases

| Phase | Semaines | Thème | Objectif final |
|---|---|---|---|
| 1 | 1-4 | Fondations solides | Écrire n'importe quelle requête analytique sans hésiter |
| 2 | 5-8 | Index et plans d'exécution | Lire un plan comme un texte et repérer le coupable en 30 s |
| 3 | 9-14 | Optimisation de requêtes | Passer une requête de 30 s à quelques ms, en expliquant pourquoi |
| 4 | 15-20 | Les entrailles du moteur | Comprendre pourquoi ça ralentit, pas seulement comment corriger |
| 5 | 21-26 | Architecture et production | Raisonner comme un DBA/architecte face à un incident ou une montée en charge |

---

## 4. Plan détaillé semaine par semaine

### Phase 1 : Fondations solides (semaines 1-4)

| Semaine | Contenu |
|---|---|
| **S1** | Mise en place de la base, `SELECT` avancé, filtres, tri, `DISTINCT`, **logique du `NULL`** (logique à 3 valeurs) |
| **S2** | Jointures (`INNER`, `LEFT`, `FULL`, `CROSS`, auto-jointure), pièges (doublons, `NULL`), `EXISTS` vs `IN` |
| **S3** | `GROUP BY`, `HAVING`, agrégats, sous-requêtes, **CTE**, `LATERAL` |
| **S4** | **Fonctions de fenêtrage** (`ROW_NUMBER`, `RANK`, `LAG`, `SUM() OVER`), normalisation et formes normales, contraintes et types |

### Phase 2 : Index et plans d'exécution (semaines 5-8)

| Semaine | Contenu |
|---|---|
| **S5** | Structure du **B-tree**, premier index, premier `EXPLAIN` |
| **S6** | **`EXPLAIN (ANALYZE, BUFFERS)`** : Seq Scan, Index Scan, Index Only Scan, Bitmap Scan, quand le Seq Scan gagne |
| **S7** | Index composites (ordre des colonnes), couvrants (`INCLUDE`), partiels, sur expressions, sélectivité |
| **S8** | Algorithmes de jointure (Nested Loop, Hash Join, Merge Join), **statistiques** (`ANALYZE`, `pg_stats`) |

### Phase 3 : Optimisation de requêtes (semaines 9-14)

| Semaine | Contenu |
|---|---|
| **S9** | Prédicats **sargables** : fonctions sur colonnes, conversions implicites, `LIKE`, plages de dates |
| **S10** | Réécriture de requêtes : `EXISTS` vs `IN`, `UNION ALL`, CTE matérialisée ou non, `DISTINCT` inutile |
| **S11** | Pagination efficace (**keyset vs `OFFSET`**), Top-N, tris coûteux |
| **S12** | Problème **N+1**, traitements par lots, `INSERT` multiples, `COPY`, `UPSERT` |
| **S13** | Erreurs d'estimation de cardinalité, statistiques étendues, **vues matérialisées** |
| **S14** | **Partitionnement**, `pg_stat_statements`, `auto_explain`, mini-projet d'optimisation complet |

### Phase 4 : Les entrailles du moteur (semaines 15-20)

| Semaine | Contenu |
|---|---|
| **S15** | Pages et stockage physique, TOAST, `shared_buffers`, cache du système |
| **S16** | **MVCC** : versions de lignes, `xmin` / `xmax`, visibilité |
| **S17** | **`VACUUM`**, autovacuum, bloat, HOT updates, `fillfactor` |
| **S18** | Transactions, **niveaux d'isolation**, anomalies (lecture sale, non répétable, fantôme) |
| **S19** | Verrous, **deadlocks**, `pg_locks`, diagnostic des blocages |
| **S20** | **WAL**, checkpoints, paramètres clés (`work_mem`, `maintenance_work_mem`, `effective_cache_size`) |

### Phase 5 : Architecture et production (semaines 21-26)

| Semaine | Contenu |
|---|---|
| **S21** | Modélisation avancée : JSONB, types riches, schémas, multi-tenant |
| **S22** | **Réplication** (streaming et logique), lag, réplicas en lecture |
| **S23** | Sauvegardes (`pg_dump`, `pg_basebackup`), **PITR**, plan de reprise |
| **S24** | **Pooling de connexions** (PgBouncer), monitoring (`pg_stat_*`), alerting |
| **S25** | Montée en charge : sharding, OLTP vs OLAP, quand choisir cache, NoSQL ou entrepôt de données |
| **S26** | **Projet final** : simulation d'incident de production + bilan et feuille de route |

---

## 5. Exemple de session (semaine 5, jour 1)

- **Rappel :** quand un `Seq Scan` est-il plus rapide qu'un index ?
- **Concept :** un index B-tree est un arbre trié qui évite de lire toute la table.
- **Pratique :** sur la table de 5 M de lignes, lance un `SELECT` filtré, note le temps, crée l'index, relance et compare les deux plans.
- **Carnet :** « L'index a divisé le temps par ___ parce que ___ ».

```sql
-- Avant
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM commandes WHERE client_id = 4242;

-- Création de l'index
CREATE INDEX idx_commandes_client ON commandes (client_id);

-- Après
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM commandes WHERE client_id = 4242;
```

---

## 6. Ressources

**Gratuit / en ligne**

- *Use The Index, Luke* : use-the-index-luke.com (la référence sur les index)
- **explain.dalibo.com** : visualiseur de plans d'exécution
- **pgexercises.com** : exercices SQL
- Documentation officielle PostgreSQL : postgresql.org/docs

**Livres**

- *SQL Performance Explained*, Markus Winand (phases 2-3)
- *Designing Data-Intensive Applications*, Martin Kleppmann (phases 4-5)
- *Database Internals*, Alex Petrov (pour aller plus loin)

---

## 7. Suivi de progression

À cocher à la fin de chaque phase.

- [ ] **Phase 1** : je sais écrire jointures, CTE et window functions sans aide
- [ ] **Phase 2** : je lis un `EXPLAIN ANALYZE` et j'identifie le nœud coûteux
- [ ] **Phase 3** : j'ai optimisé une requête d'un facteur 100 ou plus et je sais l'expliquer
- [ ] **Phase 4** : je sais expliquer MVCC, bloat et verrous à un collègue
- [ ] **Phase 5** : je sais proposer une architecture et un plan de reprise après sinistre

---

## 8. Règles d'or

1. **Mesure toujours avant d'optimiser** (`EXPLAIN ANALYZE`, pas d'intuition).
2. **Un seul changement à la fois**, sinon tu ne sais pas ce qui a marché.
3. **Teste avec un volume réaliste** de données.
4. **Écris dans ton carnet** : ce que tu expliques par écrit, tu le retiens.
5. **La régularité bat l'intensité** : 15 min chaque jour valent mieux que 2 h le dimanche.
