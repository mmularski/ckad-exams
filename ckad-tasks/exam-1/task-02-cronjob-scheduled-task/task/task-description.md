# CronJob: Scheduled Task

**Points:** 5

## Scenario
You are working in a Kubernetes cluster. Your task is to create a CronJob that runs on a schedule.

## Preparation
In the `prep/` directory you will find:
- `namespace.yaml` – namespace manifest

**Note:** You need to create all required manifests from scratch in the `prep/` directory.

## Requirements
- Create a namespace named `exam-1-task-02`.
- Create a CronJob named `date-writer` in that namespace with the following configuration:
  - Schedule: `* * * * *` (every minute)
  - Image: `busybox`
  - Uses an `emptyDir` volume
  - Appends data to a file in the shared volume
- The CronJob should run on schedule and complete successfully.

## Deliverables
- All required manifests in the `prep/` directory.
- A CronJob that runs on schedule and completes successfully.
- Pass the validation described below.

## Validation
To validate your solution, run:

```sh
./answer/validation.sh
```

## Notes
- The CronJob should run every minute and append data to a file.
- Use an `emptyDir` volume for temporary storage.
- The CronJob must have the exact name, schedule, and configuration listed above.