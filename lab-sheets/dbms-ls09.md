
# Database Technologies Lab – Sheet 09
## Student Record Management System
**Course Code:** MCA105P  
**Technologies:** MongoDB, Python, Flask, PyMongo, HTML and CSS

---

## Q1. Install and configure Python, Flask, PyMongo, MongoDB, and MongoDB Compass or MongoDB Shell. Verify Flask and PyMongo imports.

Install the required Python packages:

```bash
pip install flask pymongo
```

Create `test_setup.py`:

```python
import flask
import pymongo

print("Flask imported successfully!")
print("PyMongo imported successfully!")
print("Environment setup completed.")
```

Run:

```bash
python test_setup.py
```

**Expected output:**

```text
Flask imported successfully!
PyMongo imported successfully!
Environment setup completed.
```

---

## Q2. Create CollegeDB and the students collection. Insert at least five student documents and verify them.

Create `insert_students.py`:

```python
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["CollegeDB"]
students = db["students"]

student_data = [
    {"student_id": 101, "name": "Aman Sharma", "age": 21, "gender": "Male", "department": "MCA", "marks": 85},
    {"student_id": 102, "name": "Priya Singh", "age": 22, "gender": "Female", "department": "BCA", "marks": 78},
    {"student_id": 103, "name": "Rahul Verma", "age": 20, "gender": "Male", "department": "MCA", "marks": 92},
    {"student_id": 104, "name": "Neha Gupta", "age": 23, "gender": "Female", "department": "BBA", "marks": 68},
    {"student_id": 105, "name": "Karan Mehta", "age": 19, "gender": "Male", "department": "BCA", "marks": 74}
]

# Upsert avoids inserting duplicate student IDs when this script is rerun.
for student in student_data:
    students.update_one(
        {"student_id": student["student_id"]},
        {"$set": student},
        upsert=True
    )

print("Student documents inserted successfully.")

for student in students.find({}, {"_id": 0}):
    print(student)

client.close()
```

Run `python insert_students.py`.

**Verification in MongoDB Shell:**

```javascript
use CollegeDB
db.students.find()
```

---

## Q3. Create an HTML student registration form.

Create `templates/add_student.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Student Registration Form</h1>
        <form action="/add" method="POST">
            <label>Student ID</label>
            <input type="number" name="student_id" required>

            <label>Student Name</label>
            <input type="text" name="name" required>

            <label>Age</label>
            <input type="number" name="age" min="1" required>

            <label>Gender</label>
            <select name="gender" required>
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>

            <label>Department</label>
            <input type="text" name="department" required>

            <label>Marks</label>
            <input type="number" name="marks" min="0" max="100" required>

            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
```

---

## Q4. Create a CSS file to style the student registration page.

Create `static/style.css`:

```css
* {
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f2f4f8;
    margin: 0;
    padding: 30px;
}

.container {
    max-width: 600px;
    margin: 20px auto;
    padding: 25px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h1 {
    text-align: center;
    color: #263b5e;
}

label {
    display: block;
    margin-top: 15px;
    margin-bottom: 6px;
    font-weight: bold;
}

input, select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

button {
    width: 100%;
    margin-top: 20px;
    padding: 12px;
    background-color: #263b5e;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #172943;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: white;
}

th, td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}

th {
    background-color: #263b5e;
    color: white;
}
```

---

## Q5. Create a Flask application that connects to CollegeDB and accesses the students collection.

Create `app.py`:

```python
from flask import Flask
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

app = Flask(__name__)

try:
    client = MongoClient(
        "mongodb://localhost:27017/",
        serverSelectionTimeoutMS=5000
    )
    client.admin.command("ping")
    db = client["CollegeDB"]
    students = db["students"]
    print("Successfully connected to MongoDB!")
except ConnectionFailure:
    print("Could not connect to MongoDB.")
    raise

@app.route("/")
def home():
    return "Student Record Management System - MongoDB Connected!"

if __name__ == "__main__":
    app.run(debug=True)
```

Run `python app.py` and open `http://127.0.0.1:5000/`.

---

## Q6. Connect the HTML form with Flask and insert submitted student information into MongoDB.

Add this route to `app.py`:

```python
from flask import request, render_template

@app.route("/add", methods=["GET", "POST"])
def add_student():
    if request.method == "POST":
        student = {
            "student_id": int(request.form["student_id"]),
            "name": request.form["name"],
            "age": int(request.form["age"]),
            "gender": request.form["gender"],
            "department": request.form["department"],
            "marks": float(request.form["marks"])
        }

        students.insert_one(student)
        return "Student added successfully!"

    return render_template("add_student.html")
```

