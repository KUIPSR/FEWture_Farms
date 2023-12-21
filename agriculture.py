from dependency import *
from netlogo_instance import *


# Get the current working directory
current_directory = os.getcwd()


def crop_production_calculation():

    file_path = "received_data.json"

    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    start_year = int(data['StartYear']['input_start_of_years'])
    print("StartYear",start_year)

    crop_production_data = pd.read_csv(r"netlogo\crop-production.csv", delimiter="\t", header=None)

    # Preprocess the DataFrame
    df = pd.DataFrame(crop_production_data)



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

    crop_production_title = f'Crop Production (Bushels) - Start Year: {start_year}'


    # Create the dictionary conditionally for each column
    temp_dict = {'Year': df['year'].values.tolist()}

    columns_to_include = ['Corn', 'Wheat', 'Soybean', 'SG']
    for column in columns_to_include:
        if not (df[column] == 0).all():  # Check if all values in the column are not zero
            temp_dict[column] = df[column].values.tolist()
    temp_dict['crop_production_title'] = crop_production_title

    temp = {"production": temp_dict}
    return json.dumps(temp)


def net_income_calculation():

    file_path = "received_data.json"

    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    start_year = int(data['StartYear']['input_start_of_years'])
    print("StartYear",start_year)
    
    crop_production_data = pd.read_csv(r"netlogo\ag-net-income.csv", delimiter="\t", header=None)

    df = crop_production_data

    df = df.drop(df.index[0:16])


    df = df[0].str.split(',', expand=True)

    df.columns = df.iloc[0]
    df = df.iloc[1:]

    df.columns = ['year', "Corn", "color_0", "pen_down_0", 
                "year_1","Wheat", "color_1", "pen_down_1",
                "year_2","Soybean", "color_2", "pen_down_2",
                "year_3","SG", "color_3", "pen_down_3",
                "year_4", "US$0", "color_4", "pen_down_4"]

    # Reset the index
    df.reset_index(drop=True, inplace=True)

    #df['Corn'] = df['Corn'].str.replace('"', '')
    df['Corn'] = df['Corn'].str.replace('"', '').astype(float)
    df['Wheat'] = df['Wheat'].str.replace('"', '').astype(float)
    df['Soybean'] = df['Soybean'].str.replace('"', '').astype(float)
    df['SG'] = df['SG'].str.replace('"', '').astype(float)
    df['US$0'] = df['US$0'].str.replace('"', '').astype(float)

    df=df[['year','Corn','Wheat','Soybean','SG','US$0']]

    netCalculationTitle  = f'Agriculture Net Income - Start Year: {start_year}'

    # Create the dictionary conditionally for each column
    temp_dict = {'Year': df['year'].values.tolist()}

    columns_to_include = ['Corn','Wheat','Soybean','SG','US$0']
    for column in columns_to_include:
        if not (df[column] == 0).all():  # Check if all values in the column are not zero
            temp_dict[column] = df[column].values.tolist()
    temp_dict['netCalculationTitle'] = netCalculationTitle

    temp = {"Income": temp_dict}

    return json.dumps(temp)

