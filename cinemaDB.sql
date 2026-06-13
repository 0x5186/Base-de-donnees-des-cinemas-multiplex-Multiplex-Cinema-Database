/*
Groupe de projet :

	TDB, TP-B2 : 	
	 
	Ayoube Manjal 
	Raphael Drahon
	Raphael Dias
	Moussa Johnson
*/

---------------------------------------------------------------------------------------------------
--Creation BD

DROP SCHEMA IF EXISTS cinema cascade; --On s'assure que le schéma n'existe pas avant la création
CREATE SCHEMA cinema; 
SET search_path TO cinema; --On définit le chemin d'accès


CREATE TABLE film ( 
  id_film INTEGER,
  titre VARCHAR(50),
  duree TIME,
  genre VARCHAR(50),
  synopsis VARCHAR(1000), --Le synopsis doit etre un texte assez court (~1 paragraphe)
  limite_age INTEGER,
  boite_production VARCHAR(200),
  date_sortie DATE,
  CONSTRAINT film_PK PRIMARY KEY (id_film)
);



CREATE TABLE salle ( 
  id_salle INTEGER,
  capacite INTEGER,
  CONSTRAINT salle_PK PRIMARY KEY (id_salle)
);



CREATE TABLE personnes (
  id_personne INTEGER,
  CONSTRAINT personnes_PK PRIMARY KEY (id_personne)
);



CREATE TABLE client_enregistrer(
  pseudo VARCHAR(50),
  CONSTRAINT client_enregistrer_PK PRIMARY KEY (id_personne),
  CONSTRAINT client_enregistrer_id_personne_FK FOREIGN KEY (id_personne) REFERENCES personnes (id_personne)
) INHERITS (personnes);



CREATE TABLE noter ( --seul les clients enregistrer peuvent noter les films 
  id_film INTEGER,
  id_personne INTEGER,
  note DECIMAL(2,1) CHECK (note >= 0 and note <= 5),-- la note est comprise entre 0 et 5 (idées des étoiles) le type decimal permet d'avoir des 3.5 et même si cela permet de mettre des notes du style de 2.1 ou 4.6; qui ne sont pas habituelement utiliser, nous avons trouvé cela plus intéressant.
  CONSTRAINT noter_PK PRIMARY KEY (id_film, id_personne),
  CONSTRAINT noter_id_film_FK FOREIGN KEY (id_film) REFERENCES film (id_film),
  CONSTRAINT noter_id_personne_FK FOREIGN KEY (id_personne) REFERENCES client_enregistrer (id_personne)
);



CREATE TABLE seance (
  id_seance INTEGER,
  horaire_debut TIME,
  horaire_fin TIME,
  date_jour DATE,
  id_salle INTEGER,
  id_film INTEGER,
  CONSTRAINT seance_PK PRIMARY KEY (id_seance),
  CONSTRAINT seance_id_salle_FK FOREIGN KEY (id_salle) REFERENCES salle (id_salle),
  CONSTRAINT seance_id_film_FK FOREIGN KEY (id_film) REFERENCES film (id_film)
);



CREATE TABLE artiste (
  nom VARCHAR(50),
  prenom VARCHAR(50),
  date_naissance DATE,
  CONSTRAINT artiste_PK PRIMARY KEY (id_personne),
  CONSTRAINT artiste_id_personne_FK FOREIGN KEY (id_personne) REFERENCES personnes (id_personne)
) INHERITS (personnes);



CREATE TABLE reservation ( --une personne peut prendre une réservation même si elle n'est pas un client enregistrer 
  id_seance INTEGER,
  id_personne INTEGER,
  tarifs FLOAT, 
  --Tarif enfant : 7€ 
  --Tarif étudiant : 11.3€
  --Tarif adulte : 13.5€ 
  CONSTRAINT reservation_PK PRIMARY KEY (id_seance, id_personne),
  CONSTRAINT reservation_id_seance_FK FOREIGN KEY (id_seance) REFERENCES seance (id_seance),
  CONSTRAINT reservation_id_personne_FK FOREIGN KEY (id_personne) REFERENCES personnes (id_personne)
);



