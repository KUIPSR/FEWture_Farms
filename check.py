import json

file_path = "received_data.json"

with open(file_path, 'r') as json_file:
    data = json.load(json_file)

print(json.dumps(data))  

