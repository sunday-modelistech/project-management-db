--------------------------------------------------------------
--	  POSTGRESQL Copyright (c) 2022, All rights reserved	--
--															--
--			USERNAME		: postgres						--
--			PASSWORD		: adminpostgres					--
--			HOST			: localhost						--
--			PORT			: 5432							--
--			DATABASE NAME	: projectmanagdb				--
--															--
--------------------------------------------------------------

-- -----------------------------------------------------------
--	SCHEMA CONTENANT LES OBJETS DE LA BASE DE DONNEES		--
-- -----------------------------------------------------------
DROP SCHEMA IF EXISTS projectmanag CASCADE;
CREATE SCHEMA projectmanag AUTHORIZATION postgres;

-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : ROLE							--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.role(
	role_id				SERIAL,
	nom			CHARACTER VARYING(200),
	slug			CHARACTER VARYING(100),
	date_creation		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_role PRIMARY KEY(role_id)
);


-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : UTILISATEUR						--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.utilisateur(
	utilisateur_id		SERIAL,
	nom				CHARACTER VARYING(200),
	login				CHARACTER VARYING(100),
	password 			CHARACTER VARYING(100),
	phone_number	CHARACTER VARYING(200),
	email 			CHARACTER VARYING(200),
	actif 				BOOLEAN DEFAULT FALSE,
	code_role			INTEGER NOT NULL,
	date_creation		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_utilisateur PRIMARY KEY(utilisateur_id)
);

CREATE INDEX idx_utilisateur_role ON projectmanag.utilisateur(code_role ASC);

-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : DIRECTION_REGIONALE				--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.direction_re(
	direction_re_id			SERIAL,
	nom		CHARACTER VARYING(200),
	slug			CHARACTER VARYING(100),
	date_creation	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_direction_re PRIMARY KEY(direction_re_id)
);

-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : UTILISATEUR_DIRECTION_REGIONALE	--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.utilisateur_dre(
	utilisateur_dre_id	SERIAL,
	code_utilisateur	INTEGER NOT NULL,
	code_direction_re	INTEGER NOT NULL,
	actif				BOOLEAN DEFAULT FALSE,
	date_creation		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_utilisateur_dre PRIMARY KEY(utilisateur_dre_id)
);

CREATE INDEX idx_utilisateur_dre_utilisateur ON projectmanag.utilisateur_dre(code_utilisateur ASC);
CREATE INDEX idx_utilisateur_dre_direction_re ON projectmanag.utilisateur_dre(code_direction_re ASC);


-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : CATEGORIE_DONNEE						--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.categorie_donnee(
	categorie_donnee_id			SERIAL,
	libelle		CHARACTER VARYING(200),
	slug			CHARACTER VARYING(100),
	date_creation	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_categorie_donnee PRIMARY KEY(categorie_donnee_id)
);

-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : FORMAT_DONNEE						--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.format_donnee(
	format_donnee_id			SERIAL,
	libelle		CHARACTER VARYING(200),
	slug			CHARACTER VARYING(100),
	date_creation	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_format_donnee PRIMARY KEY(format_donnee_id)
);


-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : DONNEE						--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.donnee(
	donnee_id			SERIAL,
	libelle		CHARACTER VARYING(200),
	slug			CHARACTER VARYING(100),
	urlpath			CHARACTER VARYING(200),
	code_categorie_donnee INTEGER NOT NULL,
	code_format_donnee INTEGER NOT NULL,
	date_creation	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_donnee PRIMARY KEY(donnee_id)
);

CREATE INDEX idx_donnee_categorie_donnee ON projectmanag.donnee(code_categorie_donnee ASC);
CREATE INDEX idx_donnee_format_donnee ON projectmanag.donnee(code_format_donnee ASC);


-- -----------------------------------------------------------
--	STRUCTURE DE LA TABLE : DIRECTION_REGIONALE_DONNEE		--
-- -----------------------------------------------------------
CREATE TABLE IF NOT EXISTS projectmanag.dre_donnee(
	dre_donnee_id		SERIAL,
	code_donnee			INTEGER NOT NULL,
	code_direction_re	INTEGER NOT NULL,
	date_creation		TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_dre_donnee PRIMARY KEY(dre_donnee_id)
);

CREATE INDEX idx_dre_donnee_donnee ON projectmanag.dre_donnee(code_donnee ASC);
CREATE INDEX idx_dre_donnee_direction_re ON projectmanag.dre_donnee(code_direction_re ASC);


-- ---------------------------------------------------------------
--	MODIFICATION DE LA TABLE : UTILISATEUR 						--
-- ---------------------------------------------------------------
ALTER TABLE projectmanag.utilisateur ADD CONSTRAINT fk_utilisateur_role FOREIGN KEY (code_role) 
	REFERENCES projectmanag.role(role_id);


-- ---------------------------------------------------------------
--	MODIFICATION DE LA TABLE : UTILISATEUR_DIRECTION_REGIONALE	--
-- ---------------------------------------------------------------
ALTER TABLE projectmanag.utilisateur_dre ADD CONSTRAINT fk_utilisateur_dre_utilisateur FOREIGN KEY (code_utilisateur) 
	REFERENCES projectmanag.utilisateur(utilisateur_id);
ALTER TABLE projectmanag.utilisateur_dre ADD CONSTRAINT fk_utilisateur_dre_direction_re FOREIGN KEY (code_direction_re) 
	REFERENCES projectmanag.direction_re(direction_re_id);


-- ---------------------------------------------------------------
--	MODIFICATION DE LA TABLE : DONNEE							--
-- ---------------------------------------------------------------
ALTER TABLE projectmanag.donnee ADD CONSTRAINT fk_donnee_categorie_donnee FOREIGN KEY (code_categorie_donnee) 
	REFERENCES projectmanag.categorie_donnee(categorie_donnee_id);
ALTER TABLE projectmanag.donnee ADD CONSTRAINT fk_donnee_format_donnee FOREIGN KEY (code_format_donnee) 
	REFERENCES projectmanag.format_donnee(format_donnee_id);


-- ---------------------------------------------------------------
--	MODIFICATION DE LA TABLE : DIRECTION_REGIONALE_DONNEE		--
-- ---------------------------------------------------------------
ALTER TABLE projectmanag.dre_donnee ADD CONSTRAINT fk_dre_donnee_donnee FOREIGN KEY (code_donnee) 
	REFERENCES projectmanag.donnee(donnee_id);
ALTER TABLE projectmanag.dre_donnee ADD CONSTRAINT fk_dre_donnee_direction_re FOREIGN KEY (code_direction_re) 
	REFERENCES projectmanag.direction_re(direction_re_id);


--------------------------------------------------------------
--	  INSERTION DES DONNEES DANS LA BASE DE DONNEES			--
--------------------------------------------------------------
INSERT INTO projectmanag.role(nom, slug)
	VALUES('DIRECTION', 'direction');
INSERT INTO projectmanag.role(nom, slug)
	VALUES('SUPERVISEUR', 'superviseur');
INSERT INTO projectmanag.role(nom, slug)
	VALUES('RESPONSABLE DR', 'responsable_dr');