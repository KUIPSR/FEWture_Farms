from dependency import * 
from agriculture import * 
from water import *
from energy import *
from climate import *


app = Flask(__name__,template_folder='template')


# Homepage EndPoint
@app.route('/')
def index():
    return render_template('homepage.html')

# Netlogo Stimulation EndPoint
@app.route('/NetlogoInputV1')
def netlogoinput():
    return render_template('NetlogoInputV1.html')

# Agriculture Page EndPoint
@app.route('/AgricultureV1')
def agriculture():
    return render_template('index.html')

# Water Page EndPoint

@app.route('/WaterV1')
def water():
    return render_template('water.html')

# Energy Page EndPoint

@app.route('/EnergyV1')
def energy():
    return render_template('energy.html')


@app.route('/ChartWindow')
def ChartWindow():
    return render_template('ChartWindow.html')

@app.route('/ClimateV1')
def climate():
    return render_template('climate.html')


@app.route('/AllChartsV1')
def allcharts():
    return render_template('allcharts.html')


@app.route('/download-csv')
def download_csv():
    # Replace the file path with the actual path to your CSV file
    file_path = r'netlogo\What NH3 production pays off 2.0.xlsx'
    file_name = r'netlogo\Ammonia.xlsx'  # Set the desired file name

    # Serve the file for download
    return send_file(file_path, as_attachment=True, download_name=file_name)




# Agriculture global variable
global corn_area, wheat_area, soybeans_area, sg_area,num_of_years

# Water global variable
global aquifier_level,min_aquifier_level

# Energy global variable
global energy_value,loan_term,interest,num_wind_turbines,nyear_w,capacity_w,cost_w,degrade_w,wind_factor,num_panel_sets,nyear_s,cost_s,capacity_s,degrade_s,sun_hrs,ptc_w,itc_s,ptc_s

# Climate global variable
global future_processes,climate_model


# Start Year Input
global start_year

# Agriculture Form Value
corn_area=None
wheat_area=None
soybeans_area=None
sg_area=None

# Water Form Value
aquifier_level=None
min_aquifier_level=None

# Energy Form Value
energy_value = None
loan_term = None
interest = None
num_wind_turbines = None
nyear_w = None
capacity_w = None
cost_w = None
degrade_w = None
wind_factor = None
num_panel_sets = None
nyear_s = None
cost_s = None
capacity_s = None
degrade_s = None
sun_hrs = None
ptc_w = None
itc_s = None
ptc_s = None

# Climate Form Value
future_processes = None
climate_model = None


# Get Number of Years
num_of_years=None

# Get Start Year Input
start_year = None



