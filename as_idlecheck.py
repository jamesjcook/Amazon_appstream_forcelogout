import boto3
import datetime
import json
import os

MaxIdleMinutes = float(os.environ.get('MaxIdleMinutes') or 15) 

def handler(event, context):
    print( "Event: " + str(event) )
    # MaxIdleMinutes isnt avaialable directly... : (, had to use os environ get.
    print( "MaxIdleMinutes " + str(MaxIdleMinutes))
    cloudwatch = boto3.client('cloudwatch')
    appstream = boto3.client('appstream')
    dnow = datetime.datetime.now()
    metrics = cloudwatch.list_metrics(
        Namespace='Usage Metrics',
        MetricName='UserIdleTime',
    )
    print("Searching " + str(len(metrics['Metrics'])) + " metrics.")
    for metric in metrics['Metrics']:
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
            print("One open")
            if(statistics['Datapoints'][0]['Maximum'] > (MaxIdleMinutes*60) ):
                sessions = appstream.describe_sessions(
                    StackName=metric['Dimensions']['StackName'],
                    FleetName=metric['Dimensions']['FleetName'],
                    UserId=metric['Dimensions']['UserId'],
                    AuthenticationType='API',
                )
                for session in sessions['Sessions']:
                    appstream.expire_session(SessionId=sessions['id'])
                
        else:
            print("not there ")# + metric['Dimensions']['StackName'] + " " + metric['Dimensions']['FleetName'])
            
        
    