Sort       actual time=2838..3117
  Seq Scan actual time=25..318

Temps propre du Sort = son B moins le B de son enfant : 3117 - 318 = environ 2,8 s.

Le A du Sort est très grand (2838 ms) car il est bloquant :
il doit recevoir les 5 M de lignes et tout trier avant de renvoyer la première.
La plus petite valeur peut être la toute dernière lue.

Conséquence : un LIMIT 10 au-dessus d'un Sort ne fait presque rien gagner.
PostgreSQL fait un "top-N heapsort" (il ne garde en mémoire que les 10 meilleures lignes),
mais il lit quand même toute la table.

La vraie solution : un index qui donne les lignes déjà triées.
Plus de noeud Sort, et un A proche de 0 (semaine 7, puis Top-N en semaine 11).