@app.route('/calculate', methods=['GET','POST'])
def calculate():
    global corn_area, wheat_area, soybeans_area, sg_area,num_of_years
    global energy_value,loan_term,interest,num_wind_turbines,nyear_w,capacity_w,cost_w,degrade_w,wind_factor,num_panel_sets,nyear_s,cost_s,capacity_s,degrade_s,sun_hrs,ptc_w,itc_s,ptc_s
    global aquifier_level,min_aquifier_level
    global future_processes,climate_model

    data = request.get_json()

    # Saving the Data to JSON
    with open('received_data.json', 'w') as json_file:
        json.dump(data, json_file)
        
    print("Data",data)


    # Getting Start Year Input
    start_year = int(data['StartYear']['input_start_of_years'])

    # Getting Agriculture Form Value

    corn_area=int(data['agriculture']['corn_area'])
    wheat_area=int(data['agriculture']['wheat_area'])
    soybeans_area=int(data['agriculture']['soybeans_area'])
    sg_area=int(data['agriculture']['sg_area'])

    # Getting Energy Form Value

    energy_value = int(data['energy']['energy_value'])
    loan_term = int(data['energy']['loan_term'])
    interest = float(data['energy']['interest'])
    num_wind_turbines = int(data['energy']['num_wind_turbines'])
    nyear_w = int(data['energy']['nyear_w'])
    capacity_w = int(data['energy']['capacity_w'])
    cost_w = int(data['energy']['cost_w'])
    degrade_w = int(data['energy']['degrade_w'])
    wind_factor = int(data['energy']['wind_factor'])
    num_panel_sets = int(data['energy']['num_panel_sets'])
    nyear_s = int(data['energy']['nyear_s'])
    cost_s = int(data['energy']['cost_s'])
    capacity_s = int(data['energy']['capacity_s'])
    degrade_s = int(data['energy']['degrade_s'])
    sun_hrs = int(data['energy']['sun_hrs'])
    ptc_w = int(data['energy']['ptc_w'])
    itc_s = int(data['energy']['itc_s'])
    ptc_s = int(data['energy']['ptc_s'])

    # Getting Water Form Value

    aquifier_level = int(data['irrigation']['aquifier_level'])
    min_aquifier_level = int(data['irrigation']['min_aquifier_level'])

    # Getting Climate Form Value

    future_processes=str(data['ClimateData']['future_processes'])
    climate_model=str(data['ClimateData']['climate_model'])


    num_of_years=int(data['numberofyears']['num_of_years'])

    print("Start_Year --->",start_year)

    print("corn_area ---->", corn_area)
    print("wheat_area ---->", wheat_area)
    print("soybeans_area ----->", soybeans_area)
    print("sg_area----->", sg_area)

    print("aquifier_level ---->", aquifier_level)
    print("min_aquifier_level ---->", min_aquifier_level)
    print("num_of_years ------>", num_of_years)

    print("energy_value ---->",energy_value)
    print("loan_term ---->",loan_term)
    print("interest ---->",interest)
    print("num_wind_turbines ---->",num_wind_turbines)
    print("nyear_w ---->",nyear_w)
    print("capacity_w ----->",capacity_w)
    print("cost_w----->",cost_w)
    print("degrade_w----->",degrade_w)
    print("wind_factor ---->",wind_factor)
    print("num_panel_sets ---->",num_panel_sets)
    print("nyear_s ---->",nyear_s)
    print("cost_s ----->",cost_s)
    print("capacity_s----->",capacity_s)
    print("degrade_s----->",degrade_s)
    print("sun_hrs ---->",sun_hrs)
    print("ptc_w ---->",ptc_w)
    print("itc_s ---->",itc_s)
    print("ptc_s ---->",ptc_s)

    print("future_processes ---->",future_processes)
    print("climate_model ---->",climate_model)

    #Fetching Netlogo Instance 

    netlogo = get_netlogo_instance()

    # Agriculture Netlogo Command

    netlogo.command(f"set corn_area {corn_area}")
    netlogo.command(f"set wheat_area {wheat_area}")
    netlogo.command(f"set soybeans_area {soybeans_area}")
    netlogo.command(f"set sg_area {sg_area}")

    # Water Netlogo Command

    netlogo.command(f"set Aquifer_thickness {aquifier_level}")
    netlogo.command(f"set Min_Aq_Thickness {min_aquifier_level}")

    # Energy Netlogo Command

    netlogo.command(f"set Energy_value {energy_value}")
    netlogo.command(f"set Loan_term {loan_term}")
    netlogo.command(f"set interest {interest}")
    netlogo.command(f"set Nyear_W {nyear_w}")
    netlogo.command(f"set #wind_turbines {num_wind_turbines}")
    netlogo.command(f"set Cost_W {cost_w}")
    netlogo.command(f"set Capacity_W {capacity_w}")
    netlogo.command(f"set Degrade_W {degrade_w}")
    netlogo.command(f"set wind_factor {wind_factor}")
    netlogo.command(f"set #Panel_sets {num_panel_sets}")
    netlogo.command(f"set Nyear_S {nyear_s}")
    netlogo.command(f"set Cost_S {cost_s}")
    netlogo.command(f"set Capacity_S {capacity_s}")
    netlogo.command(f"set Degrade_S {degrade_s}")
    netlogo.command(f"set Sun_hrs {sun_hrs}")
    netlogo.command(f"set PTC_W {ptc_w}")
    netlogo.command(f"set ITC_S {itc_s}")
    netlogo.command(f"set PTC_S {ptc_s}")

    # Climate Netlogo Command
    print(f"set Future_Process '{future_processes}'")
    netlogo.command(f'set Future_Process "{future_processes}"')
    netlogo.command(f'set Climate_Model "{climate_model}"')


    # Setup and run the NetLogo model
    netlogo.command("setup")
    netlogo.command(f'repeat {num_of_years} [go]')


    print("Received Data:", data)

    restart()
    return jsonify(data)



