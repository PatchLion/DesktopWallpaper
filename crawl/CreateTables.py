#! /usr/bin/env python
# -*- coding: utf-8 -*-
from sqlalchemy import create_engine, Column, Integer, VARCHAR, Sequence
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from DB import mySQLConnectString

Base = declarative_base()


class Product(Base):
    __tablename__ = 'products'

    id = Column(Integer, Sequence('id'), primary_key=True)
    name = Column(VARCHAR(256))
    count = Column(Integer)

    def __repr__(self):
        return "<Product(id='%d', name='%s', count='%d')>" % (self.id, self.name, self.count)

engine = create_engine(mySQLConnectString, echo=False)  # True will turn on the logging

Session = sessionmaker(bind=engine)
session = Session()

Base.metadata.create_all(engine)