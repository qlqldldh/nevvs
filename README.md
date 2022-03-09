# NEVVs

> News Notifier written with V

## Prerequisites

- [V](https://github.com/vlang/v)
- OpenSSL (on non Windows systems)
- Incoming Webhook plugin for Slack

## Usage
### 1. Create `.env.{stage}` file in nevvs directory and set stage as an env variable

- set stage as an env variable<br>
`export STAGE={stage}`

- Fields in env file

| Field | Description |
|-------|-------------|
| RSS_URL | URL providing news data |
| SLACK_URL | URL generated by Incoming webhook plugin from Slack|
| SLACK_CHANNEL | Channel name of your workspace in Slack

### 2. Create a `articles` file in history directory

### 3. Build

`v nevvs`

### 4. Run `nevvs`

`./nevvs`
