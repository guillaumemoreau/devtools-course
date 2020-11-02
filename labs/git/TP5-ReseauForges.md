# TP5 : Réseau et forges

## Introduction

Pour ce dernier TP sur le réseau et les forges sociales, je vous propose de
refaire le monde en vous livrant à un petit exercice d'édition collaborative
autour de la Déclaration des Droits de l'Homme et du Citoyen de 1789.

Pourquoi ce texte, me direz-vous ? Parce que c'est un texte court, très connu,
dont le copyright a expiré depuis longtemps, et dont la nature politique se
prête naturellement à des polémiques bon enfant. En un mot, un candidat idéal
pour explorer les subtilités de la gestion de version collaborative.


## Préparations au travail en réseau

### Configuration de GitHub

Nous allons utiliser la plate-forme GitHub ( https://github.com ). Si vous avez
bien suivi vos mails, vous devriez avoir déjà créé un compte dessus. Si ce n'est
pas le cas, vous pouvez le faire via le lien "Sign Up" en haut à droite de
l'interface.

Pour pouvoir communiquer via SSH, vous auriez aussi besoin de transmettre votre
clé publique à GitHub, afin de permettre au service de vous authentifier. Mais
durant cette formation, nous utiliserons exclusivement le protocole HTTPS, qui
vous authentifie en vous demandant votre mot de passe GitHub. Aucune
configuration supplémentaire ne sera donc nécessaire.

### Fork et clonage

Une copie de la Déclaration des Droits de l'Homme est disponible sur
https://github.com/guillaumemoreau/ddhc .

Pour commencez, créez-en un _fork_ sous votre contrôle, en utilisant le bouton
"Fork" situé en haut à droite de l'interface de GitHub.

Lorsque c'est fait, vous devriez être redirigé automatiquement sur votre fork.
Pour travailler dessus localement, vous allez ensuite devoir copier son contenu
sur votre machine. Pour cela, vous avez besoin de son URL HTTPS, que vous pouvez
obtenir de l'interface GitHub de la façon suivante :

- En cliquant sur le bouton vert "Clone or download".
- En cliquant sur l'option "Use HTTPS" si elle s'affiche.
- L'interface devrait maintenant afficher une URL commençant par "http://".

Une fois l'URL obtenue, créez un clone local du _fork_ de la façon suivante :

    $ cd Bureau/
    $ git clone <url de votre dépôt>

### Connexion au dépôt officiel

Comme notre clone local dans le TP précédent, le clone du _fork_ possède une
_remote_ pointant vers le dépôt distant qui permet d'échanger facilement des
commits avec ce dernier :

    $ cd ddhc/
    $ git status
    $ git remote -v

Mais pour appliquer la méthode de travail basée sur les _forks_ et les _pull
requests_ (appelée _GitHub flow_), il faut aussi être capable d'échanger des
commits avec le dépôt officiel, celui à partir duquel vous avez créé votre fork.
En effet, des nouveautés vont arriver sur ce dernier au fur et à mesure du TP,
et vous devrez vous synchroniser avec ces dernières.

Par convention, le dépôt officiel est généralement appelé _upstream_ :

    $ git remote add upstream https://github.com/guillaumemoreau/ddhc.git
    $ git fetch upstream

Si vous ouvrez maintenant `gitg`, vous pourrez constater que vous pouvez
maintenat visualiser vos commits et branches locales, celles de votre _fork_, et
celles du dépôt officiel. Tout est prêt !


## Travail distribué avec le GitHub flow

### Introduction

Le _GitHub flow_ est une méthode de travail qui, malgré son nom, n'a rien de
spécifique à la forge GitHub. Toutes les forges sociales modernes peuvent être
utilisées de cette manière. Dans cette méthode, le travail s'organise autour de
quatre grandes étapes :

1. Rester à jour par rapport au dépôt officiel
2. Préparer des changements dans une branche dédiée de son dépôt local
3. Publier ses changements sur son _fork_ lorsqu'ils sont prêts
4. Les soumettre au dépôt officiel pour qu'ils y soient intégrés

Examinons ces quatre étapes en détail

### Se synchroniser avec le dépôt officiel

Comme nous l'avons vu dans le TP précédent, il est possible de récupérer les
changements du dépôt officiel avec `git fetch` :

    $ git fetch upstream

Cependant, dans le cadre de cette méthode de travail, nous n'avons généralement
pas besoin de nous intéresser à l'ensemble des branches de ce dépôt. Il suffit
de tenir notre branche `master` à jour, ce que l'on peut faire avec `git pull`
après avoir configuré `upstream/master` comme branche amont :

    $ git checkout master
    $ git branch --set-upstream-to=upstream/master

Par la suite, vous pourrez mettre à jour votre master via :

    $ git checkout master
    $ git pull --ff-only

Je conseille ici l'utilisation de `--ff-only` pour vous aider à repérer une
erreur classique. Si l'on applique correctement le _GitHub flow_, la branche
`master` du dépôt officiel devrait avancer de façon monotone, et votre branche
`master` locale devrait suivre son avancée. Par conséquent, si vous ne pouvez
pas mettre en avance rapide, cela relève d'un comportement pathologique :

- Soit les mainteneurs du dépôt officiel ont fait diverger `master`. C'est
  parfois nécessaire, mais très rare, et un mainteneur responsable vous
  informera lorsqu'il doit en venir à de tels extrêmes.
- Soit, cas de loin le plus courant, vous avez vous-même créé une divergence,
  typiquement en ajoutant des commits sur votre `master` local.

Dans ce dernier cas, pour vous tirer d'affaire, vous pouvez...

- Si vous le souhaitez, sauvegarder vos changements dans une nouvelle branche
  avec `git branch <nom>`
- Forcer votre branche `master` à revenir au même point que le `master` officiel
  avec la commande `git reset --hard upstream/master`

### Construire des changements dans une branche dédiée

Une fois que l'on a un `master` à jour, il est possible de construire des
changements par-dessus ce dernier. Il suffit pour cela de créer une branche qui
part de master et de commencer à créer des _commits_ dessus :

    $ git checkout master
    $ git checkout -b changements
    $ echo -e "\nCeci n'est pas un pied de page" >> README.md
    $ git add README.md
    $ git commit -m "Ajout d'un pied de page rebelle"

Mais pendant que vous effectuez vos modifications, le dépôt officiel continue
d'évoluer, et il est possible que des nouveautés arrivent sur la branche
`master`. Les sorties des commandes `git fetch` et `git pull` vous en
informeront.

Si c'est le cas, vous pourrez intégrer ces nouveautés à votre branche de
développement avec les outils que nous avons vus précédemment. Un cycle complet
de mise à jour de `master` et d'intégrations de ses nouveautés à votre branche
pourrait ainsi ressembler à ceci :

    $ git checkout master
    $ git pull --ff-only
    $ git checkout changements
    $ git merge master

En cas de conflit de fusion, il vous appartiendra de vous adapter aux nouveautés
de la branche `master` officielle qui sont incompatibles avec vos changements.

En règle général, plus une de vos branches a une durée de vie longue, plus il y
a de chances que cela se produise. De plus, si vous utilisez `git rebase` plutôt
que `git merge`, comme la politique de certains projets l'exige, il peut
aussi arriver que vous rencontriez de conflits de fusion en cascade, où vous
devrez faire face à des conflits non pas une seule fois, mais une fois par
commit de votre branche !

Pour éviter cela et simplifier le passage en revue de vos changements par les
mainteneurs, il est recommandé de privilégier des branches de durée de vie
courte, aux objectifs précis et modestes, que l'on soumettra au dépôt officiel
dès que possible. Nous allons maintenant étudier ce processus de soumission.

### Mettre en ligne des changements sur son fork

Lorsque vous êtes satisfait de votre branche locale, vous pouvez la mettre en
ligne sur votre _fork_ avec la commande `git push`.

L'option `--set-upstream`, que nous avons évoquée précédemment, vous permettra
de mémoriser l'association entre votre branche locale et la branche présente sur
votre _fork_, et ainsi de pousser avec un simple `git push` par la suite.

    $ git push --set-upstream origin changements

Nous l'avons évoqué précédemment, dès lors que vous avez mis des changements en
ligne sur un serveur, il faut être prudent avec les modifications d'historique
et les `git push -f` associés pour ne pas "couper l'herbe sous le pied" aux gens
qui travaillent par-dessus vos branches.

Mais l'un des avantages qu'il y a à utiliser un _fork_, c'est que ce dépôt
n'appartient qu'à vous. Personne d'autre n'est donc censé baser son travail
dessus, et c'est pourquoi la plupart des projets tolèrent l'utilisation libérale
du _force-push_ sur les _forks_, un confort très appréciable pour les amateurs
d'édition d'historique.

Gardez cependant à l'esprit que cette règle de vie est à double tranchant. Si
vous devez un jour baser votre travail sur le _fork_ de quelqu'un d'autre, il
vous appartiendra de vivre avec les suppressions de branches et autres
modifications d'historique effectuées par cette personne sur son _fork_. Evitez
donc si possible de baser du travail sur le _fork_ d'autrui.

### Soumission au dépôt officiel

Une fois que vous avez mis des changements en ligne sous la forme d'une branche
sur votre _fork_, vous pouvez demander l'intégration de ces changements au dépôt
officiel avec une fonctionnalité des forges git modernes, la _pull request_.
Cette fonctionnalité est également appelée _merge request_ par GitLab, mais le
terme _pull request_ étant plus répandu, et la forge GitHub que nous utilisons
dans ce TP l'employant, c'est celui que nous utiliserons par la suite.

Cette possibilité vous sera généralement directement offerte par l'affichage
d'une URL dans la console lorsque vous poussez la branche sur votre _fork_. Mais
vous avez manqué ce raccourci, vous pouvez créer "manuellement" une
_pull request_ en allant dans l'interface web de votre _fork_, affichant la
liste des branches, et cliquant sur le bouton _"New pull request"_.

Comme son nom l'indique, une _pull request_ invite le(s) mainteneur(s) du dépôt
officiel à intégrer des changements au projet en fusionnant les nouveautés de
votre branche dans un historique officiel (généralement la branche `master`).
Vous êtes invité à donner un titre court à votre branche, ainsi qu'une
description qui peut être plus étoffée et aggrémentée de mise en page Markdown.
Selon la forge que vous utilisez, d'autres fonctionnalités de gestion de projet
peuvent vous être proposées lors de la création d'une _pull request_, nous vous
invitons à consulter la documentation de votre forge pour en savoir plus.

Pour les mainteneurs, une _pull request_ se présente sous la forme du titre et
de la description que vous avez donnés, d'une visualisation des changements
proposés, et d'une interface permettant de discuter desdits changements (pour
proposer des modifications avant intégration par exemple).