Verify the inserted document in MongoDB Shell:

```javascript
use CollegeDB
db.students.find()
```

---

## Q7. Retrieve all student documents and display them in an HTML table.

Add this route to `app.py`:

```python
@app.route("/students")
def view_students():
    all_students = list(
        students.find({}, {"_id": 0}).sort("student_id", 1)
    )
    return render_template("students.html", students=all_students)
```

Create `templates/students.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>All Students</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Student Records</h1>
        <table>
            <tr>
                <th>Student ID</th>
                <th>Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Department</th>
                <th>Marks</th>
            </tr>
            {% for student in students %}
            <tr>
                <td>{{ student.student_id }}</td>
                <td>{{ student.name }}</td>
                <td>{{ student.age }}</td>
                <td>{{ student.gender }}</td>
                <td>{{ student.department }}</td>
                <td>{{ student.marks }}</td>
            </tr>
            {% endfor %}
        </table>
    </div>
</body>
</html>
```

Open `http://127.0.0.1:5000/students`.

---

## Q8. Create a search facility using Student ID and handle records that do not exist.

Add this route to `app.py`:

```python
@app.route("/search", methods=["GET", "POST"])
def search_student():
    student = None
    message = ""

    if request.method == "POST":
        student_id = int(request.form["student_id"])
        student = students.find_one(
            {"student_id": student_id},
            {"_id": 0}
        )

        if student is None:
            message = "Student not found."

    return render_template(
        "search.html",
        student=student,
        message=message
    )
```

Create `templates/search.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Search Student</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Search Student</h1>
        <form method="POST">
            <label>Enter Student ID</label>
            <input type="number" name="student_id" required>
            <button type="submit">Search</button>
        </form>

        <p>{{ message }}</p>

        {% if student %}
            <h2>Student Details</h2>
            <p>Student ID: {{ student.student_id }}</p>
            <p>Name: {{ student.name }}</p>
            <p>Age: {{ student.age }}</p>
            <p>Gender: {{ student.gender }}</p>
            <p>Department: {{ student.department }}</p>
            <p>Marks: {{ student.marks }}</p>
        {% endif %}
    </div>
</body>
</html>
```

---

## Q9. Create an update facility for Name, Age, Department, and Marks.

Add this route to `app.py`:

```python
@app.route("/update", methods=["GET", "POST"])
def update_student():
    message = ""

    if request.method == "POST":
        student_id = int(request.form["student_id"])

        result = students.update_one(
            {"student_id": student_id},
            {
                "$set": {
                    "name": request.form["name"],
                    "age": int(request.form["age"]),
                    "department": request.form["department"],
                    "marks": float(request.form["marks"])
                }
            }
        )

        if result.matched_count > 0:
            message = "Student updated successfully."
        else:
            message = "Student not found."

    return render_template("update.html", message=message)
```

Create `templates/update.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Update Student</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Update Student</h1>
        <form method="POST">
            <label>Student ID</label>
            <input type="number" name="student_id" required>

            <label>New Name</label>
            <input type="text" name="name" required>

            <label>New Age</label>
            <input type="number" name="age" min="1" required>

            <label>New Department</label>
            <input type="text" name="department" required>

            <label>New Marks</label>
            <input type="number" name="marks" min="0" max="100" required>

            <button type="submit">Update Student</button>
        </form>
        <p>{{ message }}</p>
    </div>
</body>
</html>
```

Verify the updated document:

```javascript
db.students.findOne({ student_id: 101 })
```

---

## Q10. Create a delete facility that accepts a Student ID and removes the corresponding document.

Add this route to `app.py`:

```python
@app.route("/delete", methods=["GET", "POST"])
def delete_student():
    message = ""

    if request.method == "POST":
        student_id = int(request.form["student_id"])
        result = students.delete_one({"student_id": student_id})

        if result.deleted_count > 0:
            message = "Student deleted successfully."
        else:
            message = "Student not found."

    return render_template("delete.html", message=message)
```

Create `templates/delete.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Delete Student</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Delete Student</h1>
        <form method="POST">
            <label>Enter Student ID</label>
            <input type="number" name="student_id" required>
            <button type="submit">Delete Student</button>
        </form>
        <p>{{ message }}</p>
    </div>
</body>
</html>
```

---

## Q11. Create MongoDB queries for department, marks greater than 75, marks between 50 and 80, and age greater than 20. Display the results through Flask.

Add this route to `app.py`:

