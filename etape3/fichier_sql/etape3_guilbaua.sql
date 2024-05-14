/* A1 */

/*Nombre de survivants, respectivement de victimes parmi les passagers, selon leur classe (une requête par classe) */

SELECT (SELECT COUNT(*) AS "Nb_survivants_1Class" FROM PASSENGER WHERE Survived = 1 AND PClass = 1),
(SELECT COUNT(*) AS "Nb_victimes_1Class" FROM PASSENGER WHERE Survived = 0 AND PClass = 1);


SELECT (SELECT COUNT(*) AS "Nb_survivants_2Class" FROM PASSENGER WHERE Survived = 1 AND PClass = 2),
(SELECT COUNT(*) AS "Nb_victimes_2Class" FROM PASSENGER WHERE Survived = 0 AND PClass = 2);


SELECT (SELECT COUNT(*) AS "Nb_survivants_3Class" FROM PASSENGER WHERE Survived = 1 AND PClass = 3),
(SELECT COUNT(*) AS "Nb_victimes_3Class" FROM PASSENGER WHERE Survived = 0 AND PClass = 3);

/* Nombre de survivants, respectivement de victimes parmi les passagers, selon leur catégorie (enfant, femme et
homme – une requête par catégorie)*/

SELECT (SELECT COUNT(*) AS "Nb_survivants_enfants" FROM PASSENGER WHERE Survived = 1 AND Age < 12),
(SELECT COUNT(*) AS "Nb_victimes_enfants" FROM PASSENGER WHERE Survived = 0 AND Age < 12);

SELECT (SELECT COUNT(*) AS "Nb_survivants_femmes" FROM PASSENGER WHERE Survived = 1 AND Age >= 12 AND sex='female'),
(SELECT COUNT(*) AS "Nb_victimes_femmes" FROM PASSENGER WHERE Survived = 0 AND Age >= 12 AND sex='female');

SELECT (SELECT COUNT(*) AS "Nb_survivants_hommes" FROM PASSENGER WHERE Survived = 1 AND Age >= 12 AND sex='male'),
(SELECT COUNT(*) AS "Nb_victimes_hommes" FROM PASSENGER WHERE Survived = 0 AND Age >= 12 AND sex='male');

/* requête qui compare le nombre de survivants parmi les passagers au total des survivants enfants,
femmes et hommes résultant des requêtes précédentes */

SELECT (SELECT COUNT(*) AS "Nb_survivants" FROM PASSENGER WHERE Survived = 1),
(SELECT COUNT(*) AS "Nb_survivants_enfants" FROM PASSENGER WHERE Survived = 1 AND Age < 12),
(SELECT COUNT(*) AS "Nb_survivants_femmes" FROM PASSENGER WHERE Survived = 1 AND Age >= 12 AND sex='female'),
(SELECT COUNT(*) AS "Nb_survivants_hommes" FROM PASSENGER WHERE Survived = 1 AND Age >= 12 AND sex='male');

/* Ecrivez une autre requête qui compare le nombre de victimes parmi les passagers au total des victimes enfants,
femmes et hommes résultant de ces mêmes requêtes. */

SELECT (SELECT COUNT(*) AS "Nb_victimes" FROM PASSENGER WHERE Survived = 0),
(SELECT COUNT(*) AS "Nb_victimes_enfants" FROM PASSENGER WHERE Survived = 0 AND Age < 12),
(SELECT COUNT(*) AS "Nb_victimes_femmes" FROM PASSENGER WHERE Survived = 0 AND Age >= 12 AND sex='female'),
(SELECT COUNT(*) AS "Nb_victimes_hommes" FROM PASSENGER WHERE Survived = 0 AND Age >= 12 AND sex='male');

/* Pourquoi cet écart ???
Un indice : si on ajoute le nombre de passagers de moins de 12 ans au nombre de passagers ayant au moins 12 ans,
on obtient 263 passagers de moins que le nombre total de passagers. 
reponse : car il y a des passagers qui n'ont pas d'age, ou ils ont pas renseignés les âges, on peut le voir dans le 
fichier Data_Titanic_S1.04.ods (ou des bébés de 0 an ?)*/


/* A3 */
--(a) Taux de survivants par classe, toutes catégories confondues (enfants, femmes ou hommes)

SELECT pclass, SUM(survived) * 100 / COUNT(*) AS taux_survie_tot
FROM passenger
GROUP BY pclass
ORDER BY pclass;