Il est aussi possible pour le mainteneur de définir une batterie de tests
automatisés que toute _pull request_ doit passer avant d'être acceptée par le
projet. On parle alors d'intégration continue.

Si des changements sont demandés par le mainteneur, vous pouvez ajouter ceux-ci
à votre branche locale via de nouveaux commits et de les pousser sur votre
_fork_ avec un simple `git push`. La _pull request_ associée sera alors mise à
jour automatiquement.


## A vous de jouer !

A ce stade, vous en savez assez pour commencer à vous amuser avec cette pauvre
Déclaration des Droits de l'Homme.

Peut-être avez vous toujours rêvé de paraphraser Olympe de Gouges en réécrivant
entièrement le texte au féminin ("Déclaration des Droits de la Femme et de la
Citoyenne") ? Peut-être souhaitez-vous y ajouter l'article manquant qui résoudra
enfin le débat séculaire entre pain au chocolat et chocolatine ? Ou bien
peut-être est-il temps d'amender l'article 15 qui autorise chaque citoyen à
demander des comptes aux agents publics ?

Modifiez le texte comme vous le souhaitez, en n'hésitant pas à créer des commits
en cours de route pour vous permettre de revenir facilement en arrière. Puis,
quand vous aurez fini, poussez votre branche finale sur votre _fork_, et
soumettez une _pull request_ au dépôt officiel pour terminer ce TP.


## Conclusion

Dans ce dernier TP, nous avons vu comment utiliser git en réseau, avec une
méthode de travail basée sur les _forks_ et les _pull requests_.

Si ce n'est pas la seule manière d'utiliser git, cette méthode est une des plus
populaires aujourd'hui, car elle sécurise le dépôt officiel, facilite les
contributions extérieures, et évite certains problèmes liés à l'utilisation
naïve d'un dépôt git partagé (par exemple un "_force-push_" malencontrueux sur
une branche du dépôt principal qui sème le chaos dans le projet).

