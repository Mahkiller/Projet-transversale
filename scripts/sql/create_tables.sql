CREATE TABLE t_genre (
    id SERIAL PRIMARY KEY,
    genre VARCHAR(50) NOT NULL
);

CREATE TABLE t_marque (
    id SERIAL PRIMARY KEY,
    marque VARCHAR(100) NOT NULL
);

CREATE TABLE t_type (
    id SERIAL PRIMARY KEY,
    type VARCHAR(100) NOT NULL
);

CREATE TABLE t_modele (
    id SERIAL PRIMARY KEY,
    modele VARCHAR(100) NOT NULL
);

CREATE TABLE t_couleur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);

CREATE TABLE t_pointure (
    id SERIAL PRIMARY KEY,
    valeur NUMERIC(4,1) NOT NULL
);

CREATE TABLE t_trancheAge (
    id SERIAL PRIMARY KEY,
    trancheAge VARCHAR(50) NOT NULL
);

CREATE TABLE t_modele_chaussure (
    id SERIAL PRIMARY KEY,
    idGenre INT REFERENCES t_genre(id),
    idMarque INT REFERENCES t_marque(id),
    idType INT REFERENCES t_type(id),
    idModele INT REFERENCES t_modele(id),
    idTrancheAge INT REFERENCES t_trancheAge(id),
    description TEXT
);

CREATE TABLE t_chaussure (
    id SERIAL PRIMARY KEY,
    idChaussure INT REFERENCES t_modele_chaussure(id),
    idCouleur INT REFERENCES t_couleur(id),
    idPointure INT REFERENCES t_pointure(id),
    image VARCHAR(255),
    prix NUMERIC(10,2) NOT NULL
);

CREATE TABLE t_stock (
    id SERIAL PRIMARY KEY,
    idChaussure INT REFERENCES t_chaussure(id),
    quantite INT DEFAULT 0,
    dateDernierMaj TIMESTAMP DEFAULT NOW()
);

CREATE TABLE t_mouvement_stock (
    id SERIAL PRIMARY KEY,
    dtn TIMESTAMP DEFAULT NOW(),
    idChaussure INT REFERENCES t_chaussure(id),
    quantiteEntree INT DEFAULT 0,
    quantiteSortie INT DEFAULT 0
);

CREATE TABLE t_role (
    id SERIAL PRIMARY KEY,
    role VARCHAR(50) NOT NULL
);

CREATE TABLE t_utilisateur (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    motDePasse VARCHAR(255),
    idRole INT REFERENCES t_role(id)
);

CREATE TABLE t_commande (
    id SERIAL PRIMARY KEY,
    idUtilisateur INT REFERENCES t_utilisateur(id),
    dtn TIMESTAMP DEFAULT NOW(),
    statut VARCHAR(50)
);

CREATE TABLE t_detailCommande (
    id SERIAL PRIMARY KEY,
    idCommande INT REFERENCES t_commande(id),
    idChaussure INT REFERENCES t_chaussure(id),
    quantite INT
);

CREATE TABLE t_paiement (
    id SERIAL PRIMARY KEY,
    idCommande INT REFERENCES t_commande(id),
    montant NUMERIC(10,2),
    date TIMESTAMP DEFAULT NOW()
);


INSERT INTO t_genre (genre) VALUES
('Homme'), ('Femme'), ('Enfant'), ('Unisexe'), ('Sport');

INSERT INTO t_marque (marque) VALUES
('Nike'), ('Adidas'), ('Puma'), ('New Balance'), ('Reebok'), ('Asics'), ('Salomon');

INSERT INTO t_type (type) VALUES
('Basket'), ('Running'), ('Ville'), ('Sandale'), ('Randonnée');

INSERT INTO t_modele (modele) VALUES
('AirMax'), ('AirForce'), ('Vapormax'), ('Cortez'), ('Pegasus'),
('Ultraboost'), ('NMD'), ('RSX'), ('ClubC'), ('574'),
('993'), ('ClassicLeather'), ('SuedeClassic'), ('GelKayano'), ('GelNimbus'),
('SpeedTrainer'), ('CloudRunner'), ('RunnerPro'), ('TrailMaster'), ('StreetLite');

INSERT INTO t_couleur (nom) VALUES
('Noir'), ('Blanc'), ('Rouge'), ('Bleu'), ('Vert');

INSERT INTO t_pointure (valeur) VALUES
(36), (37), (38), (39), (40);

INSERT INTO t_trancheAge (trancheAge) VALUES
('Enfant'), ('Adolescent'), ('Adulte'), ('Senior'), ('Tout âge');

INSERT INTO t_modele_chaussure (idGenre, idMarque, idType, idModele, idTrancheAge, description) VALUES
(1, 1, 1, 1, 3, 'AirMax classique homme'),
(1, 1, 1, 2, 3, 'AirForce street'),
(1, 1, 2, 3, 3, 'Vapormax performance'),
(1, 1, 1, 4, 3, 'Cortez retro'),
(2, 1, 2, 5, 3, 'Pegasus running femme'),
(2, 2, 2, 6, 3, 'Ultraboost confort'),
(2, 2, 1, 7, 3, 'NMD lifestyle'),
(4, 3, 1, 8, 5, 'RSX unisexe'),
(1, 4, 3, 9, 3, 'ClubC ville'),
(3, 4, 3, 10, 1, '574 enfant'),
(1, 5, 2, 11, 3, '993 running'),
(2, 5, 3, 12, 3, 'ClassicLeather ville'),
(1, 3, 1, 13, 3, 'SuedeClassic casual'),
(1, 6, 2, 14, 3, 'GelKayano running'),
(1, 6, 2, 15, 3, 'GelNimbus amorti'),
(2, 7, 2, 16, 3, 'SpeedTrainer sport'),
(4, 7, 2, 17, 3, 'CloudRunner confort'),
(1, 2, 1, 18, 3, 'RunnerPro performance'),
(1, 3, 5, 19, 1, 'TrailMaster randonnée'),
(1, 4, 1, 20, 3, 'StreetLite urbain');

