#!/bin/bash

echo -e "\nProcesses listening on TCP ports\n"
ss -tlnp

echo -e "\nProcesses listening on UDP ports\n"
ss -ulnp

echo -e "\nActive (not only listening) on UDP ports\n"
ss -ulnp

echo -e "\nDoing a quick test with nc to send a UDP message over a socket locally (the alternative is 2 consoles)\n"
PORT=9999
OUTFILE=$(mktemp)

# start listener in background, redirect received data to a file
nc -u -l $PORT > "$OUTFILE" &
LISTENER_PID=$!

sleep 0.5   # give the listener a moment to bind the port

# send the message
echo "hello over UDP" | nc -u -w1 127.0.0.1 $PORT

sleep 0.5   # give the listener a moment to receive it

# check the result
echo "--- received ---"
cat "$OUTFILE"

kill $LISTENER_PID 2>/dev/null
rm -f "$OUTFILE"