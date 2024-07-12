from flask import Flask, Blueprint, render_template, request, jsonify, json
from PIL import Image
import base64
from pymongo import MongoClient
from bson import ObjectId

from database import Database

app = Flask(__name__)
db = Database()
'''
mod = Blueprint('backend',__name__,template_folder='templates',static_folder='./static')
UPLOAD_URL = 'http://10.0.2.2:5000/static/'
model = load_model("name of model")
model._make_predict_function()
'''

'''
@mod.route(‘/predict’ ,methods=[‘POST’])
def predict():
if request.method == ‘POST’:
# check if the post request has the file part
    if ‘file’ not in request.files:
    return “No file found”
user_file = request.files[‘file’]
temp = request.files[‘file’]
if user_file.filename == ‘’:
    return “file name not found …”
else:
path=os.path.join(os.getcwd()+’\\modules\\static\\’+user_file.filename)
user_file.save(path)
classes = identifyImage(path)
#save image details to database
db.addNewImage(
user_file.filename,
classes[0][0][1],
str(classes[0][0][2]),
datetime.now(),
UPLOAD_URL+user_file.filename)
return jsonify({
“status”:”success”,
“prediction”:classes[0][0][1],
“confidence”:str(classes[0][0][2]),
“upload_time”:datetime.now()
}) '''


@app.route('/enrollment', methods=['POST'])
def check_username():
    username = request.json['username']
    # Non-repeated username
    if db.check_valid_username(username):
        return {'status': 200, "message": "Username is valid"}
    return {'status': 422, "message": "Username already exists"}

@app.route('/enrollment/scan', methods=['POST'])
def enroll_credentials():
    username = request.json['username']
    password = request.json['password']
    leftFingerprintPath = request.json['leftFingerprintPath']
    rightFingerprintPath = request.json['rightFingerprintPath']
    if db.add_user(username, password, leftFingerprintPath, rightFingerprintPath):
        return {'status': 200}
    return {'status': 500}

@app.route('/verification', methods=['POST'])
def verify_credentials():
    username = request.json['username']
    password = request.json['password']
    user = db.get_user(username, password)
    if user:
        return {'status': 200, 'leftFingerprintPath': user['leftFingerprintPath'], 
                'rightFingerprintPath': user['rightFingerprintPath']}
    return {'status': 404, 'message': 'Incorrect username or password'}

@app.route('/verification/scan', methods=['GET'])
def verify_fingerprint():
    pass

@app.route('/processing', methods=['POST'])
def process():
    file = request.files['image']
    
    img = Image.open(file.stream)
    
    data = file.stream.read()
    #data = base64.encodebytes(data)
    data = base64.b64encode(data).decode()   

    return jsonify({
                'msg': 'success', 
                'size': [img.width, img.height], 
                'format': img.format,
                'img': data
           })

if __name__ == '__main__':
    app.run()