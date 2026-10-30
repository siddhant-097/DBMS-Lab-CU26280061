from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient("mongodb://localhost:27017/")
db = client["HospitalDB"]
medicines = db["medicines"]

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/add", methods=["GET", "POST"])
def add_medicine():
    if request.method == "POST":
        medicine = {
            "medicine_id": int(request.form["medicine_id"]),
            "name": request.form["name"],
            "category": request.form["category"],
            "price": float(request.form["price"]),
            "stock": int(request.form["stock"]),
            "manufacturer": request.form["manufacturer"]
        }
        medicines.insert_one(medicine)
        return redirect(url_for("list_medicines"))
    return render_template("add.html")

@app.route("/medicines")
def list_medicines():
    data = list(medicines.find())
    return render_template("list.html", medicines=data)

@app.route("/search", methods=["GET", "POST"])
def search_medicine():
    result = None
    searched = False
    if request.method == "POST":
        searched = True
        result = medicines.find_one({
            "medicine_id": int(request.form["medicine_id"])
        })
    return render_template("search.html", medicine=result, searched=searched)

@app.route("/edit/<int:medicine_id>", methods=["GET", "POST"])
def edit_medicine(medicine_id):
    medicine = medicines.find_one({"medicine_id": medicine_id})
    if request.method == "POST":
        medicines.update_one(
            {"medicine_id": medicine_id},
            {"$set": {"stock": int(request.form["stock"])}}
        )
        return redirect(url_for("list_medicines"))
    return render_template("edit.html", medicine=medicine)

@app.route("/delete/<int:medicine_id>")
def delete_medicine(medicine_id):
    medicines.delete_one({"medicine_id": medicine_id})
    return redirect(url_for("list_medicines"))

@app.route("/low-stock")
def low_stock():
    data = list(medicines.find({"stock": {"$lt": 30}}))
    return render_template("low_stock.html", medicines=data)

@app.route("/report")
def report():
    total_medicines = medicines.count_documents({})
    all_medicines = list(medicines.find())
    total_stock = sum(m["stock"] for m in all_medicines) if all_medicines else 0
    low_stock_count = medicines.count_documents({"stock": {"$lt": 30}})
    most_expensive = medicines.find_one(sort=[("price", -1)])
    cheapest = medicines.find_one(sort=[("price", 1)])
    return render_template(
        "report.html",
        total_medicines=total_medicines,
        total_stock=total_stock,
        low_stock_count=low_stock_count,
        most_expensive=most_expensive,
        cheapest=cheapest
    )

if __name__ == "__main__":
 app.run(debug=True) 
