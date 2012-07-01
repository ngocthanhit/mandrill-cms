SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;


-- ---------------------- DROPS ----------------------

DROP TABLE IF EXISTS `accounts`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `countries`;
DROP TABLE IF EXISTS `timezones`;
DROP TABLE IF EXISTS `currentevents`;
DROP TABLE IF EXISTS `archivedevents`;
DROP TABLE IF EXISTS `currentchanges`;
DROP TABLE IF EXISTS `archivedchanges`;



-- ---------------------- ACCOUNTS ----------------------

--
-- Table structure for table `accounts`
--

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

--
-- Data for table `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `code`, `createdat`) VALUES
(1, 'Visitors', '99536BF6-99D4-492E-BF2113DDAD7E6E51', NOW()),  
(2, 'Administrators', '3DADA579-39E7-4465-BB86D37F2A7ADC3E', NOW());


-- ---------------------- USERS ----------------------

--
-- Table structure for table `users`
--

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

-- ---------------------- GEO DATA ----------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iso` char(2) NOT NULL,
  `name` varchar(80) NOT NULL,
  `iso3` char(3) DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

--
-- Data for table `countries`
--

INSERT INTO `countries` (`id`, `iso`, `name`, `iso3`, `numcode`) VALUES
(1, 'AD', 'Andorra', 'AND', 20),
(2, 'AE', 'United Arab Emirates', 'ARE', 784),
(3, 'AF', 'Afghanistan', 'AFG', 4),
(4, 'AG', 'Antigua and Barbuda', 'ATG', 28),
(5, 'AI', 'Anguilla', 'AIA', 660),
(6, 'AL', 'Albania', 'ALB', 8),
(7, 'AM', 'Armenia', 'ARM', 51),
(8, 'AN', 'Netherlands Antilles', 'ANT', 530),
(9, 'AO', 'Angola', 'AGO', 24),
(10, 'AQ', 'Antarctica', NULL, NULL),
(11, 'AR', 'Argentina', 'ARG', 32),
(12, 'AS', 'American Samoa', 'ASM', 16),
(13, 'AT', 'Austria', 'AUT', 40),
(14, 'AU', 'Australia', 'AUS', 36),
(15, 'AW', 'Aruba', 'ABW', 533),
(16, 'AZ', 'Azerbaijan', 'AZE', 31),
(17, 'BA', 'Bosnia and Herzegovina', 'BIH', 70),
(18, 'BB', 'Barbados', 'BRB', 52),
(19, 'BD', 'Bangladesh', 'BGD', 50),
(20, 'BE', 'Belgium', 'BEL', 56),
(21, 'BF', 'Burkina Faso', 'BFA', 854),
(22, 'BG', 'Bulgaria', 'BGR', 100),
(23, 'BH', 'Bahrain', 'BHR', 48),
(24, 'BI', 'Burundi', 'BDI', 108),
(25, 'BJ', 'Benin', 'BEN', 204),
(26, 'BM', 'Bermuda', 'BMU', 60),
(27, 'BN', 'Brunei Darussalam', 'BRN', 96),
(28, 'BO', 'Bolivia', 'BOL', 68),
(29, 'BR', 'Brazil', 'BRA', 76),
(30, 'BS', 'Bahamas', 'BHS', 44),
(31, 'BT', 'Bhutan', 'BTN', 64),
(32, 'BV', 'Bouvet Island', NULL, NULL),
(33, 'BW', 'Botswana', 'BWA', 72),
(34, 'BY', 'Belarus', 'BLR', 112),
(35, 'BZ', 'Belize', 'BLZ', 84),
(36, 'CA', 'Canada', 'CAN', 124),
(37, 'CC', 'Cocos (Keeling) Islands', NULL, NULL),
(38, 'CD', 'Congo, the Democratic Republic of the', 'COD', 180),
(39, 'CF', 'Central African Republic', 'CAF', 140),
(40, 'CG', 'Congo', 'COG', 178),
(41, 'CH', 'Switzerland', 'CHE', 756),
(42, 'CI', 'Cote D''Ivoire', 'CIV', 384),
(43, 'CK', 'Cook Islands', 'COK', 184),
(44, 'CL', 'Chile', 'CHL', 152),
(45, 'CM', 'Cameroon', 'CMR', 120),
(46, 'CN', 'China', 'CHN', 156),
(47, 'CO', 'Colombia', 'COL', 170),
(48, 'CR', 'Costa Rica', 'CRI', 188),
(49, 'CS', 'Serbia and Montenegro', NULL, NULL),
(50, 'CU', 'Cuba', 'CUB', 192),
(51, 'CV', 'Cape Verde', 'CPV', 132),
(52, 'CX', 'Christmas Island', NULL, NULL),
(53, 'CY', 'Cyprus', 'CYP', 196),
(54, 'CZ', 'Czech Republic', 'CZE', 203),
(55, 'DE', 'Germany', 'DEU', 276),
(56, 'DJ', 'Djibouti', 'DJI', 262),
(57, 'DK', 'Denmark', 'DNK', 208),
(58, 'DM', 'Dominica', 'DMA', 212),
(59, 'DO', 'Dominican Republic', 'DOM', 214),
(60, 'DZ', 'Algeria', 'DZA', 12),
(61, 'EC', 'Ecuador', 'ECU', 218),
(62, 'EE', 'Estonia', 'EST', 233),
(63, 'EG', 'Egypt', 'EGY', 818),
(64, 'EH', 'Western Sahara', 'ESH', 732),
(65, 'ER', 'Eritrea', 'ERI', 232),
(66, 'ES', 'Spain', 'ESP', 724),
(67, 'ET', 'Ethiopia', 'ETH', 231),
(68, 'FI', 'Finland', 'FIN', 246),
(69, 'FJ', 'Fiji', 'FJI', 242),
(70, 'FK', 'Falkland Islands (Malvinas)', 'FLK', 238),
(71, 'FM', 'Micronesia, Federated States of', 'FSM', 583),
(72, 'FO', 'Faroe Islands', 'FRO', 234),
(73, 'FR', 'France', 'FRA', 250),
(74, 'GA', 'Gabon', 'GAB', 266),
(75, 'GB', 'United Kingdom', 'GBR', 826),
(76, 'GD', 'Grenada', 'GRD', 308),
(77, 'GE', 'Georgia', 'GEO', 268),
(78, 'GF', 'French Guiana', 'GUF', 254),
(79, 'GH', 'Ghana', 'GHA', 288),
(80, 'GI', 'Gibraltar', 'GIB', 292),
(81, 'GL', 'Greenland', 'GRL', 304),
(82, 'GM', 'Gambia', 'GMB', 270),
(83, 'GN', 'Guinea', 'GIN', 324),
(84, 'GP', 'Guadeloupe', 'GLP', 312),
(85, 'GQ', 'Equatorial Guinea', 'GNQ', 226),
(86, 'GR', 'Greece', 'GRC', 300),
(87, 'GS', 'South Georgia and the South Sandwich Islands', NULL, NULL),
(88, 'GT', 'Guatemala', 'GTM', 320),
(89, 'GU', 'Guam', 'GUM', 316),
(90, 'GW', 'Guinea-Bissau', 'GNB', 624),
(91, 'GY', 'Guyana', 'GUY', 328),
(92, 'HK', 'Hong Kong', 'HKG', 344),
(93, 'HM', 'Heard Island and Mcdonald Islands', NULL, NULL),
(94, 'HN', 'Honduras', 'HND', 340),
(95, 'HR', 'Croatia', 'HRV', 191),
(96, 'HT', 'Haiti', 'HTI', 332),
(97, 'HU', 'Hungary', 'HUN', 348),
(98, 'ID', 'Indonesia', 'IDN', 360),
(99, 'IE', 'Ireland', 'IRL', 372),
(100, 'IL', 'Israel', 'ISR', 376),
(101, 'IN', 'India', 'IND', 356),
(102, 'IO', 'British Indian Ocean Territory', NULL, NULL),
(103, 'IQ', 'Iraq', 'IRQ', 368),
(104, 'IR', 'Iran, Islamic Republic of', 'IRN', 364),
(105, 'IS', 'Iceland', 'ISL', 352),
(106, 'IT', 'Italy', 'ITA', 380),
(107, 'JM', 'Jamaica', 'JAM', 388),
(108, 'JO', 'Jordan', 'JOR', 400),
(109, 'JP', 'Japan', 'JPN', 392),
(110, 'KE', 'Kenya', 'KEN', 404),
(111, 'KG', 'Kyrgyzstan', 'KGZ', 417),
(112, 'KH', 'Cambodia', 'KHM', 116),
(113, 'KI', 'Kiribati', 'KIR', 296),
(114, 'KM', 'Comoros', 'COM', 174),
(115, 'KN', 'Saint Kitts and Nevis', 'KNA', 659),
(116, 'KP', 'Korea, Democratic People''s Republic of', 'PRK', 408),
(117, 'KR', 'Korea, Republic of', 'KOR', 410),
(118, 'KW', 'Kuwait', 'KWT', 414),
(119, 'KY', 'Cayman Islands', 'CYM', 136),
(120, 'KZ', 'Kazakhstan', 'KAZ', 398),
(121, 'LA', 'Lao People''s Democratic Republic', 'LAO', 418),
(122, 'LB', 'Lebanon', 'LBN', 422),
(123, 'LC', 'Saint Lucia', 'LCA', 662),
(124, 'LI', 'Liechtenstein', 'LIE', 438),
(125, 'LK', 'Sri Lanka', 'LKA', 144),
(126, 'LR', 'Liberia', 'LBR', 430),
(127, 'LS', 'Lesotho', 'LSO', 426),
(128, 'LT', 'Lithuania', 'LTU', 440),
(129, 'LU', 'Luxembourg', 'LUX', 442),
(130, 'LV', 'Latvia', 'LVA', 428),
(131, 'LY', 'Libyan Arab Jamahiriya', 'LBY', 434),
(132, 'MA', 'Morocco', 'MAR', 504),
(133, 'MC', 'Monaco', 'MCO', 492),
(134, 'MD', 'Moldova, Republic of', 'MDA', 498),
(135, 'MG', 'Madagascar', 'MDG', 450),
(136, 'MH', 'Marshall Islands', 'MHL', 584),
(137, 'MK', 'Macedonia, the Former Yugoslav Republic of', 'MKD', 807),
(138, 'ML', 'Mali', 'MLI', 466),
(139, 'MM', 'Myanmar', 'MMR', 104),
(140, 'MN', 'Mongolia', 'MNG', 496),
(141, 'MO', 'Macao', 'MAC', 446),
(142, 'MP', 'Northern Mariana Islands', 'MNP', 580),
(143, 'MQ', 'Martinique', 'MTQ', 474),
(144, 'MR', 'Mauritania', 'MRT', 478),
(145, 'MS', 'Montserrat', 'MSR', 500),
(146, 'MT', 'Malta', 'MLT', 470),
(147, 'MU', 'Mauritius', 'MUS', 480),
(148, 'MV', 'Maldives', 'MDV', 462),
(149, 'MW', 'Malawi', 'MWI', 454),
(150, 'MX', 'Mexico', 'MEX', 484),
(151, 'MY', 'Malaysia', 'MYS', 458),
(152, 'MZ', 'Mozambique', 'MOZ', 508),
(153, 'NA', 'Namibia', 'NAM', 516),
(154, 'NC', 'New Caledonia', 'NCL', 540),
(155, 'NE', 'Niger', 'NER', 562),
(156, 'NF', 'Norfolk Island', 'NFK', 574),
(157, 'NG', 'Nigeria', 'NGA', 566),
(158, 'NI', 'Nicaragua', 'NIC', 558),
(159, 'NL', 'Netherlands', 'NLD', 528),
(160, 'NO', 'Norway', 'NOR', 578),
(161, 'NP', 'Nepal', 'NPL', 524),
(162, 'NR', 'Nauru', 'NRU', 520),
(163, 'NU', 'Niue', 'NIU', 570),
(164, 'NZ', 'New Zealand', 'NZL', 554),
(165, 'OM', 'Oman', 'OMN', 512),
(166, 'PA', 'Panama', 'PAN', 591),
(167, 'PE', 'Peru', 'PER', 604),
(168, 'PF', 'French Polynesia', 'PYF', 258),
(169, 'PG', 'Papua New Guinea', 'PNG', 598),
(170, 'PH', 'Philippines', 'PHL', 608),
(171, 'PK', 'Pakistan', 'PAK', 586),
(172, 'PL', 'Poland', 'POL', 616),
(173, 'PM', 'Saint Pierre and Miquelon', 'SPM', 666),
(174, 'PN', 'Pitcairn', 'PCN', 612),
(175, 'PR', 'Puerto Rico', 'PRI', 630),
(176, 'PS', 'Palestinian Territory, Occupied', NULL, NULL),
(177, 'PT', 'Portugal', 'PRT', 620),
(178, 'PW', 'Palau', 'PLW', 585),
(179, 'PY', 'Paraguay', 'PRY', 600),
(180, 'QA', 'Qatar', 'QAT', 634),
(181, 'RE', 'Reunion', 'REU', 638),
(182, 'RO', 'Romania', 'ROM', 642),
(183, 'RU', 'Russian Federation', 'RUS', 643),
(184, 'RW', 'Rwanda', 'RWA', 646),
(185, 'SA', 'Saudi Arabia', 'SAU', 682),
(186, 'SB', 'Solomon Islands', 'SLB', 90),
(187, 'SC', 'Seychelles', 'SYC', 690),
(188, 'SD', 'Sudan', 'SDN', 736),
(189, 'SE', 'Sweden', 'SWE', 752),
(190, 'SG', 'Singapore', 'SGP', 702),
(191, 'SH', 'Saint Helena', 'SHN', 654),
(192, 'SI', 'Slovenia', 'SVN', 705),
(193, 'SJ', 'Svalbard and Jan Mayen', 'SJM', 744),
(194, 'SK', 'Slovakia', 'SVK', 703),
(195, 'SL', 'Sierra Leone', 'SLE', 694),
(196, 'SM', 'San Marino', 'SMR', 674),
(197, 'SN', 'Senegal', 'SEN', 686),
(198, 'SO', 'Somalia', 'SOM', 706),
(199, 'SR', 'Suriname', 'SUR', 740),
(200, 'ST', 'Sao Tome and Principe', 'STP', 678),
(201, 'SV', 'El Salvador', 'SLV', 222),
(202, 'SY', 'Syrian Arab Republic', 'SYR', 760),
(203, 'SZ', 'Swaziland', 'SWZ', 748),
(204, 'TC', 'Turks and Caicos Islands', 'TCA', 796),
(205, 'TD', 'Chad', 'TCD', 148),
(206, 'TF', 'French Southern Territories', NULL, NULL),
(207, 'TG', 'Togo', 'TGO', 768),
(208, 'TH', 'Thailand', 'THA', 764),
(209, 'TJ', 'Tajikistan', 'TJK', 762),
(210, 'TK', 'Tokelau', 'TKL', 772),
(211, 'TL', 'Timor-Leste', NULL, NULL),
(212, 'TM', 'Turkmenistan', 'TKM', 795),
(213, 'TN', 'Tunisia', 'TUN', 788),
(214, 'TO', 'Tonga', 'TON', 776),
(215, 'TR', 'Turkey', 'TUR', 792),
(216, 'TT', 'Trinidad and Tobago', 'TTO', 780),
(217, 'TV', 'Tuvalu', 'TUV', 798),
(218, 'TW', 'Taiwan, Province of China', 'TWN', 158),
(219, 'TZ', 'Tanzania, United Republic of', 'TZA', 834),
(220, 'UA', 'Ukraine', 'UKR', 804),
(221, 'UG', 'Uganda', 'UGA', 800),
(222, 'UM', 'United States Minor Outlying Islands', NULL, NULL),
(223, 'US', 'United States', 'USA', 840),
(224, 'UY', 'Uruguay', 'URY', 858),
(225, 'UZ', 'Uzbekistan', 'UZB', 860),
(226, 'VA', 'Holy See (Vatican City State)', 'VAT', 336),
(227, 'VC', 'Saint Vincent and the Grenadines', 'VCT', 670),
(228, 'VE', 'Venezuela', 'VEN', 862),
(229, 'VG', 'Virgin Islands, British', 'VGB', 92),
(230, 'VI', 'Virgin Islands, U.s.', 'VIR', 850),
(231, 'VN', 'Viet Nam', 'VNM', 704),
(232, 'VU', 'Vanuatu', 'VUT', 548),
(233, 'WF', 'Wallis and Futuna', 'WLF', 876),
(234, 'WS', 'Samoa', 'WSM', 882),
(235, 'YE', 'Yemen', 'YEM', 887),
(236, 'YT', 'Mayotte', NULL, NULL),
(237, 'ZA', 'South Africa', 'ZAF', 710),
(238, 'ZM', 'Zambia', 'ZMB', 894),
(239, 'ZW', 'Zimbabwe', 'ZWE', 716);


