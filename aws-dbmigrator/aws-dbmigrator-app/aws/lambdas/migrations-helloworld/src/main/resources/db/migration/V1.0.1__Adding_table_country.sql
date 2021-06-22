CREATE TABLE IF NOT EXISTS `country` (
  `alpha2` char(2) NOT NULL PRIMARY KEY,
  `alpha3` char(3) NOT NULL,
  `name` varchar(128)
);

INSERT INTO `country` (`alpha2`, `alpha3`, `name`)
VALUES
('fr', 'fre', 'France'),
('be', 'bel', 'Belgium'),
('lu', 'lux', 'Luxembourg'),
('de', 'deu', 'Germany');
