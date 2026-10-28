from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("mongodb://localhost:27017/")
db = client["CollegeDB"]
students = db["students"]

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/add", methods=["GET", "POST"])
def add_student():
    if request.method == "POST":
        student = {
            "student_id": int(request.form["student_id"]),
            "name": request.form["name"],
            "age": int(request.form["age"]),
            "gender": request.form["gender"],
            "department": request.form["department"],
            "marks": int(request.form["marks"])
        }
        students.insert_one(student)
        return redirect(url_for("list_students"))
    return render_template("add.html")

@app.route("/students")
def list_students():
    data = list(students.find())
    return render_template("list.html", students=data)

@app.route("/search", methods=["GET", "POST"])
def search_student():
    student = None
    searched = False
    if request.method == "POST":
        searched = True
        student_id = int(request.form["student_id"])
        student = students.find_one({"student_id": student_id})
    return render_template("search.html", student=student, searched=searched)

@app.route("/edit/<int:student_id>", methods=["GET", "POST"])
def edit_student(student_id):
    student = students.find_one({"student_id": student_id})
    if request.method == "POST":
        students.update_one(
            {"student_id": student_id},
            {"$set": {
                "name": request.form["name"],
                "age": int(request.form["age"]),
                "gender": request.form["gender"],
                "department": request.form["department"],
                "marks": int(request.form["marks"])
            }}
        )
        return redirect(url_for("list_students"))
    return render_template("edit.html", student=student)

@app.route("/delete/<int:student_id>")
def delete_student(student_id):
    students.delete_one({"student_id": student_id})
    return redirect(url_for("list_students"))


if __name__ == "__main__":
 app.run(debug=True)
