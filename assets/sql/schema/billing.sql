SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;


DROP TABLE IF EXISTS `features`;
DROP TABLE IF EXISTS `plans`;
DROP TABLE IF EXISTS `discounts`;
DROP TABLE IF EXISTS `quotas`;
DROP TABLE IF EXISTS `accountplans`;
DROP TABLE IF EXISTS `accountquotas`;
-- TODO: DROP TABLE IF EXISTS `payments`;


--
-- Features limited by quotas
--

CREATE TABLE `features` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(32) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `description` varchar(512) DEFAULT NULL,
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ixu_features_token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Current and archived billing plans
--

CREATE TABLE `plans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `price` decimal(7,2) NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `ispublic` tinyint(4) NOT NULL DEFAULT '1',
  `createdat` datetime NOT NULL,
  `createdby` int(10) unsigned DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Current and archived discounts
--

CREATE TABLE `discounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `coupon` varchar(50) DEFAULT NULL,
  `discount` smallint(6) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `expirationdate` date DEFAULT NULL,
  `createdat` datetime NOT NULL,
  `createdby` int(10) unsigned DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_discounts_coupon`(`coupon`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Quota values for features/plans
--

CREATE TABLE `quotas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `featureid` int(10) unsigned NOT NULL,
  `planid` int(10) unsigned NOT NULL,
  `quota` int(10) unsigned NOT NULL DEFAULT '0',
  `createdat` datetime NOT NULL,
  `createdby` int(10) unsigned DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ixu_quotas_compositekey` (`featureid`,`planid`),
  CONSTRAINT `fk_quotas_featureid` FOREIGN KEY (`featureid`) REFERENCES `features` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_quotas_planid` FOREIGN KEY (`planid`) REFERENCES `plans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Account plans and prices
--

CREATE TABLE `accountplans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountid` int(10) unsigned NOT NULL,
  `planid` int(10) unsigned NOT NULL,
  `discountid` int(10) unsigned NOT NULL,
  `price` decimal(7,2) NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `createdat` datetime NOT NULL,
  `createdby` int(10) unsigned DEFAULT NULL,
  `renewedat` datetime NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_accountplans_accountid` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_accountplans_planid` FOREIGN KEY (`planid`) REFERENCES `plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_accountplans_discountid` FOREIGN KEY (`discountid`) REFERENCES `discounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Account quotas and values
--

CREATE TABLE `accountquotas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountid` int(10) unsigned NOT NULL,
  `quotaid` int(10) unsigned NOT NULL,
  `accountplanid` int(10) unsigned NOT NULL,
  `quota` int(10) unsigned NOT NULL DEFAULT '0',
  `isactive` tinyint(4) NOT NULL DEFAULT '1',
  `createdat` datetime NOT NULL,
  `createdby` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_accountquotas_accountid` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_accountquotas_quotaid` FOREIGN KEY (`quotaid`) REFERENCES `quotas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_accountquotas_accountplanid` FOREIGN KEY (`accountplanid`) REFERENCES `accountplans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



COMMIT;
SET FOREIGN_KEY_CHECKS=1;