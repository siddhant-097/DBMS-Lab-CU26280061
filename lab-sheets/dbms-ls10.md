# Database Technologies Lab Sheet – 10

## Hospital Medicine Management System

* **Course Code:** MCA105P

* **Technologies:** MongoDB, Python, Flask, PyMongo, HTML, CSS

## Part A – MongoDB Setup

### Q1. Create a MongoDB database named `HospitalDB` and a collection named `medicines`. Insert at least 8 medicine documents and verify them.

Run the following commands in MongoDB Shell (`mongosh`):

```
use HospitalDB

db.createCollection("medicines")

db.medicines.insertMany([
    {
        medicine_id: 301,
        name: "Paracetamol",
        category: "Analgesic",
        price: 25,
        stock: 100,
        manufacturer: "ABC Pharma"
    },
    {
        medicine_id: 302,
        name: "Amoxicillin",
        category: "Antibiotic",
        price: 85,
        stock: 45,
        manufacturer: "HealthCare Ltd"
    },
    {
        medicine_id: 303,
        name: "Cetirizine",
        category: "Antihistamine",
        price: 18,
        stock: 20,
        manufacturer: "MediLife"
    },
    {
        medicine_id: 304,
        name: "Azithromycin",
        category: "Antibiotic",
        price: 120,
        stock: 15,
        manufacturer: "ABC Pharma"
    },
    {
        medicine_id: 305,
        name: "Ibuprofen",
        category: "Analgesic",
        price: 60,
        stock: 75,
        manufacturer: "Wellness Pharma"
    },
    {
        medicine_id: 306,
        name: "Omeprazole",
        category: "Antacid",
        price: 95,
        stock: 28,
        manufacturer: "HealthCare Ltd"
    },
    {
        medicine_id: 307,
        name: "Vitamin C",
        category: "Supplement",
        price: 150,
        stock: 60,
        manufacturer: "NutriMed"
    },
    {
        medicine_id: 308,
        name: "Metformin",
        category: "Antidiabetic",
        price: 45,
        stock: 12,
        manufacturer: "MediLife"
    }
])

```

Verify the database and documents:

```
show dbs
show collections
db.medicines.find()
db.medicines.countDocuments()

```

The collection should contain 8 medicine documents.

## Part B – HTML and CSS

### Q2. Create an HTML medicine entry form.

Create `templates/add_medicine.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Medicine</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Add New Medicine</h1>
        <form action="{{ url_for('add_medicine') }}" method="POST">
            <label for="medicine_id">Medicine ID</label>
            <input type="number" id="medicine_id" name="medicine_id" required>

            <label for="name">Medicine Name</label>
            <input type="text" id="name" name="name" required>

            <label for="category">Category</label>
            <input type="text" id="category" name="category" required>

            <label for="price">Price (₹)</label>
            <input type="number" step="0.01" id="price" name="price" required>

            <label for="stock">Stock</label>
            <input type="number" id="stock" name="stock" required>

            <label for="manufacturer">Manufacturer</label>
            <input type="text" id="manufacturer" name="manufacturer" required>

            <button type="submit">Add Medicine</button>
        </form>
        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

### Q3. Create a CSS file and design the medicine entry page (Print-Friendly Clean Styling).

Create `static/style.css`:

```
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    padding: 20px;
    font-family: Arial, sans-serif;
    background: #ffffff;
    color: #000000;
}

.container {
    width: 100%;
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    background: #ffffff;
}

h1, h2, h3 {
    text-align: center;
    color: #000000;
}

form {
    display: flex;
    flex-direction: column;
    gap: 10px;
    max-width: 600px;
    margin: 0 auto;
}

label {
    margin-top: 8px;
    font-weight: bold;
}

input {
    width: 100%;
    padding: 8px;
    border: 1px solid #000000;
    border-radius: 4px;
    font-size: 14px;
}

button, .button {
    display: inline-block;
    margin-top: 15px;
    padding: 10px 15px;
    border: 1px solid #000000;
    border-radius: 4px;
    background: #ffffff;
    color: #000000;
    font-size: 14px;
    text-align: center;
    text-decoration: none;
    cursor: pointer;
}

a {
    color: #000000;
}

table {
    width: 100%;
    margin-top: 20px;
    border-collapse: collapse;
    background: #ffffff;
}

th, td {
    padding: 8px;
    border: 1px solid #000000;
    text-align: left;
}

