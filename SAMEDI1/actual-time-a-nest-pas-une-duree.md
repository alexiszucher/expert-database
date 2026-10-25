Sort       actual time=2838..3117
  Seq Scan actual time=25..318

A (2838) n'est pas une durée, c'est un moment : "la 1re ligne sort à 2838 ms depuis le début".
Le temps propre du Sort se calcule avec les B : 3117 - 318 = 2799 ms.
2838 et 2799 se ressemblent ici par hasard, il ne faut pas les confondre.

On peut découper le travail du Sort :
- de 0 à 318 ms : il reçoit les lignes du Seq Scan
- de 318 à 2838 ms : il trie, rien ne sort (environ 2,5 s de tri pur)
- de 2838 à 3117 ms : il renvoie les lignes triées (environ 280 ms)

Le A d'un noeud bloquant est toujours plus grand que le B de son enfant :
il ne peut rien renvoyer tant que son enfant n'a pas tout donné.
