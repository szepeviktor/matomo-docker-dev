# piwik-docker-dev
Development docker-compose.yml for Piwik.

## Usage

To start Piwik:

```
PIWIK_HOME=/path/to/your/piwik docker-compose up
```

Visit `http://localhost:3000` to install & use your development Piwik.

To run a Piwik CLI command:

```
PIWIK_HOME=/path/to/your/piwik ./console help
```

You may find it helpful to define `PIWIK_HOME` in your bash profile.

To run tests:

First add the following to your config.ini.php:

```
[tests]
http_host   = piwik
```

then run:

```
PIWIK_HOME=/path/to/your/piwik ./console tests:run
```

(NOTE: some tests currently don't pass inside the container)

To connect to mariadb:

```
docker-compose run mariadb sh -c 'exec mysql -hmariadb -uroot -ppass'
```
