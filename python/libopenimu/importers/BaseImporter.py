
"""
    Base class for every data importer
    @authors Dominic Létourneau
    @date 18/04/2018

"""

import threading
from libopenimu.tools.timing import timing
from libopenimu.db.DBManager import DBManager

@timing
def load_worker(importer, filename):
    print('load_worker starting')
    result = importer.load(filename)
    importer.loaded_callback(result)
    print('load worker done')


class BaseImporter:
    def __init__(self, db_filename):
        print('BaseImporter')
        self.db = DBManager(filename=db_filename, overwrite=True, echo=False)

        # TODO should be specified by users...
        self.group = self.db.add_group('MyGroup', 'MyDescription')
        self.participant = self.db.add_participant(group=self.group, name='Anonymous', description='Participant')

    def async_load(self, filename):
        print('will call load on importer with filename: ', filename)
        t = threading.Thread(target=load_worker, args=[self, filename])
        t.start()
        return t

    def load(self, filename):
        print('Nothing to do in BaseImporter.load')
        pass

    def import_to_database(self, result):
        pass

    def loaded_callback(self, result):
        print('loaded callback result len', len(result))
        self.import_to_database(result)

    def add_recordset_to_db(self, name, start_timestamp, stop_timestamp):
        recordset = self.db.add_recordset(self.participant, name, start_timestamp, stop_timestamp)
        return recordset

    def add_sensor_to_db(self, sensor_type, name, hw_name, location, sampling_rate, data_rate):
        sensor = self.db.add_sensor(sensor_type, name, hw_name, location, sampling_rate, data_rate)
        return sensor

    def add_channel_to_db(self, sensor, unit, data_format, label):
        channel = self.db.add_channel(sensor, unit, data_format, label)
        return channel

    def add_sensor_data_to_db(self, recordset, sensor, channel, timestamp, data):
        sensor_data = self.db.add_sensor_data(recordset, sensor, channel, timestamp, data)
        return sensor_data