th {
    background: #ffffff;
    color: #000000;
    font-weight: bold;
}

.message {
    margin: 15px 0;
    padding: 10px;
    border: 1px solid #000000;
    background: #ffffff;
    color: #000000;
}

.low-stock {
    font-weight: bold;
}

nav {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 10px;
    margin: 20px 0;
}

@media print {
    body {
        padding: 0;
    }
    .container {
        width: 100%;
        max-width: none;
        padding: 0;
    }
}

```

## Part C – Python Flask and MongoDB

### Q4. Create a Flask application that connects to `HospitalDB` and accesses the `medicines` collection.

Create `app.py`:

```
from flask import Flask
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017/", serverSelectionTimeoutMS=5000)
db = client["HospitalDB"]
medicines = db["medicines"]

@app.route("/")
def home():
    return "Hospital Medicine Management System"

if __name__ == "__main__":
    try:
        client.admin.command("ping")
        print("Successfully connected to MongoDB!")
        print("Database:", db.name)
        print("Collection:", medicines.name)
    except Exception as error:
        print("MongoDB connection failed:", error)
    app.run(debug=True)

```

Run the application:

```
python app.py

```

Expected terminal output:

```
Successfully connected to MongoDB!
Database: HospitalDB
Collection: medicines

```

### Q5. Connect the HTML medicine form with Flask and store submitted medicine details in MongoDB.

Add this route to `app.py`:

```
from flask import render_template, request, redirect, url_for

@app.route("/add", methods=["GET", "POST"])
def add_medicine():
    if request.method == "POST":
        try:
            medicine = {
                "medicine_id": int(request.form["medicine_id"]),
                "name": request.form["name"].strip(),
                "category": request.form["category"].strip(),
                "price": float(request.form["price"]),
                "stock": int(request.form["stock"]),
                "manufacturer": request.form["manufacturer"].strip()
            }
            if medicine["price"] < 0 or medicine["stock"] < 0:
                return "Price and stock cannot be negative.", 400
            if medicines.find_one({"medicine_id": medicine["medicine_id"]}):
                return "A medicine with this ID already exists.", 409
            
            medicines.insert_one(medicine)
            return redirect(url_for("view_medicines"))
        except (ValueError, KeyError):
            return "Please enter valid medicine details.", 400
            
    return render_template("add_medicine.html")

```

Verify the inserted document in MongoDB Shell:

```
use HospitalDB
db.medicines.find({ medicine_id: 309 })

```

### Q6. Retrieve all medicine documents from MongoDB and display them on an HTML page.

Add this route to `app.py`:

```
@app.route("/medicines")
def view_medicines():
    all_medicines = list(medicines.find().sort("medicine_id", 1))
    return render_template("view_medicines.html", medicines=all_medicines)

```

Create `templates/view_medicines.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Medicines</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Medicine Inventory</h1>
        {% if medicines %}
        <table>
            <thead>
                <tr>
                    <th>Medicine ID</th>
                    <th>Medicine Name</th>
                    <th>Category</th>
                    <th>Price (₹)</th>
                    <th>Stock</th>
                    <th>Manufacturer</th>
                </tr>
            </thead>
            <tbody>
                {% for medicine in medicines %}
                <tr>
                    <td>{{ medicine.medicine_id }}</td>
                    <td>{{ medicine.name }}</td>
                    <td>{{ medicine.category }}</td>
                    <td>{{ "%.2f"|format(medicine.price) }}</td>
                    <td>{{ medicine.stock }}</td>
                    <td>{{ medicine.manufacturer }}</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
        {% else %}
            <p>No medicines found.</p>
        {% endif %}
        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

### Q7. Create a search facility that allows the user to search for a medicine using Medicine ID or Medicine Name.

Add this route to `app.py`:

```
@app.route("/search", methods=["GET", "POST"])
def search_medicine():
    results = []
    message = None
    if request.method == "POST":
        search_value = request.form.get("search_value", "").strip()
        if search_value:
            if search_value.isdigit():
                medicine = medicines.find_one({"medicine_id": int(search_value)})
                if medicine:
                    results = [medicine]
            else:
                results = list(medicines.find({
                    "name": {"$regex": search_value, "$options": "i"}
                }))
            if not results:
                message = "No medicine found."
    return render_template("search_medicine.html", medicines=results, message=message)

```

