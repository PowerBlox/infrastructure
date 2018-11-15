from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, DateTime, TIMESTAMP

Base = declarative_base()


class Device(Base):
    __tablename__ = 'devices'

    id = Column(Integer, primary_key=True)
    name = Column(String)
    hardware_mac_id = Column(String)
    hardware_rev = Column(String)
    software_ref = Column(String)
    base_station_id = Column(String)
    created_at = Column(DateTime)
    modified_at = Column(DateTime)
    created_by = Column(Integer)
    modified_by = Column(Integer)
    HARDWAREID = Column(Integer)


class RawData(Base):
    __tablename__ = 'node_red_import'

    id = Column(Integer, primary_key=True)

    gbl_tsp = Column(TIMESTAMP)
    gtw_mac_id = Column(String)
    pbx_mac_id = Column(String)
    reg_00 = Column(String)
    reg_01 = Column(String)
    reg_18 = Column(String)
    reg_19 = Column(String)
    reg_1A = Column(String)
    reg_1C = Column(String)
    reg_1D = Column(String)
    reg_22 = Column(String)
    reg_40 = Column(String)
    reg_41 = Column(String)
    reg_4D = Column(String)
    reg_4F = Column(String)
    reg_50 = Column(String)
    reg_51 = Column(String)
    reg_79 = Column(String)
    reg_80 = Column(String)
    reg_81 = Column(String)
    reg_8C = Column(String)
    reg_8D = Column(String)