Nous terminerons cette formation par une exploration "à la carte" de sujets
plus avancés, ou de tout point déjà abordé que vous souhaiteriez approfondir.


----

## Exercices

1. Partez de votre clone du dépôt `ddhc`.
2. Vérifiez que les URLs de vos deux `remotes` sont correctes : `origin` doit
   pointer sur votre fork, `upstream` doit pointer sur le dépôt officiel, et les
   deux `remotes` doivent utiliser une connexion HTTPS.
3. Créez une nouvelle branche, et ajoutez-y un commit.
4. Poussez cette branche sur votre _fork_.
5. Ajoutez deux nouveaux commits à la branche, puis poussez-les sur votre _fork_
   aussi.
6. Mettez à jour votre dépôt vis à vis des éventuelles nouveautés du dépôt
   officiel du projet.
7. Détruisez la version locale de votre nouvelle branche avec `git branch -D`,
   puis régénérez-la à partir de la version sauvegardée sur votre dépôt.


## Antisèche

Ce TP n'est qu'une mise en pratique des enseignements du TP4, et n'introduit
aucune nouvelle commande git. Par conséquent, nous vous invitons à vous référer
aux TPs précédents pour retrouver les commandes utilisées.


---

## Informations complémentaires

### Authentification SSH

Arrivé à la fin de ce TP, vous en avez probablement d'ores et déjà assez de taper
votre mot de passe GitHub sans arrêt. Inutile, donc, de dire que vous ne vous
imagineriez pas le faire tous les jours. Heureusement, des solutions existent.

