CREATE TABLE IF NOT EXISTS job (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255) NOT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
);

CREATE UNIQUE INDEX sync_v_job_id_uindex ON job (id);

CREATE TABLE IF NOT EXISTS job_position (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255) NOT NULL,
    `rank` bigint NOT NULL,
    job_id bigint NOT NULL,
    created_at datetime DEFAULT NULL,
    updated_at datetime DEFAULT NULL
  );

  CREATE UNIQUE INDEX sync_v_job_position_id_uindex ON job_position (id);
  CREATE INDEX sync_v_job_position_job_id_fk ON job_position (job_id);

  CREATE TABLE IF NOT EXISTS personage (
    id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    player_id bigint NOT NULL,
    `identity` longtext NOT NULL,
  model longtext NOT NULL,
  current_outfit longtext DEFAULT NULL,
  max_outfit bigint NOT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
);

CREATE UNIQUE INDEX sync_v_personage_id_uindex ON personage (id);
CREATE INDEX sync_v_character_player_id_fk ON personage (player_id);

CREATE TABLE IF NOT EXISTS personage_rp_role (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  rp_role_id bigint NOT NULL,
  personage_id bigint NOT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
);

CREATE UNIQUE INDEX sync_v_personage_rp_role_id_uindex ON personage_rp_role (id);
CREATE INDEX sync_v_character_role_role_id_fk ON personage_rp_role (rp_role_id);
CREATE INDEX sync_v_personage_rp_role_character_id_fk ON personage_rp_role (personage_id);

CREATE TABLE IF NOT EXISTS player (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  license_id varchar(255) NOT NULL,
  user_name varchar(255) NOT NULL,
  group_id bigint NOT NULL,
  citizen_level bigint NOT NULL,
  xp float NOT NULL,
  current_personage_id bigint DEFAULT NULL,
  max_personage bigint NOT NULL,
  banned tinyint(1) NOT NULL,
  last_location longtext DEFAULT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
);

CREATE UNIQUE INDEX sync_v_player_id_uindex ON player (id);

CREATE TABLE IF NOT EXISTS rp_role (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  job_id bigint NOT NULL,
  job_position_id bigint NOT NULL,
  permisions longtext NOT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
);

CREATE UNIQUE INDEX sync_v_rp_role_id_uindex ON rp_role (id);
CREATE INDEX sync_v_character_role_type_fk ON rp_role (job_id);
CREATE INDEX sync_v_character_role_position_id_fk ON rp_role (job_position_id);

CREATE TABLE IF NOT EXISTS outfit (
  id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
  personage_id bigint NOT NULL,
  name varchar(255) NOT NULL,
  clothes json NOT NULL,
  created_at datetime DEFAULT NULL,
  updated_at datetime DEFAULT NULL
);

ALTER TABLE job_position ADD CONSTRAINT job_position_job_id_fk FOREIGN KEY (job_id) REFERENCES job (id);
ALTER TABLE personage ADD CONSTRAINT character_player_id_fk FOREIGN KEY (player_id) REFERENCES player (id);
ALTER TABLE personage_rp_role ADD CONSTRAINT character_role_role_id_fk FOREIGN KEY (rp_role_id) REFERENCES rp_role (id);
ALTER TABLE personage_rp_role ADD CONSTRAINT personage_rp_role_character_id_fk FOREIGN KEY (personage_id) REFERENCES personage (id);
ALTER TABLE rp_role ADD CONSTRAINT character_role_position_id_fk FOREIGN KEY (job_position_id) REFERENCES job_position (id);
ALTER TABLE rp_role ADD CONSTRAINT character_role_type_fk FOREIGN KEY (job_id) REFERENCES job (id);
ALTER TABLE outfit ADD CONSTRAINT outfit_personage_id_fk FOREIGN KEY (personage_id) REFERENCES personage (id);