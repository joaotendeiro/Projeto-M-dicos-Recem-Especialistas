# Welcome

Welcome to my project on an analysis on Medical Education and Newly Qualified Specialists.

The data is sourced from Portugal's open Data website ["dados.gov - Administração Central do Sistema de Saúde (ACSS), I.P"](https://dados.gov.pt/pages/datasets/formacao-medica-medicos-recem-especialistas).


## Questions

## Tools Used
- **Python + Pandas + Numpy**: Used for ETL (reading the csv, renaming collumns, checking for incoherent values, normalizing data). This tools were also used to connect to SQLite and populate the tables.
- **SQLite**: Database+Table creation and some queries.
- **Power BI** 

## Data Dictionary

| Corrected Column Name | Original Column Name (with error) | Data Type | Description | Example |
| :--- | :--- | :--- | :--- | :--- |
| **Registration No.** / Nº Registo | NÂº Registo | Integer | Unique identifier or registration number for the record. | `2`, `11`, `22` |
| **Period** / Período | PerÃ-odo | Year / Integer | The calendar year to which the reported data refers. | `2020` |
| **Specialty** / Especialidade | Especialidade | String / Text | The medical specialty of the training program. | `Anestesiologia` (Anesthesiology) |
| **Training Institution** / Instituição de Formação | InstituiÃ§Ã£o de FormaÃ§Ã£o | String / Text | The hospital or medical center where the specialty training took place. | `Centro Hospitalar Universitário de Lisboa Norte, E.P.E.` |
| **Newly Qualified Specialists** / Médicos Recém-Especialistas | MÃ©dicos RecÃ©m-Especialistas | Integer | The count of doctors who recently completed their medical specialty at that institution during the given period. | `1`, `8`, `2` |

## Data Preparation and Cleanup

1. Normalize Null/Blank values
2. Validate abnormal values like wrong values for Years and Negative Values for 'Period' and for 'Newly Qualified Specialists'. Also setting appropriate value ranges when necessary.
3. Running describe() and info() to see if something strange pops up like outliers.

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

## SQLite Database
I split the Data across 3 tables. One for **Instituion**(Hospital or Medical Center), another one for the **Specialty** which the Doctor Specialized in and a third one '**Formation**' for bringing together every record and counting how many Doctors Specialized in a said Instituion and a certain Speciality.

This is the layout of the Database: