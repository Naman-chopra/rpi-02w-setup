import smtplib
import socket
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import subprocess
from datetime import datetime as dt
import time


def get_ip():
    try:
        ifconfig_output = subprocess.check_output(
            ["/usr/sbin/ifconfig", "wlan0"]
        ).decode("utf-8")
    except subprocess.CalledProcessError:
        print("Error running ifconfig")
        exit(1)

    # Parse the IP address from ifconfig output
    ip_address = None
    for line in ifconfig_output.split("\n"):
        if "inet " in line:
            parts = line.split()
            ip_address = parts[1]
            print(ip_address)
        copy_str = str(ip_address) + "\n"
    return copy_str


# Email settings
sender_email = "iamipupdater@gmail.com"
sender_password = "azywzopwpelbxfpv"
receiver_email = "kratoes669@gmail.com"

# Compose the email

msg = MIMEMultipart()
msg["From"] = sender_email
msg["To"] = receiver_email
msg["Subject"] = "IP Address Update"
msg.attach(MIMEText(get_ip(), "plain"))


# Send the email
def send_mail():
    with smtplib.SMTP("smtp.gmail.com", 587) as server:
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, msg.as_string())
        server.quit()
    print("Email sent at " + str(dt.now().time()))


init_ip = get_ip()
send_mail()
while True:
    curr_ip = get_ip()
    time.sleep(10)
    if curr_ip != init_ip:
        init_ip = curr_ip
        print("ip changed")
        send_mail()
