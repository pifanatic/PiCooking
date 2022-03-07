-- generate the tables needed for PiCooking

DROP TABLE IF EXISTS 'Users';
DROP TABLE IF EXISTS 'Recipes';
DROP TABLE IF EXISTS 'Categories';
DROP TABLE IF EXISTS 'RecipesCategories';

CREATE TABLE 'Users' (
    id            INTEGER   PRIMARY KEY,
    username      TEXT,
    password      TEXT,
    first_name    TEXT
);

CREATE TABLE 'Recipes' (
    id                      INTEGER     PRIMARY KEY,
    title                   TEXT        NOT NULL,
    ingredients             TEXT        NOT NULL,
    instructions            TEXT        NOT NULL,
    created                 DATE        NOT NULL,
    in_trash                INTEGER     NOT NULL DEFAULT 0,
    user_id                 INTEGER     NOT NULL,
    FOREIGN KEY(user_id)    REFERENCES Users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE 'Categories' (
    id                      INTEGER     PRIMARY KEY,
    name                    TEXT        NOT NULL,
    user_id                 INTEGER     NOT NULL,
    FOREIGN KEY(user_id) REFERENCES Users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE 'RecipesCategories' (
    id                      INTEGER     PRIMARY KEY,
    recipe_id                 INTEGER     NOT NULL,
    category_id                  INTEGER     NOT NULL,
    FOREIGN KEY(recipe_id) REFERENCES Recipes(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES Categories(id) ON UPDATE CASCADE ON DELETE CASCADE
);
