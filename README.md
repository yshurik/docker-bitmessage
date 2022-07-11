# Intro

The repository is missing link to run [Bitmessage](http://bitmessage.org)
as a docker container and provide IMAP and SMTP access for communications.

It is based on [Notbit](https://github.com/bpeel/notbit) which is a minimal client for the 
bitmessage network. 

That way the bitmessage can be used with
any compliant mail program such as Thunderbird or Apple Mail.

The docker image is compact (~20MB) alpine-based, can run on Linux / Mac / Windows with the
appropriate setup of Mail client supporting IMAP and SMTP

# Disclaimer

I am not a cryptography expert and I don't know whether Notbit or the
Bitmessage protocol is actually safe for secure communications. I
wouldn't recommend using for anything highly sensitive.

# Download the software

There is a choice of Intel or Arm architecture. The Arm version is built and tested on Raspberry Pi system and tested on Mac M1.

PC: linux/amd64:
```bash
docker pull yshurik/bitmessage:latest_x86
```

Raspberry Pi, Mac M1: linux/arm:
```bash
docker pull yshurik/bitmessage:latest_arm
```


# Running bitmessage docker container

First you may want to have dedicated docker volume for bitmessage data (keys etc):

```bash
docker volume create bm-data
```

Then the docker container can be started with appropriate port mappings for IMAP (143) and SMTP(25).

```bash
docker run -v bm-data:/data -d --name bm \
  -p 8444:8444 \
  -p 127.0.0.1:25:2525 \
  -p 127.0.0.1:143:143 \
  yshurik/bitmessage:latest
```

Note that on Mac it can be tricky way to access the volume files directly, so you may prefer to map an exisitng folder:

```bash
docker run -v /Users/anonymous/bm-data:/data -d --name bm \
  -p 8444:8444 \
  -p 127.0.0.1:25:2525 \
  -p 127.0.0.1:143:143 \
  yshurik/bitmessage:latest
```


From example above you can setup the Thunderbird to use IMAP from `localhost`, port `143`, user: `bm`, password: `bm`.
For sending use SMTP `localhost` port `25` (no auth and credential)

Not that in example above port `25`,`143` are mapped to `127.0.0.1` only so IMAP and SMTP can be accessed only from local machine.

Port `8444` (bitmessage) is mapped to all interfaces to make network connectivity with other peers.

# Creating an address

On first run (so no keys.dat file `<docker volume>/notbit/keys.dat`) the initialization script will create your first 
personal address and send welcome email from yourself so you identify your `From` address for further use in emails
as sender - appropriate key will be used from keys.dat.

# Importing addresses

If you already have some addresses from the official PyBitmessage
client you can import these directly by copying over the keys.dat.
file. To do this, make sure the container is stopped then
type:

```bash
docker stop bm
cp ~/.config/PyBitmessage/keys.dat <docker volume location>/notbit/keys.dat
chown 1000.1000 <docker volume location>/notbit/keys.dat
docker start bm
```

# Addresses format

The addresses used can not be real email
addresses but instead they must be of the form
`<bitmessage-address>@bitmessage`. 

# Messages content-type limitations

Note that any messages you send must have the content type set to
`text/plain` and can't contain any attachments. This means that HTML
messages won't work. They must use either the us-ascii encoding or
UTF-8.




