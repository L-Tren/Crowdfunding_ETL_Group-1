# Project 2 Group 2
Module 13 Challenge - Extract, Transform & Load (ETL)

- Trenerry, Lewis
- Yu, Olivia,
- Siad, Matias,
- Robertson, John
---
---

Getting started
---
An anaconda dev environment with python version 3.7 was used to edit the notebook file and perform all operations.

The two methods used to edit code were:

  1. VSCode with the Jupyter extension (ms-toolsai.jupyter) & Python extension(ms-python.python).
  
  2. A Jupyter Lab IDE session started with the following command line through git terminal:
   
    jupyter jab

The following python dependencies were imported:

    import pandas as pd
    import numpy as np
    from datetime import datetime as dt
    import json

In addition to these dependencies we've limited the column width in the dataframe outputs to 400 pixels with the following line:

    pd.set_option('max_colwidth', 400)

---
---

Summary of code
---

### Pandas data tranformation
We begin by importing our crowfunding excel document with the following command:

    pd.read_excel('Resources/crowdfunding.xlsx')

This will load the table below as a Pandas Dataframe to perform data cleaning and further table generation:

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>cf_id</th>
      <th>contact_id</th>
      <th>company_name</th>
      <th>blurb</th>
      <th>goal</th>
      <th>pledged</th>
      <th>outcome</th>
      <th>backers_count</th>
      <th>country</th>
      <th>currency</th>
      <th>launched_at</th>
      <th>deadline</th>
      <th>staff_pick</th>
      <th>spotlight</th>
      <th>category &amp; sub-category</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>147</td>
      <td>4661</td>
      <td>Baldwin, Riley and Jackson</td>
      <td>Pre-emptive tertiary standardization</td>
      <td>100</td>
      <td>0</td>
      <td>failed</td>
      <td>0</td>
      <td>CA</td>
      <td>CAD</td>
      <td>1581573600</td>
      <td>1614578400</td>
      <td>False</td>
      <td>False</td>
      <td>food/food trucks</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1621</td>
      <td>3765</td>
      <td>Odom Inc</td>
      <td>Managed bottom-line architecture</td>
      <td>1400</td>
      <td>14560</td>
      <td>successful</td>
      <td>158</td>
      <td>US</td>
      <td>USD</td>
      <td>1611554400</td>
      <td>1621918800</td>
      <td>False</td>
      <td>True</td>
      <td>music/rock</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1812</td>
      <td>4187</td>
      <td>Melton, Robinson and Fritz</td>
      <td>Function-based leadingedge pricing structure</td>
      <td>108400</td>
      <td>142523</td>
      <td>successful</td>
      <td>1425</td>
      <td>AU</td>
      <td>AUD</td>
      <td>1608184800</td>
      <td>1640844000</td>
      <td>False</td>
      <td>False</td>
      <td>technology/web</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2156</td>
      <td>4941</td>
      <td>Mcdonald, Gonzalez and Ross</td>
      <td>Vision-oriented fresh-thinking conglomeration</td>
      <td>4200</td>
      <td>2477</td>
      <td>failed</td>
      <td>24</td>
      <td>US</td>
      <td>USD</td>
      <td>1634792400</td>
      <td>1642399200</td>
      <td>False</td>
      <td>False</td>
      <td>music/rock</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1365</td>
      <td>2199</td>
      <td>Larson-Little</td>
      <td>Proactive foreground core</td>
      <td>7600</td>
      <td>5265</td>
      <td>failed</td>
      <td>53</td>
      <td>US</td>
      <td>USD</td>
      <td>1608530400</td>
      <td>1629694800</td>
      <td>False</td>
      <td>False</td>
      <td>theater/plays</td>
    </tr>
  </tbody>
</table>
</div>

By splitting the category & subcategory columns on '/' and casting the output to a string we can create two separate arrays of data containing the data independently:

    crowdfunding_info_df['category & sub-category'].str.split('/').str

The unique values of each array are parsed into a list:

    categories = crowdfunding_info_df['category'].unique().tolist()

---
    subcategories = crowdfunding_info_df['subcategory'].unique().tolist()

Using the independent arrays of data and stitching 'cat' or 'subcat' to the ouputs with the comprehension method we store the outputs as lists to create a Pandas Dataframe:

    cat_ids = ['cat' + str(cat_id) for cat_id in category_ids]

    category_df = pd.DataFrame({'category_id': cat_ids, 'category': categories})
