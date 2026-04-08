# Using Phenix

Usually phenix runs in docker, so you will need to use `docker exec` to run phenix commands like so:

```
docker exec -it phenix phenix <command>
```

example:
```
docker exec -it phenix phenix --help
```
You can also run that help command and interpret the output to figure out what commands to run.

## Reloading the topology and scenario

Unless otherwise specified, the WORKFLOW_API is "http://localhost:3000/api/v1/workflow" and the experiment name is "test".
Usually the experiment name, scenario name, and topology name are all the same (as a convention)

```
curl -X POST -H "Content-Type: application/x-yaml" --data-binary "@topology.yml" $(WORKFLOW_API)/configs/$(EXP)
curl -X POST -H "Content-Type: application/x-yaml" --data-binary "@scenario.yml" $(WORKFLOW_API)/configs/$(EXP)
```

If there is a Makefile with the `topo-reload` command, you can use that instead.

## Starting the experiment

If there is a .phenix.yml file, you can use a workflow command like above to start or recreate/restart the experiment:
```
curl -X POST -H "Content-Type: application/x-yaml" --data-binary "@.phenix.yml" $(WORKFLOW_API)/apply/$(EXP)
```

If there is a Makefile with the `exp-reload` command, you can use that instead.

If you want to start the experiment with more verbose output/error messsages using the command line, you can use:

```
phenix exp delete <exp_name>
phenix exp create <exp_name> -t <topology_name> -s <scenario_name>
phenix exp start <exp_name>
```
But when you do this, the `${BRANCH_NAME}` variable will not be replaced with the actual names in the topology and scenario files, so you would have to do it manually.

## Scorch testing

If you want to test a scorch pipeline, you can run like so after an experiment is started:

```
phenix exp scorch <exp_name> -r <run_number>
```

Where the run number is the order of the run in the `runs` key of the `scorch` key of the scenario file (starting from 0). You can read the command output from there to identify errors.

## Other debugging

You can look at the logs from phenix and minimega with

```
docker logs -n 50 phenix
docker logs -n 50 minimega
```

You can also view the open vswitch status using the minimega container with
```
docker exec -it minimega ovs-vsctl show
```
