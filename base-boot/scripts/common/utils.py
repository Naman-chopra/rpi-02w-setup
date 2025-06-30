import os


def getDevicePrefix():
    user = os.getlogin()
    if user=='kratoes':
        return ""
    elif user=='rpi':
        return "~/base-boot/"



prefix = getDevicePrefix()