--liquibase formatted sql
--changeset satwell:initialRows-1 logicalFilePath:sql/9-initialRows.sql 
insert into person(name, city) VALUES ('john doe','springfield');
insert into person(name, city) VALUES ('jane doe','springfield');
--rollback delete from person where name='john doe' OR name='jane doe';
--changeset satwell:initialRows-2 logicalFilePath:sql/9-initialRows.sql 
insert into person(name, city) VALUES ('john do','springfield');
insert into person(name, city) VALUES ('jane do','springfield');
--rollback delete from person where name='jane do';
--rollback delete from person where name='john do';
--changeset satwell:runOnChangeOption runOnChange:true logicalFilePath:sql/9-initialRows.sql 
delete from person where city='rerun';
insert into person(name, city) VALUES ('bart simpson','rerun');
insert into person(name, city) VALUES ('lisa simpson','rerun');
--rollback delete from person where city='rerun';
--changeset satwell:initialRows-3 logicalFilePath:sql/9-initialRows.sql 
insert into person(name, city) VALUES ('me', 'here');
--rollback delete from person where name='me';
--changeset satwell:initialRows-5 logicalFilePath:sql/9-initialRows.sql 
insert into person(name, city) VALUES ('you', 'there');
--rollback delete from person where name='you';
--changeset satwell:initialRows-7 logicalFilePath:sql/9-initialRows.sql 
insert into person(name, city) VALUES ('you too', 'over there');
--rollback delete from person where name='you too';
--changeset satwell:initialRows-8-test logicalFilePath:sql/9-initialRows.sql 
insert into person(name, city) VALUES ('me too', 'over there');
--rollback delete from person where name='me too';
