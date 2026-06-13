--Requêtes

--Afficher les films ayant une moyenne supérieure à 2.5.

select f.id_film, f.titre, round(avg(n.note), 1) as moyenne_note
from film f
inner join noter n on f.id_film = n.id_film
group by f.id_film, f.titre
having round(avg(n.note), 1) > 2.5;




--afficher les jours de la semaine avec le plus d’affluence, triés dans l’ordre decroissant.

select 
    extract(dow from s.date_jour) as jour_semaine,
    count(r.id_personne) as nb_personnes
from seance s
inner join reservation r on s.id_seance = r.id_seance
group by jour_semaine
order by nb_personnes desc;


--affiche les 10 clients étant venu le plus de fois voir un film.

select 
    c.pseudo,
    count(n.id_film) as nb_films
from client_enregistrer c
inner join noter n on c.id_personne = n.id_personne
group by c.pseudo
order by nb_films desc
limit 10;



--affiche les 5 acteurs les plus représentés dans la base de données.

select 
    ar.nom,
    ar.prenom,
    count(aj.id_film) as nb_films
from cinema.artiste ar
inner join cinema.a_jouer aj on ar.id_personne = aj.id_personne
group by ar.id_personne, ar.nom, ar.prenom
order by nb_films desc
limit 5;





--affiche le genre de film ayant reçu le plus de bonne notes (supérieures ou égales à 4).

select  f.genre count(n.note) as nb_bonnes_notes
from cinema.film f
inner join cinema.noter n on f.id_film = n.id_film
where n.note >= 4
group by f.genre
order by nb_bonnes_notes desc
limit 1;



--affiche les 5 genres de films les plus visionnés.

selectf.genre,
count(r.id_personne) as nombre_visionnages
from film f
inner join seance s on f.id_film = s.id_film
inner join reservation r on s.id_seance = r.id_seance
group by f.genre
order by nombre_visionnages desc
limit 5;



--affiche les 5 réalisateurs qui ont eu les films avec les meilleurs moyennes des notes.

select  a.nom, a.prenom, avg(n.note) as note_moyenne
from cinema.artiste a
inner join cinema.a_realiser ar on a.id_personne = ar.id_personne
inner join cinema.noter n on ar.id_film = n.id_film
group by a.id_personne, a.nom, a.prenom
order by note_moyenne desc
limit 5;



--affiche les 10 films avec la meilleure moyenne, en ayant plus de 5 notations.

select  f.titre, count(n.note) as nombre_notes,avg(n.note) as note_moyenne
from cinema.film f
inner join cinema.noter n on f.id_film = n.id_film
group by f.id_film, f.titre
having count(n.note) > 5
order by note_moyenne desc
limit 10;





--crée une vue permettant d’avoir la note moyenne d’un film et pouvoir effectuer des opérations dessus par la suite.

create view noteMoyFilm as
select f.id_film, f.titre, f.genre, f.boite_production, round(avg(n.note),1) as note_moyenne
from film f
inner join noter n using(id_film)
group by f.id_film, f.titre, f.genre, f.boite_production;




--exemple d’operation: le film avec la meilleure moyenne de note dans le genre “action”.

select *
from noteMoyFilm
where genre = 'Action'
order by note_moyenne desc
limit 1;



--l’acteur avec la meilleure moyenne de films.

select a.id_personne, a.nom, a.prenom, avg(n.note) as moyenne_films
from artiste a
inner join a_jouer aj on a.id_personne = aj.id_personne
inner join noter n on aj.id_film = n.id_film
group by a.id_personne, a.nom, a.prenom
order by moyenne_films desc
limit 1;