from dependency import *
from netlogo_instance import get_netlogo_instance


def crop_groundwater_irrigation():

    file_path = "received_data.json"

    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    start_year = int(data['StartYear']['input_start_of_years'])

    crop_groundwater_irrigation_data = pd.read_csv(r"netlogo\crop-groundwater-irrigation.csv", delimiter="\t", header=None)

    df = pd.DataFrame(crop_groundwater_irrigation_data)

    df = df.drop(df.index[0:15])
    df = df[0].str.split(',', expand=True)
    df.columns = df.iloc[0]
    df = df.iloc[1:]
    df.columns = ['year', "Corn", "color_0", "pen_down_0", 
                "year_1","Wheat", "color_1", "pen_down_1",
                "year_2","Soybean", "color_2", "pen_down_2",
                "year_3","SG", "color_3", "pen_down_3"]

    # Reset the index
    df.reset_index(drop=True, inplace=True)

    # Convert columns to integers
    df['Corn'] = df['Corn'].str.replace('"', '').astype(int)
    df['Wheat'] = df['Wheat'].str.replace('"', '').astype(int)
    df['Soybean'] = df['Soybean'].str.replace('"', '').astype(int)
    df['SG'] = df['SG'].str.replace('"', '').astype(int)

    df=df[['year','Corn','Wheat','Soybean','SG']]

    CropIrrigationTitle = f'Crop Irrigation - Start Year: {start_year}'

    # Create the dictionary conditionally for each column
    temp_dict = {'Year': df['year'].values.tolist()}

    columns_to_include = ['Corn','Wheat','Soybean','SG']
    for column in columns_to_include:
        if not (df[column] == 0).all():  # Check if all values in the column are not zero
            temp_dict[column] = df[column].values.tolist()
    temp_dict['CropIrrigationTitle'] = CropIrrigationTitle

    temp = {"irrigation": temp_dict}

    
    print(temp)

    return json.dumps(temp)


def groundwater_level():

    file_path = "received_data.json"

    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    start_year = int(data['StartYear']['input_start_of_years'])
    
    groundwater_level_data = pd.read_csv(r"netlogo\groundwater-level.csv", delimiter="\t", header=None)

    df = groundwater_level_data

    df = df.drop(df.index[0:14])



    df = df[0].str.split(',', expand=True)

    df.columns = df.iloc[0]
    df = df.iloc[1:]

    df.columns = ['year', "GW level", "color_0", "pen_down_0", 
                "year_1","Min. Aq.", "color_1", "pen_down_1",
                "year_2","Min. +30", "color_2", "pen_down_2"]

    # Reset the index
    df.reset_index(drop=True, inplace=True)

    #df['GW level'] = df['GW level'].str.replace('"', '')
    df['GW level'] = df['GW level'].str.replace('"', '').astype(float)
    df['Min. Aq.'] = df['Min. Aq.'].str.replace('"', '').astype(float)
    df['Min. +30'] = df['Min. +30'].str.replace('"', '').astype(float)

    df=df[['year','GW level','Min. Aq.','Min. +30']]

    GroundWaterLeveltitle = f'Ground Water Level- Start Year: {start_year}'


    temp = {
        "gw_level": {
            'Year': df['year'].values.tolist(),
            'GW_level': df['GW level'].values.tolist(),
            'Min_Aq': df['Min. Aq.'].values.tolist(),
            'MinPlus30': df['Min. +30'].values.tolist(),
            'GroundWaterLeveltitle':GroundWaterLeveltitle
        }
    }

    return json.dumps(temp)