```python
@app.route("/filters")
def filter_students():
    department_students = list(
        students.find({"department": "MCA"}, {"_id": 0})
    )

    high_marks_students = list(
        students.find({"marks": {"$gt": 75}}, {"_id": 0})
    )

    marks_range_students = list(
        students.find(
            {"marks": {"$gte": 50, "$lte": 80}},
            {"_id": 0}
        )
    )

    older_students = list(
        students.find({"age": {"$gt": 20}}, {"_id": 0})
    )

    return render_template(
        "filters.html",
        department_students=department_students,
        high_marks_students=high_marks_students,
        marks_range_students=marks_range_students,
        older_students=older_students
    )
```

Create `templates/filters.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Student Filters</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="container">
        <h1>Student Filter Results</h1>

        <h2>Students in MCA Department</h2>
        {% for s in department_students %}
            <p>{{ s.name }} - {{ s.department }}</p>
        {% else %}
            <p>No matching students.</p>
        {% endfor %}

        <h2>Students with Marks Greater Than 75</h2>
        {% for s in high_marks_students %}
            <p>{{ s.name }} - {{ s.marks }}</p>
        {% else %}
            <p>No matching students.</p>
        {% endfor %}

        <h2>Students with Marks Between 50 and 80</h2>
        {% for s in marks_range_students %}
            <p>{{ s.name }} - {{ s.marks }}</p>
        {% else %}
            <p>No matching students.</p>
        {% endfor %}

        <h2>Students Older Than 20</h2>
        {% for s in older_students %}
            <p>{{ s.name }} - {{ s.age }}</p>
        {% else %}
            <p>No matching students.</p>
        {% endfor %}
    </div>
</body>
</html>
```

---

## Q12. Combine the previous tasks into one working Student Record Management System.

The following is a compact integrated Flask application. It provides Add, View, Search, Update, Delete, and Filter features in one application. It uses inline HTML for the integrated demonstration; Q3 and Q4 separately demonstrate HTML templates and CSS.

Create `app.py`:

