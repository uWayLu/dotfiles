#!/usr/bin/env python3

from dotenv import load_dotenv
load_dotenv(verbose=True)

import imaplib
import email
import os

# mail server config
mail_server = os.getenv('GMAIL_SMTP_SERVER')
mail_user = os.getenv('GMAIL_USER')
mail_password = os.getenv('GMAIL_PW')
mail_folder = os.getenv('GMAIL_FOLDER')

def main():
    mail = imaplib.IMAP4_SSL(mail_server)
    mail.login(mail_user, mail_password)
    print(mail.noop())

main()
