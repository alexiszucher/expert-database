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
  (ARRAY['nouvelle','payee','expediee','annulee'])[1 + floor(random()*4)::int] AS statut
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

## 8. Journal de bord

Un dossier par jour (`JOUR1/`, `JOUR2/`, …) avec la phrase du carnet.

### Semaine 1

- [x] **Jour 1** : mise en place (Docker + 5 M de lignes), ordre logique d'exécution d'un `SELECT`
- [x] **Jour 2** : logique du `NULL` (logique à 3 valeurs), `IS DISTINCT FROM`
- [x] **Jour 3** : tri (`ORDER BY`), place des `NULL` (`NULLS FIRST` / `NULLS LAST`)
- [x] **Jour 4** : `DISTINCT`, `count(DISTINCT)`, `DISTINCT ON`, premier tri lu dans un `EXPLAIN ANALYZE` (`work_mem`)
- [ ] **Jour 5**
- [ ] **Samedi** : quiz + mini-défi

---

## 9. Notions avancées (au fil des jours)

Pièges et nuances rencontrés en pratique. Chaque entrée indique le jour où elle est apparue.

### Jour 1 : ordre d'exécution d'un `SELECT`

```
FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
```

- **Un alias du `SELECT` n'existe pas dans `WHERE`**, mais existe dans `ORDER BY`. Solutions : répéter l'expression, sous-requête / CTE, ou `LATERAL`.
- **`WHERE` filtre des lignes, `HAVING` des groupes.** Filtrer dans `WHERE` plutôt que dans `HAVING` évite de grouper des lignes inutiles.
- **Ordre logique, pas physique** : l'optimiseur peut réorganiser le travail tant que le résultat est identique à celui de l'ordre logique.
- **Extension PostgreSQL** : `GROUP BY` accepte un alias du `SELECT`, ce qui n'est pas du SQL standard.
- **Un plan `EXPLAIN` se lit de bas en haut** (la ligne la plus indentée s'exécute en premier).
- **Prédicat sargable (aperçu de la S9)** : `WHERE montant > 500 / 1.2` laisse la colonne « nue » et permet un index, contrairement à `WHERE montant * 1.2 > 500`.
- **`::int` arrondit, il ne tronque pas** (`0.5::int` donne 1). Pour tirer un entier uniforme entre 0 et N-1 : `floor(random() * N)::int`. Avec `(random() * N)::int`, les valeurs extrêmes sortent deux fois moins souvent.
- **Un jeu de test biaisé donne des conclusions biaisées** : vérifier la répartition des données générées (`GROUP BY` + `count(*)`) avant de mesurer quoi que ce soit.

### Jour 2 : logique du `NULL`

- **Logique à 3 valeurs** : une comparaison avec `NULL` donne `UNKNOWN`, et `WHERE` ne garde que `TRUE`. `statut <> 'payee'` (ou `!=`) exclut donc silencieusement les lignes où `statut` est `NULL`.
- **`IS DISTINCT FROM`** traite `NULL` comme une valeur comparable : `statut IS DISTINCT FROM 'payee'` inclut les `NULL`.
- **Contrôle de cohérence** : `count(= 'payee') + count(IS DISTINCT FROM 'payee')` doit redonner le total de la table. Avec `<>`, il manque les `NULL`.
- **On cherche un `NULL` avec `IS NULL`**, jamais `= NULL` (toujours `UNKNOWN`, donc zéro ligne).

### Jour 3 : tri et place des `NULL`

- **Pour PostgreSQL, `NULL` est plus grand que toute valeur** : `ORDER BY x` (ASC) les met à la fin, `ORDER BY x DESC` les met en premier.
- **Piège du Top-N** : `ORDER BY montant DESC LIMIT 3` renvoie des `NULL` au lieu des plus grosses commandes. Corriger avec `NULLS LAST` ou en filtrant `WHERE montant IS NOT NULL`.
- **Aperçu de la S7** : un index ne sert un tri que si son ordre correspond, y compris la place des `NULL` (index `(montant DESC NULLS LAST)` pour ce Top-N).

### Jour 4 : `DISTINCT`, `DISTINCT ON` et premier tri mesuré

- **Rappel du Jour 3 inversé** : `ORDER BY montant` (ASC) met déjà les `NULL` en dernier, `NULLS LAST` n'y change rien. Le défaut dépend du moteur : PostgreSQL et Oracle mettent les `NULL` en dernier en ASC, MySQL et SQL Server en premier. Écrire `NULLS FIRST` / `NULLS LAST` explicitement dès que ça compte.
- **`SELECT DISTINCT` porte sur la ligne entière** : `DISTINCT client_id, date_commande, montant` ne donne pas une ligne par client, mais une ligne par trio (soit presque les 5 M de lignes).
- **`DISTINCT(client_id)` n'est pas une fonction** : les parenthèses entourent juste une expression, la requête est identique à la précédente. Il manque le mot-clé `ON`.
- **`DISTINCT` garde les `NULL` en une seule ligne, `count(DISTINCT x)` les ignore** (5 lignes contre un compte de 4 sur `statut`).
- **Tous les agrégats ignorent les `NULL`, sauf `count(*)`** : `avg(montant)` est la moyenne des seuls montants renseignés. Si `NULL` veut dire 0, écrire `avg(coalesce(montant, 0))`.
- **Compter les distincts en incluant le `NULL`** : `count(DISTINCT coalesce(statut, 'inconnu'))` marche, mais se trompe en silence si `'inconnu'` existe déjà dans les données. Plus sûr : `SELECT count(*) FROM (SELECT DISTINCT statut ...) t`.
- **`IS DISTINCT FROM` n'utilise pas d'index B-tree** : sur une grosse table, préférer `statut <> 'x' OR statut IS NULL`. Son contraire, `IS NOT DISTINCT FROM`, est un `=` qui accepte les `NULL` (utile en jointure, S2).
- **`DISTINCT ON (col)` garde la première ligne de chaque groupe selon le `ORDER BY`**, qui doit commencer par `col`. Penser au `NULLS LAST` sur la colonne qui choisit la ligne, et ajouter une colonne de départage (`id DESC`) pour un résultat stable.
- **`SELECT DISTINCT statut ... ORDER BY montant` est une erreur** : après le `DISTINCT`, une ligne regroupe 1,25 M de montants, impossible de choisir lequel trier. Passer par `GROUP BY statut` + `max(montant)`.
- **`DISTINCT ON` trie toute la table** pour n'en garder que quelques lignes. Un `GROUP BY` + agrégat peut s'en passer (`HashAggregate`).
- **Lire `actual time=A..B`** : A = première ligne renvoyée, B = dernière, en ms depuis le début. Les temps sont cumulés avec les enfants : temps propre d'un nœud = son B moins le B de son enfant. Un `Sort` est bloquant (A élevé). Si `loops > 1`, le temps est une moyenne par boucle.
- **`rows` dans `cost=...` est une estimation, `rows` dans `actual` est le réel** (98 929 estimés contre 100 001 clients réels).
- **`Sort Method: external merge`** : le tri dépasse `work_mem` (4 Mo par défaut) et passe par des fichiers temporaires. En mémoire, le même tri prend environ 2,3 fois sa taille sur disque (429 Mo contre 184 Mo). Avec `work_mem = 1GB`, le quicksort ne gagnait que 200 ms sur 3,3 s : les fichiers temporaires restaient dans le cache du système. `external merge` est un signal, pas une preuve. La vraie solution est un index qui fournit les lignes déjà triées (S7), pas de la RAM (`work_mem` s'applique par tri et par connexion, S20).
- **`SET` ne vaut que pour la session** : un `SET work_mem` lancé dans une autre connexion que la requête n'a aucun effet. Vérifier avec `SHOW work_mem`.

---

## 10. Règles d'or

1. **Mesure toujours avant d'optimiser** (`EXPLAIN ANALYZE`, pas d'intuition).
2. **Un seul changement à la fois**, sinon tu ne sais pas ce qui a marché.
3. **Teste avec un volume réaliste** de données.
4. **Écris dans ton carnet** : ce que tu expliques par écrit, tu le retiens.
5. **La régularité bat l'intensité** : 15 min chaque jour valent mieux que 2 h le dimanche.
