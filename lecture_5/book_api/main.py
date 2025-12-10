import sqlalchemy
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from database import get_db, engine
import models
import schemas
app = FastAPI(
    title="Book API",
    description="API для управления",#описание
    version="1.0.0",
)
models.Base.metadata.create_all(bind=engine)#построение таблиц
@app.get("/")
def read_root():
    return {"message": "Welcome to Book API","status":"active"}
@app.get("/health")
def health(db: Session = Depends(get_db)):
    try:
        return {"status":"healthy",
                "database" : "connected"
                }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database Error: {str(e)}")
@app.get("/info")
def info():
    return {
        "database": "SQLite",
        "message": "Database connection established",
        "tables": ["books"]
    }
@app.post("/books/", response_model=schemas.BookResponse, status_code=201)
def create_book(book: schemas.BookCreate, db: Session = Depends(get_db)):
    db_book = models.Book(title=book.title, author=book.author, year=book.year)
    db.add(db_book)
    db.commit()
    db.refresh(db_book)
    return db_book
@app.get("/books/", response_model=list[schemas.BookResponse])
def get_books(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    books = db.query(models.Book).offset(skip).limit(limit).all()
    return books
@app.delete("/books/{book_id}")
def delete_book(book_id: int, db: Session = Depends(get_db)):
    book = db.query(models.Book).filter(models.Book.id == book_id).first()
    if book is None:
        raise HTTPException(status_code=404, detail="Book not found")
    db.delete(book)
    db.commit()
    return {"message": f"Book with id {book_id} deleted successfully"}
@app.get("/books/{book_id}", response_model=schemas.BookResponse)
def get_book(book_id: int, db: Session = Depends(get_db)):
    book = db.query(models.Book).filter(models.Book.id == book_id).first()
    if book is None:
        raise HTTPException(status_code=404, detail="Book not found")
    return book
@app.put("/books/{book_id}", response_model=schemas.BookResponse)
def update_book(book_id: int, book_update: schemas.BookUpdate, db: Session = Depends(get_db)):
    db_book = db.query(models.Book).filter(models.Book.id == book_id).first()
    if db_book is None:
        raise HTTPException(status_code=404, detail="Book not found")
    update_data = book_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_book, field, value)
    db.commit()
    db.refresh(db_book)
    return db_book