<?php
// auth.php

class User
{
    private string $id;
    private string $email;
    private string $password;
    private array $roles = [];

    // ... (méthodes d'accès aux propriétés)

    public function addRole(string $role): void
    {
        $this->roles[] = $role;
    }

    public function getRoles(): array
    {
        return $this->roles;
    }
}

function connectUser(PDO $pdo, string $email, string $password): ?User
{
    $statement = $pdo->prepare('SELECT * FROM users WHERE email = :email');
    $statement->bindValue(':email', $email);

    if ($statement->execute()) {
        $user = $statement->fetch(PDO::FETCH_ASSOC);

        if ($user !== false && password_verify($password, $user['password'])) {
            return new User($user['id'], $user['email'], $user['password']);
        }
    }

    return null;
}

function fetchUserRoles(PDO $pdo, User $user): void
{
    $statement = $pdo->prepare('SELECT * FROM userRoles JOIN roles ON roles.id = userRoles.roleId WHERE id = :id');
    $statement->bindValue(':id', $user->getId());

    if ($statement->execute()) {
        while ($role = $statement->fetch(PDO::FETCH_ASSOC)) {
            $user->addRole($role['name']);
        }
    }
}

function hasRole(User $user, string $role): bool
{
    return in_array($role, $user->getRoles());
}

// Exemples d'utilisation

$pdo = new PDO('mysql:host=localhost;dbname=mydatabase', 'root', '');

// Inscription
$statement = $pdo->prepare('INSERT INTO users(email, username, password) VALUES (:email, :username, :password)');
$statement->bindValue(':email', 'john@doe.fr');
$statement->bindValue(':username', 'john');
$statement->bindValue(':password', password_hash('p4$$w0rd', PASSWORD_BCRYPT));

if ($statement->execute()) {
    echo 'L\'utilisateur a bien été créé';
} else {
    echo 'Impossible de créer l\'utilisateur';
}

// Connexion
$user = connectUser($pdo, 'john@doe.fr', 'p4$$w0rd');

if ($user !== null) {
    fetchUserRoles($pdo, $user);

    if (hasRole($user, 'ROLE_MANAGER')) {
        // Faire quelque chose pour les utilisateurs avec le rôle ROLE_MANAGER
        echo 'Bienvenue Manager ' . $user->getUsername();
    } else {
        echo 'Bienvenue ' . $user->getUsername();
    }
}
