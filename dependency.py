import pynetlogo
import base64
import matplotlib
import pandas as pd
import seaborn as sns
from io import BytesIO
import matplotlib.pyplot as plt
from flask import Flask, render_template, request,jsonify,send_file
import json
import os
import pynetlogo
import gc
from netlogo_instance import get_netlogo_instance
import subprocess
from flask import Flask
from multiprocessing import Process, Queue
import sys
import time