CREATE TABLE a_jouer (
  id_personne INTEGER,
  id_film INTEGER,
  CONSTRAINT a_jouer_PK PRIMARY KEY (id_personne, id_film),
  CONSTRAINT a_jouer_id_personne_FK FOREIGN KEY (id_personne) REFERENCES artiste (id_personne),
  CONSTRAINT a_jouer_id_film_FK FOREIGN KEY (id_film) REFERENCES film (id_film)
);



CREATE TABLE a_realiser (
  id_personne INTEGER,
  id_film INTEGER,
  CONSTRAINT a_realiser_PK PRIMARY KEY (id_personne, id_film),
  CONSTRAINT a_realiser_id_personne_FK FOREIGN KEY (id_personne) REFERENCES artiste (id_personne),
  CONSTRAINT a_realiser_id_film_FK FOREIGN KEY (id_film) REFERENCES film (id_film)
);


---------------------------------------------------------------------------------------------------
--Insertions 


INSERT INTO film (id_film, titre, duree, genre, synopsis, limite_age, boite_production, date_sortie) values

(1, 'Inception', '02:00:00', 'Science-fiction', 'Cool world', 12, 'Warner Bros', '2010-07-21'), 
(2, 'Tenet', '02:30:00', 'Science-fiction', 'Un agent secret appelé le Protagoniste doit empêcher une troisième guerre mondiale avec une technologie qui inverse le temps.', 13, 'Warner Bros', '2020-08-26'), 
(3, 'Oppenheimer', '03:00:00', 'Science-fiction', 'Biographie du physicien J. Robert Oppenheimer et du développement de la première bombe atomique pendant la Seconde Guerre mondiale.', null, 'Syncopy', '2023-07-19'), 
(4, 'Minecraft', '01:41:00', 'Aventure', 'Exploration du monde Minecraft suivant les péripéties de Steve', 7, 'Warner Bros', '2009-05-17'),
(5, 'Cars 2', '01:46:00', 'Animation', 'Flash McQueen et son ami Martin se retrouvent mêlés à une mission d’espionnage internationale pendant une tournée mondiale de courses automobiles.', 7, 'Disney-Pixar', '2011-07-10'),
(6, 'Naruto et la Princesse des neiges', '01:22:00', 'Animation', 'Naruto et son équipe protègent une princesse déguisée en actrice menacée dans le pays de la neige.', 12, 'Bandai Co', '2004-08-21'), 
(7, 'Le Tombeau des lucioles', '01:29:00', 'Tragédie', 'Histoire de Seita et de sa soeur Setsuko, deux jeunes japonais dont les parents sont tués lors d’un bombardement américain sur Kobe.', 16, 'Studio Ghibli', '1996-06-19'), 
(8, 'Dossier 137', '01:55:00', 'Thriller', 'Une enquêtrice dévoile les secrets derrière un incident policier grave.', 14, 'France 2 Cinéma', '2025-11-19'),
(9, 'Chainsaw Man', '01:41:00', 'Animation', 'Denji, devenu Chainsaw Man, tombe sous le charme de Reze, mais leur histoire vire en combat explosif mêlant amour, trahison et affrontements contre des démons.', 16, 'MAPPA', '2025-10-22'),
(10, 'Naruto Shippuden: Road to Ninja', '01:49:00', 'Animation', 'Naruto est transporté dans un monde paralèlle avec Sakura', 12, 'Bandai Co', '2012-07-28'),
(11, 'Scream 7', '01:54:00', 'Horreur', 'Lorsqu un nouveau tueur, alias Ghostface, fait son apparition dans la paisible ville où Sidney a refait sa vie, ses pires craintes se réalisent : sa fille devient la prochaine cible', 14, 'Spyglass MG', '2026-02-25'),
(12, 'Parasite', '02:12:00', 'Thriller', 'Parasite raconte l histoire d une famille pauvre, les Kim, qui s infiltre chez une famille riche, les Park', 16, 'CJ ENM', '2019-06-05'),
(13, 'Spider-Man : Across the Spider-Verse', '02:20:00', 'Animation 3D', 'Après avoir retrouvé Gwen Stacy, Spider-Man, le sympathique quartier à temps plein de Brooklyn, est catapulté à travers le multivers, où il rencontre une équipe de Spider-People chargée de protéger son existence même.', 7, 'Sony Pictures Animation', '2023-05-31'),
(14, 'Backrooms', '02:00:00', 'Thriller', 'Découverte de l univers des arrières salles', 12, 'A24', '2026-06-17'), 
(15, 'Five Nights at Freddy s', '01:50:00', 'Horreur', 'Un veilleur de nuit doit surveiller une pizzeria où des peluches animatronics inoffensives le jour deviennent meurtrières la nuit, en gérant les caméras et l électricité pour survivre cinq nuits.', 12, 'A24', '2023-11-08'),
(16, 'Le Mangeur d âmes', '01:48:00', 'Horreur', 'Le gendarme Franck de Rolan est à la recherche de 3 enfants kidnappés. Son enquête le conduit dans un chalet où a eu lieu un double meurtre. Il fait équipe avec Elisabeth Guardiano, policière diligentée pour mener l enquête criminelle.', 12, 'Phase 4 Productions', '2024-04-24'),
(17, 'Bleach', '01:48:00', 'Action', 'Un adolescent japonais qui a le pouvoir de vois des fantômes doit lutter contre les mauvais esprits et aider les âmes perdues à trouver leur chemin vers une autre vie.', 12, 'Cine Bazar', '2018-07-20'),
(18, 'Interstellar', '02:49:00', 'Science-fiction', 'Dans un proche futur, la Terre est devenue hostile pour l homme. Les tempêtes de sable sont fréquentes et il n y a plus que le maïs qui peut être cultivé, en raison d un sol trop aride. Cooper est un pilote, recyclé en agriculteur, qui vit avec son fils et sa fille dans la ferme familiale.', 13, 'Warner Bros', '2014-11-05'),
(19, 'La planète des singes : Les origines', '01:45:00', 'Action', 'Un médecin de San Francisco tente de guérir la maladie d Alzheimer en introduisant un virus bénin dans le tissu cérébral des singes. Lorsqu il ne trouve plus de financement pour ses recherches et qu il doit abandonner ses projets, il se retrouve seul avec un chimpanzé, le sujet le plus prometteur de son expérience.', 14, 'Chernin Entertainment', '2011-08-10'),
(20, 'Carry-On', '01:59:00', 'Action', 'Un jeune agent de sécurité essaie de déjouer les plans d un mystérieux voyageur qui le fait chanter pour qu il laisse monter un dangereux colis à bord d un avion la veille de Noël.', 13, 'Amblin Partners', '2024-12-05'),
(21, '1917', '01:59:00', 'Guerre', 'Lorsque la Première Guerre mondiale frappe le monde, deux soldats britanniques, caporal suppléant Schofield et caporal suppléant Blake, reçoivent une mission qui leur semble impossible: ils doivent traverser le territoire ennemi pour délivrer un message.', 16, 'Dreamworks Pictures ', '2020-01-15'),
(22, 'Princesse Mononoké', '02:13:00', 'Animation', 'Ashitaka, frappé par une malédiction après avoir tué un sanglier démoniaque, part à l ouest et découvre que la destruction humaine de la forêt cause la violence et les monstres.', 7, 'Studio Ghibli', '2000-01-12'),
(23, 'Une bataille après l autre', '02:42:00', 'Action', 'Bob est un ancien révolutionnaire, plongé dans une paranoïa, survivant en marge du système avec sa fille Willa, pleine de fougue et d autonomie.', 12, 'Ghoulardi Film Company', '2025-09-24'),
(24, 'The Truman Show', '01:43:00', 'Comédie', 'Truman Burbank vit dans une ville entièrement scénarisée où sa vie est filmée à son insu, jusqu’au jour où il découvre la vérité.', 12, 'Paramount Pictures', '1998-10-28'),
(25, 'The Amazing Spider-Man : Le Destin d un héros', '02:22:00', 'Action', 'Le plus grand défi de Spider-Man est de concilier sa vie de Peter Parker avec ses responsabilités héroïques, tout en affrontant des ennemis puissants liés à OsCorp.', 12, 'Marvel Enterprises', '2014-04-30'),
(26, 'Les Dents de la mer', '02:40:00', 'Horreur', 'Un énorme requin agressif terrorise une petite ville côtière de la Nouvelle-Angleterre. Le shérif local, un pêcheur et un scientifique tentent de mettre fin au carnage', 12, 'Universal Pictures', '1976-01-01'),
(27, 'Terminator 2 : Le Jugement dernier', '02:17:00', 'Science-fiction', 'En 2029, après leur échec pour éliminer Sarah Connor, les robots de Skynet programment un nouveau Terminator, le T-1000, pour retourner dans le passé et éliminer son fils John Connor, futur leader de la résistance humaine.', 12, 'Carolco Pictures', '1991-10-16'),
(28, 'Get Out', '01:44:00', 'Horreur', 'Maintenant que Chris et sa copine Rose vont rencontrer leurs parents respectifs, elle l invite dans la résidence secondaire de sa famille pour un week-end. D abord Chris comprend que le comportement un peu étrange de la famille de Rose est lié au fait qu il est noir et qu elle est blanche. Cependant, il découvre que la vérité est bien plus dérangeante.', 16, 'Blumhouse Productions', '2017-05-03'),
(29, 'Us', '02:10:00', 'Horreur', 'Les vacances s annoncent reposantes pour Adelaide et Gabe Wilson et leurs deux enfants.', 13, 'Monkeypaw Productions', '2019-03-20'),
(30, 'Uncharted', '01:56:00', 'Aventure', 'Le chasseur de trésors Victor Sully Sullivan recrute Nathan Drake pour l aider à récupérer une fortune vieille de 500 ans amassée par l explorateur Ferdinand Magellan.', 10, 'Arad Productions', '2022-02-18'),
(31, 'Tomb Raider', '01:58:00', 'Aventure', 'Lara Croft, 21 ans, est persuadée que son père, un riche explorateur excentrique porté disparu depuis sept ans, n est pas mort.', 14, 'Paramount Pictures', '2018-03-04'),
(32, 'Tous en scene 2', '01:50:00', 'Animation 3D', 'Remotivé par Nana Noodleman, le koala rassemble ses artistes.', 7, 'Universal Pictures', '2021-12-22'),
(33, 'Karaté Kid', '02:20:00', 'Action', 'Quand la carrière de sa mère l oblige à aller en Chine.', 10, 'Columbia Pictures', '2025-08-13'),
(34, 'Police Story', '01:40:00', 'Action', 'L inspecteur Chan se voit confier la protection d une femme.', 16, 'Golden Way Films Ltd', '1987-07-29'),
(35, 'Jumanji: Next Level', '02:30:00', 'Comédie', 'Lorsque Spencer retourne dans le monde fantastique de Jumanji.', 7, 'Columbia Pictures', '2019-12-04'),
(36, 'Shinobi', '01:47:00', 'Action', 'En 1614, les Shoguns règnent sur le Japon.', 12, 'Eisei Gekijo','2005-09-17'),
(37, 'Naruto the Last', '01:52:00', 'Action', 'Dans le village de Konoha, deux années après la 4e grande guerre des ninjas.', 12, 'Bandai Co', '2015-05-13'), 
(38, 'Course à la mort', '01:51:00', 'Action', 'Dans une Amérique futuriste, les prisonniers sont contraints de participer à de très violentes courses automobiles.', 12, 'Wagner Productions', '2008-08-22'),
(39, 'One Piece Film - Red', '01:55:00', 'Aventure', 'Luffy et son équipage s apprêtent à assister à un festival de musique attendu avec impatience.', 13, 'Toei Animation', '2022-08-10'),
(40, 'The Mask', '01:41:00', 'Comédie', 'Stanley Ipkiss, modeste employé de banque.', 10, 'Alliance Vivafilm', '1994-10-26');


