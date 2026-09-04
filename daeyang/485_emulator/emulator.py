from __future__ import annotations
import sys, time, os, ctypes
from datetime import datetime

def _resource(name: str) -> str:
    base = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base, name)
import serial
import serial.tools.list_ports
from PyQt5.QtWidgets import *
from PyQt5.QtCore import Qt, QThread, pyqtSignal
from PyQt5.QtGui import QFont, QColor
from PyQt5.QtWidgets import QSizePolicy

# ── CRC ──────────────────────────────────────────────────────────────────────
_CRC_TABLE = [
    0x0000,0xC0C1,0xC181,0x0140,0xC301,0x03C0,0x0280,0xC241,0xC601,0x06C0,0x0780,0xC741,
    0x0500,0xC5C1,0xC481,0x0440,0xCC01,0x0CC0,0x0D80,0xCD41,0x0F00,0xCFC1,0xCE81,0x0E40,
    0x0A00,0xCAC1,0xCB81,0x0B40,0xC901,0x09C0,0x0880,0xC841,0xD801,0x18C0,0x1980,0xD941,
    0x1B00,0xDBC1,0xDA81,0x1A40,0x1E00,0xDEC1,0xDF81,0x1F40,0xDD01,0x1DC0,0x1C80,0xDC41,
    0x1400,0xD4C1,0xD581,0x1540,0xD701,0x17C0,0x1680,0xD641,0xD201,0x12C0,0x1380,0xD341,
    0x1100,0xD1C1,0xD081,0x1040,0xF001,0x30C0,0x3180,0xF141,0x3300,0xF3C1,0xF281,0x3240,
    0x3600,0xF6C1,0xF781,0x3740,0xF501,0x35C0,0x3480,0xF441,0x3C00,0xFCC1,0xFD81,0x3D40,
    0xFF01,0x3FC0,0x3E80,0xFE41,0xFA01,0x3AC0,0x3B80,0xFB41,0x3900,0xF9C1,0xF881,0x3840,
    0x2800,0xE8C1,0xE981,0x2940,0xEB01,0x2BC0,0x2A80,0xEA41,0xEE01,0x2EC0,0x2F80,0xEF41,
    0x2D00,0xEDC1,0xEC81,0x2C40,0xE401,0x24C0,0x2580,0xE541,0x2700,0xE7C1,0xE681,0x2640,
    0x2200,0xE2C1,0xE381,0x2340,0xE101,0x21C0,0x2080,0xE041,0xA001,0x60C0,0x6180,0xA141,
    0x6300,0xA3C1,0xA281,0x6240,0x6600,0xA6C1,0xA781,0x6740,0xA501,0x65C0,0x6480,0xA441,
    0x6C00,0xACC1,0xAD81,0x6D40,0xAF01,0x6FC0,0x6E80,0xAE41,0xAA01,0x6AC0,0x6B80,0xAB41,
    0x6900,0xA9C1,0xA881,0x6840,0x7800,0xB8C1,0xB981,0x7940,0xBB01,0x7BC0,0x7A80,0xBA41,
    0xBE01,0x7EC0,0x7F80,0xBF41,0x7D00,0xBDC1,0xBC81,0x7C40,0xB401,0x74C0,0x7580,0xB541,
    0x7700,0xB7C1,0xB681,0x7640,0x7200,0xB2C1,0xB381,0x7340,0xB101,0x71C0,0x7080,0xB041,
    0x5000,0x90C1,0x9181,0x5140,0x9301,0x53C0,0x5280,0x9241,0x9601,0x56C0,0x5780,0x9741,
    0x5500,0x95C1,0x9481,0x5440,0x9C01,0x5CC0,0x5D80,0x9D41,0x5F00,0x9FC1,0x9E81,0x5E40,
    0x5A00,0x9AC1,0x9B81,0x5B40,0x9901,0x59C0,0x5880,0x9841,0x8801,0x48C0,0x4980,0x8941,
    0x4B00,0x8BC1,0x8A81,0x4A40,0x4E00,0x8EC1,0x8F81,0x4F40,0x8D01,0x4DC0,0x4C80,0x8C41,
    0x4400,0x84C1,0x8581,0x4540,0x8701,0x47C0,0x4680,0x8641,0x8201,0x42C0,0x4380,0x8341,
    0x4100,0x81C1,0x8081,0x4040,
]

def _modbus_crc16(data: bytes) -> tuple:
    crc = 0xFFFF
    for b in data:
        crc ^= b
        for _ in range(8):
            crc = (crc >> 1) ^ 0xA001 if crc & 1 else crc >> 1
    return crc & 0xFF, (crc >> 8) & 0xFF

def _kaco_crc16(text: str) -> int:
    lo, hi = 0xFF, 0xFF
    for b in text.encode('ascii'):
        n = _CRC_TABLE[(lo ^ b) & 0xFF]
        lo = (n & 0xFF) ^ hi
        hi = (n >> 8) & 0xFF
    return (~((hi << 8) | lo)) & 0xFFFF


# ── KACO ASCII 응답 생성 ───────────────────────────────────────────────────────
def _build_kaco_std(addr: str, v: dict) -> str:
    return (f"*{addr}0 {v.get(101,4)} "
            f"{v.get(102,6500)/10:.1f} {v.get(103,1000)/100:.2f} {v.get(104,50000):.0f} "
            f"{v.get(105,3800)/10:.1f} {v.get(106,1315)/100:.2f} {v.get(107,50000):.0f} "
            f"{v.get(108,350)/10:.1f}")

def _build_kaco_std_yield(addr: str, v: dict) -> str:
    d2 = f"{int(v.get(109,150)*1000):06d}"[:6]
    d4 = f"{int(v.get(110,500)*1000):06d}"[:6]
    return f"*{addr}3 50000{d2}000000{d4}000000:00000000:00000000:00"

def _build_kaco_gen2(addr: str, v: dict, typ: str = "200TL") -> str:
    sta  = v.get(201, 4)
    udc1 = v.get(202,6287)/10;  idc1 = v.get(203,521)/100;  pdc1 = v.get(204,3282)
    udc2 = v.get(205,6332)/10;  idc2 = v.get(206,267)/100;  pdc2 = v.get(207,1692)
    uac1 = v.get(208,2288)/10;  iac1 = v.get(209,753)/100
    uac2 = v.get(210,2306)/10;  iac2 = v.get(211,758)/100
    uac3 = v.get(212,2313)/10;  iac3 = v.get(213,751)/100
    pac  = v.get(214,5174);     temp = v.get(215,562)/10
    eday = v.get(216,78)*1000
    payload = (f"{udc1:.1f} {idc1:.2f} {pdc1:.0f} "
               f"{udc2:.1f} {idc2:.2f} {pdc2:.0f} "
               f"{uac1:.1f} {iac1:.2f} {uac2:.1f} {iac2:.2f} {uac3:.1f} {iac3:.2f} "
               f"{pdc1+pdc2:.0f} {pac:.0f} 1.000c {temp:.1f} {eday:.0f}")
    body = f"*{addr}n 20 {typ} {sta} {payload} "
    return f"{body}{_kaco_crc16(body[1:]):04X}"

def _build_kaco_gen3(addr: str, v: dict, typ: str = "200TL") -> str:
    sta  = v.get(301, 4)
    udc1 = v.get(302,6500)/10;  idc1 = v.get(303,1000)/100;  pdc1 = v.get(304,16667)
    udc2 = v.get(305,6500)/10;  idc2 = v.get(306,1000)/100;  pdc2 = v.get(307,16667)
    udc3 = v.get(308,6500)/10;  idc3 = v.get(309,1000)/100;  pdc3 = v.get(310,16667)
    uac1 = v.get(311,3800)/10;  iac1 = v.get(312,2380)/100
    uac2 = v.get(313,3800)/10;  iac2 = v.get(314,2380)/100
    uac3 = v.get(315,3800)/10;  iac3 = v.get(316,2380)/100
    pac  = v.get(317,50000);    temp = v.get(318,350)/10
    eday = v.get(319,150)*1000
    payload = (f"{udc1:.1f} {idc1:.2f} {pdc1:.0f} "
               f"{udc2:.1f} {idc2:.2f} {pdc2:.0f} "
               f"{udc3:.1f} {idc3:.2f} {pdc3:.0f} "
               f"{uac1:.1f} {iac1:.2f} {uac2:.1f} {iac2:.2f} {uac3:.1f} {iac3:.2f} "
               f"{pdc1+pdc2+pdc3:.0f} {pac:.0f} 1.000c {temp:.1f} {eday:.0f}")
    body = f"*{addr}n 23 {typ} {sta} {payload} "
    return f"{body}{_kaco_crc16(body[1:]):04X}"

def _build_kaco_gen1(addr: str, v: dict, typ: str = "100kTR") -> str:
    sta  = v.get(401, 4)
    udc1 = v.get(402,6500)/10;  idc1 = v.get(403,1000)/100
    uac1 = v.get(404,3800)/10;  iac1 = v.get(405,2380)/100
    uac2 = v.get(406,3800)/10;  iac2 = v.get(407,2380)/100
    uac3 = v.get(408,3800)/10;  iac3 = v.get(409,2380)/100
    pac  = v.get(410,50000);    temp = v.get(411,350)/10
    eday = v.get(412,150)*1000
    pdc  = udc1 * idc1
    payload = (f"{udc1:.1f} {idc1:.2f} "
               f"{uac1:.1f} {iac1:.2f} {uac2:.1f} {iac2:.2f} {uac3:.1f} {iac3:.2f} "
               f"{pdc:.0f} {pac:.0f} 1.000c {temp:.1f} {eday:.0f}")
    body = f"*{addr}n 16 {typ} {sta} {payload} "
    return f"{body}{_kaco_crc16(body[1:]):04X}"

def _build_kaco_gen_yield(addr: str, daily: float, total: float) -> str:
    return (f"*{addr}3 50000 {int(daily*1000)} 0 {int(total*1000)} "
            f"000000:00 000000:00 000000:00")


