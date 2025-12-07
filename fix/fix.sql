
-- 1.)
ALTER TABLE ps_tab
  MODIFY class_name VARCHAR(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_uca1400_ai_ci NOT NULL,
  MODIFY module VARCHAR(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_uca1400_ai_ci DEFAULT NULL;


CREATE TABLE ps_tab_transit (
    id_tab_transit INT AUTO_INCREMENT PRIMARY KEY,
    `key` VARCHAR(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_uca1400_ai_ci NOT NULL,
    id_new_tab INT DEFAULT NULL
);

INSERT INTO ps_tab_transit (`key`)
SELECT CONCAT(class_name, COALESCE(module, ''))
FROM ps_tab;

UPDATE ps_tab_transit tt
JOIN ps_tab t
  ON CONCAT(t.class_name, COALESCE(t.module, '')) COLLATE utf8mb3_uca1400_ai_ci =
     tt.`key` COLLATE utf8mb3_uca1400_ai_ci
SET tt.id_new_tab = t.id_tab;

-- 2.) 
CREATE TABLE ps_pagenotfound (
    id_pagenotfound INT AUTO_INCREMENT PRIMARY KEY,
    request_uri VARCHAR(255) DEFAULT NULL,
    http_referer VARCHAR(255) DEFAULT NULL,
    date_add DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3.)
CREATE TABLE ps_statssearch (
    id_statssearch INT AUTO_INCREMENT PRIMARY KEY,
    keywords VARCHAR(255) NOT NULL,
    date_add DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- 4.)
CREATE TABLE ps_translation (
    id_translation INT AUTO_INCREMENT PRIMARY KEY,
    id_lang INT NOT NULL,
    `key` TEXT NOT NULL,
    translation TEXT NOT NULL,
    domain VARCHAR(80) NOT NULL,
    theme VARCHAR(32) DEFAULT NULL,
    INDEX IDX_translation_id_lang (id_lang),
    INDEX IDX_translation_domain (domain)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 5.)
CREATE TABLE ps_attribute_tmp (
    id_attribute INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    id_attribute_group INT(10) UNSIGNED NOT NULL,
    color VARCHAR(32) NOT NULL,
    position INT(10) UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id_attribute),
    KEY (id_attribute_group)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO ps_attribute_tmp (id_attribute, id_attribute_group, color, position)
SELECT
    id_attribute,
    id_attribute_group,
    COALESCE(NULLIF(color, ''), '') AS color,
    position
FROM ps_attribute;

UPDATE ps_attribute_tmp SET color = '' WHERE color IS NULL;

DROP TABLE ps_attribute;

RENAME TABLE ps_attribute_tmp TO ps_attribute;

ALTER TABLE ps_attribute
MODIFY color VARCHAR(64) NOT NULL;