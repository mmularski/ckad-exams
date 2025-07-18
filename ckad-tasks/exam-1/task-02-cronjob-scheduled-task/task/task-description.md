# CronJob: Scheduled Task

**Points:** 5

## Scenario
You need to schedule a recurring task in Kubernetes that runs every minute and appends the current date to a file in an emptyDir volume.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

To prepare the environment, run:
```sh
kubectl apply -f prep/namespace.yaml
```

You must create `cronjob.yaml` yourself as part of the solution.

## Requirements
- Create a namespace named `exam-1-task-02`.
- Create a CronJob named `date-writer` in that namespace.
- The CronJob should use the `busybox` image and run the command: `date >> /data/dates.txt`
- Use an `emptyDir` volume mounted at `/data`.
- The CronJob should run every minute.

## Deliverables
- `cronjob.yaml` in the `prep/` directory.
- A CronJob that appends the current date to `/data/dates.txt` on each run.
- Pass the validation described below.

## Validation
To validate your solution, run:
```sh
kubectl get cronjob -n exam-1-task-02
# Check that jobs are being created and pods complete successfully.
```