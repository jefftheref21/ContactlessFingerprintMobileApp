from pymongo import MongoClient
from bson import ObjectId

class Database():
    def __init__(self) -> None:
        self.client = MongoClient("mongodb://localhost:27017")
        self.db = self.client['fingerprints']
        self.collection = self.db['users']

    def check_valid_username(self, username):
        user = self.collection.find_one({"username": username})
        if user is None:
            return True
        return False

    def add_user(self, username, password, leftFingerprintPath, rightFingerprintPath):
        post = {"username": username, "password": password,
                "leftFingerprintPath": leftFingerprintPath, "rightFingerprintPath": rightFingerprintPath}
        self.collection.insert_one(post)
        return True
    
    def get_user(self, username, password):
        user = self.collection.find_one({"username": username, "password": password})
        print(user)
        return user
    
    def get_all_users(self):
        users = self.collection.find()
        return users
    
    def delete_user(self, username):
        self.collection.delete_one({"username": username})
        return True
    
    def update_user(self, username, password, fingerprint1, fingerprint2):
        self.collection.update_one({"username": username}, {"$set": {"password": password, "fingerprint1": fingerprint1, "fingerprint2": fingerprint2}})
        return True

    