import pandas as pd 
import numpy as np
import requests

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@transformer
def transform(df, *args, **kwargs) -> pd.DataFrame:
    # I prefer to clone the DF and perform transformations without altering the original DF
    _df = df.copy()
    
    # Reset the index
    _df = _df.reset_index()

    # Select just the columns of interest 
    final_columns = ['index', 'magnitude', 'date','felt', 'depth', 'latitude', 'longitude', 'distanceKM', 'location', 'country', 'city', 'continent']
    _df = _df.loc[:, final_columns]
    _df.rename(columns={'index': 'id'}, inplace=True)

    # Date converted to datetime 
    _df['date'] = pd.to_datetime(_df['date'])

    # Create new columns for year and week
    _df['year'] = pd.to_datetime(_df['date']).dt.isocalendar().year
    _df['week'] = pd.to_datetime(_df['date']).dt.isocalendar().week

    # Now let's separate the column date to keep just the date (there is no need to keep the hour)
    _df.rename(columns={'date': 'date_time'}, inplace=True)
    _df['date'] = pd.to_datetime(_df['date_time']).dt.date
    _df.drop('date_time', inplace=True, axis=1)

    # Transform to datetime type again with specified format
    _df['date'] = pd.to_datetime(_df['date'], format="%Y/%m/%d")

    # Some of country names were misspelled
    _df = _df.replace('Türkiye', 'Turkey')
    _df = _df.replace('Índia', 'India')

    # Transform the data types of the table
    convert_dict = {
        'id': str,
        'magnitude': float, 
        'felt': int, 
        'depth': float, 
        'latitude': float, 
        'longitude': float, 
        'distanceKM': float,
        'year': int, 
        'week': int,
        'country': str, 
        'city': str, 
        'location': str, 
        'continent': str
    }

    _df = _df.astype(convert_dict)
    
    return _df

@test
def test_output(output, *args) -> None:
    assert output is not None, 'The output is undefined'