Une méthode à la fois élégante et sécurisée pour vous authentifier sans mot de
passe sur un dépôt git est d'utiliser le protocole à clé publique de SSH. L'idée
est de générer une paire clé privée / clé publique comme vous le feriez pour
vous authentifier sur un serveur Unix distant en SSH, puis de configurer la clé
publique associée dans votre forge logicielle.

Une fois ceci fait, git se chargera ensuite d'envoyer à votre forge des
commandes signées numériquement avec votre clé privée, et la forge pourra
utiliser votre clé publique pour s'assurer que ces commandes viennent bien de
vous et non d'un imposteur qui essaie de se faire passer pour vous.

Pour se passer totalement de mot de passe, votre clé privée doit être stockée de
façon non chiffrée (pas de "passphrase"). Un tel stockage offre une sécurité
suffisante à condition que votre ordinateur remplisse les prérequis suivants :

* Votre dossier personnel ("home") est situé sur un stockage chiffré, et à
  l'abri du regard des autres utilisateurs si l'ordinateur est partagé.
* Vous n'exécutez que des logiciels de confiance, non susceptibles d'espionner
  votre clé privée et de la transmettre à des tiers malveillants.

La procédure de configuration exacte dépend de la forge logicielle utilisée,
mais les étapes suivantes sont généralement nécessaires:

1. Vérifier que vous êtes autorisé à vous connecter à des serveurs SSH distants
   (certains administrateurs réseau configurent leurs pare-feux de façon si
   restrictive que c'est impossible, il faudra alors vous arranger avec eux).
2. Générer une paire de clés (privée et publique) avec `ssh-keygen`.
3. Saisir votre clé publique dans l'interface de configuration de la forge.
4. Configurer les _remotes_ git pour utiliser une URL SSH (celles-ci sont
   généralement de la forme `git@<serveur>:<utilisateur>/<dépôt>.git`).


### Petit tour d'horizon des forges logicielles

Dans ce TP, nous avons utilisé GitHub, mais il existe de nombreuses autres
forges logicielles basées sur git.

Les trois moteurs de forge les plus utilisés à l'heure actuelle sont GitHub,
GitLab et BitBucket. Les éditeurs de ces applications web proposent des
instances hébergées sur leurs propres serveurs, selon un modèle commercial
"freemium" (niveau de service gratuit limité, pour avoir plus il faut souscrire
à un abonnement). Il est également possible d'en héberger une instance sur un
serveur que l'on contrôle, par exemple lorsque le secret professionnel l'exige.

Dans ce cadre d'auto-hébergement, GitLab est le moteur le plus populaire dans le
secteur académique. On peut mentionner, par exemple, des instances ayant des
milliers d'utilisateurs au CERN et au centre de calcul de l'IN2P3 (CCIN2P3),
ainsi que de nombreuses déploiements plus modestes au sein de laboratoires
individuels. La popularité de GitLab tient sans doute au fait que c'est
l'éditeur de forge le plus ouvert à l'auto-hébergement.

Parmi les hébergeurs publics, GitHub domine. C'est donc souvent la meilleure
solution lorsque l'on souhaite collaborer avec des développeurs hors de son
cercle de sociabilité académique, ou lorsque l'on n'a pas accès à un hébergeur
"en propre". Notez toutefois que la légalité de l'utilisation de GitHub,
hébergeur américain, pour stocker des données de recherche européennes, est un
sujet de polémique récurrent vis à vis duquel un consensus clair se fait
toujours attendre.

Les moteurs de forge ci-dessus ont de nombreuses fonctionnalités en commun:

- Visualisation de l'historique et des différentes branches
- Parcours de l'arborescence des fichiers à la tête d'une branche donnée
- Visualisation de certains formats de fichier (ex: Markdown, code source)
- Possibilités limitées d'édition de fichiers en ligne
- Gestion de tickets (pour signaler des problèmes, recevoir des demandes...)
- Soumission et revue de changements (_pull requests_/_merge requests_)
- Documentation collaborative au format wiki
- Statistiques diverses et variées sur les contributions
- Outils de gestion de projet agile
- Systèmes de notification élaborées pour "suivre" l'évolution d'un projet

Cependant, chaque moteur a aussi ses spécificités:

- GitLab fournit en standard des fonctionnalités comme l'intégration continue
  ou l'hébergement d'images Docker, là où GitHub se veut plus minimaliste et
  délègue ce genre de fonction à des services tiers partie comme Travis CI
- BitBucket propose une intégration poussée avec d'autres applications web du
  même éditeur (JIRA, Bamboo, Confluence, HipChat...)
- Le vocabulaire utilisé et le détail des statistiques proposées varie d'une
  forge à l'autre, et il n'est pas trivial de migrer l'ensemble d'un projet
  (y compris les tickets, pull requests...) d'une forge à une autre.
