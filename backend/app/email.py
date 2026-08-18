import smtplib
import logging
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from app.config import settings

logger = logging.getLogger(__name__)

def send_magic_link_email(email: str, magic_link: str) -> bool:
    if not settings.SMTP_SERVER or not settings.SMTP_USER or not settings.SMTP_PASSWORD:
        logger.warning("SMTP not configured, skipping email send")
        return False
    
    try:
        msg = MIMEMultipart('alternative')
        msg['From'] = settings.SMTP_USER
        msg['To'] = email
        msg['Bcc'] = settings.SMTP_USER
        msg['Subject'] = "Anmeldelink für Ihre Alumni-Adressliste"
        
        text_body = f"""Anmeldelink für Ihre Alumni-Adressliste

Sie haben einen Link zur Anmeldung angefordert.

Klicken Sie auf den untenstehenden Link, um sich anzumelden:
{magic_link}

Dieser Link ist {settings.TOKEN_EXPIRY_HOURS} Stunden gültig.

Falls Sie diesen Link nicht angefordert haben, ignorieren Sie diese E-Mail einfach.
"""
        
        html_body = f"""
        <html>
        <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
            <h2 style="color: #2c3e50;">Anmeldelink für Ihre Alumni-Adressliste</h2>
            <p>Sie haben einen Link zur Anmeldung angefordert.</p>
            <p><a href="{magic_link}" style="display: inline-block; padding: 12px 24px; background-color: #3498db; color: white; text-decoration: none; border-radius: 4px;">Anmelden</a></p>
            <p style="font-size: 0.9em; color: #666;">Oder kopieren Sie diesen Link in Ihren Browser:<br><a href="{magic_link}">{magic_link}</a></p>
            <p style="font-size: 0.9em; color: #666;">Dieser Link ist {settings.TOKEN_EXPIRY_HOURS} Stunden gültig.</p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="font-size: 0.85em; color: #999;">Falls Sie diesen Link nicht angefordert haben, ignorieren Sie diese E-Mail einfach.</p>
        </body>
        </html>
        """
        
        msg.attach(MIMEText(text_body, 'plain'))
        msg.attach(MIMEText(html_body, 'html'))
        
        with smtplib.SMTP_SSL(settings.SMTP_SERVER, settings.SMTP_PORT) as server:
            server.login(settings.SMTP_USER, settings.SMTP_PASSWORD)
            server.send_message(msg)
        
        logger.info(f"Magic link email sent to {email}")
        return True
    except Exception as e:
        logger.error(f"Failed to send magic link email to {email}: {e}")
        return False