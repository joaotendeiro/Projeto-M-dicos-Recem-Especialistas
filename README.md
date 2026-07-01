## Welcome
  
Welcome to my project analyzing Medical Education and Newly Qualified Specialists.  
The data is sourced from Portugal's open data website: https://dados.gov.pt/pages/datasets/formacao-medica-medicos-recem-especialistas.

### Questions

### Tools Used
- **Python + Pandas + NumPy**: Used for ETL (reading the CSV file, renaming columns, checking for inconsistent values, and normalizing data). These tools were also used to connect to SQLite and populate the tables.
- **SQLite**: Used for database and table creation, as well as basic querying.
- **Power BI**

---

### Data Dictionary

<table>
<tr>
<th>Corrected Column Name</th>
<th>Original Column Name (with error)</th>
<th>Data Type</th>
<th>Description</th>
<th>Example</th>
</tr>

<tr>
<td>**Registration No.** / Nº Registo</td>
<td>NÂº Registo</td>
<td>Integer</td>
<td>Unique identifier or registration number for each record.</td>
<td>2, 11, 22</td>
</tr>

<tr>
<td>**Period** / Período</td>
<td>PerÃ-odo</td>
<td>Year / Integer</td>
<td>The calendar year to which the data refers.</td>
<td>2020</td>
</tr>

<tr>
<td>**Specialty** / Especialidade</td>
<td>Especialidade</td>
<td>String / Text</td>
<td>The medical specialty of the training program.</td>
<td>Anestesiologia (Anesthesiology)</td>
</tr>

<tr>
<td>**Training Institution** / Instituição de Formação</td>
<td>InstituiÃ§Ã£o de FormaÃ§Ã£o</td>
<td>String / Text</td>
<td>The hospital or medical center where the specialty training took place.</td>
<td>Centro Hospitalar Universitário de Lisboa Norte, E.P.E.</td>
</tr>

<tr>
<td>**Newly Qualified Specialists** / Médicos Recém-Especialistas</td>
<td>MÃ©dicos RecÃ©m-Especialistas</td>
<td>Integer</td>
<td>The number of doctors who successfully completed their specialty during the given period at a given institution.</td>
<td>1, 8, 2</td>
</tr>
</table>

---

### Data Preparation and Cleanup
- Normalized null and blank values.
- Validated abnormal values such as incorrect years and negative values in 'Period' and 'Newly Qualified Specialists'.
- Applied appropriate value ranges where necessary.
- Used `describe()` and `info()` to check for anomalies such as outliers.

```python
url = "https://transparencia.sns.gov.pt/explore/dataset/formacao-medica-medicos-recem-especialistas/download?format=csv&timezone=Europe/Berlin&use_labels_for_header=true"

df = (
    pd.read_csv(url, sep=";").astype({
        "Nº Registo": "int64",
        "Período": "int64",
        "Médicos Recém-Especialistas": "int64"
    })
)

df = df.replace(
    ["", " ", "NA", "N/A", "NULL", "-"],
    np.nan
)

# some other checks
validar_dados(df)
df.info()
df.describe(include="all")
```

You can find the file for the data extract-tranform here: [`etl_dos_dados.ipynb`](etl_dos_dados.ipynb).

---

### PostgreSQL Database
  
The data was split across three tables:
- **Institution** (Hospital or Medical Center)
- **Specialty**
- **Formation** (fact table linking institutions and specialties with the number of doctors trained)

A new column was added to the Institution table indicating the district where each institution is located. This allows geographic analysis in Power BI. You can find the file for the scripint adding the new column here: [`localizacao_hospitais.ipynb`](localizacao_hospitais.ipynb).

This is the layout of the Database:
![DB layout](imagens\esquema_tabelas.png)
And this is the schema in SQL:[`create_tables.sql`](create_tables.sql).

Here you can also check some queries I did on the tables: [`queries.sql`](queries.sql).
Such as finding out the top specialities by year:
![DB layout](imagens\top_especialidades.png)

---

### Power BI
  
Two dashboard pages were created.

The **first page** is the main dashboard and includes:
- KPIs
- Filters
- A table showing the number of doctors trained per year, institution, and specialty
- A time trend of total trained doctors
- A geographical map by district
- Rankings by institution and specialty

![Dashboard](imagens\dashboard_1.png)

The **second page** provides a more in-depth analysis:
- A bar chart showing the difference in the number of doctors between 2020 and 2025
- A geographical distribution highlighting areas with higher training activity
- A visual showing specialties with fewer new specialists, potentially indicating future shortages

![2nd Page](imagens\dashboard_2.png)

---

## Key Insights — Overview & Institutions

- The total number of trained medical specialists reached 9,346 between 2020 and 2025, indicating steady growth in the healthcare workforce.
- The yearly trend shows overall growth, increasing from approximately 1,450 specialists in 2020 to nearly 1,700 in 2025.
- A small number of institutions dominate specialist training, with the top institution producing around 360 specialists.
- Training capacity is concentrated in major hospital centers.
- Geographic distribution shows clustering in coastal and urban regions.
- Inland regions show lower training activity.

---

## Key Insights — Specialties & Growth

- Growth patterns vary significantly across specialties.
- Some specialties show strong growth, while others remain stable or decline.
- Year-over-year growth varies and is not linear.
- Some specialties consistently show low numbers of new specialists.
- Low-volume specialties may indicate future shortages.
- There is an imbalance between high-growth and low-volume specialties.

---

## Overall Conclusion

- The analysis shows growth but also imbalance in the system.
- Training is concentrated geographically and institutionally.
- Some specialties may face future shortages.