INSERT INTO salle (id_Salle, capacite) VALUES
(1, 500),
(2, 150),
(3, 150),
(4, 200),
(5, 100),
(6, 400),
(7, 130),
(8, 150),
(9, 250),
(10, 65),
(11, 120),
(12, 330),
(13, 200),
(14, 150),
(15, 180),
(16, 110),
(17, 310),
(18, 350),
(19, 290),
(20, 210),
(21, 110),
(22, 400),
(23, 145),
(24, 150), 
(25, 300); 


INSERT INTO personnes (id_personne) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),
(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),
(31),(32),(33),(34),(35),(36),(37),(38),(39),(40),
(41),(42),(43),(44),(45),(46),(47),(48),(49),(50),
(51),(52),(53),(54),(55),(56),(57),(58),(59),(60),
(61),(62),(63),(64),(65),(66),(67),(68),(69),(70),
(71),(72),(73),(74),(75),(76),(77),(78),(79),(80),
(81),(82),(83),(84),(85),(86),(87),(88),(89),(90);


INSERT INTO seance (id_seance, horaire_debut, horaire_fin, date_jour, id_salle, id_film) VALUES
(1, '17:00:00', '18:59:00', '2027-02-15', 10, 21),
(2, '10:30:00', '12:22:00', '2026-03-20', 1, 37),
(3, '21:00:00', '23:42:00', '2026-12-29', 22, 23),
(4, '11:00:00', '12:56:00', '2026-03-03', 9, 30),
(5, '15:30:00', '17:11:00', '2026-06-25', 24, 33),
(6, '08:00:00', '09:30:00', '2028-01-01', 5, 28),
(7, '21:30:00', '22:52:00', '2020-05-25',1, 6),
(8, '16:21:00', '18:10:00', '2024-04-11', 21, 34),
(9, '13:00:00', '14:54:00', '2026-02-25', 13, 11),
(10, '12:40:00', '14:30:00', '2023-05-20', 20, 16),
(11, '11:50:00', '13:50:00', '2024-03-12', 1, 1),
(12, '14:44:44', '16:44:44', '2025-04-29', 6, 40),
(13, '17:00:00', '18:58:00', '2027-12-25', 13, 31),
(14, '23:00:00', '01:00:00', '2021-05-17', 7, 1),
(15, '17:00:00', '18:50:00', '2028-02-01', 18, 15),
(16, '14:00:00', '15:59:00', '2023-07-27', 19, 20),
(17, '12:30:00', '14:25:00', '2022-03-18', 18, 8),
(18, '17:50:00', '19:41:00', '2021-05-17', 5, 38),
(19, '18:00:00', '19:28:00', '2020-12-12', 8, 7),
(20, '06:00:00', '08:20:00', '2028-07-04', 4, 13);


