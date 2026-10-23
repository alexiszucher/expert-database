SELECT DISTINCT statut FROM commandes_null;

Ici, 5 status sont renvoyés, avec une ligne NULL comprise.

SELECT count(DISTINCT statut) FROM commandes_null;

Le count, ou d'autres agrégats, ne prennent pas en compte les NULL, on a donc 4 ici.

Un facon de faire pour avoir les NULL serait : SELECT count(*) FROM (SELECT DISTINCT statut FROM commandes_null) t;