# ── 레지스터 맵 ───────────────────────────────────────────────────────────────
ADDR_INFO = {
    # ── KACO Standard ─────────────────────────────────────────────────────────
    101: {"name": "STA (상태코드)",      "scale": "Code",     "type": "ASCII"},
    102: {"name": "Vpv (DC전압)",        "scale": "x0.1 V",   "type": "ASCII"},
    103: {"name": "Ipv (DC전류)",        "scale": "x0.01 A",  "type": "ASCII"},
    104: {"name": "PDC (DC전력)",        "scale": "x1 W",     "type": "ASCII"},
    105: {"name": "UAC (AC전압)",        "scale": "x0.1 V",   "type": "ASCII"},
    106: {"name": "IAC (AC전류)",        "scale": "x0.01 A",  "type": "ASCII"},
    107: {"name": "PAC (AC전력)",        "scale": "x1 W",     "type": "ASCII"},
    108: {"name": "온도",                "scale": "x0.1 ℃",   "type": "ASCII"},
    109: {"name": "Daily",              "scale": "x1 kWh",   "type": "ASCII"},
    110: {"name": "Total",              "scale": "x1 kWh",   "type": "ASCII"},
    # ── KACO Generic 2MPPT ────────────────────────────────────────────────────
    201: {"name": "STA",                "scale": "Code",     "type": "ASCII"},
    202: {"name": "UDC1 (DC전압1)",      "scale": "x0.1 V",   "type": "ASCII"},
    203: {"name": "IDC1 (DC전류1)",      "scale": "x0.01 A",  "type": "ASCII"},
    204: {"name": "PDC1 (DC전력1)",      "scale": "x1 W",     "type": "ASCII"},
    205: {"name": "UDC2 (DC전압2)",      "scale": "x0.1 V",   "type": "ASCII"},
    206: {"name": "IDC2 (DC전류2)",      "scale": "x0.01 A",  "type": "ASCII"},
    207: {"name": "PDC2 (DC전력2)",      "scale": "x1 W",     "type": "ASCII"},
    208: {"name": "UAC1 (AC전압 A)",     "scale": "x0.1 V",   "type": "ASCII"},
    209: {"name": "IAC1 (AC전류 A)",     "scale": "x0.01 A",  "type": "ASCII"},
    210: {"name": "UAC2 (AC전압 B)",     "scale": "x0.1 V",   "type": "ASCII"},
    211: {"name": "IAC2 (AC전류 B)",     "scale": "x0.01 A",  "type": "ASCII"},
    212: {"name": "UAC3 (AC전압 C)",     "scale": "x0.1 V",   "type": "ASCII"},
    213: {"name": "IAC3 (AC전류 C)",     "scale": "x0.01 A",  "type": "ASCII"},
    214: {"name": "PAC (AC전력)",        "scale": "x1 W",     "type": "ASCII"},
    215: {"name": "온도",                "scale": "x0.1 ℃",   "type": "ASCII"},
    216: {"name": "Daily",              "scale": "x1 kWh",   "type": "ASCII"},
    217: {"name": "Total",              "scale": "x1 kWh",   "type": "ASCII"},
    # ── KACO Generic 3MPPT ────────────────────────────────────────────────────
    301: {"name": "STA",                "scale": "Code",     "type": "ASCII"},
    302: {"name": "UDC1",               "scale": "x0.1 V",   "type": "ASCII"},
    303: {"name": "IDC1",               "scale": "x0.01 A",  "type": "ASCII"},
    304: {"name": "PDC1",               "scale": "x1 W",     "type": "ASCII"},
    305: {"name": "UDC2",               "scale": "x0.1 V",   "type": "ASCII"},
    306: {"name": "IDC2",               "scale": "x0.01 A",  "type": "ASCII"},
    307: {"name": "PDC2",               "scale": "x1 W",     "type": "ASCII"},
    308: {"name": "UDC3",               "scale": "x0.1 V",   "type": "ASCII"},
    309: {"name": "IDC3",               "scale": "x0.01 A",  "type": "ASCII"},
    310: {"name": "PDC3",               "scale": "x1 W",     "type": "ASCII"},
    311: {"name": "UAC1",               "scale": "x0.1 V",   "type": "ASCII"},
    312: {"name": "IAC1",               "scale": "x0.01 A",  "type": "ASCII"},
    313: {"name": "UAC2",               "scale": "x0.1 V",   "type": "ASCII"},
    314: {"name": "IAC2",               "scale": "x0.01 A",  "type": "ASCII"},
    315: {"name": "UAC3",               "scale": "x0.1 V",   "type": "ASCII"},
    316: {"name": "IAC3",               "scale": "x0.01 A",  "type": "ASCII"},
    317: {"name": "PAC",                "scale": "x1 W",     "type": "ASCII"},
    318: {"name": "온도",                "scale": "x0.1 ℃",   "type": "ASCII"},
    319: {"name": "Daily",              "scale": "x1 kWh",   "type": "ASCII"},
    320: {"name": "Total",              "scale": "x1 kWh",   "type": "ASCII"},
    # ── KACO Generic 1MPPT ────────────────────────────────────────────────────
    401: {"name": "STA",                "scale": "Code",     "type": "ASCII"},
    402: {"name": "UDC1",               "scale": "x0.1 V",   "type": "ASCII"},
    403: {"name": "IDC1",               "scale": "x0.01 A",  "type": "ASCII"},
    404: {"name": "UAC1",               "scale": "x0.1 V",   "type": "ASCII"},
    405: {"name": "IAC1",               "scale": "x0.01 A",  "type": "ASCII"},
    406: {"name": "UAC2",               "scale": "x0.1 V",   "type": "ASCII"},
    407: {"name": "IAC2",               "scale": "x0.01 A",  "type": "ASCII"},
    408: {"name": "UAC3",               "scale": "x0.1 V",   "type": "ASCII"},
    409: {"name": "IAC3",               "scale": "x0.01 A",  "type": "ASCII"},
    410: {"name": "PAC",                "scale": "x1 W",     "type": "ASCII"},
    411: {"name": "온도",                "scale": "x0.1 ℃",   "type": "ASCII"},
    412: {"name": "Daily",              "scale": "x1 kWh",   "type": "ASCII"},
    413: {"name": "Total",              "scale": "x1 kWh",   "type": "ASCII"},
    # ── GoodWe 60kW (FC=03) ───────────────────────────────────────────────────
    0x0222: {"name": "ETotal High",     "scale": "U32 High", "type": "U32"},
    0x0223: {"name": "ETotal Low",      "scale": "U32 Low",  "type": "U32"},
    0x0224: {"name": "HTotal High",     "scale": "U32 High", "type": "U32"},
    0x0225: {"name": "HTotal Low",      "scale": "U32 Low",  "type": "U32"},
    0x022A: {"name": "Grid V A",        "scale": "x0.1 V",   "type": "U16"},
    0x022B: {"name": "Grid V B",        "scale": "x0.1 V",   "type": "U16"},
    0x022C: {"name": "Grid V C",        "scale": "x0.1 V",   "type": "U16"},
    0x022D: {"name": "Grid I A",        "scale": "x0.1 A",   "type": "U16"},
    0x022E: {"name": "Grid I B",        "scale": "x0.1 A",   "type": "U16"},
    0x022F: {"name": "Grid I C",        "scale": "x0.1 A",   "type": "U16"},
    0x0230: {"name": "Freq A",          "scale": "x0.01 Hz", "type": "U16"},
    0x0231: {"name": "Freq B",          "scale": "x0.01 Hz", "type": "U16"},
    0x0232: {"name": "Freq C",          "scale": "x0.01 Hz", "type": "U16"},
    0x0233: {"name": "Active Power",    "scale": "x1 W",     "type": "U16"},
    0x0234: {"name": "Running Status",  "scale": "Code",     "type": "U16"},
    0x0235: {"name": "온도",             "scale": "x0.1 ℃",   "type": "U16"},
    0x0236: {"name": "EDay",            "scale": "x0.1 kWh", "type": "U16"},
    0x0300: {"name": "Vpv1",            "scale": "x0.1 V",   "type": "U16"},
    0x0301: {"name": "Vpv2",            "scale": "x0.1 V",   "type": "U16"},
    0x0302: {"name": "Vpv3",            "scale": "x0.1 V",   "type": "U16"},
    0x0303: {"name": "Vpv4",            "scale": "x0.1 V",   "type": "U16"},
    0x030E: {"name": "Ipv1",            "scale": "x0.1 A",   "type": "U16"},
    0x030F: {"name": "Ipv2",            "scale": "x0.1 A",   "type": "U16"},
    0x0310: {"name": "Ipv3",            "scale": "x0.1 A",   "type": "U16"},
    0x0311: {"name": "Ipv4",            "scale": "x0.1 A",   "type": "U16"},
    0x0357: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    0x0358: {"name": "ErrorH",          "scale": "Code",     "type": "U16"},
    0x0359: {"name": "ErrorL",          "scale": "Code",     "type": "U16"},
    0x035A: {"name": "Temp2",           "scale": "x0.1 ℃",   "type": "U16"},
    # ── Growatt (FC=04) ────────────────────────────────────────────────────────
    0x0000: {"name": "Status",          "scale": "Code",     "type": "U16"},
    0x0001: {"name": "Active Power L",  "scale": "x0.1 W",   "type": "U16"},
    0x0003: {"name": "Vpv1",            "scale": "x0.1 V",   "type": "U16"},
    0x0004: {"name": "Ipv1",            "scale": "x0.1 A",   "type": "U16"},
    0x0007: {"name": "Vpv2",            "scale": "x0.1 V",   "type": "U16"},
    0x0008: {"name": "Ipv2",            "scale": "x0.1 A",   "type": "U16"},
    0x000B: {"name": "Vpv3",            "scale": "x0.1 V",   "type": "U16"},
    0x000C: {"name": "Ipv3",            "scale": "x0.1 A",   "type": "U16"},
    0x000F: {"name": "Vpv4",            "scale": "x0.1 V",   "type": "U16"},
    0x0010: {"name": "Ipv4",            "scale": "x0.1 A",   "type": "U16"},
    0x0013: {"name": "Vpv5",            "scale": "x0.1 V",   "type": "U16"},
    0x0014: {"name": "Ipv5",            "scale": "x0.1 A",   "type": "U16"},
    0x0017: {"name": "Vpv6",            "scale": "x0.1 V",   "type": "U16"},
    0x0018: {"name": "Ipv6",            "scale": "x0.1 A",   "type": "U16"},
    0x001B: {"name": "Vpv7",            "scale": "x0.1 V",   "type": "U16"},
    0x001C: {"name": "Ipv7",            "scale": "x0.1 A",   "type": "U16"},
    0x001F: {"name": "Vpv8",            "scale": "x0.1 V",   "type": "U16"},
    0x0020: {"name": "Ipv8",            "scale": "x0.1 A",   "type": "U16"},
    0x0025: {"name": "Freq A",          "scale": "x0.01 Hz", "type": "U16"},
    0x0026: {"name": "V A",             "scale": "x0.1 V",   "type": "U16"},
    0x0027: {"name": "V AB",            "scale": "x0.1 V",   "type": "U16"},
    0x002A: {"name": "V BC",            "scale": "x0.1 V",   "type": "U16"},
    0x002B: {"name": "Freq B",          "scale": "x0.01 Hz", "type": "U16"},
    0x002E: {"name": "V CA",            "scale": "x0.1 V",   "type": "U16"},
    0x002F: {"name": "V B",             "scale": "x0.1 V",   "type": "U16"},
    0x0032: {"name": "V C",             "scale": "x0.1 V",   "type": "U16"},
    0x0033: {"name": "I A",             "scale": "x0.1 A",   "type": "U16"},
    0x0034: {"name": "I B",             "scale": "x0.1 A",   "type": "U16"},
    0x0035: {"name": "Today kWh",       "scale": "x0.1 kWh", "type": "U16"},
    0x0037: {"name": "Total kWh",       "scale": "x0.1 kWh", "type": "U16"},
    0x005D: {"name": "온도",             "scale": "x0.1 ℃",   "type": "U16"},
    0x005E: {"name": "온도2",            "scale": "x0.1 ℃",   "type": "U16"},
    0x0069: {"name": "Fault Code",      "scale": "Code",     "type": "U16"},
    0x006B: {"name": "Error Code",      "scale": "Code",     "type": "U16"},
    # ── Hyundai 50kW (FC=04) ──────────────────────────────────────────────────
    0x0016: {"name": "ETotal High",     "scale": "U32 High", "type": "U32"},
    0x0018: {"name": "EDay",            "scale": "x0.1 kWh", "type": "U16"},
    0x001D: {"name": "Active Power",    "scale": "x0.1 kW",  "type": "U16"},
    0x001F: {"name": "V AB",            "scale": "x0.1 V",   "type": "U16"},
    0x0021: {"name": "V BC",            "scale": "x0.1 V",   "type": "U16"},
    0x0023: {"name": "V CA",            "scale": "x0.1 V",   "type": "U16"},
    0x0025: {"name": "Freq A",          "scale": "x0.01 Hz", "type": "U16"},
    # 0x0025 conflict with Growatt handled by model selection
    0x002C: {"name": "Vpv1",            "scale": "x0.1 V",   "type": "U16"},
    0x002D: {"name": "Vpv2",            "scale": "x0.1 V",   "type": "U16"},
    0x002F: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    0x0036: {"name": "Error1",          "scale": "Code",     "type": "U16"},
    # ── Hyosung 100kW (FC=03) ─────────────────────────────────────────────────
    0x0011: {"name": "Vpv1",            "scale": "x0.1 V",   "type": "U16"},
    0x0012: {"name": "Ipv1",            "scale": "x0.01 A",  "type": "U16"},
    0x0013: {"name": "Vpv2",            "scale": "x0.1 V",   "type": "U16"},
    0x0019: {"name": "Active Power",    "scale": "x0.1 kW",  "type": "U16"},
    0x001A: {"name": "Active Power2",   "scale": "x0.1 kW",  "type": "U16"},
    0x0037: {"name": "V A",             "scale": "x0.1 V",   "type": "U16"},
    0x0038: {"name": "V B",             "scale": "x0.1 V",   "type": "U16"},
    0x0039: {"name": "V C",             "scale": "x0.1 V",   "type": "U16"},
    0x0063: {"name": "EDay",            "scale": "x0.1 kWh", "type": "U16"},
    0x0064: {"name": "ETotal",          "scale": "x0.1 kWh", "type": "U16"},
    0x0067: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    # ── Huawei SUN2000 (FC=03) ────────────────────────────────────────────────
    0x7D09: {"name": "State1",          "scale": "Code",     "type": "U16"},
    0x7D0A: {"name": "State2",          "scale": "Code",     "type": "U16"},
    0x7D0B: {"name": "State3",          "scale": "Code",     "type": "U32"},
    0x7D10: {"name": "Vpv1",            "scale": "x0.1 V",   "type": "U16"},
    0x7D11: {"name": "Ipv1",            "scale": "x0.01 A",  "type": "S16"},
    0x7D12: {"name": "Vpv2",            "scale": "x0.1 V",   "type": "U16"},
    0x7D13: {"name": "Ipv2",            "scale": "x0.01 A",  "type": "S16"},
    0x7D14: {"name": "Vpv3",            "scale": "x0.1 V",   "type": "U16"},
    0x7D15: {"name": "Ipv3",            "scale": "x0.01 A",  "type": "S16"},
    0x7D16: {"name": "Vpv4",            "scale": "x0.1 V",   "type": "U16"},
    0x7D17: {"name": "Ipv4",            "scale": "x0.01 A",  "type": "S16"},
    0x7D18: {"name": "Vpv5",            "scale": "x0.1 V",   "type": "U16"},
    0x7D19: {"name": "Ipv5",            "scale": "x0.01 A",  "type": "S16"},
    0x7D1A: {"name": "Vpv6",            "scale": "x0.1 V",   "type": "U16"},
    0x7D1B: {"name": "Ipv6",            "scale": "x0.01 A",  "type": "S16"},
    0x7D1C: {"name": "Vpv7",            "scale": "x0.1 V",   "type": "U16"},
    0x7D1D: {"name": "Ipv7",            "scale": "x0.01 A",  "type": "S16"},
    0x7D1E: {"name": "Vpv8",            "scale": "x0.1 V",   "type": "U16"},
    0x7D1F: {"name": "Ipv8",            "scale": "x0.01 A",  "type": "S16"},
    0x7D20: {"name": "Vpv9",            "scale": "x0.1 V",   "type": "U16"},
    0x7D21: {"name": "Ipv9",            "scale": "x0.01 A",  "type": "S16"},
    0x7D22: {"name": "Vpv10",           "scale": "x0.1 V",   "type": "U16"},
    0x7D23: {"name": "Ipv10",           "scale": "x0.01 A",  "type": "S16"},
    0x7D24: {"name": "Vpv11",           "scale": "x0.1 V",   "type": "U16"},
    0x7D25: {"name": "Ipv11",           "scale": "x0.01 A",  "type": "S16"},
    0x7D26: {"name": "Vpv12",           "scale": "x0.1 V",   "type": "U16"},
    0x7D27: {"name": "Ipv12",           "scale": "x0.01 A",  "type": "S16"},
    0x7D42: {"name": "V AB",            "scale": "x0.1 V",   "type": "U16"},
    0x7D43: {"name": "V BC",            "scale": "x0.1 V",   "type": "U16"},
    0x7D44: {"name": "V CA",            "scale": "x0.1 V",   "type": "U16"},
    0x7D45: {"name": "V A",             "scale": "x0.1 V",   "type": "U16"},
    0x7D46: {"name": "V B",             "scale": "x0.1 V",   "type": "U16"},
    0x7D47: {"name": "V C",             "scale": "x0.1 V",   "type": "U16"},
    0x7D48: {"name": "I A",             "scale": "x0.001 A", "type": "S32"},
    0x7D4A: {"name": "I B",             "scale": "x0.001 A", "type": "S32"},
    0x7D4C: {"name": "I C",             "scale": "x0.001 A", "type": "S32"},
    0x7D50: {"name": "Active Power",    "scale": "x0.001 kW","type": "S32"},
    0x7D55: {"name": "Freq",            "scale": "x0.01 Hz", "type": "U16"},
    0x7D57: {"name": "온도",             "scale": "x0.1 ℃",   "type": "S16"},
    0x7D59: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    0x7D6A: {"name": "ETotal High",     "scale": "U32 High", "type": "U32"},
    0x7D6B: {"name": "ETotal Low",      "scale": "U32 Low",  "type": "U32"},
    0x7D72: {"name": "EDay",            "scale": "x0.01 kWh","type": "U16"},
    0x7D73: {"name": "EDay2",           "scale": "x0.01 kWh","type": "U16"},
    # GoodWe 100kW 추가 레지스터 (Vpv/Ipv 9~24, 0x7D28~0x7D3F)
    0x7D28: {"name": "Vpv13",           "scale": "x0.1 V",   "type": "U16"},
    0x7D29: {"name": "Ipv13",           "scale": "x0.01 A",  "type": "S16"},
    0x7D2A: {"name": "Vpv14",           "scale": "x0.1 V",   "type": "U16"},
    0x7D2B: {"name": "Ipv14",           "scale": "x0.01 A",  "type": "S16"},
    0x7D2C: {"name": "Vpv15",           "scale": "x0.1 V",   "type": "U16"},
    0x7D2D: {"name": "Ipv15",           "scale": "x0.01 A",  "type": "S16"},
    0x7D2E: {"name": "Vpv16",           "scale": "x0.1 V",   "type": "U16"},
    0x7D2F: {"name": "Ipv16",           "scale": "x0.01 A",  "type": "S16"},
    0x7D30: {"name": "Vpv17",           "scale": "x0.1 V",   "type": "U16"},
    0x7D31: {"name": "Ipv17",           "scale": "x0.01 A",  "type": "S16"},
    0x7D32: {"name": "Vpv18",           "scale": "x0.1 V",   "type": "U16"},
    0x7D33: {"name": "Ipv18",           "scale": "x0.01 A",  "type": "S16"},
    0x7D34: {"name": "Vpv19",           "scale": "x0.1 V",   "type": "U16"},
    0x7D35: {"name": "Ipv19",           "scale": "x0.01 A",  "type": "S16"},
    0x7D36: {"name": "Vpv20",           "scale": "x0.1 V",   "type": "U16"},
    0x7D37: {"name": "Ipv20",           "scale": "x0.01 A",  "type": "S16"},
    0x7D38: {"name": "Vpv21",           "scale": "x0.1 V",   "type": "U16"},
    0x7D39: {"name": "Ipv21",           "scale": "x0.01 A",  "type": "S16"},
    0x7D3A: {"name": "Vpv22",           "scale": "x0.1 V",   "type": "U16"},
    0x7D3B: {"name": "Ipv22",           "scale": "x0.01 A",  "type": "S16"},
    0x7D3C: {"name": "Vpv23",           "scale": "x0.1 V",   "type": "U16"},
    0x7D3D: {"name": "Ipv23",           "scale": "x0.01 A",  "type": "S16"},
    0x7D3E: {"name": "Vpv24",           "scale": "x0.1 V",   "type": "U16"},
    0x7D3F: {"name": "Ipv24",           "scale": "x0.01 A",  "type": "S16"},
    0x8BAE: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    0x8B7E: {"name": "DSP Error Code",  "scale": "Code",     "type": "U16"},
    0x8B80: {"name": "DSP Alarm Code",  "scale": "Code",     "type": "U16"},
    # ── Hyundai 500kW (FC=03) ─────────────────────────────────────────────────
    0x02C1: {"name": "V RS",            "scale": "x0.1 V",   "type": "U16"},
    0x02C2: {"name": "V ST",            "scale": "x0.1 V",   "type": "U16"},
    0x02C3: {"name": "V TR",            "scale": "x0.1 V",   "type": "U16"},
    0x02C4: {"name": "I R",             "scale": "x0.1 A",   "type": "U16"},
    0x02C5: {"name": "I S",             "scale": "x0.1 A",   "type": "U16"},
    0x02C6: {"name": "I T",             "scale": "x0.1 A",   "type": "U16"},
    0x02C7: {"name": "V RS2",           "scale": "x0.1 V",   "type": "U16"},
    0x02C8: {"name": "V ST2",           "scale": "x0.1 V",   "type": "U16"},
    0x02C9: {"name": "V TR2",           "scale": "x0.1 V",   "type": "U16"},
    0x02CA: {"name": "I R2",            "scale": "x0.1 A",   "type": "U16"},
    0x02CB: {"name": "I S2",            "scale": "x0.1 A",   "type": "U16"},
    0x02CC: {"name": "I T2",            "scale": "x0.1 A",   "type": "U16"},
    0x02CD: {"name": "Active Power H",  "scale": "U32 High", "type": "U32"},
    0x02CE: {"name": "Active Power L",  "scale": "U32 Low",  "type": "U32"},
    0x02D1: {"name": "Freq H",          "scale": "U32 High", "type": "U32"},
    0x02D2: {"name": "Freq L",          "scale": "U32 Low",  "type": "U32"},
    0x02D5: {"name": "EDay H",          "scale": "U32 High", "type": "U32"},
    0x02D6: {"name": "EDay L",          "scale": "U32 Low",  "type": "U32"},
    0x02D7: {"name": "ETotal H",        "scale": "U32 High", "type": "U32"},
    0x02D8: {"name": "ETotal L",        "scale": "U32 Low",  "type": "U32"},
    0x02E3: {"name": "온도 H",           "scale": "U32 High", "type": "U32"},
    0x02E4: {"name": "온도 L",           "scale": "U32 Low",  "type": "U32"},
    0x02E5: {"name": "WorkMode H",      "scale": "U32 High", "type": "U32"},
    0x02E6: {"name": "WorkMode L",      "scale": "U32 Low",  "type": "U32"},
    0x02E7: {"name": "Error1",          "scale": "Code",     "type": "U16"},
    0x02E8: {"name": "Error2",          "scale": "Code",     "type": "U16"},
    0x02E9: {"name": "Error3",          "scale": "Code",     "type": "U16"},
    # ── Hyosung 36kW New (FC=03) ──────────────────────────────────────────────
    0x7E06: {"name": "Vpv1",            "scale": "x0.1 V",   "type": "U16"},
    0x7E07: {"name": "Ipv1",            "scale": "x0.1 A",   "type": "U16"},
    0x7E08: {"name": "Vpv2",            "scale": "x0.1 V",   "type": "U16"},
    0x7E09: {"name": "Ipv2",            "scale": "x0.1 A",   "type": "U16"},
    0x7E0A: {"name": "Vpv3",            "scale": "x0.1 V",   "type": "U16"},
    0x7E0B: {"name": "Ipv3",            "scale": "x0.1 A",   "type": "U16"},
    0x7E0C: {"name": "Vpv4",            "scale": "x0.1 V",   "type": "U16"},
    0x7E0D: {"name": "Ipv4",            "scale": "x0.1 A",   "type": "U16"},
    0x7E0E: {"name": "Vpv5",            "scale": "x0.1 V",   "type": "U16"},
    0x7E0F: {"name": "Ipv5",            "scale": "x0.1 A",   "type": "U16"},
    0x7E10: {"name": "Vpv6",            "scale": "x0.1 V",   "type": "U16"},
    0x7E11: {"name": "Ipv6",            "scale": "x0.1 A",   "type": "U16"},
    0x7E1B: {"name": "Grid Freq",       "scale": "x0.01 Hz", "type": "U16"},
    0x7E1F: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    0x7E22: {"name": "Active Power H",  "scale": "U32 High", "type": "U32"},
    0x7E23: {"name": "Active Power L",  "scale": "U32 Low",  "type": "U32"},
    0x7E2C: {"name": "ETotal H",        "scale": "U32 High", "type": "U32"},
    0x7E2D: {"name": "ETotal L",        "scale": "U32 Low",  "type": "U32"},
    0x7E32: {"name": "EDay H",          "scale": "U32 High", "type": "U32"},
    0x7E33: {"name": "EDay L",          "scale": "U32 Low",  "type": "U32"},
    0x7E3A: {"name": "V A",             "scale": "x0.1 V",   "type": "U16"},
    0x7E3B: {"name": "V B",             "scale": "x0.1 V",   "type": "U16"},
    0x7E3C: {"name": "V C",             "scale": "x0.1 V",   "type": "U16"},
    0x7E3D: {"name": "I A",             "scale": "x0.1 A",   "type": "U16"},
    # ── Solis (FC=04) ─────────────────────────────────────────────────────────
    0x0BBC: {"name": "Active Power H",  "scale": "U32 High", "type": "U32"},
    0x0BBD: {"name": "Active Power L",  "scale": "U32 Low",  "type": "U32"},
    0x0BC0: {"name": "ETotal High",     "scale": "U32 High", "type": "U32"},
    0x0BC1: {"name": "ETotal Low",      "scale": "U32 Low",  "type": "U32"},
    0x0BC6: {"name": "EDay",            "scale": "x0.1 kWh", "type": "U16"},
    0x0BD9: {"name": "V AB",            "scale": "x0.1 V",   "type": "U16"},
    0x0BDA: {"name": "V BC",            "scale": "x0.1 V",   "type": "U16"},
    0x0BDB: {"name": "V CA",            "scale": "x0.1 V",   "type": "U16"},
    0x0BDC: {"name": "V A",             "scale": "x0.1 V",   "type": "U16"},
    0x0BDD: {"name": "V B",             "scale": "x0.1 V",   "type": "U16"},
    0x0BDE: {"name": "V C",             "scale": "x0.1 V",   "type": "U16"},
    0x0BE1: {"name": "온도",             "scale": "x0.1 ℃",   "type": "U16"},
    0x0BE2: {"name": "Freq",            "scale": "x0.01 Hz", "type": "U16"},
    0x0BFA: {"name": "Error1",          "scale": "Code",     "type": "U16"},
    0x0BFB: {"name": "Error2",          "scale": "Code",     "type": "U16"},
    0x0BFC: {"name": "Error3",          "scale": "Code",     "type": "U16"},
    0x0BFD: {"name": "Error4",          "scale": "Code",     "type": "U16"},
    0x0BFF: {"name": "WorkMode",        "scale": "Code",     "type": "U16"},
    # ── K-STAR ────────────────────────────────────────────────────────────────
    3014: {"name": "RS계통 전압",         "scale": "x0.1 V",   "type": "U16"},
    3020: {"name": "R상 전류",            "scale": "x0.01 A",  "type": "S16"},
    3023: {"name": "유효전력(Active)",     "scale": "x0.001 kW","type": "S32"},
    3042: {"name": "금일 발전량",          "scale": "x1 kWh",   "type": "U16"},
    3038: {"name": "누적 발전량",          "scale": "x0.1 kWh", "type": "U32"},
    3026: {"name": "모듈 온도",            "scale": "x0.1 ℃",   "type": "S16"},
    3027: {"name": "DSP Alarm",          "scale": "Bit",      "type": "U16"},
    3028: {"name": "DSP Error",          "scale": "Code",     "type": "U32"},
    3030: {"name": "Work Mode",          "scale": "Code",     "type": "U16"},
    # ── SOFAR ─────────────────────────────────────────────────────────────────
    0x0584: {"name": "금일 발전량",        "scale": "x0.01 kWh","type": "U16"},
    0x0586: {"name": "누적 발전량",        "scale": "x0.001 kWh","type":"U32"},
    0x0588: {"name": "총 가동시간",        "scale": "x1 h",     "type": "U32"},
    0x058A: {"name": "내부 온도",          "scale": "x0.01 ℃",  "type": "S16"},
    0x0584+14: {"name": "A-B 전압",       "scale": "x0.1 V",   "type": "U16"},
    # ── Sungrow ───────────────────────────────────────────────────────────────
    5002: {"name": "금일 발전량",          "scale": "x0.1 kWh", "type": "U16"},
    5003: {"name": "누적 발전량",          "scale": "x1 kWh",   "type": "U32"},
    5007: {"name": "내부 온도",            "scale": "x0.1 ℃",   "type": "S16"},
    5018: {"name": "A-B 전압",            "scale": "x0.1 V",   "type": "U16"},
    5021: {"name": "A상 전류",             "scale": "x0.1 A",   "type": "S16"},
    5030: {"name": "유효전력(Active)",     "scale": "x0.001 kW","type": "S32"},
    5035: {"name": "계통 주파수",          "scale": "x0.1 Hz",  "type": "U16"},
    5037: {"name": "Work State",         "scale": "Code",     "type": "U16"},
    5044: {"name": "Fault/Alarm Code",   "scale": "Code",     "type": "U16"},
}