Create `templates/search_medicine.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Medicine</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Search Medicine</h1>
        <form action="{{ url_for('search_medicine') }}" method="POST">
            <label for="search_value">Medicine ID or Medicine Name</label>
            <input type="text" id="search_value" name="search_value" placeholder="Enter ID or name" required>
            <button type="submit">Search</button>
        </form>

        {% if message %}
            <p class="message">{{ message }}</p>
        {% endif %}

        {% if medicines %}
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Manufacturer</th>
                </tr>
            </thead>
            <tbody>
                {% for medicine in medicines %}
                <tr>
                    <td>{{ medicine.medicine_id }}</td>
                    <td>{{ medicine.name }}</td>
                    <td>{{ medicine.category }}</td>
                    <td>{{ medicine.price }}</td>
                    <td>{{ medicine.stock }}</td>
                    <td>{{ medicine.manufacturer }}</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
        {% endif %}
        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

### Q8. Create a facility to update the stock of a medicine.

Add this route to `app.py`:

```
@app.route("/update-stock", methods=["GET", "POST"])
def update_stock():
    message = None
    updated_medicine = None
    if request.method == "POST":
        try:
            medicine_id = int(request.form["medicine_id"])
            new_stock = int(request.form["new_stock"])
            if new_stock < 0:
                message = "Stock cannot be negative."
            else:
                result = medicines.update_one(
                    {"medicine_id": medicine_id},
                    {"$set": {"stock": new_stock}}
                )
                if result.matched_count == 0:
                    message = "Medicine not found."
                else:
                    message = "Stock updated successfully."
                    updated_medicine = medicines.find_one({"medicine_id": medicine_id})
        except (ValueError, KeyError):
            message = "Enter a valid Medicine ID and stock value."

    return render_template("update_stock.html", message=message, medicine=updated_medicine)

```

Create `templates/update_stock.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Stock</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Update Medicine Stock</h1>
        <form action="{{ url_for('update_stock') }}" method="POST">
            <label for="medicine_id">Medicine ID</label>
            <input type="number" id="medicine_id" name="medicine_id" required>

            <label for="new_stock">New Stock</label>
            <input type="number" id="new_stock" name="new_stock" min="0" required>

            <button type="submit">Update Stock</button>
        </form>

        {% if message %}
            <p class="message">{{ message }}</p>
        {% endif %}

        {% if medicine %}
            <h3>Updated Medicine Information</h3>
            <p><strong>Medicine ID:</strong> {{ medicine.medicine_id }}</p>
            <p><strong>Name:</strong> {{ medicine.name }}</p>
            <p><strong>Updated Stock:</strong> {{ medicine.stock }}</p>
        {% endif %}

        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

### Q9. Create a facility to delete a medicine using its Medicine ID.

Add this route to `app.py`:

```
@app.route("/delete", methods=["GET", "POST"])
def delete_medicine():
    message = None
    if request.method == "POST":
        try:
            medicine_id = int(request.form["medicine_id"])
            result = medicines.delete_one({"medicine_id": medicine_id})
            if result.deleted_count == 1:
                message = "Medicine deleted successfully."
            else:
                message = "Medicine not found."
        except (ValueError, KeyError):
            message = "Enter a valid Medicine ID."

    return render_template("delete_medicine.html", message=message)

```

Create `templates/delete_medicine.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Medicine</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Delete Medicine</h1>
        <form action="{{ url_for('delete_medicine') }}" method="POST">
            <label for="medicine_id">Medicine ID</label>
            <input type="number" id="medicine_id" name="medicine_id" required>
            <button type="submit">Delete Medicine</button>
        </form>

        {% if message %}
            <p class="message">{{ message }}</p>
        {% endif %}

        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

Verify deletion in MongoDB Shell:

```
db.medicines.findOne({ medicine_id: 309 })

```

## Part D – MongoDB Query Practice

### Q10. Write and execute MongoDB queries to filter and sort medicine documents.

Select the database:

```
use HospitalDB

```

**(a) Display medicines belonging to a particular category:**

```
db.medicines.find({ category: "Antibiotic" })

```

**(b) Display medicines costing more than ₹50:**

```
db.medicines.find({ price: { $gt: 50 } })

```

**(c) Display medicines costing less than ₹100:**

```
db.medicines.find({ price: { $lt: 100 } })

