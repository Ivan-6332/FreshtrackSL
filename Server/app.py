import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split

# Load the monthly data
df = pd.read_csv('2021.csv')

# Function to convert month-based data to week-based predictions
def month_to_week_predictions(df):
    month_to_weeks = {
        1: [1, 2, 3, 4],
        2: [5, 6, 7, 8],
        3: [9, 10, 11, 12, 13],
        4: [14, 15, 16, 17],
        5: [18, 19, 20, 21, 22],
        6: [23, 24, 25, 26],
        7: [27, 28, 29, 30, 31],
        8: [32, 33, 34, 35],
        9: [36, 37, 38, 39],
        10: [40, 41, 42, 43, 44],
        11: [45, 46, 47, 48],
        12: [49, 50, 51, 52]
    }

    weekly_data = []

    for crop_id in df['crop_id'].unique():
        crop_data = df[df['crop_id'] == crop_id]
        X = crop_data[['month_no']].values
        y = crop_data['demand'].values

        model = LinearRegression()
        model.fit(X, y)

        for month in range(1, 13):
            monthly_demand = float(crop_data[crop_data['month_no'] == month]['demand'].values[0])
            weeks = month_to_weeks[month]
            num_weeks = len(weeks)

            for i, week in enumerate(weeks):
                position_within_month = (i + 1) / (num_weeks + 1)
                week_factor = 1.0 + (position_within_month - 0.5) * 0.1
                weekly_demand = (monthly_demand / num_weeks) * week_factor
                weekly_demand = int(round(weekly_demand))

                weekly_data.append({
                    'crop_id': crop_id,
                    'week_no': week,
                    'demand': weekly_demand
                })

    weekly_df = pd.DataFrame(weekly_data)
    weekly_df = weekly_df.sort_values(by=['crop_id', 'week_no'])
    weekly_df['id'] = range(1, len(weekly_df) + 1)
    weekly_df = weekly_df[['id', 'crop_id', 'week_no', 'demand']]

    return weekly_df