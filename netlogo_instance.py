from dependency import *

netlogo = None

def get_netlogo_instance():
    global netlogo
    if netlogo is None:
        netlogo = pynetlogo.NetLogoLink(gui=False, jvm_path=r"C:\Program Files\Java\jdk-19\bin\server\jvm.dll")
        netlogo.load_model(r"netlogo\FEWCalc_Export_Test.nlogo")
        # netlogo.command("setup")
    return netlogo

