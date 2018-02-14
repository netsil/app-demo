USE appdb;
CREATE TABLE IF NOT EXISTS mobile
(
device_id INT(11) NOT NULL AUTO_INCREMENT,
device_type VARCHAR(30) NOT NULL,
CONSTRAINT mobile_pk PRIMARY KEY (device_id)
);
