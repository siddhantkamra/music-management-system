CREATE TABLE IF NOT EXISTS artist (
    id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS album (
    id INT AUTO_INCREMENT PRIMARY KEY,
    album_name VARCHAR(255),
    artist_id INT,
    FOREIGN KEY (artist_id) REFERENCES artist(id)
);

CREATE TABLE IF NOT EXISTS genre (
    id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255) UNIQUE
);

CREATE TABLE IF NOT EXISTS track (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    album_id INT,
    genre_id INT,
    artist_id INT,
    rlsyr INT,
    FOREIGN KEY (album_id) REFERENCES album(id),
    FOREIGN KEY (genre_id) REFERENCES genre(id),
    FOREIGN KEY (artist_id) REFERENCES artist(id)
);


CREATE TABLE IF NOT EXISTS artist_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_name VARCHAR(255),
    operation VARCHAR(10),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS album_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    album_name VARCHAR(255),
    artist_id INT,
    operation VARCHAR(10),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS genre_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255),
    operation VARCHAR(10),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS track_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    album_id INT,
    genre_id INT,
    artist_id INT,
    rlsyr INT,
    operation VARCHAR(10),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER after_artist_insert
AFTER INSERT ON artist
FOR EACH ROW
BEGIN
    INSERT INTO artist_log (artist_name, operation)
    VALUES (NEW.artist_name, 'INSERT');
END//

CREATE TRIGGER after_artist_update
AFTER UPDATE ON artist
FOR EACH ROW
BEGIN
    INSERT INTO artist_log (artist_name, operation)
    VALUES (NEW.artist_name, 'UPDATE');
END//

CREATE TRIGGER after_artist_delete
AFTER DELETE ON artist
FOR EACH ROW
BEGIN
    INSERT INTO artist_log (artist_name, operation)
    VALUES (OLD.artist_name, 'DELETE');
END//

-- Triggers for album table
CREATE TRIGGER after_album_insert
AFTER INSERT ON album
FOR EACH ROW
BEGIN
    INSERT INTO album_log (album_name, artist_id, operation)
    VALUES (NEW.album_name, NEW.artist_id, 'INSERT');
END//

CREATE TRIGGER after_album_update
AFTER UPDATE ON album
FOR EACH ROW
BEGIN
    INSERT INTO album_log (album_name, artist_id, operation)
    VALUES (NEW.album_name, NEW.artist_id, 'UPDATE');
END//

CREATE TRIGGER after_album_delete
AFTER DELETE ON album
FOR EACH ROW
BEGIN
    INSERT INTO album_log (album_name, artist_id, operation)
    VALUES (OLD.album_name, OLD.artist_id, 'DELETE');
END//

-- Triggers for genre table
CREATE TRIGGER after_genre_insert
AFTER INSERT ON genre
FOR EACH ROW
BEGIN
    INSERT INTO genre_log (genre_name, operation)
    VALUES (NEW.genre_name, 'INSERT');
END//

CREATE TRIGGER after_genre_update
AFTER UPDATE ON genre
FOR EACH ROW
BEGIN
    INSERT INTO genre_log (genre_name, operation)
    VALUES (NEW.genre_name, 'UPDATE');
END//

CREATE TRIGGER after_genre_delete
AFTER DELETE ON genre
FOR EACH ROW
BEGIN
    INSERT INTO genre_log (genre_name, operation)
    VALUES (OLD.genre_name, 'DELETE');
END//

-- Triggers for track table
CREATE TRIGGER after_track_insert
AFTER INSERT ON track
FOR EACH ROW
BEGIN
    INSERT INTO track_log (title, album_id, genre_id, artist_id, rlsyr, operation)
    VALUES (NEW.title, NEW.album_id, NEW.genre_id, NEW.artist_id, NEW.rlsyr, 'INSERT');
END//

CREATE TRIGGER after_track_update
AFTER UPDATE ON track
FOR EACH ROW
BEGIN
    INSERT INTO track_log (title, album_id, genre_id, artist_id, rlsyr, operation)
    VALUES (NEW.title, NEW.album_id, NEW.genre_id, NEW.artist_id, NEW.rlsyr, 'UPDATE');
END//

CREATE TRIGGER after_track_delete
AFTER DELETE ON track
FOR EACH ROW
BEGIN
    INSERT INTO track_log (title, album_id, genre_id, artist_id, rlsyr, operation)
    VALUES (OLD.title, OLD.album_id, OLD.genre_id, OLD.artist_id, OLD.rlsyr, 'DELETE');
END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE insert_track(
    IN track_title VARCHAR(255),
    IN track_album_id INT,
    IN track_genre_id INT,
    IN track_artist_id INT,
    IN track_rlsyr INT
)
BEGIN
    DECLARE track_exists INT DEFAULT 0;
    SELECT COUNT(*) INTO track_exists
    FROM track
    WHERE track.title = insert_track.track_title
        AND track.album_id = insert_track.track_album_id
        AND track.genre_id = insert_track.track_genre_id
        AND track.artist_id = insert_track.track_artist_id
        AND track.rlsyr = insert_track.track_rlsyr;

    IF track_exists = 0 THEN
        INSERT INTO track (title, album_id, genre_id, artist_id, rlsyr)
        VALUES (insert_track.track_title, insert_track.track_album_id, insert_track.track_genre_id, insert_track.track_artist_id, insert_track.track_rlsyr);
        SELECT CONCAT('Track inserted: ', insert_track.track_title) AS 'Success';
    ELSE
        SELECT CONCAT('Track already exists: ', insert_track.track_title) AS 'Warning';
    END IF;
END//

DELIMITER ;