--(b) Taux de survivants par classe dans la catégorie enfants

SELECT pclass, SUM(survived) * 100 / COUNT(*) AS taux_survie_enfant
FROM passenger
WHERE age < 12
GROUP BY pclass
ORDER BY pclass;

--------------------------------------------------------------
--(c) Taux de survivants par classe dans la catégorie femmes

SELECT pclass, SUM(survived) * 100/ COUNT(*) AS taux_survie_femme
FROM passenger
WHERE age >= 12 AND sex = 'female'
GROUP BY pclass
ORDER BY pclass;

--------------------------------------------------------------
--(d) Taux de survivants par classe dans la catégorie hommes

SELECT pclass, SUM(survived) * 100/ COUNT(*) AS taux_survie_homme
FROM passenger
WHERE age >= 12 AND sex = 'male'
GROUP BY pclass
ORDER BY pclass;



-- (a) Nombre total d'enfants et nombre d'enfants rescapés

SELECT (SELECT COUNT(*) AS total_enfant FROM PASSENGER WHERE age < 12) as nb_total_enfants,
(SELECT count(*) FROM PASSENGER WHERE age <12 AND passengerid in (SELECT passengerid FROM rescue)) as nb_enfants_sauvés;

-- (b) Nombre d'enfants qui ont survécu parmi les enfants qui ont été rescapés

SELECT count(*) as nb_enfants_survie FROM PASSENGER WHERE age <12 AND survived = 1 and passengerid in (SELECT passengerid FROM rescue);

-- (c) Pour chaque classe de passagers : nombre d'enfants qui ont survécu parmi les enfants rescapés :

SELECT pclass, count(*) as nb_enfants_survie FROM PASSENGER WHERE age <12 AND survived = 1 and passengerid in (SELECT passengerid FROM rescue)
GROUP BY pclass
ORDER BY pclass;

/* (d) Taux de rescapés parmi les passagers */

SELECT COUNT(*) * 100 / (SELECT COUNT(*) FROM passenger) AS taux_rescapés
FROM passenger
WHERE passengerid IN (SELECT passengerid FROM rescue);

/* (e) Nombre de rescapés par catégorie de passager (enfant, femme ou homme) */

SELECT (SELECT COUNT(*) AS nb_rescapés_enfants FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue) AND age < 12),
(SELECT COUNT(*) AS nb_rescapés_femmes FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue) AND age >= 12 AND sex='female'),
(SELECT COUNT(*) AS nb_rescapés_hommes FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue) AND age >= 12 AND sex='male');



/* (f) Nombre de survivants par catégorie de rescapés (enfant, femme ou homme)*/

SELECT (SELECT COUNT(passengerid) FROM passenger WHERE survived = 1 AND age < 12 AND passengerid IN (SELECT passengerid FROM rescue)) AS Nb_survivants_enfants,
(SELECT COUNT(passengerid) FROM passenger WHERE survived = 1 AND age >= 12 AND sex = 'female' AND passengerid IN (SELECT passengerid FROM rescue)) AS Nb_survivants_femmes,
(SELECT COUNT(passengerid) FROM passenger WHERE survived = 1 AND age >= 12 AND sex = 'male' AND passengerid IN (SELECT passengerid FROM rescue)) AS Nb_survivants_hommes;


/* (g) Nombre total de rescapés et taux de survivants par embarcation - résultat ordonné sur le code de l'embarcation */

SELECT count(lifeboatId) AS nb_rescaped, (SELECT count(r.lifeboatId) FROM RESCUE r, PASSENGER p WHERE r.lifeboatId = a.lifeboatId AND p.passengerId = r.passengerId AND p.survived = 1)*100/count(a.lifeboatId)
AS Taux_de_survie, a.lifeboatId FROM RESCUE a 
GROUP BY a.lifeboatId 
ORDER BY a.lifeboatId;

/* (h) Pour chaque classe de passager, nombre d'enfants, nombre de femmes et nombre d'hommes qui ont survécu parmi
les rescapés */

