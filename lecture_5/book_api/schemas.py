from pydantic import BaseModel
from typing import Optional#необязательно указывать или менять


class BookCreate(BaseModel):
    title: str
    author: str
    year: Optional[int] = None


class BookUpdate(BaseModel):
    title: Optional[str] = None
    author: Optional[str] = None
    year: Optional[int] = None


class BookResponse(BaseModel):
    id: int
    title: str
    author: str
    year: Optional[int] = None

    class Config:
        from_attributes = True#для работы с SQLAlchemy моделями