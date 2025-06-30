from PIL import Image, ImageEnhance, ImageDraw, ImageFont
from io import BytesIO
import requests
from datetime import datetime
from TP_lib import epd2in13_V4 as epv4
from epdUtils import *

epd = epv4.EPD()
clear()

image = Image.new('1', (epd.height, epd.width), 255)  # 1-bit color (black and white)
draw = ImageDraw.Draw(image)
font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 24)

draw.text((10, 10), "Display worksss!!", font=font, fill=0)
draw.text((10, 30), "☜(⌒▽⌒)☞", font=font, fill=0)
epd.display(epd.getbuffer(image))