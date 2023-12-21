from dependency import *
from netlogo_instance import get_netlogo_instance

dirname = os.path.dirname(__file__)
def crop_income_calculation():

    file_path = "received_data.json"

    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    start_year = int(data['StartYear']['input_start_of_years'])

    crop_income_data = pd.read_csv(r"netlogo\total-net-income.csv", delimiter="\t", header=None)

    # Preprocess the DataFrame
    df = pd.DataFrame(crop_income_data)


    df = df.drop(df.index[0:15])
    df = df[0].str.split(',', expand=True)
    df.columns = df.iloc[0]
    df = df.iloc[1:]
    df.columns = ['year', "Crop", "color_0", "pen_down_0", 
                "year_1","Energy", "color_1", "pen_down_1",
                "year_2","All", "color_2", "pen_down_2",
                "year_3","US$0", "color_3", "pen_down_3"]

    # Reset the index
    df.reset_index(drop=True, inplace=True)

    # Convert columns to integers
    df['Crop'] = df['Crop'].str.replace('"', '').astype(float)
    df['Energy'] = df['Energy'].str.replace('"', '').astype(float)
    df['All'] = df['All'].str.replace('"', '').astype(float)
    df['US$0'] = df['US$0'].str.replace('"', '').astype(float)

    df=df[['year','Crop','Energy','All','US$0']]

    total_farm_net_income = f'Total Farm Net Income - Start Year: {start_year}'


    temp = {"Crop_Income": {
        'Year': df['year'].values.tolist(),
        'Crop': df['Crop'].values.tolist(),
        'Energy': df['Energy'].values.tolist(),
        'All': df['All'].values.tolist(),
        'US$0': df['US$0'].values.tolist(),
        'total_farm_net_income':total_farm_net_income
    }}

    
    print(temp)

    return json.dumps(temp)


def insurance_income_calculation():

    file_path = "received_data.json"

    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    start_year = int(data['StartYear']['input_start_of_years'])
    
    insurance_production_data = pd.read_csv(r"netlogo\income-from-crop-insurance.csv", delimiter="\t", header=None)

    df = insurance_production_data

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

    df['Corn'] = df['Corn'].str.replace('"', '')


    df['Corn'] = df['Corn'].str.replace('"', '').astype(float)

    df['Wheat'] = df['Wheat'].str.replace('"', '').astype(float)
    df['Soybean'] = df['Soybean'].str.replace('"', '').astype(float)
    df['SG'] = df['SG'].str.replace('"', '').astype(float)

    df=df[['year','Corn','Wheat','Soybean','SG']]

    total_income_from_crop_insurance = f'Total Income From Crop Insurance - Start Year: {start_year}'



    temp = {
        "Insurance_Income": {
            'Year': df['year'].values.tolist(),
            'Corn': df['Corn'].values.tolist(),
            'Wheat': df['Wheat'].values.tolist(),
            'Soybean': df['Soybean'].values.tolist(),
            'SG': df['SG'].values.tolist(),
            'total_income_from_crop_insurance':total_income_from_crop_insurance
        }
    }

    return json.dumps(temp)
