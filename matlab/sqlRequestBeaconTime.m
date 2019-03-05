function [sqlquery] = sqlRequest(date, subject, sensor, hw_sensor, label)
%Same but just request the time vector
% subject : name or # of the subject depending of what is in the DB
% sensor : name of the sensor
% hw_sensor : name of the host sensor (AppleWatch, Sensoria...)
% date : date requested format string yyyy-mm-dd
% label is the concatenate off namespace_instanceID and TX Power or Rssi
% ex:01b00000000000002018_000000000081_TxPower

%Example:
% subject = 'P01'
% sensor = 'Accelerometer'
% hw_sensor = 'AppleWatch'
% date = '2019-02-15';


sqlquery = [...
    'SELECT tabSensorsTimestamps.timestamps '...
    'FROM tabSensorsData '... 
    'INNER JOIN tabSensorsTimestamps ON tabSensorsTimestamps.id_sensor_timestamps = tabSensorsData.id_timestamps '...
    'WHERE tabSensorsData.id_sensor '...
        'IN ('...
            'SELECT tabSensors.id_sensor '...
            'FROM tabSensors '...
            'WHERE tabSensors.name = ''' sensor ''' '...
            'AND tabSensors.hw_name = ''' hw_sensor ''''...
            ') '...
    'AND tabSensorsData.id_channel '...
        'IN ('...
            'SELECT tabChannels.id_channel '...
            'FROM tabChannels '...
            'WHERE tabChannels.id_sensor '...
                'IN ('...
                    'SELECT tabSensors.id_sensor '...
                    'FROM tabSensors '...
                    'WHERE tabSensors.name = ''' sensor ''' '...
                    'AND tabSensors.hw_name = ''' hw_sensor ''''...
                    ') '...
            'AND tabChannels.label = ''' label ''' '...
            ') '...
    'AND tabSensorsData.id_timestamps '...
        'IN ('...
            'SELECT tabSensorsTimestamps.id_sensor_timestamps '...
            'FROM tabSensorsTimestamps '...
            'WHERE tabSensorsTimestamps.start_timestamp LIKE ''' date '%'' '...
            'OR tabSensorsTimestamps.end_timestamp LIKE ''' date '%'''...
            ') '...
    'AND tabSensorsData.id_recordset '...
        'IN ('...
            'SELECT tabRecordsets.id_recordset '...
            'FROM tabRecordsets '...
            'WHERE tabRecordsets.id_participant '...
                'IN ('...
                    'SELECT tabParticipants.id_participant '...
                    'FROM tabParticipants '...
                    'WHERE tabParticipants.name=''' subject ''''...    
                    ')'...
        ') '...
    'AND tabSensorsData.data IS NOT NULL '...
    ];
end