@app.route('/calculateAgriculture', methods=['GET', 'POST'])
def calculate_agriculture():

    print("corn_area ---->", corn_area)
    print("wheat_area ---->", wheat_area)
    print("soybeans_area ----->", soybeans_area)
    print("sg_area----->", sg_area)
    print("num_of_years ------>", num_of_years)

    print("Successfully Hiting the Agriculture Chart API")

    crop_production_img = crop_production_calculation()
    net_calc_img = net_income_calculation()

    result = {
        "crop_production_img": crop_production_img,
        "net_calc_img": net_calc_img
    }

    print("Agriculture",result)

    return jsonify(result)





@app.route('/calculateIrrigation', methods=['GET', 'POST'])
def calculate_irrigation():
    
    print("aquifier_level ---->", aquifier_level)
    print("min_aquifier_level ---->", min_aquifier_level)

    crop_groundwater_irrigation_data_for_img = crop_groundwater_irrigation()

    groundwater_level_data_img = groundwater_level()

    result = {
        "crop_groundwater_irrigation_data_for_img": crop_groundwater_irrigation_data_for_img,
        "groundwater_level_data_img": groundwater_level_data_img
    }

    print("Water",result)

    return jsonify(result)

    



@app.route('/calculateEnergy',methods=['GET', 'POST'])
def calculate_energy():
    
    print("energy_value ---->",energy_value)
    print("loan_term ---->",loan_term)
    print("interest ---->",interest)
    print("num_wind_turbines ---->",num_wind_turbines)
    print("nyear_w ---->",nyear_w)
    print("capacity_w ----->",capacity_w)
    print("cost_w----->",cost_w)
    print("degrade_w----->",degrade_w)
    print("wind_factor ---->",wind_factor)
    print("num_panel_sets ---->",num_panel_sets)
    print("nyear_s ---->",nyear_s)
    print("cost_s ----->",cost_s)
    print("capacity_s----->",capacity_s)
    print("degrade_s----->",degrade_s)
    print("sun_hrs ---->",sun_hrs)
    print("ptc_w ---->",ptc_w)
    print("itc_s ---->",itc_s)
    print("ptc_s ---->",ptc_s)

    farm_energy_production_img_data = farm_energy_production_calculation()

    energy_net_calc_img_data= energy_net_income_calculation()

    result = {
        "farm_energy_production_img_data": farm_energy_production_img_data,
        "energy_net_calc_img_data": energy_net_calc_img_data
    }

    print("Energy",result)

    return jsonify(result)


@app.route('/calculateClimate',methods=['GET', 'POST'])
def calculate_climate():

    print("future_processes ---->",future_processes)
    print("climate_model ---->",climate_model)



    crop_income_img = crop_income_calculation()

    insur_income_calc_img= insurance_income_calculation()

    result = {
        "crop_income_img": crop_income_img,
        "insur_income_img": insur_income_calc_img
    }

    print("Climate",result)

    return jsonify(result)


    


@app.route('/restart', methods=['GET', 'POST'])
def restart():
    some_queue.put("something")
    print("Restarted successfully")

def start_flaskapp(queue):
    global some_queue
    some_queue = queue
    app.run(host='0.0.0.0', port=5000)


if __name__ == "__main__":
    q = Queue()
    p = Process(target=start_flaskapp, args=(q,))
    p.start()
    while True:
        if q.empty():
            time.sleep(1)
        else:
            break
    p.terminate()
    args = [sys.executable] + sys.argv
    subprocess.call(args)


