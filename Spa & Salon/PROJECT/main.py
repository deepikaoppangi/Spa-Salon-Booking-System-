from flask import Flask, render_template, request, flash, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin, LoginManager, login_user, logout_user, login_required, current_user
from flask_mail import Mail
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from sqlalchemy import DateTime
app = Flask(__name__)
app.secret_key = 'spadbms'

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:@localhost/spadbms'
db = SQLAlchemy(app)

# Login Manager configuration
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# Define your slots
allowed_slots = {
    'morning': {'start': 10, 'end': 12},
    'afternoon': {'start': 12, 'end': 17},
    'night': {'start': 18, 'end': 22}
}

# SMTP Mail Server configuration
app.config.update(
    MAIL_SERVER='smtp.gmail.com',
    MAIL_PORT='465',
    MAIL_USE_SSL=True,
    MAIL_USERNAME="poojita.1@iitj.ac.in",
    MAIL_PASSWORD="Dinesh@2003"
)
mail = Mail(app)

# User model for login
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    username = db.Column(db.String(50), nullable=False)
    usertype = db.Column(db.String(50), nullable=False)
    email = db.Column(db.String(50), unique=True, nullable=False)
    password = db.Column(db.String(1000), nullable=False)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Stylists model
class Stylists(db.Model):
    sid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(50), unique=True, nullable=False)
    stylist_name = db.Column(db.String(50), nullable=False)
    service_offered = db.Column(db.String(100), nullable=False)

# Customers model
class Customers(db.Model):
    cid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(50), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    gender = db.Column(db.String(50), nullable=False)
    slot = db.Column(db.String(50), nullable=False)
    service = db.Column(db.String(100), nullable=False)  # Changed from 'disease' to 'service'
    time = db.Column(db.String(5), nullable=False)
    date = db.Column(db.String(50), nullable=False)
    department = db.Column(db.String(50), nullable=False)
    number = db.Column(db.String(50), nullable=False)
    
