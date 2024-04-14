-- Crear la base de datos

CREATE DATABASE desafio3_reinaldo_lopez_123;

-- Crear la tabla Usuarios. 

CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

-- Crear 5 usuarios.

insert into Usuarios (email, nombre, apellido, rol) values ('first0@gmail.com', 'first', 'person', 'administrador');
insert into Usuarios (email, nombre, apellido, rol) values ('second@gmail.com', 'second', 'user', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('third@gmail.com', 'third', 'individual', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('fourth@gmail.com', 'fourth', 'human', 'usuario');
insert into Usuarios (email, nombre, apellido, rol) values ('fifth@gmail.com', 'fifth', 'bot', 'usuario');

-- Crear la tabla Posts (artículos).


CREATE TABLE "Posts (artículos)" (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    fecha_actualizacion TIMESTAMP NOT NULL,
    destacado BOOLEAN DEFAULT false,
    usuario_id BIGINT
);

-- Crear los 5 posts.

INSERT INTO "Posts (artículos)" (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES 
    ('Articulo 1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', '2024-01-01', '2024-01-02', true, 2),
    ('Segundo articulo', 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', '2024-01-02', '2024-02-03', true, 2),
    ('El tercero', 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.', '2024-03-04', '2024-04-05', true, 1),
    ('Vamos con el 4to', 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '2024-05-05', '2024-05-06', false, 3),
    ('finalmente el 5to', 'Aliquet nec ullamcorper sit amet risus nullam eget felis. Consectetur adipiscing elit pellentesque habitant morbi tristique.', '2024-06-06', '2024-06-07', false, NULL);

-- Crear la tabla Comentarios.

CREATE TABLE Comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL,
    usuario_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL
);

-- Crear los 5 comentarios.

INSERT INTO Comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES 
    ('Comentario primero.', '2024-07-17', 1, 1),
    ('Segundo comentario', '2024-05-28', 2, 1),
    ('El tercer comentario', '2024-04-24', 3, 1),
    ('Comentario numero 4', '2024-01-12', 1, 2),
    ('5to comentario', '2024-05-17', 2, 2);

-- 1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido. 

-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y 
-- email del usuario junto al título y contenido del post.

SELECT Usuarios.nombre, Usuarios.email, "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores. 
-- El administrador puede ser cualquier id.

SELECT "Posts (artículos)".id, "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM "Posts (artículos)"
JOIN Usuarios ON "Posts (artículos)".usuario_id = Usuarios.id
WHERE Usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.

SELECT Usuarios.id, Usuarios.email, COUNT("Posts (artículos)".id) AS cantidad_posts
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.id, Usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts. 

SELECT Usuarios.email, COUNT("Posts (artículos)".id) AS cantidad_posts
FROM Usuarios
INNER JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.email
ORDER BY cantidad_posts DESC
LIMIT 1;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT Usuarios.email, "Posts (artículos)".titulo, MAX("Posts (artículos)".fecha_creacion) AS fecha_ultimo_post
FROM Usuarios
LEFT JOIN "Posts (artículos)" ON Usuarios.id = "Posts (artículos)".usuario_id
GROUP BY Usuarios.email, "Posts (artículos)".titulo;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios. (debe mostrar titulo del post, 
--contenido del post y cantidad de comentarios)

SELECT "Posts (artículos)".titulo, "Posts (artículos)".contenido, COUNT(Comentarios.id) AS cantidad_comentarios
FROM "Posts (artículos)"
LEFT JOIN Comentarios ON "Posts (artículos)".id = Comentarios.post_id
GROUP BY "Posts (artículos)".titulo, "Posts (artículos)".contenido
ORDER BY cantidad_comentarios DESC
LIMIT 1;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada 
-- comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.

SELECT "Posts (artículos)".titulo, "Posts (artículos)".contenido
FROM "Posts (artículos)"
LEFT JOIN Comentarios ON "Posts (artículos)".id = Comentarios.post_id

SELECT
    "Posts (artículos)".titulo AS titulo_post,
    "Posts (artículos)".contenido AS contenido_post,
    Comentarios.contenido AS contenido_comentario,
    Usuarios.email AS email_usuario
FROM
    "Posts (artículos)"
JOIN
    Comentarios ON "Posts (artículos)".id = Comentarios.post_id
JOIN
    Usuarios ON Comentarios.usuario_id = Usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario.

SELECT
    Usuarios.email AS email_usuario,
    Comentarios.contenido AS contenido_ultimo_comentario
FROM
    Usuarios
JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
LEFT JOIN Comentarios AS com2 ON Comentarios.usuario_id = com2.usuario_id AND Comentarios.fecha_creacion < com2.fecha_creacion
WHERE
    com2.fecha_creacion IS NULL;

-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.

SELECT Usuarios.email
FROM Usuarios
LEFT JOIN Comentarios ON Usuarios.id = Comentarios.usuario_id
GROUP BY Usuarios.id, Usuarios.email
HAVING COUNT(Comentarios.id) = 0;