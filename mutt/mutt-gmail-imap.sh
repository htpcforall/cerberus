#!/bin/bash


# mutt gmail imap set up
#=====================================================================

sudo apt-get install mutt urlview


# google create application passwords
#=====================================================================

# google create application passwords for 

# imap
# smtp
# goobook


# gpg generate keys to encrypt passwords
#=====================================================================

gpg --gen-key

# list keys
#==========
gpg --list-keys

# create revoke certificatre
#===========================

# replace 12345678 with your gpg key id
gpg --output revoke.asc --gen-revoke 12345678




# create mutt files and directories
#=====================================================================

mkdir -p ~/.mutt/cache/headers
mkdir ~/.mutt/cache/bodies
touch ~/.mutt/certificates
touch ~/.mutt/muttrc
touch ~/.mutt/mailcap


# gpg encrypt mutt passwords so they arent stored in plain text
#=====================================================================

# store password in an encrypted gpg file not plain text
vim ~/.mutt/passwords
set imap_pass="google-application-password"
set smtp_pass="google-application-password"

gpg -r danieljwilcox@gmail.com -e ~/.mutt/mutt-passwords
ls ~/.mutt
cache  certificates  mailcap  muttrc  passwords  mutt-passwords.gpg

shred ~/.mutt/passwords
rm ~/.mutt/passwords


# goobook gmail contacts
#=====================================================================

sudo pip install goobook

# googbook config
vim ~/.goobookrc

# add the following code to ~/.goobookrc


# "#" or ";" at the start of a line makes it a comment.
[DEFAULT]
# If not given here, email and password is taken from .netrc using
;machine google.com
email: danieljwilcox@gmail.com
passwordeval: gpg --no-tty --use-agent -q -d ~/.mutt/goobookrc.gpg
;max_results: 9999
cache_filename: /home/djwilcox/.goobook_cache
;cache_expiry_hours:


# set up encrypted goobookrcpass file
#=====================================================================
vim ~/.goobookrcpass

# paste in the following replace 
password: google-application-password

# encrypt the file
gpg -r danieljwilcox@gmail.com -e ~/.goobookrcpass
mv ~/.goobookrcpass.gpg ~/.goobookrc.gpg

shred ~/.goobookrcpass
rm ~/.goobookrcpass


# create  ~/.gpg/gpg.conf
#=======================================================================

# add gpg.conf to ~/.gpg with use-agent uncommented to use gpg use-agent

vim ~/.gpg/gpg.conf

# add the following code to ~/.gpg/gpg.conf
use-agent


# urlview open urls with chromium-browser
#=======================================================================

# open urls in chromium
vim ~/.urlview

# add the following code to ~/.urlview

