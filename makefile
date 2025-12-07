.PHONY: conn up fix

conn:
	mysql -u root -h localhost -p prestashop -P 3306
up:
	mysql -u root -h localhost -p prestashop -P 3306 < ./dump/dump2.sql

fix:
	mysql -u root -h localhost -p prestashop -P 3306 < ./fix/fix.sql



