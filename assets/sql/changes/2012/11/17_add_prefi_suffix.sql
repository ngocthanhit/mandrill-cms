ALTER TABLE `pages`
	ADD COLUMN `prefix` TEXT NULL;
ALTER TABLE `pages`
	ADD COLUMN `suffix` TEXT NULL;
ALTER TABLE `posts`
	ADD COLUMN `prefix` TEXT NULL;
ALTER TABLE `posts`
	ADD COLUMN `suffix` TEXT NULL;