INSERT INTO artiste (id_personne, nom, prenom, date_naissance) VALUES
(1, 'Dicaprio', 'Lenardo', '1974-11-11'), 
(2, 'Pattinson', 'Robert', '1986-05-13'), 
(3, 'Washington', 'John David', '1984-07-28'), 
(4, 'Murphy', 'Cillian', '1976-05-25'), 
(5, 'Downey Jr', 'Robert', '1965-04-04'), 
(6, 'Black', 'Jack', '1969-08-28'), 
(7, 'Lewis', 'Brad', '1958-04-29'),
(8, 'Lasseter', 'John', '1957-01-12'), 
(9, 'Okamura', 'Tensai', '1961-12-13'), 
(10, 'Sato', 'Toya', '1959-04-11'), 
(11, 'Drucker', 'Lea', '1972-01-23'), 
(12, 'Moll', 'Dominik ', '1962-05-07'), 
(13, 'Yoshihara', 'Tatsuya', '1988-12-09'), 
(14, 'Date', 'Hayato', '1962-05-22'), 
(15, 'Campbell', 'Neve', '1973-10-03'), 
(16, 'May', 'Isabel', '2000-11-21'), 
(17, 'Ho', 'Bong Joon', '1969-09-14'), 
(18, 'Kang-Ho', 'Song', '1967-01-17'), 
(19, 'Dos Santos', 'Joaquim', '1977-06-22'), 
(20, 'Powers', 'Kemp', '1974-01-01'), 
(21, 'Parsons', 'Kane', '2005-06-18'), 
(22, 'Ejiofor', 'Chiwetel', '1977-07-10'),   
(23, 'Reinsve', 'Renate', '1987-11-24'), 
(24, 'Tammi', 'Emma', '1970-01-01'), 
(25, 'Hutcherson', 'Josh', '1992-10-12'),  
(26, 'Ledoyen', 'Virginie', '1976-11-15'), 
(27, 'Nolan', 'Christopher', '1970-07-30'), 
(28, 'McConaughey', 'Matthew', '1969-11-04'), 
(29, 'Hathaway', 'Anne', '1982-11-12'), 
(30, 'Franco', 'James', '1978-04-19'), 
(31, 'Felton', 'Tom', '1987-09-22'),  
(32, 'Egerton', 'Taron', '1989-11-10'), 
(33, 'Bateman', 'Jason', '1969-01-14'), 
(34, 'MacKay', 'George', '1992-03-13'), 
(35, 'Mendes', 'Sam', '1965-08-01'), 
(36, 'Miyazaki', 'Hayao', '1941-01-05'), 
(37, 'Anderson', 'Paul Thomas', '1970-06-26'), 
(38, 'Carrey', 'Jim', '1962-01-17'), 
(39, 'Garfield', 'Andrew', '1983-08-20'), 
(40, 'Webb', 'Marc', '1974-08-31'), 
(41, 'Holland', 'Tom', '1996-06-01'), 
(42, 'Vikander', 'Alicia', '1988-10-03'), 
(43, 'Kasdan', 'Jake', '1974-10-28'), 
(44, 'Statham', 'Jason', '1967-07-26'), 
(45, 'Chan', 'Jackie', '1954-04-07');  


