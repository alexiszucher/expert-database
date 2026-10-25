Gather Merge          actual time=109..138  rows=180549 loops=1
  Sort               actual time=103..107  rows=60183  loops=3
    Parallel Seq Scan actual time=0.2..82  rows=60183  loops=3
                     Rows Removed by Filter: 1606484

Avec Workers Launched: 2, il y a 3 processus (le principal + 2 workers) : loops=3.
Les chiffres d'un noeud parallèle sont des moyennes par processus.

Les lignes : on multiplie par loops.
- gardées : 60183 x 3 = 180549 (c'est bien le rows du Gather Merge)
- jetées  : 1606484 x 3 = 4819452
- lues    : 180549 + 4819452 = 5000001, toute la table
On lit toute la table pour en garder 3,6 %.

Le temps : on ne multiplie PAS. Les 3 processus travaillent en même temps,
le Seq Scan prend environ 82 ms d'horloge, pas 246 ms.
(Dans un Nested Loop, les boucles passent l'une après l'autre : là on multiplie.)

Aussi : rows=66094 dans cost=... est l'estimation par processus, pas un résultat.

Temps propres (B moins le B de l'enfant) :
- Parallel Seq Scan : 82 ms   <- le plus coûteux
- Sort              : 107 - 82 = 25 ms
- Gather Merge      : 138 - 107 = 31 ms
- Unique            : 148 - 138 = 10 ms
- Subquery Scan     : 167 - 148 = 19 ms
- Sort top-N        : 176 - 167 = 9 ms
Total : 176 ms