---
    scat_ids = ['subcat' + str(scat_id) for scat_id in subcategory_ids]

    subcategory_df = pd.DataFrame({'subcategory_id': scat_ids, 'subcategory': subcategories})


Each category & subcategory Dataframe is exported to a .csv.

---

The campaign Dataframe was cleaned up further including renaming some columns to better reflect the data and converting data types:

    campaign_df['goal'] = campaign_df['goal'].astype(float)

    campaign_df['pledged'] = campaign_df['pledged'].astype(float)

Next we had to convert the UNIX times contained in the 'launched_date' & 'end_date' columns and reformat the ouput string into YYYY-MM-DD format:

    campaign_df["launched_date"] = pd.to_datetime(campaign_df["launched_date"], unit='s').dt.strftime('%Y-%m-%d')

    campaign_df["end_date"] = pd.to_datetime(campaign_df["end_date"], unit='s').dt.strftime('%Y-%m-%d')

Teh campaign Dataframe was merged with the category & subcategory ids row:

    campaign_merged_df = pd.merge(campaign_df, category_df, on="category", how="left")

    campaign_merged_df = pd.merge(campaign_merged_df, subcategory_df, on="subcategory", how="left")

The campaign Dataframe had redundant columns which were dropped then the complete Dataframe was then exported to a .csv.

--- 

The 'contacts' excel spreadsheet was imported for cleaning and turned into a Dataframe for cleaning.

The first row was a redundant row containing the string 'contact_info'. This row was dropped:

    contact_info_df = contact_info_df.drop(0)

Each row of data was looped through using the json dependency and the contact_id, name and email was parsed from the output and saved as a unique list within a list:

    dict_values = []

    for index, row in contact_info_df.iterrows():
        data = json.loads(row[0])
        parsed_row = [data['contact_id'], data['name'], data['email']]
        dict_values.append(parsed_row)

This dictionary was used to create a 'contact_info' Dataframe.

The 'name' column was split on ' ' (space) and saved as dictionaries to create two lists, 'first_name' & 'last_name'. These lists were used to create 2 new rows in the Dataframe:

    contact_info['first_name'] = contact_info['name'].str.split().str[0]

    contact_info['last_name'] = contact_info['name'].str.split().str[1]

The 'contacts' Dataframe was exported to a .csv.

---

### SQL Database creation





---
---
References
--- 

QuickDatabaseDiagrams. (2024). Quick Database Diagrams. Retrieved from https://app.quickdatabasediagrams.com/#/ Accessed (18/03/2024)

University of Adelaide. (2023). Ins Loc and Iloc Solution Bootcamp Content. https://git.bootcampcontent.com/University-of-Adelaide/UADEL-VIRT-DATA-PT-12-2023-U-LOLC/-/blob/main/04-Data-Analysis-Pandas/2/Activities/01-Ins_LocAndIloc/Solved/loc_iloc_solution.ipynb?ref_type=heads Accessed (15/03/2024)

University of Adelaide. (2023). Ins List Comprehensions Solved Solution Bootcamp Content. https://git.bootcampcontent.com/University-of-Adelaide/UADEL-VIRT-DATA-PT-12-2023-U-LOLC/-/blob/main/13-Project-2-ETL/1/Activities/03-Ins_List_Comprehensions/Solved/list_comprehensions_solution.ipynb?ref_type=heads (15/03/2024)

University of Adelaide. (2023). Stu List Comprehensions Solved Solution Bootcamp Content. https://git.bootcampcontent.com/University-of-Adelaide/UADEL-VIRT-DATA-PT-12-2023-U-LOLC/-/blob/main/13-Project-2-ETL/1/Activities/04-Stu_List_Comprehensions/Solved/list_comprehensions_solution.ipynb?ref_type=heads (15/03/2024)

University of Adelaide. (2023). Evr Transform and Clean Grocery Orders Solved Solution Bootcamp Content. https://git.bootcampcontent.com/University-of-Adelaide/UADEL-VIRT-DATA-PT-12-2023-U-LOLC/-/blob/main/13-Project-2-ETL/1/Activities/05-Evr_Transform_and_Clean_Grocery_Orders/Solved/transform_and_clean_grocery_orders_solution.ipynb?ref_type=heads (15/03/2024)

Xpert. (2024, March 15). Re: Debugging Option1: Use Pandas to create the contacts Dataframe. Retrieved from https://www.edx.org/ (15/03/2024)

---
---

