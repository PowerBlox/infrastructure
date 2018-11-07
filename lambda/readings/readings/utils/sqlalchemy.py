import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

ENGINE = create_engine('mysql+pymysql://{username}:{password}@{host}/{database}'.format(
    username=os.getenv('MYSQL_USERNAME'),
    password=os.getenv('MYSQL_PASSWORD'),
    host=os.getenv('MYSQL_HOST'),
    database=os.getenv('MYSQL_DATABASE'),
))

SESSION = sessionmaker(bind=ENGINE)


def get_session():
    return SESSION()


def row2dict(row):
    d = {}
    for column in row.__table__.columns:
        d[column.name] = getattr(row, column.name)
    return d
