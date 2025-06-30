from TP_lib import epd2in13_V4 as epv4
from PIL import Image, ImageDraw, ImageFont
import time
from ..common.utils import *

# Initialize the e-paper display
epd = epv4.EPD()
epd.init(epd.FULL_UPDATE)
epd.Clear(0xFF)

# epd dimesnions (widthxheight) (122x250)

# Set dimensions of the Image
HEIGHT = 200
WIDTH = 57
count = 0
logo_path= prefix+"assets/batman.jpeg"
qr_path= prefix+"assets/pairing.png"

def batlogo():
    while(count<2):
        # Create a blank image with the dimensions of the display (122x250)
        canvas = Image.new('1', (epd.height, epd.width), 255)  # 255 for white background

        # Load and resize the image you want to display
        image = Image.open(logo_path)
        image = image.resize((HEIGHT, WIDTH))  # Resize to smaller size

        # Paste the resized image onto the canvas (centered)
        canvas.paste(image, (int((epd.height - HEIGHT) / 2), int((epd.width - WIDTH) / 2)))

        # Display the final image on the e-paper display
        epd.display(epd.getbuffer(canvas))

        HEIGHT = 248
        WIDTH = 71
        count +=1
    
batlogo()
# clear for a cool animation
epd.Clear(0xFF)
