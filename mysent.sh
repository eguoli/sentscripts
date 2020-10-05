#!/bin/bash
# Import the variables from mysent.conf
. mysent.conf

# Get validator voting power info
power=$($GOBIN/sentinel-hub-cli status --chain-id sentinel-turing-3a --output json | jq -r '.validator_info .voting_power')

# Get rewards info
rewards=$($GOBIN/sentinel-hub-cli query distribution rewards $ADDR $OPER --chain-id sentinel-turing-3a --output json | jq -r '.[0] .amount')
amount=${rewards%.*}

# Compose message text with emojis in Unicode https://apps.timwhitlock.info/emoji/tables/unicode
TEXT=""$'\U0001F50B'"%20Voting%20Power:%20$power"

# Try to unjail if voting power equal 0
if [[ $power -eq 0 ]]; then
        echo $PASS | $GOBIN/sentinel-hub-cli tx slashing unjail --from=$NODE --chain-id sentinel-turing-3a --gas 200000 -y
        TEXT+="%20"$'\U0001F193'"%20unjail"
fi

TEXT+="%0A"$'\U0001F4AB'"%20Rewards:%20"
TEXT+=$(printf %.4f $(echo "$amount/1000000" | bc -l))
TEXT+=" TSENT"

# Withdraw rewards
if (($amount > $CLAIM*1000000)); then
	echo $PASS | $GOBIN/sentinel-hub-cli tx distribution withdraw-rewards $OPER --commission --from $NODE --chain-id sentinel-turing-3a -y
	TEXT+="%20"$'\U000027A1'"%20withdraw"
fi

# Wait for tx to be confirmed so we get the updated balance
sleep $SLEEP

# Get available balance
checkbal=$($GOBIN/sentinel-hub-cli query account $ADDR --chain-id sentinel-turing-3a --output json | jq -r '.value .coins[0] .amount')
balance=${checkbal%.*}

TEXT+="%0A"$'\U0001F4B0'"%20Available:%20"
TEXT+=$(printf %.4f $(echo "$balance/1000000" | bc -l))
TEXT+=" TSENT"

# Delegate available balance to validator
if (($balance > $DELEGATE*1000000)); then
	# Leave 1 TSENT and delegate the rest
	SUM=$((balance-1000000))
	echo $PASS | $GOBIN/sentinel-hub-cli tx staking delegate $OPER ${SUM}tsent --from $NODE --chain-id sentinel-turing-3a -y
	TEXT+="%20"$'\U0001F501'"%20delegate%20"
	TEXT+=$(printf %.4f $(echo "$SUM/1000000" | bc -l))
	TEXT+=" TSENT"
fi

# Send message via Telegram
send=$(curl -s -X POST -H "Content-Type:multipart/form-data" \
    "https://api.telegram.org/bot$BOT/sendMessage?chat_id=$TGID&text=$TEXT")