```python
from flask import Flask, request, render_template_string
from pymongo import MongoClient

app = Flask(__name__)

# Connect to MongoDB
client = MongoClient(
    "mongodb://localhost:27017/",
    serverSelectionTimeoutMS=5000
)
client.admin.command("ping")

db = client["CollegeDB"]
students = db["students"]
students.create_index("student_id", unique=True)

# Common page layout
LAYOUT = """
<!DOCTYPE html>
<html>
<head>
    <title>Student Record Management System</title>
    <style>
        body { font-family: Arial; background: #f2f4f8; margin: 30px; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 25px; }
        h1, h2 { color: #263b5e; }
        nav a { margin-right: 12px; }
        input { display: block; width: 100%; padding: 9px; margin: 8px 0 15px; box-sizing: border-box; }
        button { padding: 10px 18px; background: #263b5e; color: white; border: 0; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 9px; text-align: left; }
        th { background: #263b5e; color: white; }
    </style>
</head>
<body>
<div class="container">
    <h1>Student Record Management System</h1>
    <nav>
        <a href="/">Home</a>
        <a href="/add">Add Student</a>
        <a href="/students">View Students</a>
        <a href="/search">Search Student</a>
        <a href="/update">Update Student</a>
        <a href="/delete">Delete Student</a>
        <a href="/filters">Filters</a>
    </nav>
    <hr>
    {{ content|safe }}
</div>
</body>
</html>
"""

def show_page(content):
    return render_template_string(LAYOUT, content=content)

@app.route("/")
def home():
    return show_page("<h2>Welcome</h2><p>Manage student records using the navigation links.</p>")

@app.route("/add", methods=["GET", "POST"])
def add_student():
    message = ""
    if request.method == "POST":
        record = {
            "student_id": int(request.form["student_id"]),
            "name": request.form["name"],
            "age": int(request.form["age"]),
            "gender": request.form["gender"],
            "department": request.form["department"],
            "marks": float(request.form["marks"])
        }
        try:
            students.insert_one(record)
            message = "Student added successfully."
        except Exception:
            message = "Could not add student. The Student ID may already exist."

    content = """
    <h2>Add Student</h2>
    <form method="POST">
        <label>Student ID</label><input type="number" name="student_id" required>
        <label>Name</label><input type="text" name="name" required>
        <label>Age</label><input type="number" name="age" min="1" required>
        <label>Gender</label>
        <select name="gender">
            <option>Male</option><option>Female</option><option>Other</option>
        </select>
        <label>Department</label><input type="text" name="department" required>
        <label>Marks</label><input type="number" name="marks" min="0" max="100" required>
        <button type="submit">Add Student</button>
    </form>
    """
    return show_page(content + f"<p>{message}</p>")

@app.route("/students")
def view_students():
    records = students.find({}, {"_id": 0}).sort("student_id", 1)
    rows = ""
    for s in records:
        rows += (
            f"<tr><td>{s.get('student_id')}</td><td>{s.get('name')}</td>"
            f"<td>{s.get('age')}</td><td>{s.get('gender')}</td>"
            f"<td>{s.get('department')}</td><td>{s.get('marks')}</td></tr>"
        )

    content = """
    <h2>All Students</h2>
    <table>
        <tr><th>Student ID</th><th>Name</th><th>Age</th>
        <th>Gender</th><th>Department</th><th>Marks</th></tr>
    """ + rows + "</table>"
    return show_page(content)

@app.route("/search", methods=["GET", "POST"])
def search_student():
    result = ""
    if request.method == "POST":
        record = students.find_one(
            {"student_id": int(request.form["student_id"])},
            {"_id": 0}
        )
        if record:
            result = "<h3>Student Details</h3>" + "".join(
                f"<p><b>{key}:</b> {value}</p>"
                for key, value in record.items()
            )
        else:
            result = "<p>Student not found.</p>"

    content = """
    <h2>Search Student</h2>
    <form method="POST">
        <label>Student ID</label>
        <input type="number" name="student_id" required>
        <button type="submit">Search</button>
    </form>
    """
    return show_page(content + result)

@app.route("/update", methods=["GET", "POST"])
def update_student():
    message = ""
    if request.method == "POST":
        result = students.update_one(
            {"student_id": int(request.form["student_id"])},
            {"$set": {
                "name": request.form["name"],
                "age": int(request.form["age"]),
                "department": request.form["department"],
                "marks": float(request.form["marks"])
            }}
        )
        message = "Student updated successfully." if result.matched_count else "Student not found."

    content = """
    <h2>Update Student</h2>
    <form method="POST">
        <label>Student ID</label><input type="number" name="student_id" required>
        <label>New Name</label><input type="text" name="name" required>
        <label>New Age</label><input type="number" name="age" min="1" required>
        <label>New Department</label><input type="text" name="department" required>
        <label>New Marks</label><input type="number" name="marks" min="0" max="100" required>
        <button type="submit">Update Student</button>
    </form>
    """
    return show_page(content + f"<p>{message}</p>")

@app.route("/delete", methods=["GET", "POST"])
def delete_student():
    message = ""
    if request.method == "POST":
        result = students.delete_one(
            {"student_id": int(request.form["student_id"])}
        )
        message = "Student deleted successfully." if result.deleted_count else "Student not found."

    content = """
    <h2>Delete Student</h2>
    <form method="POST">
        <label>Student ID</label>
        <input type="number" name="student_id" required>
        <button type="submit">Delete Student</button>
    </form>
    """
    return show_page(content + f"<p>{message}</p>")

@app.route("/filters")
def filter_students():
    department = list(students.find({"department": "MCA"}, {"_id": 0}))
    high_marks = list(students.find({"marks": {"$gt": 75}}, {"_id": 0}))
    marks_range = list(students.find(
        {"marks": {"$gte": 50, "$lte": 80}}, {"_id": 0}
    ))
    older = list(students.find({"age": {"$gt": 20}}, {"_id": 0}))

    def format_records(records):
        if not records:
            return "<p>No matching students.</p>"
        return "<ul>" + "".join(
            f"<li>{s['name']} (ID: {s['student_id']})</li>"
            for s in records
        ) + "</ul>"

    content = (
        "<h2>Student Filters</h2>"
        "<h3>MCA Department</h3>" + format_records(department) +
        "<h3>Marks Greater Than 75</h3>" + format_records(high_marks) +
        "<h3>Marks Between 50 and 80</h3>" + format_records(marks_range) +
        "<h3>Age Greater Than 20</h3>" + format_records(older)
    )
    return show_page(content)

if __name__ == "__main__":
    print("Successfully connected to MongoDB!")
    app.run(debug=True)
```

Run the application:

```bash
python app.py
```

Open `http://127.0.0.1:5000/` in a web browser.

**Features:** Add Student, View Students, Search Student, Update Student, Delete Student, and Filter Students.

---

## Learning Outcome

The Student Record Management System demonstrates how MongoDB stores student information as documents and how Python Flask and PyMongo perform CRUD operations. It also demonstrates searching, updating, deleting, filtering, and displaying student records through a web application.
