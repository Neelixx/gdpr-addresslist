from app.database import SessionLocal
from app.models import Person, Group
from app.auth import get_password_hash
from app.config import settings

def create_admin_user():
    db = SessionLocal()
    try:
        admin = db.query(Person).filter(Person.username == settings.ADMIN_USER).first()
        if admin:
            print(f"Admin user '{settings.ADMIN_USER}' already exists")
            return
        
        if not settings.ADMIN_DEFAULTPASSWORD or not settings.ADMIN_EMAIL:
            print("Admin credentials not configured in .env")
            return
        
        group = db.query(Group).first()
        if not group:
            group = Group(name="Administratoren")
            db.add(group)
            db.flush()
        
        admin = Person(
            gruppe_id=group.id,
            vorname="Admin",
            nachname="User",
            email_1=settings.ADMIN_EMAIL,
            username=settings.ADMIN_USER,
            password_hash=get_password_hash(settings.ADMIN_DEFAULTPASSWORD),
            admin=True,
            consent_storage=True,
            consent_sharing=True,
            consent_photos=True,
        )
        db.add(admin)
        db.commit()
        print(f"Admin user '{settings.ADMIN_USER}' created with email {settings.ADMIN_EMAIL}")
    except Exception as e:
        print(f"Error creating admin user: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    create_admin_user()