# K-STAR 60KTL 추가 레지스터
for i in range(3064, 3072):
    ADDR_INFO[i] = {"name": f"Istr{i-3063}", "scale": "x0.01 A", "type": "S16"}
ADDR_INFO[3036] = {"name": "Slave DSP Alarm", "scale": "Code", "type": "U16"}

# Solis PV 레지스터 추가
for i in range(15):
    ADDR_INFO[0x0DAB + i] = {"name": f"Ipv{i+1}", "scale": "x0.1 A", "type": "U16"}
    ADDR_INFO[0x0DC9 + i] = {"name": f"Vpv{i+1}", "scale": "x0.1 V", "type": "U16"}
# K-STAR PV 레지스터 추가
for i in [2984,2980,2976,2972,2968,2964,3000,3001,3002,2996,2992,2988]:
    ADDR_INFO[i] = {"name": "Vpv",  "scale": "x0.1 V",  "type": "U16"}
for i in [3004,3005,2997,2993,2989,2985,2981,2977,2973,2969,2965,3003]:
    ADDR_INFO[i] = {"name": "Ipv",  "scale": "x0.01 A", "type": "S16"}
for i in [3015,3016]:
    ADDR_INFO[i] = {"name": "계통전압", "scale": "x0.1 V","type": "U16"}
