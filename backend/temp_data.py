import pymongo
from pymongo import MongoClient
# from dotenv import load_dotenv, find_dotenv
import os

import json
# from databasedelete import databasedeletehelper
from bson import ObjectId


# class JSONEncoder(json.JSONEncoder):
#     def default(self, o):
#         if isinstance(o, ObjectId):
#             return str(o)
#         return json.JSONEncoder.default(self, o)

class Database:
    base_address = "/home/easgrad/suryavee/images/json/"
    def __init__(self) -> None:
        # load_dotenv()
        # self._collection_name = "CAPTURE_DATA"
        # MONGO_DB_PASSWORD = os.environ.get("MONGO_DB_PASSWORD")
        # print(MONGO_DB_PASSWORD)
        # # client = pymongo.MongoClient(connecction_string)

        # client = pymongo.MongoClient(uri, server_api=pymongo.server_api.ServerApi('1'))

        # try:
        #     client.admin.command('ping')
        #     print("Pinged your deployment. You successfully connected to MongoDB!")
        # except Exception as e:
        #     print(e)

        # self.db = client.FP_APP_DATABASE
        # collections = self.db.list_collection_names()
        # print(collections)
        # if collections.__contains__(self._collection_name):
        #     print(collections)
        # else:
        #     print("creating collection:",self._collection_name)
        #     self.db.create_collection(self._collection_name)

        print("__init__")

    def saveImages(self,data):
        # print(type(data),data)
        # JSONEncoder().encode(data)

        # capturedata = self.db[self._collection_name]
        # capturedata.insert_one(data)
        # self.file_id_ = self.fs.put(data)
        if(data["type"] == "Enroll"):
            file_name = self.base_address+data["personid"]+'.json'
            print("Enroll Data Saved")
        elif(data["type"] == "Verify"):
            file_name = self.base_address+data["sessionid"]+'.json'
            print("Verify Data Saved")
        with open(file_name, "w") as outfile:
            json.dump(data, outfile)
        return True
        

    # def getImages(self,sessionid):
    #     print('getImages called for sessionId:',sessionid)
    #     try:
    #         capturedata = self.db[self._collection_name]
    #         data = capturedata.find_one({'sessionid': sessionid})
    #         # data = self.fs.get(self.file_id_)
    #         print(data.keys())
    #         return data
    #     except Exception as e:
    #         print("Exception retrieving data in DB",e)

    def getImages(self,personId):
        print('getImages called for personId:',personId)
        try:
            # capturedata = self.db[self._collection_name]
            # data = capturedata.find_one({'personid': personId, 'type': 'Enroll'})
            # data = self.fs.get(self.file_id_)
            with open(self.base_address+personId+'.json', 'r') as openfile:
 
                data = json.load(openfile)
            # print(data.keys())
            return data
        except Exception as e:
            print("Exception retrieving data in DB",e)
    
    def getImagesfromSession(self,sessionid):
        print('getImages called for sessionId:',sessionid)
        try:
            # capturedata = self.db[self._collection_name]
            # data = capturedata.find_one({'sessionid': sessionid})
            # data = self.fs.get(self.file_id_)
            with open(self.base_address+sessionid+'.json', 'r') as openfile:
 
                data = json.load(openfile)
            # print(data.keys())
            return data
        except Exception as e:
            print("Exception retrieving data in DB",e)

    def updateImages(self,sessionid,data):
        # print(data.keys())
        try:
            # capturedata = self.db[self._collection_name]
            # print("before update:",capturedata.find_one({'sessionid': sessionid}))
            # capturedata.find_one_and_update({'sessionid': sessionid},{ '$set': data })
            if(data["type"] == "Enroll"):
                file_name = self.base_address+data["personid"]+'.json'
                print("Enroll Data Saved")
            elif(data["type"] == "Verify"):
                file_name = self.base_address+data["sessionid"]+'.json'
                print("Verify Data Saved")
            with open(file_name, "w") as outfile:
                json.dump(data, outfile)

            # print("after update:",capturedata.find_one({'sessionid': sessionid}))
        except Exception as e:
            print("Exception updating data in DB",e)

    def deleteImages(self,sessionid):
        print("Deleting:",sessionid)
        try:
            sessiondata = self.getImagesfromSession(sessionid)
            if sessiondata:
                personid = sessiondata.get('personid',None)
            else:
                personid = sessionid
            if personid:
                databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/",pattern=personid)
                databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/enroll/",pattern=personid)
                databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/json/",pattern=personid)
            databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/",pattern=sessionid)
            databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/json/",pattern=sessionid)
            databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/enroll/",pattern=personid)
        except Exception as e:
            print("Exception Deleting data in DB",e)
            databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/",pattern=sessionid)
            databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/json/",pattern=sessionid)
            databasedeletehelper.purge(dir = "/home/easgrad/suryavee/images/enroll/",pattern=personid)

    # def deleteAllImages(self):
    #     print("Deleting All:")
    #     try:
    #         x = self.db[self._collection_name].delete_many({})

    #         print(x.deleted_count, " documents deleted.")
    #     except Exception as e:
    #          print("Exception Deleting data in DB",e)

    def testhello(self):
        print('hello')

if __name__ == '__main__':
    dbClass = Database()
    # dbClass.deleteAllImages()
    # dbClass.getImages('1')
    # dbClass.deleteImages('7B71BAA5')