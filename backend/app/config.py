from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', extra='ignore')

    DATABASE_URL: str
    SECRET_KEY: str
    TOKEN_EXPIRY_HOURS: int = 24
    BACKEND_PORT: int = 8001
    POSTGRES_USER: str = "alumni_admin"
    POSTGRES_PASSWORD: str = ""
    POSTGRES_DB: str = "alumni_db"
    SMTP_SERVER: str = ""
    SMTP_USER: str = ""
    SMTP_PASSWORD: str = ""
    SMTP_PORT: int = 465
    FRONTEND_URL: str = "http://localhost:8085"
    ADMIN_USER: str = "admin"
    ADMIN_DEFAULTPASSWORD: str = ""
    ADMIN_EMAIL: str = ""
    HCAPTCHA_SECRET_KEY: str = ""
    HCAPTCHA_SITE_KEY: str = ""

settings = Settings()
