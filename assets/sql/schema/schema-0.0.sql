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
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` varchar(100) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `statuses` (`id`, `status`) VALUES 
(1, 'Publish'),
(2, 'Draft');


--
-- Custom post/page categories
--

DROP TABLE IF EXISTS `categories`;

CREATE TABLE `categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(255) NOT NULL,
  `createdby` int(10) unsigned DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `updatedby` int(10) unsigned DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_categories_createdby` FOREIGN KEY (`createdby`) REFERENCES `users` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_categories_updatedby` FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Custom page/post templates 
--

DROP TABLE IF EXISTS `templates`;

CREATE TABLE `templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(10) unsigned DEFAULT NULL,
  `templateName` varchar(255) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_templates_userid` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Published and pending pages
--

DROP TABLE IF EXISTS `pages`;

CREATE TABLE `pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(10) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `permalink` varchar(250) DEFAULT NULL,
  `navigationtitle` varchar(250) DEFAULT NULL,
  `content` text,
  `description` text,
  `parentid` int(10) unsigned DEFAULT '0',
  `templateid` int(10) unsigned DEFAULT NULL,
  `publishedby` int(10) unsigned DEFAULT NULL,
  `isprotected` bit(1) DEFAULT NULL,
  `issubpageprotected` bit(1) DEFAULT NULL,
  `password` varchar(250) DEFAULT NULL,
  `publisheddate` datetime DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `statusid` int(10) unsigned DEFAULT NULL,
  `showinnavigation` bit(1) DEFAULT b'1',
  `showinfooternavigation` bit(1) DEFAULT b'0',
  `updatedby` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pages_userid` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_pages_parentid` FOREIGN KEY (`parentid`) REFERENCES `pages` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_pages_templateid` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_pages_publishedby` FOREIGN KEY (`publishedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_pages_statusid` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_pages_updatedby` FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Published and pending posts
--

DROP TABLE IF EXISTS `posts`;

