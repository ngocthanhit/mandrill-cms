START TRANSACTION;


-- deploy default billing settings for new database
-- should not be used when adding new features to existing db


truncate table accountquotas;
truncate table accountplans;
truncate table quotas;
truncate table discounts;
truncate table plans;
truncate table features;


insert into features (token, name, unit, description, position) values 
('TeamMembers', 'Team Members', '', '', 1),
('WebSites', 'Web Sites', '', '', 2),
('Hosting', 'Hosting', '', '', 3);


insert into discounts (name, description, discount, createdat, createdby) values 
('- no discount -', 'Virtual discount automatically assigned to all accounts without real discount.', 0, NOW(), 4);


INSERT INTO plans (id, name, description, price, position, isactive, ispublic, createdat, createdby, updatedat, updatedby) VALUES
(1, 'VIP', 'Default plan for internal and premium accounts, can be assigned only by admin.', 0.00, 100, 1, 0, NOW(), 4, NULL, NULL),
(2, 'Beta', 'Beta plan for early testers.', 5.00, 10, 1, 1, NOW(), 4, NULL, NULL);


INSERT INTO quotas (id, featureid, planid, quota, createdat, createdby, updatedat, updatedby) VALUES
(1, 1, 1, 999999, NOW(), 4, NULL, NULL),
(2, 2, 1, 999999, NOW(), 4, NULL, NULL),
(3, 3, 1, 2, NOW(), 4, NULL, NULL),
(4, 1, 2, 3, NOW(), 4, NULL, NULL),
(5, 2, 2, 1, NOW(), 4, NULL, NULL),
(6, 3, 2, 1, NOW(), 4, NULL, NULL);


-- set up default plan for all current accounts
insert into accountplans (accountid, planid, discountid, price, createdat, createdby, renewedat) select id, 1, 1, 0.0, NOW(), 3, NOW() from accounts;


COMMIT;