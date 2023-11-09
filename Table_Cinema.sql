CREATE TABLE Cinemas (
    CinemaID INT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,
    Adresse VARCHAR(255) NOT NULL,
    AdminID INT NOT NULL,
    UtilisateurID INT NOT NULL
);

CREATE TABLE Films (
    FilmID INT PRIMARY KEY,
    Titre VARCHAR(255) NOT NULL,
    Description TEXT,
    Duree INT NOT NULL
);

CREATE TABLE Projections (
    ProjectionID INT PRIMARY KEY,
    FilmID INT NOT NULL,
    CinemaID INT NOT NULL,
    HeureDeDebut DATETIME NOT NULL,
    PlacesMax INT NOT NULL
);

CREATE TABLE CategoriesDePrix (
    CategorieID INT PRIMARY KEY,
    Nom VARCHAR(50) NOT NULL,
    Prix DECIMAL(6, 2) NOT NULL
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,
    ProjectionID INT NOT NULL,
    UtilisateurID INT NOT NULL,
    PrixPlace INT NOT NULL,
    Paiement INT NOT NULL
);

CREATE TABLE Utilisateurs (
    UtilisateurID INT PRIMARY KEY,
    NomUtilisateur VARCHAR(50) NOT NULL,
    CinemaID INT
);

CREATE TABLE Administrateur (
    AdminID INT PRIMARY KEY,
    NomAdminID INT NOT NULL,
    CinemaID INT NOT NULL
);

CREATE TABLE TypePaiement (
    PaiementID INT PRIMARY KEY,
    Type INT NOT NULL
);

-- Ajout des contraintes de clé étrangère
ALTER TABLE Cinemas ADD FOREIGN KEY (AdminID) REFERENCES Administrateur(AdminID);
ALTER TABLE Cinemas ADD FOREIGN KEY (UtilisateurID) REFERENCES Utilisateurs(UtilisateurID);

ALTER TABLE Projections ADD FOREIGN KEY (FilmID) REFERENCES Films(FilmID);
ALTER TABLE Projections ADD FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID);

ALTER TABLE Reservations ADD FOREIGN KEY (ProjectionID) REFERENCES Projections(ProjectionID);
ALTER TABLE Reservations ADD FOREIGN KEY (UtilisateurID) REFERENCES Utilisateurs(UtilisateurID);

ALTER TABLE Utilisateurs ADD FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID);

ALTER TABLE Administrateur ADD FOREIGN KEY (CinemaID) REFERENCES Cinemas(CinemaID);

ALTER TABLE Reservations ADD FOREIGN KEY (Paiement) REFERENCES TypePaiement(PaiementID);



-- Premières Requetes pour initialisation avant utilisation --

-- initialisation des prix --
INSERT INTO CategoriesDePrix (Nom, Prix) VALUES ('Moins de 14 ans', 5.90);
INSERT INTO CategoriesDePrix (Nom, Prix) VALUES ('Etudiant', 7.60);
INSERT INTO CategoriesDePrix (Nom, Prix) VALUES ('Plein tarif', 9.20);

-- initialisation des paiement --
INSERT INTO TypePaiement (PaiementID, Type) VALUES (1, 'Sur place');
INSERT INTO TypePaiement (PaiementID, Type) VALUES (2, 'En ligne');

-- initialisation d'un nouveau cinema --
INSERT INTO Cinemas (Nom, Adresse, AdminID, UtilisateurID) VALUES ('Nom du Cinéma', 'Adresse du Cinéma', 1 /*ID de l'administrateur*/, 2 /*ID de l'utilisateur*/);

-- Création d'une projection --
INSERT INTO Projections (FilmID, CinemaID, HeureDeDebut, PlacesMax) VALUES (1 /*ID du film*/, 1 /*ID du cinéma*/, '2023-11-09 19:30:00', 150);

-- Mettre un film à l'affiche --
INSERT INTO Films (Titre, Description, Duree) VALUES ('Titre du Film', 'Description du Film', 120);

-- Pour créer un administrateur --
INSERT INTO Administrateur (NomAdminID, CinemaID) VALUES ('Nom de l''Administrateur', 1 /*ID du cinéma*/);

-- Pour faire une nouvelle réservation --
INSERT INTO Reservations (ProjectionID, UtilisateurID, PrixPlace, Paiement) VALUES (1 /*ID de la projection*/, 3 /*ID de l'utilisateur*/, 9.20 /*Prix de la place*/, 1 /*ID du type de paiement*/);

-- Pour créer un utilisateur --
-- Remplacez les valeurs entre parenthèses par les détails spécifiques du nouvel utilisateur
INSERT INTO Utilisateurs (NomUtilisateur, CinemaID) VALUES ('Nom de l''Utilisateur', 1 /*ID du cinéma*/);



-- Script factice -- 
-- Nouveau client --
INSERT INTO Utilisateurs (NomUtilisateur, CinemaID) VALUES ('Pierre', 1);
-- Modifier le nom d'un client (utilisateur) --
UPDATE Utilisateurs SET NomUtilisateur = 'Jacques' WHERE UtilisateurID = 1; 


-- Nouvel administrateur --
INSERT INTO Administrateur (NomAdminID, CinemaID) VALUES ('AdminJean', 2);
-- Modifier le cinema de l'administrateur --
UPDATE Administrateur SET CinemaID = 2 WHERE AdminID = 1; 


-- Nouvelle reservation -- 
INSERT INTO Reservations (ProjectionID, UtilisateurID, PrixPlace, Paiement) VALUES (1, 2, 9.20, 1);
-- Supprimer une reservation --
DELETE FROM Reservations WHERE ReservationID = 1;  


-- Mettre un film à l'affiche --
INSERT INTO Films (Titre, Description, Duree) VALUES ('Titanic', 'Southampton, 10 avril 1912. Le paquebot le plus grand et le plus moderne du monde, réputé pour son insubmersibilité, le "Titanic", appareille pour son premier voyage. Quatre jours plus tard, il heurte un iceberg. A son bord, un artiste pauvre et une grande bourgeoise tombent amoureux.', 194);
-- Supprimer un film à l'affiche -- 
DELETE FROM Films WHERE FilmID = 1; 

-- Créer une projection --
INSERT INTO Projections (FilmID, CinemaID, HeureDeDebut, PlacesMax) VALUES (1, 1, '2023-11-09 19:30:00', 150);
-- Supprimer une projection --
DELETE FROM Projections WHERE ProjectionID = 1;

-- Pour consulter le nombre de reservation pour une projection --
SELECT COUNT(*) AS NombreDeReservations FROM Reservations WHERE ProjectionID = 1;

-- Pour consulter les films à l'affiche --
SELECT Films.Titre, Projections.HeureDeDebut, Projections.PlacesMax FROM Films JOIN Projections ON Films.FilmID = Projections.FilmID;