--
-- Table structure for table `timezones`
--

CREATE TABLE `timezones` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `offset` varchar(5) NOT NULL,
  `name` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;

--
-- Data for table `timezones`
--

INSERT INTO `timezones` (`id`, `offset`, `name`) VALUES
(1,	 '-12.0',	'(GMT-12:00) International Date Line West'),
(2,	 '-11.0',	'(GMT-11:00) Midway Island, Samoa'),
(3,	 '-10.0',	'(GMT-10:00) Hawaii'),
(4,	 '-9.0',	'(GMT-09:00) Alaska'),
(5,	 '-8.0',	'(GMT-08:00) Pacific Time (US & Canada); Tijuana'),
(6,	 '-7.0',	'(GMT-07:00) Arizona'),
(7,	 '-7.0',	'(GMT-07:00) Chihuahua, La Paz, Mazatlan'),
(8,	 '-7.0',	'(GMT-07:00) Mountain Time (US & Canada)'),
(9,	 '-6.0',	'(GMT-06:00) Central America'),
(10, '-6.0',	'(GMT-06:00) Central Time (US & Canada)'),
(11, '-6.0',	'(GMT-06:00) Guadalajara, Mexico City, Monterrey'),
(12, '-6.0',	'(GMT-06:00) Saskatchewan'),
(13, '-5.0',	'(GMT-05:00) Bogota, Lima, Quito'),
(14, '-5.0',	'(GMT-05:00) Eastern Time (US & Canada)'),
(15, '-5.0',	'(GMT-05:00) Indiana (East)'),
(16, '-4.0',	'(GMT-04:00) Atlantic Time (Canada)'),
(17, '-4.0',	'(GMT-04:00) Caracas, La Paz'),
(18, '-4.0',	'(GMT-04:00) Santiago'),
(19, '-3.5',	'(GMT-03:30) Newfoundland'),
(20, '-3.0',	'(GMT-03:00) Brasilia'),
(21, '-3.0',	'(GMT-03:00) Buenos Aires, Georgetown'),
(22, '-3.0',	'(GMT-03:00) Greenland'),
(23, '-2.0',	'(GMT-02:00) Mid-Atlantic'),
(24, '-1.0',	'(GMT-01:00) Azores'),
(25, '-1.0',	'(GMT-01:00) Cape Verde Is.'),
(26, '0.0',		'(GMT) Casablanca, Monrovia'),
(27, '0.0',		'(GMT) Greenwich Mean Time: Dublin, Edinburgh, Lisbon, London'),
(28, '1.0',		'(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'),
(29, '1.0',		'(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague'),
(30, '1.0',		'(GMT+01:00) Brussels, Copenhagen, Madrid, Paris'),
(31, '1.0',		'(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb'),
(32, '1.0',		'(GMT+01:00) West Central Africa'),
(33, '2.0',		'(GMT+02:00) Athens, Beirut, Istanbul, Minsk'),
(34, '2.0',		'(GMT+02:00) Bucharest'),
(35, '2.0',		'(GMT+02:00) Cairo'),
(36, '2.0',		'(GMT+02:00) Harare, Pretoria'),
(37, '2.0',		'(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius'),
(38, '2.0',		'(GMT+02:00) Jerusalem'),
(39, '3.0',		'(GMT+03:00) Baghdad'),
(40, '3.0',		'(GMT+03:00) Kuwait, Riyadh'),
(41, '3.0',		'(GMT+03:00) Moscow, St. Petersburg, Volgograd'),
(42, '3.0',		'(GMT+03:00) Nairobi'),
(43, '3.5',		'(GMT+03:30) Tehran'),
(44, '4.0',		'(GMT+04:00) Abu Dhabi, Muscat'),
(45, '4.0',		'(GMT+04:00) Baku, Tbilisi, Yerevan'),
(46, '4.5',		'(GMT+04:30) Kabul'),
(47, '5.0',		'(GMT+05:00) Ekaterinburg'),
(48, '5.0',		'(GMT+05:00) Islamabad, Karachi, Tashkent'),
(49, '5.5',		'(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi'),
(50, '5.75',	'(GMT+05:45) Kathmandu'),
(51, '6.0',		'(GMT+06:00) Almaty, Novosibirsk'),
(52, '6.0',		'(GMT+06:00) Astana, Dhaka'),
(53, '6.0',		'(GMT+06:00) Sri Jayawardenepura'),
(54, '6.5',		'(GMT+06:30) Rangoon'),
(55, '7.0',		'(GMT+07:00) Bangkok, Hanoi, Jakarta'),
(56, '7.0',		'(GMT+07:00) Krasnoyarsk'),
(57, '8.0',		'(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi'),
(58, '8.0',		'(GMT+08:00) Irkutsk, Ulaan Bataar'),
(59, '8.0',		'(GMT+08:00) Kuala Lumpur, Singapore'),
(60, '8.0',		'(GMT+08:00) Perth'),
(61, '8.0',		'(GMT+08:00) Taipei'),
(62, '9.0',		'(GMT+09:00) Osaka, Sapporo, Tokyo'),
(63, '9.0',		'(GMT+09:00) Seoul'),
(64, '9.0',		'(GMT+09:00) Vakutsk'),
(65, '9.5',		'(GMT+09:30) Adelaide'),
(66, '9.5',		'(GMT+09:30) Darwin'),
(67, '10.0',	'(GMT+10:00) Brisbane'),
(68, '10.0',	'(GMT+10:00) Canberra, Melbourne, Sydney'),
(69, '10.0',	'(GMT+10:00) Guam, Port Moresby'),
(70, '10.0',	'(GMT+10:00) Hobart'),
(71, '10.0',	'(GMT+10:00) Vladivostok'),
(72, '11.0',	'(GMT+11:00) Magadan, Solomon Is., New Caledonia'),
(73, '12.0',	'(GMT+12:00) Auckland, Wellington'),
(74, '12.0',	'(GMT+12:00) Fiji, Kamchatka, Marshall Is.'),
(75, '13.0',	'(GMT+13:00) Nuku\'alofa ');