```

**(d) Display medicines having stock less than 30:**

```
db.medicines.find({ stock: { $lt: 30 } })

```

**(e) Display medicines manufactured by a particular manufacturer:**

```
db.medicines.find({ manufacturer: "ABC Pharma" })

```

**(f) Sort medicines according to price:**

* Ascending order (lowest to highest):

```
db.medicines.find().sort({ price: 1 })

```

* Descending order (highest to lowest):

```
db.medicines.find().sort({ price: -1 })

```

**(g) Sort medicines according to stock:**

* Ascending order (lowest stock first):

```
db.medicines.find().sort({ stock: 1 })

```

* Descending order (highest stock first):

```
db.medicines.find().sort({ stock: -1 })

```

## Part E – Embedded Documents

### Q11. Modify the medicine document structure to include supplier information as an embedded document.

Insert at least three medicines with embedded supplier information:

```
db.medicines.insertMany([
    {
        medicine_id: 401,
        name: "Calcium Tablets",
        category: "Supplement",
        price: 110,
        stock: 50,
        manufacturer: "NutriMed",
        supplier: {
            name: "City Medical Suppliers",
            phone: "9876543210",
            city: "Roorkee"
        }
    },
    {
        medicine_id: 402,
        name: "Cough Syrup",
        category: "Cough Suppressant",
        price: 75,
        stock: 25,
        manufacturer: "MediLife",
        supplier: {
            name: "Health Distributors",
            phone: "9876501234",
            city: "Dehradun"
        }
    },
    {
        medicine_id: 403,
        name: "Antacid Tablets",
        category: "Antacid",
        price: 40,
        stock: 80,
        manufacturer: "ABC Pharma",
        supplier: {
            name: "Prime Pharma Supply",
            phone: "9123456780",
            city: "Haridwar"
        }
    }
])

```

Flask route to retrieve medicines with supplier details:

```
@app.route("/suppliers")
def view_suppliers():
    supplier_medicines = list(medicines.find({"supplier": {"$exists": True}}))
    return render_template("suppliers.html", medicines=supplier_medicines)

```

Create `templates/suppliers.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Medicine Suppliers</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Medicines and Supplier Information</h1>
        {% if medicines %}
        <table>
            <thead>
                <tr>
                    <th>Medicine</th>
                    <th>Medicine ID</th>
                    <th>Supplier Name</th>
                    <th>Phone</th>
                    <th>City</th>
                </tr>
            </thead>
            <tbody>
                {% for medicine in medicines %}
                <tr>
                    <td>{{ medicine.name }}</td>
                    <td>{{ medicine.medicine_id }}</td>
                    <td>{{ medicine.supplier.name }}</td>
                    <td>{{ medicine.supplier.phone }}</td>
                    <td>{{ medicine.supplier.city }}</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
        {% else %}
            <p>No supplier information found.</p>
        {% endif %}
        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

## Part F – Medicine Inventory Report

### Q12. Create a Flask page that displays total number of medicines, total stock, low-stock medicines, most expensive medicine, and cheapest medicine.

Add this route to `app.py`:

```
@app.route("/report")
def inventory_report():
    total_medicines = medicines.count_documents({})
    stock_result = list(medicines.aggregate([
        {"$group": {"_id": None, "total_stock": {"$sum": "$stock"}}}
    ]))
    total_stock = stock_result[0]["total_stock"] if stock_result else 0
    low_stock_medicines = list(medicines.find({"stock": {"$lt": 30}}).sort("stock", 1))
    most_expensive = medicines.find_one(sort=[("price", -1)])
    cheapest = medicines.find_one(sort=[("price", 1)])

    return render_template(
        "report.html",
        total_medicines=total_medicines,
        total_stock=total_stock,
        low_stock_medicines=low_stock_medicines,
        most_expensive=most_expensive,
        cheapest=cheapest
    )

```