SELECT (SELECT count(*) AS nb_enfant_c1 FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND age < 12 AND survived = 1 AND Pclass = 1),
	(SELECT count(*) AS nb_homme_c1
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND sex ='male' AND age >= 12 AND survived = 1 AND Pclass = 1),
	(SELECT count(*) AS nb_femme_c1
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND sex ='female' AND age >= 12 AND survived = 1 AND Pclass = 1),
    (SELECT count(*) AS nb_enfant_c2
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND age < 12 AND survived = 1 AND Pclass = 2),
	(SELECT count(*) AS nb_homme_c2
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND sex ='male' AND age >= 12 AND survived = 1 AND Pclass = 2),
	(SELECT count(*) AS nb_femme_c2
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND sex ='female' AND age >= 12 AND survived = 1 AND Pclass = 2),
    (SELECT count(*) AS nb_enfant_c3
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND age < 12 AND survived = 1 AND Pclass = 3),
	(SELECT count(*) AS nb_homme_c3
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND sex ='male' AND age >= 12 AND survived = 1 AND Pclass = 3),
	(SELECT count(*) AS nb_femme_c3
	FROM RESCUE r, PASSENGER p
	WHERE r.passengerId = p.passengerId AND sex ='female' AND age >= 12 AND survived = 1 AND Pclass = 3);


/* Partie B */

/* Qui des domestiques répertoriés dans la base ?
    - ont-ils tous été rescapés ?
    - s'ils ont été rescapés, en est-il de même de leurs employeurs (si oui, dans des embarcations identiques ou
différentes) ? */


SELECT (SELECT count(*) as total_dom FROM passenger 
WHERE passengerid IN (SELECT passengerid_dom FROM service)),
(SELECT count(*) as total_rescapes_dom FROM passenger 
WHERE passengerid IN (SELECT passengerid_dom FROM service) AND survived =1);

SELECT (SELECT count(*) as total_emp FROM passenger 
WHERE passengerid IN (SELECT passengerid_emp FROM service)),
(SELECT count(*) as total_rescapes_emp FROM passenger 
WHERE passengerid IN (SELECT passengerid_emp FROM service) AND survived =1);



/* • Influence de l'emplacement des embarcations de sauvetage (side et/ou position) sur le taux de survie des
passagers qui y ont pris place ? */

SELECT side, position, COUNT(p.passengerid) AS total_passagers_rescapés,
SUM(survived) AS total_passengers_survie,
ROUND((SUM(survived) * 1.0 / COUNT(p.passengerid)) * 100, 1) AS taux_survie
FROM lifeboat l, rescue r, passenger p
WHERE l.lifeboatid = r.lifeboatid AND r.passengerid = p.passengerid
GROUP BY lifeboatcat, side, position, location;


/* • Influence de l'heure de mise à l'eau des embarcations de sauvetage sur le taux de survie des passagers qui
y ont pris place (ou encore, influence de l'heure de récupération de ces embarcations par le Carpathia)? */

SELECT launching_time, COUNT(p.passengerid) AS total_passengers_rescapés,
SUM(survived) AS total_passengers_survie,
ROUND((SUM(survived) * 1.0 / COUNT(p.passengerid)) * 100, 1) AS taux_survie
FROM lifeboat l, rescue r, passenger p
WHERE l.lifeboatid = r.lifeboatid AND r.passengerid = p.passengerid
GROUP BY launching_time
ORDER BY launching_time;

/* • Taux de survie par tranche d'âge parmi les passagers ayant au moins 12 ans lors du naufrage ? */

SELECT age, count(*) AS nb_passagers, (SELECT count(*) FROM passenger WHERE age = p.age AND survived = 1)*100/count(*) AS taux_survived
FROM passenger p
WHERE age >= 12
GROUP BY age
ORDER BY age;


/* • Combien de passagers supplémentaires auraient pu être rescapés (et peut-être survivre) si le taux
maximum de remplissage des embarcations de sauvetage avait été respecté ? */

SELECT (SELECT COUNT(*) FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue)) AS nb_rescaped,
(SELECT COUNT(*) FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue))*100/(SELECT COUNT(*) FROM passenger) AS taux_rescaped,
(SELECT COUNT(*) FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue))*100/(SELECT COUNT(*) FROM passenger) AS taux_rescaped_max,
(SELECT COUNT(*) FROM passenger WHERE passengerid IN (SELECT passengerid FROM rescue))*100/(SELECT COUNT(*) FROM passenger) - 100 AS nb_supplémentaires;

/* on trouve -63 donc ils y auraient eu + de rescapés que de personnes possiblement à sauvés ??? Problème potentiel sur la requête */

