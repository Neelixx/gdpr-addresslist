from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', extra='ignore')
    
    DATABASE_URL: str
    SECRET_KEY: str = "change-me-in-production"
    TOKEN_EXPIRY_HOURS: int = 24
    BACKEND_PORT: int = 8001
    POSTGRES_USER: str = "alumni_admin"
    POSTGRES_PASSWORD: str = "super_secret_password_123"
    POSTGRES_DB: str = "alumni_db"

settings = Settings()