REGEXP (((https?|ftp|gopher)://|(mailto|file|news):)[^’ <>"]+|(www|web|w3).[-a-z0-9.]+)[^’ .,;<>":]
COMMAND chromium-browser --no-referrers %s


# create the muttrc config file ~/.muttrc
#=====================================================================

# copy gpg default settings to the desktop
# then copy the contents to your ~/.muttrc file
cp /usr/share/doc/mutt/examples/gpg.rc ~/Desktop/gpg.rc

vim ~/.muttrc

# paste in the code below

set from = "danieljwilcox@gmail.com"
set realname = "Daniel J Wilcox"

set imap_user = "danieljwilcox@gmail.com"
set smtp_url = "smtp://danieljwilcox@smtp.gmail.com:587/"
source "gpg -d ~/.mutt/mutt-passwords.gpg |"

set folder = "imaps://imap.gmail.com:993"
set spoolfile = "+Inbox"
set postponed = "+Drafts"
set trash = "imaps://imap.gmail.com/Trash"
set record = "+Sent Mail"

set header_cache = ~/.mutt/cache/headers
set message_cachedir = ~/.mutt/cache/bodies
set certificate_file = ~/.mutt/certificates
set mailcap_path = ~/.mutt/mailcap       

set sort=threads
set sort_browser=reverse-date
set sort_aux=reverse-last-date-received

set move = "no" 
set imap_idle = "yes"
set mail_check = "60"
set imap_keepalive = "900"
set editor = "vim"
set beep_new

set query_command="goobook query '%s'"
macro index,pager a "<pipe-message>goobook add<return>" "add sender to google contacts"
bind editor <Tab> complete-query

bind compose p pgp-menu
macro compose Y pfy "send mail without GPG"

bind index gg first-entry
bind index G  last-entry

bind pager k  previous-line
bind pager j  next-line
bind pager gg top
bind pager G  bottom

# View URLs inside Mutt with urlview
macro index \cb "|urlview\n"
macro pager \cb "|urlview\n"

# Note that we explicitly set the comment armor header since GnuPG, when used
# in some localiaztion environments, generates 8bit data in that header, thereby
# breaking PGP/MIME.

# decode application/pgp
set pgp_decode_command="gpg --status-fd=2 --no-verbose --quiet --batch --output - %f"

# verify a pgp/mime signature
set pgp_verify_command="gpg --status-fd=2 --no-verbose --quiet --batch --output - --verify %s %f"

# decrypt a pgp/mime attachment
set pgp_decrypt_command="gpg --status-fd=2 --no-verbose --quiet --batch --output - %f"

# create a pgp/mime signed attachment
# set pgp_sign_command="gpg-2comp --comment '' --no-verbose --batch --output - %?p?--passphrase-fd 0? --armor --detach-sign --textmode %?a?-u %a? %f"
set pgp_sign_command="gpg --no-verbose --batch --quiet --output - --armor --detach-sign --textmode %?a?-u %a? %f"

# create a application/pgp signed (old-style) message
# set pgp_clearsign_command="gpg-2comp --comment '' --no-verbose --batch --output - %?p?--passphrase-fd 0? --armor --textmode --clearsign %?a?-u %a? %f"
set pgp_clearsign_command="gpg --no-verbose --batch --quiet --output - %?p?--passphrase-fd 0? --armor --textmode --clearsign %?a?-u %a? %f"

# create a pgp/mime encrypted attachment
# set pgp_encrypt_only_command="pgpewrap gpg-2comp -v --batch --output - --encrypt --textmode --armor --always-trust -- -r %r -- %f"
set pgp_encrypt_only_command="/usr/lib/mutt/pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust -- -r %r -- %f"

# create a pgp/mime encrypted and signed attachment
# set pgp_encrypt_sign_command="pgpewrap gpg-2comp %?p?--passphrase-fd 0? -v --batch --output - --encrypt --sign %?a?-u %a? --armor --always-trust -- -r %r -- %f"
set pgp_encrypt_sign_command="/usr/lib/mutt/pgpewrap gpg --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust -- -r %r -- %f"

# import a key into the public key ring
set pgp_import_command="gpg --no-verbose --import %f"

# export a key from the public key ring
set pgp_export_command="gpg --no-verbose --export --armor %r"

# verify a key
set pgp_verify_key_command="gpg --verbose --batch --fingerprint --check-sigs %r"

# read in the public key ring
set pgp_list_pubring_command="gpg --no-verbose --batch --quiet --with-colons --list-keys %r" 

# read in the secret key ring
set pgp_list_secring_command="gpg --no-verbose --batch --quiet --with-colons --list-secret-keys %r" 

# fetch keys
# set pgp_getkeys_command="pkspxycwrap %r"
# This will work when #172960 will be fixed upstream
# set pgp_getkeys_command="gpg --recv-keys %r"

# pattern for good signature - may need to be adapted to locale!

# set pgp_good_sign="^gpgv?: Good signature from "

# OK, here's a version which uses gnupg's message catalog:
# set pgp_good_sign="`gettext -d gnupg -s 'Good signature from "' | tr -d '"'`"

# This version uses --status-fd messages
set pgp_good_sign="^\\[GNUPG:\\] GOODSIG"

# daniel j wilcox pgp
set pgp_use_gpg_agent="yes"
set my_pgp_id="4090C806"



# mailcap
#=====================================================================

vim ~/.mutt/mailcap

# view html attachments with lynx
text/html; lynx %s

# images open with ristretto default image viewer
image/jpeg; ristretto %s
image/jpeg; ristretto %s
image/png; ristretto %s
image/gif; ristretto %s

# pdfs open with evince
application/pdf; evince %s

#=====================================================================


# start mutt and you should be prompted to save the password in the keyring and unlock at login

  
