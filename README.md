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
