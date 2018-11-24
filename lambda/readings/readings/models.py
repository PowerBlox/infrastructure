from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String, Boolean, DateTime, TIMESTAMP

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
    reg_12 = Column(Boolean)
    reg_13 = Column(Boolean)
    reg_14 = Column(Boolean)
    reg_15 = Column(Boolean)
    reg_16 = Column(Boolean)
    reg_17 = Column(Boolean)
    reg_18 = Column(String)
    reg_19 = Column(String)
    reg_1A = Column(String)
    reg_1C = Column(String)
    reg_1D = Column(String)
    reg_1E = Column(String)
    reg_22 = Column(String)
    reg_23 = Column(String)
    reg_27 = Column(String)
    reg_28 = Column(String)
    reg_29 = Column(String)
    reg_40 = Column(String)
    reg_41 = Column(String)
    reg_49 = Column(Boolean)
    reg_4A = Column(String)
    reg_4B = Column(String)
    reg_4D = Column(String)
    reg_4F = Column(String)
    reg_50 = Column(String)
    reg_51 = Column(String)
    reg_52 = Column(String)
    reg_79 = Column(String)
    reg_80 = Column(String)
    reg_81 = Column(String)
    reg_8C = Column(String)
    reg_8D = Column(String)
    reg_8F = Column(String)
    reg_93 = Column(String)
    reg_C0 = Column(Boolean)
    reg_C9 = Column(String)
    reg_CA = Column(String)
