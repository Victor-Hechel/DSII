CREATE TABLE comunicadores (id SERIAL PRIMARY KEY,
			    			nome VARCHAR(50) NOT NULL);

CREATE TYPE dias AS ENUM('Segunda', 'Terca', 'Quarta', 'Quinta', 'Sexta', 'Sabado', 'Domingo'); 

CREATE TABLE programas (id SERIAL PRIMARY KEY,
						nome VARCHAR(20) NOT NULL,
						duracao TIME NOT NULL,
						inicio TIME NOT NULL,
						fim TIME NOT NULL,
						dia dias NOT NULL,
						id_comunicador INTEGER REFERENCES comunicadores(id)
						ON DELETE CASCADE);

INSERT INTO comunicadores(nome) VALUES ('Alcemar');

INSERT INTO programas(nome, duracao, inicio, fim, dia, id_comunicador) VALUES ('Pretinho Basico', '2:00', '14:00', '16:00', 'Terca', 1);

CREATE TABLE admins(id SERIAL PRIMARY KEY, login VARCHAR(20) NOT NULL, senha VARCHAR(20) NOT NULL);

INSERT INTO admins VALUES (DEFAULT, 'admin1', '12345');
INSERT INTO admins VALUES (DEFAULT, 'admin2', '54321');

ALTER TABLE comunicadores ADD COLUMN formato VARCHAR(5);
ALTER TABLE programas ADD COLUMN formato VARCHAR(5);