INSERT INTO a_jouer(id_personne, id_film) VALUES 
(1, 1), 
(1, 23), 
(2, 2),
(3, 2), 
(4, 3), 
(5, 3),
(6, 4),
(11, 8),
(15, 11),
(16, 11),
(18, 12), 
(22, 14), 
(23, 14),
(25, 15), 
(26, 16),
(28, 18), 
(29, 18),
(30, 19),
(31, 19), 
(32, 20),
(33, 20), 
(34, 21),
(38, 40),
(38, 24),
(39, 25), 
(41, 30), 
(42, 31), 
(44, 38), 
(45, 34); 


INSERT INTO a_realiser(id_personne, id_film) VALUES 
(7, 5), 
(8, 5), 
(9, 6), 
(10, 10), 
(12, 8), 
(13, 9), 
(14, 10),
(17, 12), 
(19, 13), 
(20, 13), 
(21, 14), 
(24, 15), 
(27, 18),
(27, 2), 
(27, 1), 
(27, 3), 
(35, 21), 
(36, 22), 
(37, 23),
(40, 25), 
(43, 35); 


INSERT INTO client_enregistrer (id_personne, pseudo) VALUES
(46,'El trocador'),
(47,'Asta'),
(48,'Raphaelo'),
(49,'Naruto Le Vrai'),
(50,'Xx_Yanis_xX'),
(51,'Merlin'),
(52,'Bankai303'),
(53,'EnjaSokatsu'),
(54,'CestPasDeLia'),
(55,'Sanae'),
(56,'Veronique112'),
(57,'Selafin_'),
(58,'Musaroo ft Musa'),
(59,'Ayoube ft Ayub'),
(60,'SantiagoDeParis'),
(61,'OperationBakudan'),
(62,'Eloise115'),
(63,'Sennin'),
(64,'Blonded'),
(65,'Fiona45 <3'),
(66,'LanaOnTop'),
(67,'MonSnap : Luke77'),
(68,'BartSimpson'),
(69,'Raphael ft raph'),
(70,'Luffy11245'),
(71,'PascalDurant56'),
(72,'Momo75'),
(73,'Operator'),
(74,'Bintou_93360'),
(75,'OnAPasUtiliseIA'),
(76,'LunDesPseudosEstVrais'),
(77,'Serine44'),
(78,'MrSimon'),
(79,'Ketchup'),
(80,'SpiderManjal1458'),
(81,'GuitareMan452'),
(82,'LonelyBoy'),
(83,'Kurosaki Hanma'),
(84,'ImuraSan'),
(85,'Merveille46396'),
(86,'RegeLeGorilla'),
(87,'HateRegeLeGorilla'),
(88,'ILuvMovie'),
(89,'Batmane'),
(90,'LoveNolan');