INSERT INTO t_chaussure (idChaussure, idCouleur, idPointure, image, prix) VALUES
(1, 1, 1, 'airmax_nike_noir.jpg', 120.00),
(2, 2, 2, 'airforce_nike_blanc.jpg', 110.00),
(3, 3, 3, 'vapormax_nike_rouge.jpg', 160.00),
(4, 4, 4, 'cortez_nike_bleu.jpg', 90.00),
(5, 5, 5, 'pegasus_nike_vert.jpg', 130.00),
(6, 1, 2, 'ultraboost_adidas_noir.jpg', 150.00),
(7, 2, 3, 'nmd_adidas_blanc.jpg', 140.00),
(8, 3, 4, 'rsx_puma_rouge.jpg', 110.00),
(9, 4, 5, 'clubc_newbalance_bleu.jpg', 95.00),
(10, 5, 1, '574_newbalance_vert.jpg', 100.00),
(11, 1, 2, '993_reebok_noir.jpg', 125.00),
(12, 2, 3, 'classicleather_reebok_blanc.jpg', 115.00),
(13, 3, 4, 'suedeclassic_puma_rouge.jpg', 105.00),
(14, 4, 5, 'gelkayano_asics_bleu.jpg', 145.00),
(15, 5, 1, 'gelnimbus_asics_vert.jpg', 155.00),
(16, 1, 2, 'speedtrainer_salomon_noir.jpg', 135.00),
(17, 2, 3, 'cloudrunner_salomon_blanc.jpg', 140.00),
(18, 3, 4, 'runnerpro_adidas_rouge.jpg', 120.00),
(19, 4, 5, 'trailmaster_puma_bleu.jpg', 150.00),
(20, 5, 1, 'streetlite_newbalance_vert.jpg', 85.00),
(1, 2, 3, 'airmax_nike_blanc.jpg', 120.00),
(2, 3, 4, 'airforce_nike_rouge.jpg', 110.00),
(3, 4, 5, 'vapormax_nike_bleu.jpg', 160.00),
(4, 5, 1, 'cortez_nike_vert.jpg', 90.00),
(6, 3, 2, 'ultraboost_adidas_rouge.jpg', 150.00),
(7, 4, 3, 'nmd_adidas_bleu.jpg', 140.00),
(8, 5, 4, 'rsx_puma_vert.jpg', 110.00),
(9, 1, 5, 'clubc_newbalance_noir.jpg', 95.00),
(10, 2, 1, '574_newbalance_blanc.jpg', 100.00),
(11, 4, 2, '993_reebok_bleu.jpg', 125.00);

INSERT INTO t_stock (idChaussure, quantite) VALUES
(1, 20),(2,15),(3,10),(4,12),(5,18),(6,25),(7,14),(8,16),(9,9),(10,22),
(11,17),(12,11),(13,8),(14,13),(15,19),(16,7),(17,6),(18,5),(19,4),(20,3),
(21,10),(22,9),(23,8),(24,7),(25,6),(26,5),(27,4),(28,3),(29,2),(30,1);

INSERT INTO t_mouvement_stock (idChaussure, quantiteEntree, quantiteSortie) VALUES
(1,20,0),(2,15,0),(3,10,0),(4,12,0),(5,18,0),(6,25,0),(7,14,0),(8,16,0),(9,9,0),(10,22,0),
(11,17,0),(12,11,0),(13,8,0),(14,13,0),(15,19,0),(16,7,0),(17,6,0),(18,5,0),(19,4,0),(20,3,0),
(21,10,0),(22,9,0),(23,8,0),(24,7,0),(25,6,0),(26,5,0),(27,4,0),(28,3,0),(29,2,0),(30,1,0);

INSERT INTO t_role (role) VALUES ('ADMIN'),('CLIENT'),('GESTIONNAIRE'),('VENDEUR'),('LIVREUR');

INSERT INTO t_utilisateur (nom, email, motDePasse, idRole) VALUES
('Admin','admin@mail.com','admin',1),
('Client1','client1@mail.com','pass',2);

INSERT INTO t_commande (idUtilisateur, statut) VALUES (2,'EN_COURS');
INSERT INTO t_detailCommande (idCommande, idChaussure, quantite) VALUES (1, 3, 1);
INSERT INTO t_paiement (idCommande, montant) VALUES (1, 160.00);

CREATE TABLE t_promotion (
    id SERIAL PRIMARY KEY,
    idChaussure INT NOT NULL REFERENCES t_chaussure(id),
    global BOOLEAN DEFAULT FALSE,
    reduction NUMERIC(5,2) NOT NULL,
    dtnDebut TIMESTAMP NOT NULL DEFAULT NOW(),
    dtnFin TIMESTAMP NOT NULL
);

INSERT INTO t_promotion (idChaussure, global, reduction, dtnDebut, dtnFin) VALUES
(1, FALSE, 10.00, '2026-01-15 00:00', '2026-01-31 23:59'),
(2, FALSE, 15.00, '2026-01-10 00:00', '2026-01-25 23:59'),
(3, TRUE, 5.00, '2026-01-01 00:00', '2026-12-31 23:59'),
(4, FALSE, 20.00, '2026-01-20 00:00', '2026-02-05 23:59'),
(5, FALSE, 12.50, '2026-01-12 00:00', '2026-01-28 23:59');
