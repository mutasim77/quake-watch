import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs) -> pd.DataFrame:
    df = pd.DataFrame()

    headers = {
        "X-RapidAPI-Key": "6d15e169famsh14ec07b2b3145d2p1f0eddjsnf6010e34a528",
        "X-RapidAPI-Host": "everyearthquake.p.rapidapi.com"
    }
    params_template = { "start": "1", "count": "1000" }

    url = 'https://everyearthquake.p.rapidapi.com/earthquakes'
    for i in range(100):
        start_index = i * 1000 + 1
        params = params_template.copy()
        params["start"] = str(start_index)

        response = requests.get(url, headers=headers, params=params)

        if response.status_code == 200:
            response_dict = response.json()
            df = data_to_df(response_dict)

            filename = f"dataset/earthquake_data_{i+1}.parquet"
            df.to_parquet(filename)
            print(f"Data exported to {filename}")
        else:
            print(f"Request {i+1} failed with status code {response.status_code}")

    merge_parquet_files("dataset/earthquake_data_", 100)
    merged_df = pd.read_parquet("dataset/merged_data.parquet")
    return merged_df

def data_to_df(response_dict: dict) -> pd.DataFrame:
    list_dicts_data = response_dict['data']
    keys_list = ['id', 'magnitude', 'type', 'title', 'date', 'time', 'updated', 
    'felt', 'cdi', 'mmi', 'alert', 'status', 'tsunami', 'sig', 'net', 'code', 
    'ids', 'sources', 'nst', 'dmin', 'rms', 'gap', 'magType', 'geometryType', 
    'depth', 'latitude', 'longitude', 'place', 'distanceKM', 'placeOnly', 
    'location', 'continent', 'country', 'subnational', 'city', 'locality', 
    'postcode', 'what3words', 'timezone']

    df =  pd.DataFrame()
    for earthquake in list_dicts_data:
        earthquake_dict = {key: earthquake[key] for key in keys_list}
        earthquake_df = pd.DataFrame(earthquake_dict, index=[0]).set_index('id')
        df = pd.concat([df, earthquake_df], axis=0)
    return df



def merge_parquet_files(file_prefix, num_batches):
    dfs = []

    for i in range(1, num_batches + 1):
        filename = f"{file_prefix}{i}.parquet"
        try:
            df = pd.read_parquet(filename)
            dfs.append(df)  
        except FileNotFoundError:
            print(f"File {filename} not found.")

    if dfs:
        merged_df = pd.concat(dfs, ignore_index=True)
        
        merged_filename = f"dataset/merged_data.parquet"
        merged_df.to_parquet(merged_filename)
        print(f"Merged data saved to {merged_filename}")
    else:
        print("No data to merge.")

@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'