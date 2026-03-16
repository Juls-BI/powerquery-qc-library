# Power Query QC Library (Dates & Numbers)


<p align="left">
  <img src="https://img.shields.io/badge/status-stable-brightgreen" />
  <img src="https://img.shields.io/badge/license-MIT-blue" />
  <img src="https://img.shields.io/badge/version-v1.0.0-orange" />
  <img src="https://img.shields.io/badge/powerquery-M%20Functions-ff69b4" />
</p>


A clean, reusable library of **Power Query (M)** functions for validating numeric and date values with full **culture support**.  
Ideal for Power BI, Excel Power Query, and automated data quality checks.

---

##  Included Functions

### 1. NumberQualityControl
Validates numeric-like values under a user-specified culture.

**Returns:**
- `Valid Number <culture>`
- `Invalid Number`
- `Invalid Format`

**Features:**
- Supports culture-based decimal/thousand separators  
- Cleans NBSP, whitespace, currency symbols, accounting negatives `(1,234)`  
- Optional percent acceptance (`"12%"` → `0.12` if enabled)

---

### 2. DateQualityControl
Validates dates using a user-defined culture (e.g., `en-GB` or `en-US`).

**Returns:**
- `Valid Date <culture>`
- `Invalid Date`
- `Invalid Format`

**Accepts:**
- ISO dates (`yyyy-MM-dd`)  
- Culture-specific formats (DD/MM/YYYY, MM/DD/YYYY, etc.)

---

### 3. NumberParsedOrNull
Cleans and parses numeric values using culture rules.

**Returns:**
- A **number**
- `null` if invalid

---

### 4. DateParsedOrNull
Culture-aware date parser.

**Returns:**
- A **date**
- `null` if invalid

---

##  How to Use

### 1. Copy each `.pq` file into Power Query  
Power BI → Transform Data → New Query → Blank Query → Advanced Editor → paste → name the query.

### 2. Invoke from a dataset  
Add Column → Invoke Custom Function → choose the function → supply parameters:

#### NumberQualityControl parameters:
- `valueText` → your column  
- `culture` → e.g., `en-GB`, `en-US`, `de-DE`  
- `allowPercent` → true/false  

#### DateQualityControl parameters:
- `dateText` → your column  
- `culture` → e.g., `en-GB`, `en-US`

---

##  Supported Culture Codes

Use these codes when invoking the functions:

| Culture Code | Region |
|--------------|--------|
| en-GB | United Kingdom |
| en-US | United States |
| en-CA | Canada |
| en-AU | Australia |
| en-NZ | New Zealand |
| de-DE | Germany |
| fr-FR | France |
| es-ES | Spain |
| it-IT | Italy |
| nl-NL | Netherlands |
| pt-PT | Portugal |
| sv-SE | Sweden |
| fi-FI | Finland |
| pl-PL | Poland |
| ru-RU | Russia |
| ja-JP | Japan |
| zh-CN | China (Simplified) |
| zh-TW | Taiwan |
| ko-KR | Korea |
| ar-SA | Saudi Arabia |
| he-IL | Israel |
| hi-IN | India (Hindi) |
| pt-BR | Brazil |
| es-MX | Mexico |

Full table in documentation.

---

## 📄 License

This project is licensed under the MIT License — see `LICENSE` for details.

---

##  Contributing

Pull requests are welcome.  
If adding new QC functions, please include example usage in `/examples/Demo.qpq`.