for i in [3017,3018,3019]:
    ADDR_INFO[i] = {"name": "계통주파수","scale":"x0.01 Hz","type": "U16"}
for i in [3021,3022]:
    ADDR_INFO[i] = {"name": "계통전류", "scale": "x0.01 A","type": "S16"}
# Sungrow PV 추가
for i in range(6):
    ADDR_INFO[5010+i*2] = {"name": f"Vpv{i+1}", "scale": "x0.1 V", "type": "U16"}
    ADDR_INFO[5011+i*2] = {"name": f"Ipv{i+1}", "scale": "x0.1 A", "type": "U16"}


# ── 모델 정의 ─────────────────────────────────────────────────────────────────
MODEL_MAPS = {
    # KACO
    "KACO Standard Protocol":                    {"keys": list(range(101,111)),  "brand": "KACO"},
    "KACO [2.2.2] Generic 2MPPT (200TL)":        {"keys": list(range(201,218)),  "brand": "KACO"},
    "KACO [2.2.1/2.2.3] Generic 3MPPT":          {"keys": list(range(301,321)),  "brand": "KACO"},
    "KACO [2.2.4] Generic 1MPPT (XP/TL3 M1)":   {"keys": list(range(401,414)),  "brand": "KACO"},
    # GoodWe
    "GoodWe 60kW":  {"keys": [0x0222,0x0223,0x0224,0x0225,
                               0x022A,0x022B,0x022C,0x022D,0x022E,0x022F,
                               0x0230,0x0231,0x0232,0x0233,0x0234,0x0235,0x0236,
                               0x0300,0x0301,0x0302,0x0303,
                               0x030E,0x030F,0x0310,0x0311,
                               0x0357,0x0358,0x0359,0x035A],
                     "brand": "GoodWe", "fc": 3},
    # Growatt
    "Growatt":      {"keys": [0x0000,0x0001,0x0003,0x0004,0x0007,0x0008,
                               0x000B,0x000C,0x000F,0x0010,0x0013,0x0014,
                               0x0017,0x0018,0x001B,0x001C,0x001F,0x0020,
                               0x0025,0x0026,0x0027,0x002A,0x002B,0x002E,
                               0x002F,0x0032,0x0033,0x0034,0x0035,0x0037,
                               0x005D,0x005E,0x0069,0x006B],
                     "brand": "Growatt", "fc": 4},
    # Hyundai
    "Hyundai 50kW": {"keys": [0x0016,0x0017,0x0018,0x001D,
                               0x001F,0x0021,0x0023,0x0025,
                               0x002C,0x002D,0x002F,0x0036],
                     "brand": "Hyundai", "fc": 4},
    # Hyosung
    "Hyosung 100kW":{"keys": [0x0011,0x0012,0x0013,0x0019,0x001A,
                               0x0037,0x0038,0x0039,
                               0x0063,0x0064,0x0067],
                     "brand": "Hyosung", "fc": 3},
    # Huawei
    "Huawei SUN2000":{"keys": [0x7D09,0x7D0A,0x7D0B,
                                0x7D10,0x7D11,0x7D12,0x7D13,0x7D14,0x7D15,
                                0x7D16,0x7D17,0x7D18,0x7D19,0x7D1A,0x7D1B,
                                0x7D42,0x7D43,0x7D44,0x7D45,0x7D46,0x7D47,
                                0x7D48,0x7D4A,0x7D4C,
                                0x7D50,0x7D55,0x7D57,0x7D59,
                                0x7D6A,0x7D6B,0x7D72,0x7D73],
                      "brand": "Huawei", "fc": 3},
    # Solis
    "Solis":        {"keys": [0x0BBC,0x0BBD,0x0BC0,0x0BC1,0x0BC6,
                               0x0BD9,0x0BDA,0x0BDB,0x0BDC,0x0BDD,0x0BDE,
                               0x0BE1,0x0BE2,
                               0x0BFA,0x0BFB,0x0BFC,0x0BFD,0x0BFF]
                              + [0x0DAB+i for i in range(15)]
                              + [0x0DC9+i for i in range(15)],
                     "brand": "Solis", "fc": 4},
    # GoodWe 100kW
    "GoodWe 100kW": {"keys": list(range(0x7D10, 0x7D40))      # Vpv/Ipv 1~24
                              + [0x7D42,0x7D43,0x7D44,0x7D45,0x7D46,0x7D47]  # Grid V
                              + [0x7D48,0x7D4A,0x7D4C]                         # I A/B/C
                              + [0x7D50,0x7D55,0x7D57,0x7D59]                  # Power/Freq/Temp/Mode
                              + [0x7D6A,0x7D6B,0x7D72,0x7D73]                  # ETotal/EDay
                              + [0x8BAE,0x8B7E,0x8B80],
                     "brand": "GoodWe", "fc": 3},
    # Hyundai 500kW
    "Hyundai 500kW": {"keys": [0x02C1,0x02C2,0x02C3,0x02C4,0x02C5,0x02C6,
                                0x02C7,0x02C8,0x02C9,0x02CA,0x02CB,0x02CC,
                                0x02CD,0x02CE,0x02D1,0x02D2,
                                0x02D5,0x02D6,0x02D7,0x02D8,
                                0x02E3,0x02E4,0x02E5,0x02E6,
                                0x02E7,0x02E8,0x02E9],
                      "brand": "Hyundai", "fc": 3},
    # Hyosung 36kW (New)
    "Hyosung 36kW (New)": {"keys": [0x7E06,0x7E07,0x7E08,0x7E09,0x7E0A,0x7E0B,
                                     0x7E0C,0x7E0D,0x7E0E,0x7E0F,0x7E10,0x7E11,
                                     0x7E1B,0x7E1F,
                                     0x7E22,0x7E23,0x7E2C,0x7E2D,
                                     0x7E32,0x7E33,
                                     0x7E3A,0x7E3B,0x7E3C,0x7E3D],
                            "brand": "Hyosung", "fc": 3},
    # Hyosung 250kW (100kW와 동일 레지스터)
    "Hyosung 250kW": {"keys": [0x0011,0x0012,0x0013,0x0019,0x001A,
                                0x0037,0x0038,0x0039,
                                0x0063,0x0064,0x0067],
                      "brand": "Hyosung", "fc": 3},
    # K-STAR
    "K-STAR KSG110CL": {"keys": [3000,3001,3002,2996,2992,2988,2984,2980,2976,2972,2968,2964,
                                   3003,3004,3005,2997,2993,2989,2985,2981,2977,2973,2969,2965,
                                   3014,3015,3016,3017,3018,3019,3020,3021,3022,
                                   3023,3042,3038,3026,3027,3028,3030],
                          "brand": "K-STAR", "fc": 3},
    "K-STAR KSG60KTL": {"keys": [3000,3001,3002,3003,3004,3005,
                                   3014,3015,3016,3017,3018,3019,
                                   3020,3021,3022,
                                   3023,3024,3026,3027,3028,3029,
                                   3030,3036,3038,3039,3042,
                                   3064,3065,3066,3067,3068,3069,3070,3071],
                          "brand": "K-STAR", "fc": 4},
    # Sungrow
    "Sungrow String": {"keys": [5002,5003,5007,5010,5011,5012,5013,5014,5015,
                                  5018,5019,5020,5021,5022,5023,5030,5035,5037,5044],
                        "brand": "Sungrow", "fc": 3},
    # SOFAR
    "SOFAR G3":     {"keys": [0x0584,0x0585,0x0586,0x0587,0x0588,0x0589,0x058A],
                     "brand": "SOFAR", "fc": 3},
}

