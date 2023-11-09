Table Cinemas {
  CinemaID int [primary key]
  Nom varchar(255) [not null]
  Adresse varchar(255) [not null]
  AdminID int [not null] 
  UtilisateurID int [not null]
}

Table Films {
  FilmID int [primary key]
  Titre varchar(255) [not null]
  Description text
  Duree int [not null]
}

Table Projections {
  ProjectionID int [primary key]
  FilmID int [not null] 
  CinemaID int [not null] 
  HeureDeDebut datetime [not null]
  PlacesMax int [not null]
}

Table CategoriesDePrix {
  CategorieID int [primary key]
  Nom varchar(50) [not null]
  Prix decimal(6, 2) [not null]
}

Table Reservations {
  ReservationID int [primary key]
  ProjectionID int [not null] 
  UtilisateurID int [not null]
  PrixPlace int [not null]
  Paiement int [not null]
}

Table Utilisateurs {
  UtilisateurID int [primary key]
  NomUtilisateur varchar(50) [not null]
  CinemaID int 
}

Table Administrateur {
  AdminID int [primary key]
  NomAdminID int [not null] 
  CinemaID int [not null]
}

Table TypePaiement {
  PaiementID int [primary key]
  Type int [not null] 
}


Ref: Reservations.PrixPlace > CategoriesDePrix.Prix
Ref: Projections.FilmID > Films.FilmID
Ref: Projections.CinemaID > Cinemas.CinemaID
Ref: Reservations.ProjectionID > Projections.ProjectionID
Ref: Reservations.UtilisateurID > Utilisateurs.UtilisateurID
Ref: Utilisateurs.CinemaID > Cinemas.CinemaID
Ref: Utilisateurs.UtilisateurID > Cinemas.UtilisateurID
Ref: Reservations.Paiement > TypePaiement.PaiementID
Ref: Administrateur.CinemaID > Cinemas.CinemaID
