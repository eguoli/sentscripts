# Autodelegate Bash Script For Sentinel (Tendermint) validator node
> With Notifications via Telegram

1. Set the variables in mysent.passwd:

```bash
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
- To define your Telegram ID send a message to your newly created bot and open in browser https://api.telegram.org/bot<BOT>/getUpdates - in the json string returned you will find your chat_id.

2. Make the file with your variables read-only

```bash
chmod 400 mysent.passwd
```

3. Make the main script executable

```bash
chmod +x mysent.sh
```

4. Set up a cron job

```bash
crontab -u <user> -e
```

- Set the full path to the script

```bash
# m h  dom mon dow   command
0 * * * *	/<path>/mysent.sh
```
This setting will run a script every hour at :00 minutes. Set as */10 instead to run this job every 10 minutes.