_FAULT_ITEMS = {
    "KACO": ["4 (정상-MPP)", "10 (내부온도 과다)", "41 (L1 저전압)", "42 (L1 과전압)", "57 (재투입 대기)", "87 (L1 과전류)"],
    "GoodWe": ["0 (정상)", "1 (오프그리드)", "2 (정상발전)", "256 (계통전압 오류)", "512 (계통주파수 오류)"],
    "Growatt": ["0 (대기)", "1 (정상)", "3 (장애)"],
    "Hyundai": ["0 (정상)", "1 (대기)", "2 (장애)"],
    "Hyosung": ["0 (정상)", "1 (대기)", "2 (장애)"],
    "Huawei":  ["0 (대기)", "512 (정상발전)", "1280 (장애)"],
    "Solis":   ["0 (대기)", "1 (정상발전)", "2 (장애)"],
    "K-STAR":  ["0 (정상)", "1 (전압낮음)", "128 (절연장애)"],
    "Sungrow": ["0 (Normal)", "5120 (Standby)", "21760 (Fault)"],
    "SOFAR":   ["0 (정상)", "1 (GridOVP)", "2 (GridUVP)", "16 (GFCI)"],
}

MODEL_GROUPS = [
    ("GoodWe", [
        "GoodWe 60kW",
        "GoodWe 100kW",
    ]),
    ("Growatt", [
        "Growatt",
    ]),
    ("Huawei", [
        "Huawei SUN2000",
    ]),
    ("Hyosung", [
        "Hyosung 36kW (New)",
        "Hyosung 100kW",
        "Hyosung 250kW",
    ]),
    ("Hyundai", [
        "Hyundai 50kW",
        "Hyundai 500kW",
    ]),
    ("KACO", [
        "KACO Standard Protocol",
        "KACO [2.2.1/2.2.3] Generic 3MPPT",
        "KACO [2.2.2] Generic 2MPPT (200TL)",
        "KACO [2.2.4] Generic 1MPPT (XP/TL3 M1)",
    ]),
    ("K-STAR", [
        "K-STAR KSG60KTL",
        "K-STAR KSG110CL",
    ]),
    ("SOFAR", [
        "SOFAR G3",
    ]),
    ("Solis", [
        "Solis",
    ]),
    ("Sungrow", [
        "Sungrow String",
    ]),
]