# Trigr model
class Trigr(db.Model):
    tid = db.Column(db.Integer, primary_key=True, autoincrement=True)
    cid = db.Column(db.Integer, nullable=False)
    email = db.Column(db.String(50), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    action = db.Column(db.String(50), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)

# Main route
@app.route('/')
def index():
    return render_template('index.html')

# Route for stylists
@app.route('/stylists', methods=['POST', 'GET'])
def stylists():
    if request.method == "POST":
        email = request.form.get('email')
        stylist_name = request.form.get('stylist_name')
        service_offered = request.form.get('service_offered')

        query = Stylists(email=email, stylist_name=stylist_name, service_offered=service_offered)
        db.session.add(query)
        db.session.commit()
        flash("Information is Stored", "primary")

        # Redirect to the stylist_booking page after storing the information
        return redirect(url_for('stylist_booking'))

    return render_template('stylists.html')
# Route for customers
@app.route('/customers', methods=['POST', 'GET'])
@login_required
def customers():
    services = [
        "Deep Tissue Massage", "Reflexology", "Mud Wrap", "Manicure", "Pedicure", "Facial Treatment",
        "Swedish Massage", "Aromatherapy", "Hot Stone Massage", "Body Scrub", "Haircut", "Hair Coloring",
        "Hair Styling", "Manicure-Pedicure Combo", "Waxing", "Makeup Application", "Eyelash Extensions",
        "Body Massage", "Foot Massage", "Nail Art"
    ]

    departments = ["Spa", "Salon"]

    allowed_slots = {
        'morning': {'start': 10, 'end': 12},
        'afternoon': {'start': 12, 'end': 18},
        'night': {'start': 18, 'end': 22}
    }

    if request.method == "POST":
        email = request.form.get('email')
        name = request.form.get('name')
        gender = request.form.get('gender')
        slot = request.form.get('slot')
        service = request.form.get('service')
        # time = int(request.form.get('time').split(':')[0])
        time=request.form.get('time')
        
        date = request.form.get('date')
        department = request.form.get('department')
        number = request.form.get('number')
        subject = "Booking Confirmation - SPA & SALON MANAGEMENT SYSTEM"
        if len(number) != 10:
            flash("Please provide a 10-digit phone number", "danger")
            return render_template('customer.html', services=services, departments=departments)

        # Check if the selected slot is allowed
        if slot in allowed_slots and allowed_slots[slot]['start'] <= int(time.split(':')[0]) <= allowed_slots[slot]['end']:
            # Check for existing bookings with the same date, service, department, and slot
            existing_booking = Customers.query.filter(
                Customers.date == date,
                Customers.service == service,
                Customers.department == department,
                Customers.slot == slot,
                Customers.time == time
            ).all()
            
            if existing_booking:
                flash("This slot is already booked,  Please choose another date, service, department, or slot.", "danger")
            else:
                # Check for time conflict within a 45-minute time span
                hour_part = int(time.split(':')[0])

                time_conflict = any(
                    abs(existing_book.time.seconds // 3600 - hour_part) < 1 and
                    abs(existing_book.time.seconds % 3600 // 60 - int(time.split(':')[1])) < 45
                    for existing_book in Customers.query.filter(
                        Customers.date == date,
                        Customers.department == department,
                        Customers.slot == slot
                    ).all()
                )

                if time_conflict:
                    flash('The selected slot is already booked. Please choose another time.', 'danger')
                else:
                    # No duplicate entry and no time conflict, save to the database
                    new_booking = Customers(
                        email=email, name=name, gender=gender, slot=slot, service=service,
                        time=time, date=date, department=department, number=number
                    )
                    db.session.add(new_booking)
                    db.session.commit()

                    # Send confirmation email
                    params = {
                        "gmail-user": "poojita.1@iitj.ac.in",
                        "gmail-password": "Dinesh@2003"
                    }
                    message_body = f"Dear {name},\n\n"\
                        "We are delighted to confirm your booking with SPA & SALON MANAGEMENT SYSTEM. Thank you for choosing our services.\n"\
                        "Below are the details of your booking:\n\n"\
                        f"Name: {name}\n"\
                        f"Slot: {slot}\n"\
                        f"Date: {date}\n"\
                        f"Service: {service}\n"\
                        f"Time: {time}\n"\
                        f"Department: {department}\n"\
                        f"Contact Number: {number}\n\n"\
                        "If you have any questions or need further assistance, feel free to reach out to us. We look forward to providing you with a relaxing and enjoyable experience at our spa and salon.\n\n"\
                        "Best regards,\n"\
                        "SPA & SALON MANAGEMENT SYSTEM Team"

                    mail.send_message(subject, sender=params['gmail-user'], recipients=[email], body=message_body)

                    flash("Booking Confirmed", "info")
        else:
            flash("Invalid booking time for the selected slot. Please choose a valid time.", "danger")

    return render_template('customer.html', services=services, departments=departments)
                        
@app.route('/booking', methods=['GET', 'POST'])
@login_required
def booking():
    if request.method == 'POST':
        # Get form data
        email = request.form.get('email')
        name = request.form.get('name')
        gender = request.form.get('gender')
        slot = request.form.get('slot')
        date = request.form.get('date')
        time = int(request.form.get('time').split(':')[0])
        department = request.form.get('department')
        number = request.form.get('number')
        service = request.form.get('service')

        # Check if the selected slot is allowed
        if slot in allowed_slots and allowed_slots[slot]['start'] <= int(time.split(':')[0]) <= allowed_slots[slot]['end']:
            # Check for existing bookings with the same date, time, service, department, and slot
            existing_booking = Customers.query.filter_by(
                date=date,
                # time=time,
                # time=request.form.get('time'),
                time = int(request.form.get('time').split(':')[0]),
                department=department,
                service=service,
                slot=slot
            ).first()

            if existing_booking:
                flash('Duplicate entry. Please choose another date, time, service, department, or slot.', 'danger')
            else:
                # Save to the database
                new_customer = Customers(
                    email=email,
                    name=name,
                    gender=gender,
                    slot=slot,
                    date=date,
                    # time=time,
                    # time=request.form.get('time'),
                    time = int(request.form.get('time').split(':')[0]),
                    department=department,
                    service=service,
                    number=number
                )
                db.session.add(new_customer)
                db.session.commit()
                flash('Appointment booked successfully!', 'success')

        # Fetch bookings from the database
        bookings = Customers.query.all()

        return render_template('booking.html', query=bookings)

    # If the request method is GET, simply fetch bookings from the database
    bookings = Customers.query.all()

    return render_template('booking.html', query=bookings)

@app.route('/stylist_booking')
@login_required
def stylist_booking():
    if current_user.usertype == "Stylist":
        # Fetch stylist information
        stylist = Stylists.query.filter_by(email=current_user.email).first()

        # Fetch customers booked with this stylist
        customers = Customers.query.filter_by(service=stylist.service_offered).all()

        return render_template('stylist_booking.html', stylist=stylist, customers=customers)
    else:
        flash("You are not authorized to access stylist booking page", "danger")
        return redirect(url_for('index'))

# Route for editing appointments
@app.route("/edit/<string:pid>", methods=['POST','GET'])
@login_required
def edit(pid):    
    if request.method == "POST":
        email = request.form.get('email')
        name = request.form.get('name')
        gender = request.form.get('gender')
        slot = request.form.get('slot')
        service = request.form.get('service')  # Change 'disease' to 'service'
        time = request.form.get('time')
        date = request.form.get('date')
        department = request.form.get('department')
        number = request.form.get('number')
        
        post = Customers.query.filter_by(cid=pid).first()
        post.email = email
        post.name = name
        post.gender = gender
        post.slot = slot
        post.service = service
        post.time = time
        post.date = date
        post.department = department
        post.number = number
        db.session.commit()

        flash("Appointment Updated", "success")
        return redirect('/booking')
        
    post = Customers.query.filter_by(cid=pid).first()
    return render_template('edit.html', posts=post)

# Route for deleting appointments
@app.route("/delete/<string:pid>", methods=['POST','GET'])
@login_required
def delete(pid):
    query = Customers.query.filter_by(cid=pid).first()
    db.session.delete(query)
    db.session.commit()
    flash("Appointment Deleted Successfully", "danger")
    return redirect('/booking')

@app.route('/signup', methods=['POST', 'GET'])
def signup():
    if request.method == "POST":
        username = request.form.get('username')
        usertype = request.form.get('usertype')
        email = request.form.get('email')
        password = request.form.get('password')
        user = User.query.filter_by(email=email).first()
        encpassword = generate_password_hash(password)
        if user:
            flash("Email Already Exists", "warning")
            return render_template('signup.html')

        new_user = User(username=username, usertype=usertype, email=email, password=encpassword)
        db.session.add(new_user)
        db.session.commit()
        flash("Signup Successful! Please Login", "success")
        return render_template('login.html')

    return render_template('signup.html')

# Route for logging in
@app.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == "POST":
        email = request.form.get('email')
        password = request.form.get('password')
        user = User.query.filter_by(email=email).first()

        if user and check_password_hash(user.password, password):
            login_user(user)
            flash("Login Successful", "primary")
            return redirect(url_for('index'))
        else:
            flash("Invalid Credentials", "danger")
            return render_template('login.html')

    return render_template('login.html')

# Route for logging out
@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Logout Successful", "warning")
    return redirect(url_for('login'))

# Route for testing the database connection
@app.route('/test')
def test():
    try:
        User.query.all()
        return 'My database is connected'
    except:
        return 'My db is not connected'

# Route for viewing details
@app.route('/details')
@login_required
def details():
    posts = Trigr.query.all()
    return render_template('triggers.html', posts=posts)
# Route for searching for stylists
@app.route('/search', methods=['POST', 'GET'])
@login_required
def search():
    if request.method == "POST":
        query = request.form.get('search')
        stylist_by_service = Stylists.query.filter_by(service_offered=query).first()
        stylist_by_name = Stylists.query.filter_by(stylist_name=query).first()

        if stylist_by_service or stylist_by_name:
            flash("Stylist is Available", "info")
        else:
            flash("Stylist is Not Available", "danger")

    return render_template('index.html')
# if __name__ == "__main__":
#     db.create_all()
#     app.run(debug=True)
app.run(debug=True)    