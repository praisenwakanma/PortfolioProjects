#!/usr/bin/env python
# coding: utf-8

# In[26]:


get_ipython().system('pip install yfinance')


# In[27]:


import pandas as pd
import yfinance as yf
import datetime
from datetime import date, timedelta
from datetime import datetime
import plotly.graph_objects as go
import plotly.express as px


# In[28]:


today = date.today()


# In[29]:


d1 = today.strftime('%Y-%m-%d')
end_date = d1
d2 = date.today() - timedelta(days=365)
d2 = d2.strftime('%Y-%m-%d')
start_date = d2


# In[16]:


# Collecting Data from Google
data = yf.download('GOOG', 
                   start= start_date,
                   end= end_date,
                   progress=False)
data['Date']= data.index
data= data[['Date', 'Open', 'High', 'Low', 'Close', 'Adj Close', 'Volume']]
data.reset_index(drop=True, inplace=True)
print(data)


# In[18]:


# Visualizing Candlestick Charts
figure = go.Figure(data=[go.Candlestick(x=data['Date'],
                                       open= data['Open'], high= data['High'], low= data['Low'], close= data['Close'])])
figure.update_layout(title= 'Google Stock Price Analysis', xaxis_rangeslider_visible=False)
figure.show()


# In[19]:


# Visualizing Bar Plot 
figure = px.bar(data, x= 'Date', y= 'Close')
figure.show()


# In[21]:


# Visualizing Line Plot with Rangeslider
figure = px.line(data, x= 'Date', y= 'Close',
                title= 'Stock Market Analysis with Rangeslider')
figure.update_xaxes(rangeslider_visible=True)
figure.show()


# In[22]:


# Visualizing Scatter Plot
figure = px.scatter(data, x='Date', y='Close', range_x=['2021-12-10', '2022-12-09'],
                   title= 'Stock Market Analysis by Hiding Weekend Gaps')
figure.update_xaxes(
    rangebreaks=[
        dict(bounds=['sat', 'sun'])
    ]
)
figure.show()

