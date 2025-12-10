from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
SQLALCHEMY_DATABASE_URL = "sqlite:///./books.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})#в скобках нужно для FastAPI
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)#класс серии
Base = declarative_base()
def get_db():
    db = SessionLocal()
    try:
        yield db#приостанавливает выполнение
    finally:
        db.close()