Create `templates/report.html`:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Report</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Medicine Inventory Report</h1>
        
        <h2>Inventory Summary</h2>
        <p><strong>Total Number of Medicines:</strong> {{ total_medicines }}</p>
        <p><strong>Total Stock:</strong> {{ total_stock }}</p>

        <h2>Low Stock Medicines (Stock below 30)</h2>
        {% if low_stock_medicines %}
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Stock</th>
                </tr>
            </thead>
            <tbody>
                {% for medicine in low_stock_medicines %}
                <tr>
                    <td>{{ medicine.medicine_id }}</td>
                    <td>{{ medicine.name }}</td>
                    <td class="low-stock">{{ medicine.stock }}</td>
                </tr>
                {% endfor %}
            </tbody>
        </table>
        {% else %}
            <p>No low-stock medicines.</p>
        {% endif %}

        <h2>Most Expensive Medicine</h2>
        {% if most_expensive %}
            <p>{{ most_expensive.name }} – ₹{{ most_expensive.price }}</p>
        {% else %}
            <p>No medicine records available.</p>
        {% endif %}

        <h2>Cheapest Medicine</h2>
        {% if cheapest %}
            <p>{{ cheapest.name }} – ₹{{ cheapest.price }}</p>
        {% else %}
            <p>No medicine records available.</p>
        {% endif %}

        <p><a href="{{ url_for('home') }}">Back to Home</a></p>
    </div>
</body>
</html>

```

## Part G – Complete Mini Application

### Q13. Combine the previous tasks into one working Hospital Medicine Management System.

### 1. Project Structure

```
HospitalMedicineManagement/
│
├── app.py
├── templates/
│   ├── base.html
│   ├── home.html
│   ├── add_medicine.html
│   ├── view_medicines.html
│   ├── search_medicine.html
│   ├── update_stock.html
│   ├── delete_medicine.html
│   ├── low_stock.html
│   ├── report.html
│   └── suppliers.html
│
└── static/
    └── style.css

```

### 2. Flask Application – `app.py`

```
from flask import Flask, render_template, request, redirect, url_for, flash
from pymongo import MongoClient
from pymongo.errors import DuplicateKeyError, PyMongoError

app = Flask(__name__)
app.secret_key = "hospital-medicine-app-secret"

client = MongoClient("mongodb://localhost:27017/", serverSelectionTimeoutMS=5000)
db = client["HospitalDB"]
medicines = db["medicines"]

medicines.create_index("medicine_id", unique=True)

@app.route("/")
def home():
    return render_template("home.html")

@app.route("/add", methods=["GET", "POST"])
def add_medicine():
    if request.method == "POST":
        try:
            medicine = {
                "medicine_id": int(request.form["medicine_id"]),
                "name": request.form["name"].strip(),
                "category": request.form["category"].strip(),
                "price": float(request.form["price"]),
                "stock": int(request.form["stock"]),
                "manufacturer": request.form["manufacturer"].strip()
            }
            if medicine["price"] < 0 or medicine["stock"] < 0:
                flash("Price and stock cannot be negative.")
                return redirect(url_for("add_medicine"))

            medicines.insert_one(medicine)
            flash("Medicine added successfully!")
            return redirect(url_for("view_medicines"))
        except DuplicateKeyError:
            flash("A medicine with this ID already exists.")
        except (ValueError, KeyError):
            flash("Please enter valid medicine details.")
        return redirect(url_for("add_medicine"))

    return render_template("add_medicine.html")

@app.route("/medicines")
def view_medicines():
    all_medicines = list(medicines.find().sort("medicine_id", 1))
    return render_template("view_medicines.html", medicines=all_medicines)

@app.route("/search", methods=["GET", "POST"])
def search_medicine():
    results = []
    searched = False
    if request.method == "POST":
        searched = True
        search_value = request.form.get("search_value", "").strip()
        if search_value:
            if search_value.isdigit():
                med = medicines.find_one({"medicine_id": int(search_value)})
                if med:
                    results = [med]
            else:
                results = list(medicines.find({
                    "name": {"$regex": search_value, "$options": "i"}
                }))
    return render_template("search_medicine.html", medicines=results, searched=searched)

@app.route("/update-stock", methods=["GET", "POST"])
def update_stock():
    updated_medicine = None
    if request.method == "POST":
        try:
            medicine_id = int(request.form["medicine_id"])
            new_stock = int(request.form["new_stock"])
            if new_stock < 0:
                flash("Stock cannot be negative.")
            else:
                res = medicines.update_one(
                    {"medicine_id": medicine_id},
                    {"$set": {"stock": new_stock}}
                )
                if res.matched_count == 0:
                    flash("Medicine not found.")
                else:
                    flash("Stock updated successfully.")
                    updated_medicine = medicines.find_one({"medicine_id": medicine_id})
        except (ValueError, KeyError):
            flash("Enter a valid Medicine ID and stock value.")

    return render_template("update_stock.html", medicine=updated_medicine)

