import boto3
import datetime
import json
import os
import logging

logger = logging.getLogger()


MaxIdleMinutes = float(os.environ.get('MaxIdleMinutes') or 15) 

def handler(event, context):
    # In testing this event print seems to always print the first cloudwatch
    # metric. Its not clear this will run on all each time.
    # print( "Event: " + str(event) )
    # MaxIdleMinutes isnt avaialable directly... : (, had to use os environ get.
    # print( "MaxIdleMinutes " + str(MaxIdleMinutes))
    cloudwatch = boto3.client('cloudwatch')
    appstream = boto3.client('appstream')
    dnow = datetime.datetime.now()
    metrics = cloudwatch.list_metrics(
        Namespace='Usage Metrics',
        MetricName='UserIdleTime',
    )
    # print("Searching " + str(len(metrics['Metrics'])) + " metrics.")
    for metric in metrics['Metrics']:
        # This getslast block of time that is MaxIdleMinutes in length.
        statistics = cloudwatch.get_metric_statistics(
            Namespace = metric['Namespace'],
            MetricName = metric['MetricName'],
            Dimensions = metric['Dimensions'],
            StartTime = dnow + datetime.timedelta(minutes=-MaxIdleMinutes),
            EndTime = dnow,
            Period=(int(MaxIdleMinutes*60)),
            Statistics=['Average','Minimum','Maximum']
        )
        if(len(statistics['Datapoints'])>=1):
            print("Found open session")
            if(statistics['Datapoints'][0]['Maximum'] > (MaxIdleMinutes*60) ):
                Dimensions = metric['Dimensions']
                Selection={};
                # combine dimensions.
                for dim in Dimensions:
                    Selection[dim['Name']]=dim['Value']
                    
                # print(json.dumps(Selection, sort_keys=True, indent=4))
                sessions = appstream.describe_sessions(
                    StackName=Selection['StackName'],
                    FleetName=Selection['FleetName'],
                    UserId=Selection['UserId'],
                    AuthenticationType='API',
                )
                
                # print(json.dumps(sessions, sort_keys=True, indent=4))
                for session in sessions['Sessions']:
                    print("Attempting expire on session ")
                    print(json.dumps(session, sort_keys=True, indent=4))
                    st=appstream.expire_session(SessionId=session['Id'])
                    print(json.dumps(st, sort_keys=True, indent=4))
                    logger.info("StoppedSession Stack: "+Selection['StackName']+"Fleet: "+Selection['FleetName']+"User: "+Selection['UserId'])
                
        #else:
        #    print("not there ")# + metric['Dimensions']['StackName'] + " " + metric['Dimensions']['FleetName'])
            
        
