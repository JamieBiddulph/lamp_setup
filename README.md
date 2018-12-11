# lamp_setup
Script for setting up a LAMP environment - NOT for production use; Use at your own risk

Tested with Ubuntu 18.04

PHP extensions installed for use with Moodle.

Use cases:-

-  Quick setup for Virtual machine testing
-  Creating base images for docker

Scripts provided:-

-  ubuntu_lamp_setup.sh (Recommended for Moodle 3.4 onwards)
    - MariaDB 10.2 (Latest)
    - PHP 7.2 (Latest)
-  ubuntu_lamp_setup_nosql.sh
    - No database server
    - MySQL 5.7 Client
    - PHP 7.2 (Latest)
-  ubuntu_lamp_setup_php71.sh
    - MariaDB 10.2 (Latest)
    - PHP 7.1 (Latest)
-  ubuntu_lamp_setup_php73.sh (Currently not supported by Moodle)
    - MariaDB 10.2 (Latest)
    - PHP 7.3 (Latest)
-  ubuntu_lamp_setup_mysql57.sh
    - MySQL 5.7
    - PHP 7.2 (Latest)

How to use:-

-  Copy RAW text into bash script on the LAMP host (or clone from git)
-  As the root user run the script and enter details when prompted

Issues & Requests:-

-  Please report any issues or requests in Git - https://github.com/JamieBiddulph/lamp_setup/issues
