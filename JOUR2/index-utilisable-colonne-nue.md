WHERE montant > 500 / 1.2      -- colonne nue : "montant" est seul à gauche

WHERE montant * 1.2 > 500      -- colonne habillée : "montant" est pris dans un calcul

La colonne nue est très importante pour l'utilisation de l'index.
Si le champ est calculé, l'index ne peut plus être lue car la base
ne peut pas parcour l'arbre de recherche.