SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;



-- ---------------------- SECURITY SYSTEM ----------------------


--
-- Application accounts (aka user groups)
--

DROP TABLE IF EXISTS `accounts`;

CREATE TABLE `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `status` varchar(12) NOT NULL DEFAULT 'active' COMMENT 'active,locked,expired',
  `createdat` datetime NOT NULL,
  `updatedat` datetime DEFAULT NULL,
  `expirationdate` date DEFAULT NULL,
  `exportedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `accounts` (`id`, `name`, `code`, `createdat`) VALUES
(1, 'Visitors', '99536BF6-99D4-492E-BF2113DDAD7E6E51', NOW()),  
(2, 'Administrators', '3DADA579-39E7-4465-BB86D37F2A7ADC3E', NOW());


--
-- Application users
--

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountid` int(10) unsigned NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(64) NOT NULL,
  `accesslevel` tinyint(4) NOT NULL DEFAULT '1',
  `timezoneid` int(10) unsigned NOT NULL DEFAULT '27',
  `dateformat` varchar(24) NOT NULL DEFAULT 'dd mmm yyyy',
  `timeformat` varchar(24) NOT NULL DEFAULT 'hh:mm tt',
  `isactive` tinyint(4) NOT NULL DEFAULT '0',
  `isactivated` tinyint(4) NOT NULL DEFAULT '0',
  `createdat` datetime NOT NULL,
  `updatedat` datetime DEFAULT NULL,
  `visitedat` datetime DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `ix_users_email` (`email`),
  CONSTRAINT `fk_users_accountid` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

--
-- Data for table `users`
--

INSERT INTO `users` (`id`, `accountid`, `firstname`, `lastname`, `email`, `password`, `accesslevel`, `timezoneid`, `isactive`, `isactivated`, `createdat`) VALUES
(1, 1, 'Visitor', '', 'visitor@contactchimp.com', 'E589BCAC47F724CED4C481E8F5D203E0DF3790ED8953FB4DE8255EF2DC5E71AC', 0, 27, 1, 1, NOW()),  
(2, 2, 'David', 'Crowther', 'david.crowther@nervecentral.com', 'B1D4C0B7487557925C0FF6BA094FD4F1A080549E1EB8F9103EB9E54CAB726D23', 6, 27, 1, 1, NOW()),  
(3, 2, 'Sergey', 'Galashyn', 's.galashyn@ziost.com', '0C4A9412B48F162C320C98D403B5B214B2A50B6E60163307E89BF497A234A1FB', 6, 37, 1, 1, NOW()),  
(4, 2, 'Alex', 'Khodachenko', 'a.khodachenko@ziost.com', 'F20F9776C6053B7DB44C563836D2C8DFABA895DB6727A3C3C6D2B1CF6FEF137D', 6, 37, 1, 1, NOW()),  
(5, 2, 'Maimun', 'Smith', 'maimun.smith@gmail.com', '0D48AD0F7E3A538DC84D5432906C52923E081051EBE1E938A97953FD65DD54D6', 6, 37, 1, 1, NOW());  



-- ---------------------- LOGGING SYSTEM ----------------------


--
-- System log aka events journal
--

DROP TABLE IF EXISTS `currentevents`;

CREATE TABLE `currentevents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `accountid` int(10) unsigned DEFAULT NULL,
  `userid` int(10) unsigned DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `type` varchar(1) NOT NULL DEFAULT 'I' COMMENT 'I,W,E',
  `category` varchar(100) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  `detail` mediumtext DEFAULT NULL,
  `remoteip` varchar(15) NOT NULL,
  `createdat` datetime NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_currentevents_accountid` FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_currentevents_userid` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Archived (expired) records of system log 
--

DROP TABLE IF EXISTS `archivedevents`;

CREATE TABLE `archivedevents` (
  `id` int(10) unsigned NOT NULL,
  `userid` int(10) unsigned DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `type` varchar(1) DEFAULT NULL,
  `message` varchar(512) DEFAULT NULL,
  `detail` mediumtext DEFAULT NULL,
  `remoteip` varchar(15) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8;


--
-- Data changes history 
--

DROP TABLE IF EXISTS `currentchanges`;

CREATE TABLE `currentchanges` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(10) unsigned DEFAULT NULL,
  `type` varchar(1) NOT NULL COMMENT 'r(eplaced),d(eleted)',
  `modelcode` varchar(24) DEFAULT NULL,
  `modelid` int(10) unsigned DEFAULT NULL,
  `packet` mediumtext DEFAULT NULL,
  `createdat` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Archived (expired) records of data history
--

DROP TABLE IF EXISTS `archivedchanges`;

CREATE TABLE `archivedchanges` (
  `id` int(10) unsigned NOT NULL,
  `userid` int(10) unsigned DEFAULT NULL,
  `type` varchar(1) NOT NULL COMMENT 'r(eplaced),d(eleted)',
  `modelcode` varchar(24) DEFAULT NULL,
  `modelid` int(10) unsigned DEFAULT NULL,
  `packet` mediumtext DEFAULT NULL,
  `createdat` datetime DEFAULT NULL
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8;



-- ---------------------- PAGES & POSTS ----------------------


--
-- Available post/page statuses
--

DROP TABLE IF EXISTS `statuses`;

CREATE TABLE `statuses` (
  `statusid` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(100) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`statusid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `statuses` (`id`, `status`) VALUES 
(1, 'Publish'), 
(2, 'Draft');


--
-- Custom post/page categories
--

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `categoryid` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `createdby` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`categoryid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Custom page/post templates 
--

DROP TABLE IF EXISTS `templates`;

CREATE TABLE `templates` (
  `templateid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `templateName` varchar(255) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`templateid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Published and pending pages
--

DROP TABLE IF EXISTS `pages`;

CREATE TABLE `pages` (
  `pageid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `permalink` varchar(250) DEFAULT NULL,
  `navigationtitle` varchar(250) DEFAULT NULL,
  `content` text,
  `description` text,
  `parentid` int(11) DEFAULT '0',
  `templateid` int(11) DEFAULT NULL,
  `publishedby` int(11) DEFAULT NULL,
  `isprotected` bit(1) DEFAULT NULL,
  `issubpageprotected` bit(1) DEFAULT NULL,
  `password` varchar(250) DEFAULT NULL,
  `publisheddate` datetime DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `statusid` int(11) DEFAULT NULL,
  `showinnavigation` bit(1) DEFAULT b'1',
  `showinfooternavigation` bit(1) DEFAULT b'0',
  `updatedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`pageid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Published and pending posts
--

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `postid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `templateid` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `permalink` varchar(250) DEFAULT NULL,
  `content` text,
  `description` text,
  `publishedby` int(11) DEFAULT NULL,
  `publisheddate` datetime DEFAULT NULL,
  `statusid` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`postid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Posts linked to the categories
--

DROP TABLE IF EXISTS `postcategorymappings`;

CREATE TABLE `postcategorymappings` (
  `mappingid` int(11) NOT NULL AUTO_INCREMENT,
  `categoryid` int(11) DEFAULT NULL,
  `postid` int(11) DEFAULT NULL,
  PRIMARY KEY (`mappingid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



-- ---------------------- FILES ----------------------


--
-- Custom files
--

DROP TABLE IF EXISTS `files`;

CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `accountid` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `fileext` varchar(50) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `filesize` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



--
-- What's this?
--

DROP TABLE IF EXISTS `user_roles`;

CREATE TABLE `user_roles` (
  `roleid` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(100) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`roleid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



COMMIT;
SET FOREIGN_KEY_CHECKS=1;