_STATUS_ADDR = {
    "KACO":    {101, 201, 301, 401},
    "GoodWe":  {0x0234},
    "Growatt":  {0x0000},
    "Hyundai":  {0x002F, 0x02E5},
    "Hyosung":  {0x0067, 0x7E1F},
    "Huawei":   {0x7D59, 0x8BAE},
    "Solis":    {0x0BFF},
    "K-STAR":   {3030},
    "Sungrow":  {5037},
    "SOFAR":    {0x058A},
}

_STYLESHEET = """
QWidget {
    background-color: #1e1e1e;
    color: #d4d4d4;
    font-family: '맑은 고딕', 'Segoe UI';
    font-size: 10pt;
}
QGroupBox {
    border: 1px solid #3e4a5c;
    border-radius: 6px;
    margin-top: 14px;
    padding-top: 8px;
    font-weight: bold;
    color: #4fc3f7;
}
QGroupBox::title {
    subcontrol-origin: margin;
    left: 12px;
    color: #4fc3f7;
}
QPushButton {
    background-color: #0d6efd;
    color: #ffffff;
    border: none;
    border-radius: 5px;
    padding: 6px 14px;
    font-weight: bold;
}
QPushButton:hover   { background-color: #2484ff; }
QPushButton:pressed { background-color: #0a58ca; }
QPushButton:disabled{ background-color: #3a3a3a; color: #777; }
QComboBox {
    background-color: #2d2d2d;
    border: 1px solid #3e4a5c;
    border-radius: 4px;
    padding: 4px 8px;
    color: #d4d4d4;
}
QComboBox::drop-down  { border: none; }
QComboBox QAbstractItemView {
    background-color: #252526;
    selection-background-color: #0d6efd;
    color: #d4d4d4;
    border: 1px solid #3e4a5c;
}
QTableWidget {
    background-color: #1a1a1a;
    alternate-background-color: #222222;
    gridline-color: #333;
    border: 1px solid #3e4a5c;
    color: #d4d4d4;
    selection-background-color: #0d6efd;
}
QHeaderView::section {
    background-color: #252526;
    color: #4fc3f7;
    padding: 6px;
    border: 1px solid #333;
    font-weight: bold;
}
QTextEdit {
    background-color: #0d0d0d;
    color: #9cdcfe;
    border: 1px solid #3e4a5c;
    border-radius: 4px;
    font-family: Consolas, monospace;
    font-size: 9pt;
}
QLineEdit {
    background-color: #2d2d2d;
    border: 1px solid #3e4a5c;
    border-radius: 4px;
    padding: 4px;
    color: #d4d4d4;
}
QLabel  { color: #9cdcfe; }
QDialog { background-color: #1e1e1e; }
QScrollBar:vertical {
    background: #1a1a1a;
    width: 8px;
    border-radius: 4px;
}
QScrollBar::handle:vertical {
    background: #3e4a5c;
    border-radius: 4px;
    min-height: 24px;
}
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QFrame#status_bar {
    background-color: #252526;
    border-radius: 4px;
    padding: 4px;
}
"""


# ── 시리얼 스레드 ─────────────────────────────────────────────────────────────
class SerialThread(QThread):
    log_signal          = pyqtSignal(str, str)
    update_table_signal = pyqtSignal(int)

    def __init__(self, settings, registers, ui_values, model_name, parent=None):
        super().__init__(parent)
        self.s           = settings
        self.registers   = registers
        self.ui_values   = ui_values
        self.model_name  = model_name
        self.serial_conn = None
        self.is_running  = False

    def _brand(self):
        return MODEL_MAPS.get(self.model_name.strip(), {}).get("brand", "")

    def run(self):
        try:
            self.log_signal.emit("SYS", f"[{self.s['port']}] 포트 개방 중...")
            self.serial_conn = serial.Serial(
                port     = self.s['port'],
                baudrate = int(self.s['baud']),
                parity   = {'None': serial.PARITY_NONE, 'Even': serial.PARITY_EVEN,
                             'Odd':  serial.PARITY_ODD}.get(self.s['parity'], serial.PARITY_NONE),
                stopbits = {'1': serial.STOPBITS_ONE, '2': serial.STOPBITS_TWO
                            }.get(self.s['stopbits'], serial.STOPBITS_ONE),
                bytesize = {'8': serial.EIGHTBITS, '7': serial.SEVENBITS
                            }.get(self.s['bytesize'], serial.EIGHTBITS),
                timeout  = 0.1,
            )
            self.serial_conn.reset_input_buffer()
            self.is_running = True
            self.log_signal.emit("SYS", f"[{self.s['port']}] 연결 성공!")

            brand = self._brand()
            is_kaco = brand == "KACO"

            while self.is_running:
                try:
                    if self.serial_conn and self.serial_conn.in_waiting > 0:
                        time.sleep(0.05)
                        rx = self.serial_conn.read(self.serial_conn.in_waiting)

                        # ── KACO ASCII ──────────────────────────────────────
                        if is_kaco and rx.startswith(b'#'):
                            cmd_str = rx.decode('ascii', errors='ignore').strip()
                            self.log_signal.emit("RX", cmd_str)
                            if len(cmd_str) < 4:
                                continue
                            addr = cmd_str[1:3]
                            cmd  = cmd_str[3]
                            resp = ""
                            v    = self.ui_values
                            m    = self.model_name

                            if "Standard" in m:
                                if cmd == '0':
                                    resp = _build_kaco_std(addr, v)
                                    for a in range(101,109): self.update_table_signal.emit(a)
                                elif cmd == '3':
                                    resp = _build_kaco_std_yield(addr, v)
                                    for a in [109,110]: self.update_table_signal.emit(a)
                            elif "2MPPT" in m:
                                if cmd == '0':
                                    resp = _build_kaco_gen2(addr, v)
                                    for a in range(201,217): self.update_table_signal.emit(a)
                                elif cmd == '3':
                                    resp = _build_kaco_gen_yield(addr, v.get(216,78), v.get(217,240984))
                                    for a in [216,217]: self.update_table_signal.emit(a)
                            elif "3MPPT" in m:
                                if cmd == '0':
                                    typ = "160TR" if "2.2.1" in m else "300TL"
                                    resp = _build_kaco_gen3(addr, v, typ)
                                    for a in range(301,318): self.update_table_signal.emit(a)
                                elif cmd == '3':
                                    resp = _build_kaco_gen_yield(addr, v.get(319,150), v.get(320,500))
                                    for a in [319,320]: self.update_table_signal.emit(a)
                            elif "1MPPT" in m:
                                if cmd == '0':
                                    typ = "50kH4P" if "TL3 M1" in m else "100kTR"
                                    resp = _build_kaco_gen1(addr, v, typ)
                                    for a in range(401,413): self.update_table_signal.emit(a)
                                elif cmd == '3':
                                    resp = _build_kaco_gen_yield(addr, v.get(412,150), v.get(413,500))
                                    for a in [412,413]: self.update_table_signal.emit(a)

                            if resp:
                                time.sleep(0.02)
                                self.serial_conn.write((resp + '\r').encode('ascii'))
                                self.log_signal.emit("TX", resp)

                        # ── Modbus RTU ──────────────────────────────────────
                        else:
                            idx = next((i for i in range(len(rx)-1)
                                        if 0 < rx[i] < 248 and rx[i+1] in (0x03, 0x04)), -1)
                            if idx != -1 and len(rx) >= idx + 8:
                                frame     = rx[idx:idx+8]
                                self.log_signal.emit("RX", ' '.join(f'{b:02X}' for b in frame))
                                slave_id  = frame[0]
                                fc        = frame[1]
                                reg_addr  = (frame[2] << 8) + frame[3]
                                qty       = min((frame[4] << 8) + frame[5], 125)
                                data_bytes = []
                                for i in range(qty):
                                    self.update_table_signal.emit(reg_addr + i)
                                    r = self.registers.get(reg_addr + i, 0)
                                    data_bytes += [(r >> 8) & 0xFF, r & 0xFF]
                                pkt   = bytes([slave_id, fc, qty * 2] + data_bytes)
                                lo, hi = _modbus_crc16(pkt)
                                final = pkt + bytes([lo, hi])
                                time.sleep(0.02)
                                self.serial_conn.write(final)
                                self.log_signal.emit("TX", ' '.join(f'{b:02X}' for b in final))

                except Exception as e:
                    self.log_signal.emit("SYS", f"처리 오류: {e}")
                    time.sleep(0.5)

        except Exception as e:
            self.log_signal.emit("SYS", f"연결 실패: {e}")
        finally:
            self.is_running = False
            if self.serial_conn and self.serial_conn.is_open:
                self.serial_conn.close()

    def stop(self):
        self.is_running = False


