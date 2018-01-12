CREATE TABLE `fcm_nutzer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) CHARACTER 
  		SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `vorlesung_id` varchar(255) CHARACTER 
  		SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `os` int(11) DEFAULT '0',
  `language` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `vorlesung_id` (`vorlesung_id`)
  );