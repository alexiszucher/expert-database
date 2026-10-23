---
name: next
description: Passe au jour suivant du programme « Expert SGBD & optimisation SQL » - clôture le jour en cours dans le programme, puis donne la session du jour suivant (rappel, concept, pratique, carnet). À utiliser quand l'utilisateur tape /next ou dit « on passe au jour suivant ».
---

# /next : session du jour suivant

Le programme est dans `programme-expert-sgbd-postgresql.md` (racine du dépôt). Il fait foi : rythme, plan semaine par semaine, journal de bord, notions avancées.

## 1. Faire le point

1. Lis `programme-expert-sgbd-postgresql.md` en entier.
2. Liste les dossiers `JOUR*/` et lis leurs notes : ce sont les notes de l'utilisateur, écrites avec ses mots.
3. Regarde `git log --oneline -5` pour voir le dernier jour commité.
4. Détermine le **jour en cours** (le dernier travaillé, dans cette conversation ou d'après les dossiers `JOURn/`) et le **jour suivant**.

## 2. Clôturer le jour en cours

Si un jour a été travaillé mais n'est pas encore rangé dans le programme :

- **Journal de bord (section 8)** : coche le jour et ajoute un résumé court du thème, au même format que les jours déjà cochés. Coche aussi tout jour antérieur qui a un dossier `JOURn/` mais n'est pas coché.
- **Notions avancées (section 9)** : ajoute une sous-section `### Jour N : <thème>` avec les pièges et nuances réellement rencontrés pendant la session (erreurs de l'utilisateur, questions posées, précisions d'expert). Pas de remplissage, au même style que la sous-section Jour 1.
- **Notes `JOURn/`** : ne les écris pas à la place de l'utilisateur. S'il n'a pas encore donné sa phrase du carnet, demande-la-lui en une ligne avant de passer à la suite.
- Ne commite pas, sauf si l'utilisateur le demande.

## 3. Situer le jour suivant

- Semaine `S = ceil(N / 5)` pour le Jour N. Le contenu vient du plan de la section 4 pour cette semaine.
- Répartis les sujets de la semaine sur les 5 jours, **un seul concept par jour**, dans l'ordre du plan, en tenant compte de ce qui a déjà été vu (journal + notions avancées).
- Après le Jour 5 d'une semaine vient le **Samedi : quiz de révision + mini-défi** sur toute la semaine, puis le Jour suivant ouvre la semaine d'après.
- Si la semaine n'existe pas encore dans le journal de bord, ajoute sa section (`### Semaine S` avec Jours et Samedi non cochés), sur le modèle de la semaine 1.

## 4. Préparer la pratique sur la vraie base

Avant d'écrire les exercices, vérifie l'état réel de la base (conteneur `pg-expert`, base `expert`) :

```bash
docker exec pg-expert psql -U postgres -d expert -c "\dt" -c "<requête utile>"
```

Appuie les exercices sur les tables et les données qui existent vraiment (volumes, NULL, distributions, index présents). Si le conteneur ne tourne pas, dis-le et propose `docker compose up -d`.

## 5. Donner la session

En français, en tutoyant, au format habituel :

```
## Jour N : <thème>

### ⏱ Rappel (3 min)
1 à 2 questions sur la veille, à faire sans lancer de requête.

### 💡 Concept (4 min)
Un seul concept, court, avec un tableau ou un exemple si ça aide.

### 🛠 Pratique (7 min)
2 ou 3 exercices concrets sur la base, du plus simple au plus piégeux.
Requêtes dans des blocs ```sql.

### 📓 Carnet (1 min)
Une phrase à trous « ce que j'ai compris ».
```

Termine en demandant à l'utilisateur d'envoyer ses réponses au rappel puis ses requêtes.

## Pendant la session

- Corrige une réponse à la fois, pousse d'un cran (nuance d'expert, lien avec une semaine future du plan), puis relance sur l'exercice suivant.
- Ne donne pas la solution d'un exercice avant que l'utilisateur ait essayé. S'il décrit une requête sans l'avoir lancée, demande-lui de la lancer.
- Fais des liens avec les jours précédents quand un piège déjà vu réapparaît.
