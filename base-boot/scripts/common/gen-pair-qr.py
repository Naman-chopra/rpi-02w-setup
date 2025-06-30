import qrcode
from PIL import Image
import os
from utils import prefix

qr = qrcode.QRCode(
    version=3,
    error_correction=qrcode.constants.ERROR_CORRECT_H,
    box_size=10,
    border=2,
)

instructions = '''
1) Go to your phone settings
2) turn on your hostspot and rename it to 'm51'
3) switch the hotspot to 2.4GHz band if it's on 5
4) Password for root user is rpi123
'''

qr.add_data(instructions)
qr.make(fit=True)

logo_path = prefix+"assets/wayne.png"
save_path = prefix+"assets/pairing.png"

# Step 2: Create the QR image
qr_img = qr.make_image(fill_color="black", back_color="white").convert("RGB")

logo = Image.open(logo_path)

qr_width, qr_height = qr_img.size
logo_size = qr_width // 4
# Resize logo if needed
# logo = logo.resize((qr_width //2, logo_size), Image.Resampling.LANCZOS)


logo_pos = ((qr_width - logo_size) // 2, (qr_height - logo_size) // 2)
qr_img.paste(logo, logo_pos, mask=logo if logo.mode == "RGBA" else None)

qr_img.save(os.path.expanduser(save_path))
print("Using device prefix: "+prefix)