-- ---------------------- EVENTS ----------------------

--
-- Data for table `currentevents`
--

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
-- Data for table `archivedevents`
--

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


-- ---------------------- CHANGES ----------------------

--
-- Data for table `currentchanges`
--

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
-- Data for table `archivedchanges`
--

CREATE TABLE `archivedchanges` (
  `id` int(10) unsigned NOT NULL,
  `userid` int(10) unsigned DEFAULT NULL,
  `type` varchar(1) NOT NULL COMMENT 'r(eplaced),d(eleted)',
  `modelcode` varchar(24) DEFAULT NULL,
  `modelid` int(10) unsigned DEFAULT NULL,
  `packet` mediumtext DEFAULT NULL,
  `createdat` datetime DEFAULT NULL
) ENGINE=ARCHIVE DEFAULT CHARSET=utf8;




COMMIT;
SET FOREIGN_KEY_CHECKS=1;


/*------- Script by Maimun Smith -------------------- */

/*
SQLyog Enterprise v4.07
Host - 5.1.48-community : Database - mandrillcms
*********************************************************************
Server version : 5.1.48-community
*/


create database if not exists `mandrillcms`;

USE `mandrillcms`;

/*Table structure for table `categories` */

drop table if exists `categories`;

CREATE TABLE `categories` (
  `categoryid` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) CHARACTER SET latin1 NOT NULL,
  `createdby` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`categoryid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

/*Table structure for table `pages` */

drop table if exists `pages`;

CREATE TABLE `pages` (
  `pageid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `title` varchar(255) CHARACTER SET latin1 NOT NULL,
  `permalink` varchar(250) CHARACTER SET latin1 DEFAULT NULL,
  `navigationtitle` varchar(250) CHARACTER SET latin1 DEFAULT NULL,
  `content` text CHARACTER SET latin1,
  `description` text CHARACTER SET latin1,
  `parentid` int(11) DEFAULT '0',
  `templateid` int(11) DEFAULT NULL,
  `publishedby` int(11) DEFAULT NULL,
  `isprotected` bit(1) DEFAULT NULL,
  `issubpageprotected` bit(1) DEFAULT NULL,
  `password` varchar(250) CHARACTER SET latin1 DEFAULT NULL,
  `publisheddate` datetime DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `statusid` int(11) DEFAULT NULL,
  `showinnavigation` bit(1) DEFAULT b'1',
  `showinfooternavigation` bit(1) DEFAULT b'0',
  `updatedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`pageid`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Table structure for table `postcategorymappings` */

drop table if exists `postcategorymappings`;

CREATE TABLE `postcategorymappings` (
  `mappingid` int(11) NOT NULL AUTO_INCREMENT,
  `categoryid` int(11) DEFAULT NULL,
  `postid` int(11) DEFAULT NULL,
  PRIMARY KEY (`mappingid`)
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;

/*Table structure for table `posts` */

drop table if exists `posts`;

CREATE TABLE `posts` (
  `postid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `templateid` int(11) DEFAULT NULL,
  `title` varchar(255) CHARACTER SET latin1 NOT NULL,
  `permalink` varchar(250) CHARACTER SET latin1 DEFAULT NULL,
  `content` text CHARACTER SET latin1,
  `description` text CHARACTER SET latin1,
  `publishedby` int(11) DEFAULT NULL,
  `publisheddate` datetime DEFAULT NULL,
  `statusid` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`postid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

/*Table structure for table `statuses` */

drop table if exists `statuses`;

CREATE TABLE `statuses` (
  `statusid` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`statusid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Table structure for table `templates` */

drop table if exists `templates`;

CREATE TABLE `templates` (
  `templateid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `templateName` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`templateid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user_roles` */

drop table if exists `user_roles`;

CREATE TABLE `user_roles` (
  `roleid` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(100) CHARACTER SET latin1 DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* Insert default categories */
INSERT INTO categories (category,createdBy,createdAt) values('Fact',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Figures',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Bits',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Bobs',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Yin',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Yang',5,now());

/* Insert default Statuses */
INSERT INTO statuses (status) values('Publish');
INSERT INTO statuses (status) values('Draft');
