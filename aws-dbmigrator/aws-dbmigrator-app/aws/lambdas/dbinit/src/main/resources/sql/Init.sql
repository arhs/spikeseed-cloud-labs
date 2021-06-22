CREATE DATABASE IF NOT EXISTS $db_name_helloworld;

CREATE USER IF NOT EXISTS '$db_user_name_helloworld'@'%' IDENTIFIED BY '$db_user_password_helloworld';

GRANT DELETE, INSERT, SELECT, UPDATE ON $db_name_helloworld.* TO '$db_user_name_helloworld'@'%';