# ── 메인 UI ───────────────────────────────────────────────────────────────────
class InverterEmulator(QWidget):
    def __init__(self):
        super().__init__()
        self.ui_values = {}
        self.registers = {}
        self._init_ui()

    def _init_ui(self):
        self.setWindowTitle("인버터 에뮬레이터 v1.0  ·  All Brands")
        self.resize(1400, 900)
        root = QVBoxLayout(self)
        root.setSpacing(8)
        root.setContentsMargins(10, 10, 10, 10)

        # ── 헤더 ─────────────────────────────────────────────────────────────
        hdr = QFrame()
        hdr.setFixedHeight(70)
        hdr.setStyleSheet("""
            QFrame {
                background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
                    stop:0 #0a1628, stop:0.5 #0d2444, stop:1 #0a1628);
                border-radius: 6px;
                border: 1px solid #1e3a5f;
            }
        """)
        hl = QHBoxLayout(hdr)
        hl.setContentsMargins(16, 0, 20, 0)
        hl.setSpacing(0)

        # 좌측 액센트 바
        accent = QFrame()
        accent.setFixedSize(4, 44)
        accent.setStyleSheet("background: qlineargradient(x1:0,y1:0,x2:0,y2:1,"
                             "stop:0 #00bcd4, stop:1 #0078d4); border-radius:2px;")
        hl.addWidget(accent)
        hl.addSpacing(14)

        # 타이틀 영역 (상단: 제목 / 하단: 부제)
        title_col = QVBoxLayout()
        title_col.setSpacing(2)
        title_col.setContentsMargins(0,0,0,0)
        title_lbl = QLabel("Inverter RS485 Emulator")
        title_lbl.setStyleSheet("color:#ffffff; font-size:15pt; font-weight:bold; letter-spacing:1px;")
        sub_lbl = QLabel("GoodWe  ·  Growatt  ·  Huawei  ·  Hyosung  ·  Hyundai  ·  KACO  ·  K-STAR  ·  SOFAR  ·  Solis  ·  Sungrow")
        sub_lbl.setStyleSheet("color:#5ba8d4; font-size:8pt; letter-spacing:0.5px;")
        title_col.addWidget(title_lbl)
        title_col.addWidget(sub_lbl)
        hl.addLayout(title_col)

        hl.addStretch()

        # 우측: 버전 배지 + 프로토콜 태그
        right_col = QVBoxLayout()
        right_col.setSpacing(6)
        right_col.setContentsMargins(0,0,0,0)
        right_col.setAlignment(Qt.AlignRight | Qt.AlignVCenter)

        ver_lbl = QLabel("v 1.0")
        ver_lbl.setStyleSheet("""
            color: #ffffff;
            background: #0d6efd;
            border-radius: 4px;
            padding: 2px 10px;
            font-size: 9pt;
            font-weight: bold;
        """)
        ver_lbl.setAlignment(Qt.AlignCenter)

        proto_lbl = QLabel("Modbus RTU  ·  ASCII")
        proto_lbl.setStyleSheet("color:#5ba8d4; font-size:8pt;")
        proto_lbl.setAlignment(Qt.AlignRight)

        right_col.addWidget(ver_lbl, 0, Qt.AlignRight)
        right_col.addWidget(proto_lbl, 0, Qt.AlignRight)
        hl.addLayout(right_col)

        root.addWidget(hdr)

        # ── 설정 ─────────────────────────────────────────────────────────────
        cfg = QGroupBox("통신 설정")
        cl = QHBoxLayout(cfg)
        self.port_cb   = QComboBox(); self._scan_ports()
        self.baud_cb   = QComboBox(); self.baud_cb.addItems(["9600","19200","38400","115200"])
        self.data_cb   = QComboBox(); self.data_cb.addItems(["8","7"])
        self.parity_cb = QComboBox(); self.parity_cb.addItems(["None","Even","Odd"])
        self.stop_cb   = QComboBox(); self.stop_cb.addItems(["1","2"])
        self.endian_cb = QComboBox(); self.endian_cb.addItems(["Big-Endian (Hi-Lo)","Little-Endian (Lo-Hi)"])
        self.endian_cb.currentIndexChanged.connect(self._sync_registers)
        self.model_cb  = QComboBox()
        self._populate_model_cb()
        self.model_cb.currentTextChanged.connect(self._load_model)

        # 각 콤보박스를 내용 최대 너비에 자동 맞춤
        for cb in [self.port_cb, self.baud_cb, self.data_cb,
                   self.parity_cb, self.stop_cb, self.endian_cb]:
            cb.setSizeAdjustPolicy(QComboBox.AdjustToContents)

        # 모델은 최대 너비 기준으로 맞추되 남은 공간을 채움
        self.model_cb.setSizeAdjustPolicy(QComboBox.AdjustToContents)
        self.model_cb.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)

        self.conn_btn  = QPushButton("연결")
        self.conn_btn.setMinimumWidth(self.conn_btn.sizeHint().width() + 16)
        self.conn_btn.clicked.connect(self._toggle_serial)
        scan_btn = QPushButton("포트 갱신")
        scan_btn.setMinimumWidth(scan_btn.sizeHint().width() + 16)
        scan_btn.clicked.connect(self._scan_ports)

        for w, lbl in [(self.port_cb,"포트:"), (self.baud_cb,"속도:"), (self.data_cb,"비트:"),
                       (self.parity_cb,"패리티:"), (self.stop_cb,"스탑:"),
                       (self.endian_cb,"바이트 순서:"), (self.model_cb,"모델:")]:
            cl.addWidget(QLabel(lbl)); cl.addWidget(w)
        cl.addWidget(scan_btn); cl.addWidget(self.conn_btn)
        root.addWidget(cfg)

        # ── 가운데 영역 ───────────────────────────────────────────────────────
        mid = QHBoxLayout()

        # 레지스터 테이블
        tbl_box = QGroupBox("레지스터 맵")
        tl = QVBoxLayout(tbl_box)
        self.table = QTableWidget(0, 6)
        self.table.setHorizontalHeaderLabels(["주소(Hex)","주소(Dec)","항목명","타입","스케일/단위","현재값(Raw)"])
        self.table.horizontalHeader().setStretchLastSection(True)
        self.table.setEditTriggers(QAbstractItemView.NoEditTriggers)
        self.table.setAlternatingRowColors(True)
        self.table.setSelectionBehavior(QAbstractItemView.SelectRows)
        edit_btn = QPushButton("값 수정 (팝업)")
        edit_btn.setStyleSheet("background:#155724;")
        edit_btn.clicked.connect(self._open_editor)
        tl.addWidget(edit_btn); tl.addWidget(self.table)

        # 우측 패널
        right = QVBoxLayout()

        # 장애 시뮬레이션
        fault_box = QGroupBox("장애 시뮬레이션")
        fault_box.setMinimumWidth(300)
        fl = QVBoxLayout(fault_box)
        self.status_lbl = QLabel("● NORMAL")
        self.status_lbl.setStyleSheet("color:#4caf50; font-weight:bold; font-size:14px;")
        self.fault_cb = QComboBox()
        f_btn_row = QHBoxLayout()
        self.fault_btn = QPushButton("Fault 발생")
        self.fault_btn.setStyleSheet("background:#c62828;")
        self.fault_btn.clicked.connect(self._apply_fault)
        self.clear_btn = QPushButton("정상 복구")
        self.clear_btn.setStyleSheet("background:#1b5e20;")
        self.clear_btn.clicked.connect(self._clear_fault)
        f_btn_row.addWidget(self.fault_btn); f_btn_row.addWidget(self.clear_btn)
        fl.addWidget(self.status_lbl)
        fl.addWidget(QLabel("에러 코드:"))
        fl.addWidget(self.fault_cb)
        fl.addLayout(f_btn_row)
        fl.addStretch()

        # 통신 통계
        stat_box = QGroupBox("통신 통계")
        sl = QVBoxLayout(stat_box)
        self.rx_lbl  = QLabel("RX: 0")
        self.tx_lbl  = QLabel("TX: 0")
        self.rx_cnt  = 0
        self.tx_cnt  = 0
        sl.addWidget(self.rx_lbl); sl.addWidget(self.tx_lbl); sl.addStretch()

        right.addWidget(fault_box); right.addWidget(stat_box); right.addStretch()

        mid.addWidget(tbl_box, 7)
        mid.addLayout(right, 3)
        root.addLayout(mid)

        # ── 로그 ─────────────────────────────────────────────────────────────
        log_box = QGroupBox("통신 로그")
        ll = QVBoxLayout(log_box)
        self.log = QTextEdit(); self.log.setReadOnly(True); self.log.setFixedHeight(180)
        lb = QHBoxLayout()
        clr = QPushButton("로그 지우기"); clr.clicked.connect(self.log.clear)
        sav = QPushButton("로그 저장");   sav.clicked.connect(self._save_log)
        lb.addStretch(); lb.addWidget(clr); lb.addWidget(sav)
        ll.addWidget(self.log); ll.addLayout(lb)
        root.addWidget(log_box)

        self._load_model()

    def _populate_model_cb(self):
        from PyQt5.QtGui import QStandardItem
        from PyQt5.QtCore import Qt as _Qt
        model = self.model_cb.model()
        for brand, items in MODEL_GROUPS:
            # 브랜드 헤더 (선택 불가)
            header = QStandardItem(f"  ── {brand} {'─'*(18-len(brand))}")
            header.setEnabled(False)
            header.setForeground(QColor("#4fc3f7"))
            model.appendRow(header)
            # 모델 항목
            for name in items:
                item = QStandardItem("    " + name)
                model.appendRow(item)
        # 첫 번째 실제 모델 선택
        for i in range(self.model_cb.count()):
            if self.model_cb.itemText(i).strip() in MODEL_MAPS:
                self.model_cb.setCurrentIndex(i)
                break

    # ── 모델 로딩 ─────────────────────────────────────────────────────────────
    def _load_model(self):
        name  = self.model_cb.currentText().strip()
        if name not in MODEL_MAPS:
            return  # 브랜드 헤더 항목 클릭 시 무시
        info  = MODEL_MAPS.get(name, {})
        brand = info.get("brand", "")
        keys  = sorted(info.get("keys", []))

        self.endian_cb.setCurrentIndex(1 if brand == "Sungrow" else 0)
        self.ui_values.clear()
        self.table.setRowCount(len(keys))

        for i, addr in enumerate(keys):
            ai = ADDR_INFO.get(addr, {"name": f"Addr 0x{addr:04X}", "scale": "x1", "type": "U16"})
            val = self._default(addr, ai, brand)
            self.ui_values[addr] = val
            row = [f"0x{addr:04X}", str(addr), ai["name"], ai["type"], ai["scale"], str(val)]
            for col, txt in enumerate(row):
                it = QTableWidgetItem(txt)
                it.setTextAlignment(Qt.AlignCenter)
                if ai["type"] in ("U32","S32"):
                    it.setForeground(QColor("#ffd54f"))
                self.table.setItem(i, col, it)

        self.fault_cb.clear()
        self.fault_cb.addItems(_FAULT_ITEMS.get(brand, ["0 (정상)"]))
        self._sync_registers()
        self.status_lbl.setText("● NORMAL")
        self.status_lbl.setStyleSheet("color:#4caf50; font-weight:bold; font-size:14px;")

    def _default(self, addr, ai, brand):
        name, scale = ai["name"], ai["scale"]
        # KACO status
        if addr in (101,201,301,401) and brand == "KACO": return 4
        # KACO 2MPPT 실측값
        _kaco2 = {202:6287,203:521,204:3282,205:6332,206:267,207:1692,
                  208:2288,209:753,210:2306,211:758,212:2313,213:751,
                  214:5174,215:562,216:78,217:240984}
        if addr in _kaco2: return _kaco2[addr]
        # Status registers
        if addr in {0x0234,0x0000,0x002F,0x0067,0x7D59,0x0BFF,3030,5037}: return 0
        if addr in {0x0357,0x0064}: return 0  # WorkMode / running
        # Total Energy U32 high/low
        if "High" in name: return 0
        if "Low"  in name: return 5000
        # Voltage
        if any(k in name for k in ("V A","V B","V C","VAB","VBC","VCA","Grid V","UAC","Vpv")):
            return 2288 if "0.1" in scale else 229
        # Current
        if any(k in name for k in ("I A","I B","I C","IAC","Ipv")):
            return 750 if "0.01" in scale else 75
        # Power
        if any(k in name for k in ("Power","PDC","PAC","Active")):
            if "0.001" in scale: return 5174000
            return 5174
        # Freq
        if "Freq" in name or "freq" in name.lower(): return 6000
        # Temp
        if "온도" in name or "temp" in name.lower(): return 562
        # Daily
        if "Day" in name or "daily" in name.lower() or "금일" in name: return 781
        # Total
        if "Total" in name or "누적" in name:
            if "0.001" in scale: return 240984000
            return 240984
        return 0

    def _sync_registers(self):
        self.registers.clear()
        is_big = "Big" in self.endian_cb.currentText()
        for addr, val in self.ui_values.items():
            dtype = ADDR_INFO.get(addr, {}).get("type", "U16")
            v32 = int(val) & 0xFFFFFFFF
            if dtype in ("S32","U32"):
                hi, lo = (v32 >> 16) & 0xFFFF, v32 & 0xFFFF
                self.registers[addr]   = hi if is_big else lo
                self.registers[addr+1] = lo if is_big else hi
            else:
                self.registers[addr] = int(val) & 0xFFFF

    def _scan_ports(self):
        self.port_cb.clear()
        ports = [p.device for p in serial.tools.list_ports.comports()]
        self.port_cb.addItems(ports or ["포트 없음"])

    # ── 값 수정 팝업 ─────────────────────────────────────────────────────────
    def _open_editor(self):
        dlg = QDialog(self); dlg.setWindowTitle("레지스터 값 수정"); dlg.resize(500, 700)
        lay = QVBoxLayout(dlg); form = QFormLayout()
        self._edit_w = {}
        brand = MODEL_MAPS.get(self.model_cb.currentText().strip(), {}).get("brand","")
        status_addrs = _STATUS_ADDR.get(brand, set())

        for i in range(self.table.rowCount()):
            addr  = int(self.table.item(i,1).text())
            name  = self.table.item(i,2).text()
            dtype = self.table.item(i,3).text()
            scale = self.table.item(i,4).text()
            val   = self.ui_values.get(addr, 0)
            lbl   = f"[0x{addr:04X}] {name} ({dtype}, {scale}):"
            if addr in status_addrs:
                cb = QComboBox()
                cb.addItems(_FAULT_ITEMS.get(brand, ["0 (정상)"]))
                idx = cb.findText(str(val), Qt.MatchStartsWith)
                if idx >= 0: cb.setCurrentIndex(idx)
                self._edit_w[addr] = cb; form.addRow(lbl, cb)
            else:
                le = QLineEdit(str(val))
                self._edit_w[addr] = le; form.addRow(lbl, le)

        sa = QScrollArea(); sw = QWidget(); sw.setLayout(form)
        sa.setWidget(sw); sa.setWidgetResizable(True); lay.addWidget(sa)
        ok = QPushButton("저장 및 닫기"); ok.clicked.connect(lambda: self._save_edits(dlg))
        lay.addWidget(ok); dlg.exec_()

    def _save_edits(self, dlg):
        for addr, w in self._edit_w.items():
            try:
                self.ui_values[addr] = int(w.currentText().split()[0]) if isinstance(w, QComboBox) else int(w.text())
            except ValueError: pass
        self._sync_registers(); self._refresh_table(); dlg.accept()

    def _refresh_table(self):
        for i in range(self.table.rowCount()):
            addr = int(self.table.item(i,1).text())
            self.table.item(i,5).setText(str(self.ui_values.get(addr,0)))

    # ── 장애/복구 ─────────────────────────────────────────────────────────────
    def _fault_addr(self):
        brand = MODEL_MAPS.get(self.model_cb.currentText(),{}).get("brand","")
        addrs = _STATUS_ADDR.get(brand, set())
        return next(iter(addrs), 0) if addrs else 0

    def _apply_fault(self):
        fa  = self._fault_addr()
        val = int(self.fault_cb.currentText().split()[0])
        self.ui_values[fa] = val
        self._sync_registers(); self._refresh_table()
        self.status_lbl.setText(f"● FAULT ({val})")
        self.status_lbl.setStyleSheet("color:#f44336; font-weight:bold; font-size:14px;")

    def _clear_fault(self):
        brand = MODEL_MAPS.get(self.model_cb.currentText(),{}).get("brand","")
        fa    = self._fault_addr()
        self.ui_values[fa] = 4 if brand == "KACO" else 0
        self._sync_registers(); self._refresh_table()
        self.status_lbl.setText("● NORMAL")
        self.status_lbl.setStyleSheet("color:#4caf50; font-weight:bold; font-size:14px;")

    # ── 시리얼 연결/해제 ──────────────────────────────────────────────────────
    def _toggle_serial(self):
        if hasattr(self, 'serial_thread') and self.serial_thread.isRunning():
            self.serial_thread.stop(); self.serial_thread.wait()
            self.conn_btn.setText("연결"); self.conn_btn.setStyleSheet("")
            self.log_signal_emit("SYS", "연결 해제")
        else:
            s = {'port': self.port_cb.currentText(), 'baud': self.baud_cb.currentText(),
                 'parity': self.parity_cb.currentText(), 'stopbits': self.stop_cb.currentText(),
                 'bytesize': self.data_cb.currentText()}
            if "없음" in s['port'] or not s['port']: return
            self.log.append("<hr>")
            self.serial_thread = SerialThread(s, self.registers, self.ui_values,
                                              self.model_cb.currentText().strip(), parent=self)
            self.serial_thread.log_signal.connect(self._add_log)
            self.serial_thread.update_table_signal.connect(self._mark_request)
            self.serial_thread.start()
            self.conn_btn.setText("해제")
            self.conn_btn.setStyleSheet("background:#c62828;")

    def log_signal_emit(self, t, m):
        self._add_log(t, m)

    def _add_log(self, t, m):
        ts = datetime.now().strftime('%H:%M:%S.%f')[:-3]
        if t == "TX":
            self.log.append(f"<span style='color:#569CD6;'>[{ts}] TX : {m}</span>")
            self.tx_cnt += 1; self.tx_lbl.setText(f"TX: {self.tx_cnt}")
        elif t == "RX":
            self.log.append(f"<span style='color:#D69D85;'>[{ts}] RX : {m}</span>")
            self.rx_cnt += 1; self.rx_lbl.setText(f"RX: {self.rx_cnt}")
        else:
            self.log.append(f"<span style='color:#4EC9B0;'>[{ts}] SYS: {m}</span>")
        sb = self.log.verticalScrollBar(); sb.setValue(sb.maximum())

    def _mark_request(self, addr):
        for i in range(self.table.rowCount()):
            ra = int(self.table.item(i,1).text())
            if ra == addr:
                self.table.item(i,5).setForeground(QColor("#69f0ae"))

    def _save_log(self):
        fn, _ = QFileDialog.getSaveFileName(self, "로그 저장", "inverter_log.txt", "Text (*.txt)")
        if fn:
            with open(fn, 'w', encoding='utf-8') as f:
                f.write(self.log.toPlainText())
            QMessageBox.information(self, "완료", "저장되었습니다.")


if __name__ == '__main__':
    # 작업표시줄 아이콘 고정 (Windows 전용)
    if sys.platform == 'win32':
        ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID('InverterRS485Emulator.1.0')

    app = QApplication(sys.argv)
    app.setStyleSheet(_STYLESHEET)
    app.setFont(QFont("맑은 고딕", 10))

    # 플랫폼별 아이콘 파일 선택
    from PyQt5.QtGui import QIcon
    if sys.platform == 'win32':
        icon_path = _resource('icon.ico')
    elif sys.platform == 'darwin':
        icon_path = _resource('icon.icns')
    else:
        icon_path = _resource('icon.png')

    if os.path.exists(icon_path):
        app.setWindowIcon(QIcon(icon_path))

    win = InverterEmulator()
    win.show()
    sys.exit(app.exec_())
