CREATE SCHEMA IF NOT EXISTS modular_server;

CREATE TABLE IF NOT EXISTS modular_server.job (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255) NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

CREATE UNIQUE INDEX modular_server_job_id_uindex ON modular_server.job (id);

CREATE TABLE IF NOT EXISTS modular_server.job_position (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255) NOT NULL,
  rank bigint NOT NULL,
  job_id bigint NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

CREATE UNIQUE INDEX modular_server_job_position_id_uindex ON modular_server.job_position (id);
CREATE INDEX modular_server_job_position_job_id_fk ON modular_server.job_position (job_id);

CREATE TABLE IF NOT EXISTS modular_server.personage (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  player_id bigint NOT NULL,
  information longtext NOT NULL,
  model longtext NOT NULL,
  current_outfit longtext DEFAULT NULL,
  max_outfit bigint NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

CREATE UNIQUE INDEX modular_server_personage_id_uindex ON modular_server.personage (id);
CREATE INDEX modular_server_character_player_id_fk ON modular_server.personage (player_id);

CREATE TABLE IF NOT EXISTS modular_server.personage_rp_role (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  rp_role_id bigint NOT NULL,
  personage_id bigint NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

CREATE UNIQUE INDEX modular_server_personage_rp_role_id_uindex ON modular_server.personage_rp_role (id);
CREATE INDEX modular_server_character_role_role_id_fk ON modular_server.personage_rp_role (rp_role_id);
CREATE INDEX modular_server_personage_rp_role_character_id_fk ON modular_server.personage_rp_role (personage_id);

CREATE TABLE IF NOT EXISTS modular_server.player (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  license_id varchar(255) NOT NULL,
  group_id bigint NOT NULL,
  citizen_level bigint NOT NULL,
  xp float NOT NULL,
  current_personage_id bigint DEFAULT NULL,
  max_personage bigint NOT NULL,
  banned tinyint(1) NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

CREATE UNIQUE INDEX modular_server_player_id_uindex ON modular_server.player (id);

CREATE TABLE IF NOT EXISTS modular_server.rp_role (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id bigint NOT NULL,
  job_position_id bigint NOT NULL,
  permisions longtext NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

CREATE UNIQUE INDEX modular_server_rp_role_id_uindex ON modular_server.rp_role (id);
CREATE INDEX modular_server_character_role_type_fk ON modular_server.rp_role (job_id);
CREATE INDEX modular_server_character_role_position_id_fk ON modular_server.rp_role (job_position_id);

CREATE TABLE IF NOT EXISTS outfit (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  personage_id bigint NOT NULL,
  name varchar(255) NOT NULL,
  clothes json NOT NULL,
  created_at date DEFAULT NULL,
  updated_at date DEFAULT NULL
);

ALTER TABLE modular_server.job_position ADD CONSTRAINT job_position_job_id_fk FOREIGN KEY (job_id) REFERENCES modular_server.job (id);
ALTER TABLE modular_server.personage ADD CONSTRAINT character_player_id_fk FOREIGN KEY (player_id) REFERENCES modular_server.player (id);
ALTER TABLE modular_server.personage_rp_role ADD CONSTRAINT character_role_role_id_fk FOREIGN KEY (rp_role_id) REFERENCES modular_server.rp_role (id);
ALTER TABLE modular_server.personage_rp_role ADD CONSTRAINT personage_rp_role_character_id_fk FOREIGN KEY (personage_id) REFERENCES modular_server.personage (id);
ALTER TABLE modular_server.rp_role ADD CONSTRAINT character_role_position_id_fk FOREIGN KEY (job_position_id) REFERENCES modular_server.job_position (id);
ALTER TABLE modular_server.rp_role ADD CONSTRAINT character_role_type_fk FOREIGN KEY (job_id) REFERENCES modular_server.job (id);
ALTER TABLE outfit ADD CONSTRAINT outfit_personage_id_fk FOREIGN KEY (personage_id) REFERENCES modular_server.personage (id);