CREATE TABLE `posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(10) unsigned DEFAULT NULL,
  `templateid` int(10) unsigned DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `permalink` varchar(250) DEFAULT NULL,
  `content` text,
  `description` text,
  `publishedby` int(10) unsigned DEFAULT NULL,
  `publisheddate` datetime DEFAULT NULL,
  `statusid` int(10) unsigned DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `updatedby` int(10) unsigned DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_posts_userid` FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_posts_templateid` FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_posts_publishedby` FOREIGN KEY (`publishedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_posts_statusid` FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_posts_updatedby` FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


--
-- Posts linked to the categories
--

DROP TABLE IF EXISTS `postcategorymappings`;
DROP TABLE IF EXISTS `postscategories`;

CREATE TABLE `postscategories` (
  `categoryid` int(10) unsigned DEFAULT NULL,
  `postid` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



-- ---------------------- FILES ----------------------


--
-- Custom files
--

DROP TABLE IF EXISTS `files`;

CREATE TABLE `files` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` int(10) unsigned DEFAULT NULL,
  `accountid` int(10) unsigned DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `fileext` varchar(50) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `filesize` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



--
-- What's this?
--

DROP TABLE IF EXISTS `user_roles`;
---
--- Depricated table'user_roles'
---

COMMIT;
SET FOREIGN_KEY_CHECKS=1;

----------------------------------------------------------------------------------
--- (Foreign key/ PK field name changed to id) Alter commands if posts/pages etc. already created
--
ALTER  TABLE pages change column pageid id int(10) unsigned auto_increment;
ALTER  TABLE pages modify column userid int(10) unsigned;
ALTER  TABLE pages modify column parentid int(10) unsigned;
ALTER  TABLE pages modify column templateid int(10) unsigned;
ALTER  TABLE pages modify column publishedby int(10) unsigned;
ALTER  TABLE pages modify column statusid int(10) unsigned;
ALTER  TABLE pages modify column updatedby int(10) unsigned;
ALTER  TABLE pages change column createdAt createdat datetime;
ALTER  TABLE pages change column updatedAt updatedat datetime;
ALTER  TABLE pages change column deletedAt deletedat datetime;

ALTER  TABLE posts change column postid id int(10) unsigned auto_increment;
ALTER  TABLE posts modify column userid int(10) unsigned;
ALTER  TABLE posts modify column templateid int(10) unsigned;
ALTER  TABLE posts modify column publishedby int(10) unsigned;
ALTER  TABLE posts modify column statusid int(10) unsigned;
ALTER  TABLE posts modify column updatedby int(10) unsigned;
ALTER  TABLE posts change column createdAt createdat datetime;
ALTER  TABLE posts change column updatedAt updatedat datetime;
ALTER  TABLE posts change column deletedAt deletedat datetime;

ALTER  TABLE files modify column id int(10) unsigned auto_increment;
ALTER  TABLE files modify column userid int(10) unsigned;
ALTER  TABLE files modify column accountid int(10) unsigned;
ALTER  TABLE files change column createdAt createdat datetime;
ALTER  TABLE files change column updatedAt updatedat datetime;
ALTER  TABLE files change column deletedAt deletedat datetime;

ALTER  TABLE templates change column templateid id int(10) unsigned auto_increment;
ALTER  TABLE templates modify column userid int(10) unsigned;
ALTER  TABLE templates change column deletedAt deletedat datetime;

ALTER  TABLE statuses change column statusid id int(10) unsigned auto_increment;
ALTER  TABLE statuses change column deletedAt deletedat datetime;

ALTER  TABLE categories change column categoryid id int(10) unsigned auto_increment;
ALTER  TABLE categories modify column createdby int(10) unsigned;
ALTER  TABLE categories modify column updatedby int(10) unsigned;
ALTER  TABLE categories change column createdAt createdat datetime;
ALTER  TABLE categories change column updatedAt updatedat datetime;
ALTER  TABLE categories change column deletedAt deletedat datetime;

RENAME TABLE postcategorymappings TO postscategories;
ALTER TABLE drop column mappingid;
ALTER  TABLE categories modify column categoryid int(10) unsigned;
ALTER  TABLE categories modify column postit int(10) unsigned;

ALTER TABLE `files`
ADD FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `files`
ADD FOREIGN KEY (`accountid`) REFERENCES `accounts` (`id`) ON DELETE NO ACTION;

ALTER TABLE `categories`
ADD FOREIGN KEY (`createdby`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `categories`
ADD FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `pages`
ADD FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `pages`
ADD FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `templates`
ADD FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `pages`
ADD FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION;

ALTER TABLE `pages`
ADD FOREIGN KEY (`publishedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `pages`
ADD FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `postscategories`
ADD FOREIGN KEY (`categoryid`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

ALTER TABLE `postscategories`
ADD FOREIGN KEY (`postid`) REFERENCES `posts` (`id`) ON DELETE CASCADE;

ALTER TABLE `posts`
ADD FOREIGN KEY (`userid`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `posts`
ADD FOREIGN KEY (`templateid`) REFERENCES `templates` (`id`) ON DELETE NO ACTION;

ALTER TABLE `posts`
ADD FOREIGN KEY (`publishedby`) REFERENCES `users` (`id`) ON DELETE CASCADE;

ALTER TABLE `posts`
ADD FOREIGN KEY (`updatedby`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

ALTER TABLE `posts`
ADD FOREIGN KEY (`statusid`) REFERENCES `statuses` (`id`) ON DELETE NO ACTION;

ALTER TABLE `postscategories`
ADD PRIMARY KEY `categoryid_postid` (`categoryid`, `postid`);


----------------------------------------------------------------------------------------------------

--- create mapping page with user and account ----
CREATE TABLE  pagesusers (
  pageid int(10) unsigned NOT NULL,
  userid int(10) unsigned NOT NULL,
  accountid int(10) unsigned NOT NULL,
  siteid int(10) unsigned NOT NULL,
  PRIMARY KEY (`pageid`,`userid`,`accountid`,`siteid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--- create mapping post with user and account ----
CREATE TABLE  postsusers (
  postid int(10) unsigned NOT NULL,
  userid int(10) unsigned NOT NULL,
  accountid int(10) unsigned NOT NULL,
  siteid int(10) unsigned NOT NULL,
  PRIMARY KEY (`postid`,`userid`,`accountid`,`siteid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--- create sites with user and account ----
CREATE TABLE `mandrillcms`.`sites` (
`id` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT,
`userid` INT( 11 ) UNSIGNED NOT NULL ,
`accountid` INT( 11 ) UNSIGNED NOT NULL ,
`name` VARCHAR( 255 ) DEFAULT NULL ,
`url` VARCHAR( 255 ) DEFAULT NULL ,
`description` TEXT DEFAULT NULL ,
`serverProtocal` VARCHAR( 10 ) DEFAULT NULL ,
`host` VARCHAR( 255 ) DEFAULT NULL ,
`username` VARCHAR( 255 ) DEFAULT NULL ,
`password` VARCHAR( 255 ) DEFAULT NULL ,
`port` VARCHAR( 10 ) DEFAULT NULL ,
`remotepath` VARCHAR( 255 ) DEFAULT NULL ,
`createdAt` DATETIME NULL DEFAULT NULL ,
`deleteAt` DATETIME NULL DEFAULT NULL,
PRIMARY KEY (`id`)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8