INSERT INTO noter (id_film, id_personne, note) VALUES
(1, 46, 4.5),
(1, 47, 4.2),
(1, 48, 4.8),
(1, 86, 4.5),
(1, 87, 0.5),
(2, 49, 4.0),
(2, 50, 3.9),
(2, 86, 3.8),
(2, 87, 1.2),
(3, 51, 4.8),
(3, 52, 4.5),
(3, 53, 4.9),
(3, 54, 4.3),
(3, 86, 4.9),
(3, 87, 0.1),
(5, 46, 4.2),
(5, 55, 4.6),
(5, 56, 3.8),
(5, 86, 4.2),
(5, 87, 0.8),
(6, 57, 3.8),
(6, 58, 4.1),
(6, 86, 3.5),
(6, 87, 1.5),
(7, 59, 4.7),
(7, 60, 4.4),
(7, 61, 4.2),
(7, 86, 4.7),
(7, 87, 0.3),
(9, 49, 4.4),
(9, 62, 3.9),
(9, 86, 4.0),
(9, 87, 1.0),
(10, 63, 4.1),
(10, 64, 4.5),
(10, 65, 3.7),
(10, 86, 4.3),
(10, 87, 0.7),
(11, 66, 3.6),
(11, 67, 4.2),
(11, 86, 4.4),
(11, 87, 0.6),
(12, 57, 4.3),
(12, 68, 4.6),
(12, 69, 3.5),
(12, 70, 4.4),
(12, 86, 4.6),
(12, 87, 0.4),
(14, 71, 3.7),
(14, 50, 4.0),
(14, 86, 3.9),
(14, 87, 1.1),
(15, 72, 4.0),
(15, 73, 4.3),
(15, 74, 3.6),
(15, 86, 4.1),
(15, 87, 0.9),
(16, 75, 3.5),
(16, 76, 4.1),
(16, 86, 3.7),
(17, 77, 4.2),
(17, 78, 4.5),
(17, 79, 3.9),
(18, 46, 4.9),
(18, 80, 4.7),
(18, 81, 4.8),
(18, 82, 4.5),
(18, 83, 4.6),
(18, 86, 4.8),
(20, 84, 4.4),
(20, 85, 3.8),
(20, 86, 4.4),
(20, 87, 0.6),
(21, 47, 4.5),
(21, 88, 4.1),
(21, 51, 4.0),
(22, 88, 4.1),
(22, 51, 4.0),
(23, 89, 3.9),
(23, 90, 4.3),
(23, 52, 4.2),
(25, 53, 4.7),
(25, 54, 4.4),
(26, 55, 3.6),
(26, 56, 4.3),
(26, 59, 4.1),
(27, 60, 4.8),
(27, 61, 4.5),
(27, 62, 4.3),
(27, 63, 4.0),
(29, 64, 3.4),
(29, 65, 4.1),
(30, 49, 4.0),
(30, 66, 4.5),
(30, 67, 3.7),
(31, 68, 4.5),
(31, 69, 3.8),
(32, 70, 3.8),
(32, 71, 4.2),
(32, 72, 4.0),
(34, 73, 4.1),
(34, 74, 3.9),
(35, 75, 3.9),
(35, 76, 4.3),
(35, 77, 4.6),
(36, 78, 4.3),
(36, 79, 4.0),
(37, 50, 4.4),
(37, 80, 4.1),
(37, 81, 4.2),
(39, 82, 4.2),
(39, 83, 4.5),
(40, 47, 4.6),
(40, 84, 4.3),
(40, 85, 4.7),
(40, 48, 3.9);