@app.route("/delete", methods=["GET", "POST"])
def delete_medicine():
    if request.method == "POST":
        try:
            medicine_id = int(request.form["medicine_id"])
            res = medicines.delete_one({"medicine_id": medicine_id})
            if res.deleted_count == 1:
                flash("Medicine deleted successfully.")
            else:
                flash("Medicine not found.")
        except (ValueError, KeyError):
            flash("Enter a valid Medicine ID.")

    return render_template("delete_medicine.html")

@app.route("/low-stock")
def low_stock():
    low_stock_meds = list(medicines.find({"stock": {"$lt": 30}}).sort("stock", 1))
    return render_template("low_stock.html", medicines=low_stock_meds)

@app.route("/report")
def inventory_report():
    total_medicines = medicines.count_documents({})
    stock_result = list(medicines.aggregate([
        {"$group": {"_id": None, "total_stock": {"$sum": "$stock"}}}
    ]))
    total_stock = stock_result[0]["total_stock"] if stock_result else 0
    low_stock_meds = list(medicines.find({"stock": {"$lt": 30}}).sort("stock", 1))
    most_expensive = medicines.find_one(sort=[("price", -1)])
    cheapest = medicines.find_one(sort=[("price", 1)])

    return render_template(
        "report.html",
        total_medicines=total_medicines,
        total_stock=total_stock,
        low_stock_medicines=low_stock_meds,
        most_expensive=most_expensive,
        cheapest=cheapest
    )

@app.route("/suppliers")
def view_suppliers():
    supplier_meds = list(medicines.find({"supplier": {"$exists": True}}))
    return render_template("suppliers.html", medicines=supplier_meds)

if __name__ == "__main__":
    app.run(debug=True)

```

### 3. Base Template – `templates/base.html`

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>{% block title %}Hospital Medicine Management{% endblock %}</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Hospital Medicine Management System</h1>
        <nav>
            <a href="{{ url_for('home') }}">Home</a>
            <a href="{{ url_for('add_medicine') }}">Add Medicine</a>
            <a href="{{ url_for('view_medicines') }}">View Medicines</a>
            <a href="{{ url_for('search_medicine') }}">Search</a>
            <a href="{{ url_for('update_stock') }}">Update Stock</a>
            <a href="{{ url_for('delete_medicine') }}">Delete</a>
            <a href="{{ url_for('low_stock') }}">Low Stock</a>
            <a href="{{ url_for('inventory_report') }}">Inventory Report</a>
            <a href="{{ url_for('view_suppliers') }}">Suppliers</a>
        </nav>

        {% with messages = get_flashed_messages() %}
            {% if messages %}
                {% for message in messages %}
                    <div class="message">{{ message }}</div>
                {% endfor %}
            {% endif %}
        {% endwith %}

        {% block content %}{% endblock %}
    </div>
</body>
</html>

```

### 4. Home Page – `templates/home.html`

```
{% extends "base.html" %}

{% block title %}Home{% endblock %}

{% block content %}
<h2>Welcome</h2>
<p>Manage hospital medicine records and inventory using MongoDB.</p>

<div class="menu">
    <a class="button" href="{{ url_for('add_medicine') }}">Add Medicine</a>
    <a class="button" href="{{ url_for('view_medicines') }}">View Medicines</a>
    <a class="button" href="{{ url_for('search_medicine') }}">Search Medicine</a>
    <a class="button" href="{{ url_for('update_stock') }}">Update Stock</a>
    <a class="button" href="{{ url_for('delete_medicine') }}">Delete Medicine</a>
    <a class="button" href="{{ url_for('low_stock') }}">Low Stock</a>
    <a class="button" href="{{ url_for('inventory_report') }}">Inventory Report</a>
    <a class="button" href="{{ url_for('view_suppliers') }}">Supplier Information</a>
</div>
{% endblock %}

```

### 14. Verification Commands

```
use HospitalDB

// View all medicines
db.medicines.find()

// Count medicine records
db.medicines.countDocuments()

// View medicines with stock below 30
db.medicines.find({ stock: { $lt: 30 } })

// View a medicine by ID
db.medicines.findOne({ medicine_id: 301 })

// View medicines containing supplier information
db.medicines.find({ supplier: { $exists: true } })

```