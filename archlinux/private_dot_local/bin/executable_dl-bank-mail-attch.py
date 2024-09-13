#!/usr/bin/env python3

from dotenv import load_dotenv
load_dotenv(verbose=True)

import functools
import imaplib
import email
import os

# mail server config
mail_server = os.getenv('GMAIL_SMTP_SERVER')
mail_user = os.getenv('GMAIL_USER')
mail_password = os.getenv('GMAIL_PW')
mail_folder = os.getenv('GMAIL_FOLDER')

# config
download_dir = os.getenv('DOWNLOAD_DIR') + '/tests'

def decode_mime_words(s):
    return ''.join(
        word.decode(encoding or 'utf8') for word, encoding in email.header.decode_header(s)
)

# 連接到郵件伺服器
M = imaplib.IMAP4_SSL(mail_server)
M.login(mail_user, mail_password)
M.select(mail_folder)

# TODO 搜尋主旨，儲存檔名(發信日-)

def dl_bank_mail_attch(num):
    typ, msg_data = M.fetch(num, '(RFC822)')
    email_message = email.message_from_bytes(msg_data[0][1])

    # 獲取郵件主旨
    subject = email_message['Subject']
    print(num.decode(), decode_mime_words(subject))
    # print('永豐銀*' in decode_mime_words(subject))
    M.store(num, '-FLAGS', '(\Seen)')

    # 是否包含附件
    has_attch = False
    if email_message.get_content_maintype() == 'multipart':
        has_attch = functools.reduce(
            lambda a, b: b and a,
            (part.get_content_disposition() is None for part in email_message.walk()),
            True
        )
    return has_attch

    # 如果主旨符合特定條件
    # if '特定主旨關鍵字' in subject:
    #     # 下載附件
    #     for part in email_message.walk():
    #         if part.get_content_maintype() == 'multipart':
    #             continue
    #         if part.get('Content-Disposition') is None:
    #             continue
    #         filename = part.get_filename()
    #         if filename:
    #             filepath = os.path.join(download_dir, filename)
    #             if not os.path.isfile(filepath):
    #                 with open(filepath, 'wb') as f:
    #                     f.write(part.get_payload(decode=True))

# TODO 移除附件密碼

# 搜索未讀郵件（未讀郵件的標誌為'UNSEEN'）
result, data = M.search(None, '(UNSEEN)')
iter = 0

# 遍歷所有未讀郵件
for num in reversed(data[0].split()):
    if dl_bank_mail_attch(num): 
        break

# 關閉郵件伺服器連接
M.close()
M.logout()


def main():
    print ('Hello, World!')


# main()