INSERT INTO reservation (id_seance, id_personne, tarifs) VALUES
(1, 46, 11.3),
(1, 47, 7), 
(1, 48, 13.5), 
(1, 49, 13.5), 
(1, 50, 7), 
(1, 51, 11.3),
(2, 1, 13.5), 
(2, 27, 13.5),
(2, 58, 11.3),
(3, 52, 7),
(1, 53, 11.3),
(1, 54, 13.5),
(1, 55, 11.3),
(1, 58, 11.3),
(1, 57, 7),
(1, 59, 11.3),
(2, 56, 13.5),
(2, 4, 13.5),
(3, 60, 11.3),
(3, 61, 7), 
(3, 62, 11.3), 
(3, 63, 13.5),
(3, 46, 11.3), 
(3, 57, 7),
(3, 58, 11.3),
(3, 55, 11.3),
(3, 64, 11.3),
(3, 65, 7),
(1, 61, 7),
(4, 62, 11.3),
(4, 66, 11.3),
(4, 67, 13.5),
(4, 68, 7),
(4, 69, 13.5),
(4, 70, 7), 
(5, 71, 13.5),
(5, 72, 7),
(6, 73, 11.3),
(7, 74, 13.5),
(1, 75, 7),
(8, 76, 7),
(9, 77, 11.3),
(9, 78, 13.5),
(9, 11, 13.5),
(10, 79, 11.3),
(11, 80, 11.3), 
(11, 81, 13.5), 
(11, 82, 7), 
(12, 83, 11.3),
(13, 84, 11.3),
(14, 85, 7), 
(15, 86, 11.3), 
(16, 87, 13.5), 
(16, 88, 11.3),
(17, 89, 13.5),
(18, 90, 11.3); 
