SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;


/* Insert default categories */
INSERT INTO categories (category,createdBy,createdAt) values('Fact',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Figures',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Bits',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Bobs',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Yin',5,now());
INSERT INTO categories (category,createdBy,createdAt) values('Yang',5,now());


COMMIT;
SET FOREIGN_KEY_CHECKS=1;