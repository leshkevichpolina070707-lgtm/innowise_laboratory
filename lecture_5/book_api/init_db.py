from database import engine, Base
from models import Book

print("Creating database tables...")
Base.metadata.create_all(bind=engine)
print("✅ Database created successfully!")
print("✅ Table 'books' created with columns: id, title, author, year")
