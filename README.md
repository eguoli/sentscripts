# Autodelegate Bash Script For Sentinel (Tendermint) validator node
> With Notifications via Telegram

1. To use use this script you may need to install additional packages:

```bash
apt-get install curl jq # Debian/Ubuntu
yum install curl jq # CentOS
```

2. Set the variables in mysent.passwd:

```bash
GOBIN="" # Sentinel cli folder with full path, ie /root/go/bin
ADDR="" # Sentinel wallet address
OPER="" # Sentinel validator address
NODE="" # Sentinel node name
PASS="" # Sentinel wallet password
CLAIM=100 # Minimum rewards amount to withdraw in TSENT
DELEGATE=1000 # Minimum amount to delegate in TSENT

BOT="" # Telegram bot api from @BotFather
TGID="" # Telegram Chat ID
```
- To get the Telegram bot API key just talk to @BotFather and set up your own bot.
- To define your Telegram ID send a message to your newly created bot and open in browser https://api.telegram.org/botINSERTAPIKEY/getUpdates - in the json string returned you will find your "id".

3. Make the file with your variables not readable for anyone but owner

```bash
chmod 400 mysent.passwd
```

4. Make the main script executable

```bash
chmod +x mysent.sh
```

5. Set up a cron job

```bash
crontab -u <user> -e
```

- Set the full path to the script

```bash
# m h  dom mon dow   command
0 * * * *	/<path>/mysent.sh
```
This setting will run a script every hour at :00 minutes. Set as */10 instead to run this job every 10 minutes.

