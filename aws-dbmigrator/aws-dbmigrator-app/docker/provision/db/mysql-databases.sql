-- Create databases
CREATE DATABASE IF NOT EXISTS demo_database;

-- Create users and grant rights
CREATE USER 'user_demo'@'%' IDENTIFIED BY 'user_demo_password';
GRANT DELETE, INSERT, SELECT, UPDATE ON demo_database.* TO 'user_demo'@'%' WITH GRANT OPTION;
