# New Relic Control - Terraform Cloud Based Drop Rules 
This demo terraform extends the [Fidelity Controlled Drop Rules demo](https://github.com/jsbnr/nr-terraform-fidelity-drop-rules) to support New Relic control cloud rules. Whilst there is currently no NR provider the [generic graphQL](https://registry.terraform.io/providers/sullivtr/graphql/latest/docs) provider can be used as temporary solution.

You can use the legacy provider or the graphQL provider to drive rule creation. You may comment out the relevant provider call in the module to decide which is used, you can even run both simultaneously. Note that in this mode you must provide a different NRQL syntax for the cloud rule. For example:

```
account_id   = 6884052
name        = "Drop INFO logs"
description = "Drop INFO logs"
action      = "drop_data"
nrql        = "SELECT * FROM Log WHERE debugLevel ='INFO'" #legacy
nrqlCloud    = "DELETE FROM Log WHERE debugLevel ='INFO'" #cloud
```

Specifying two different NRQL rules is toilsome, so instead its possible to generate the correct NRQL from component parts. This configuration shows an example:

```
account_id   = 6884052
name        = "Drop INFO logs"
description = "Drop INFO logs description"

event_type = "Log" 
filter = "debugLevel ='INFO'"
attributes = [] # leave empty for whole record 
```

In the above example instead of providing an action and two nrql statements we provide the key components: the `event_type`, the where clause via `filter` and a list of `attributes` to drop (an empty list indicates we should drop the entire record). This abstraction  makes it simpler to migrate from the legacy provider to the new provider (once available) which can be handled by a simple change in the module logic to switch between providers.



> -- Original readme follows --

## Configuration
The rules themselves are defined in the [config.tfvars](config.tfvars) file. Include the rules required for each level. In this toy example we specify four fidelity levels related to fictional LOG levels as follows:

- minimum - drop INFO, DEBUG and ERROR.  CRITICAL is kept. This is the standard level.
- medium - drop INFO and DEBUG only. ERROR and CRITCAL are kept
- high - drop INFO only.  DEBUG, ERROR and CRITICAL are kept
- maximum - drop nothing, all states are kept

Note the levels are cuulative, this means if you set the `level` to `minimum` then all the rules from `minium`, `medium` and `high` will be included.

To sleect the level to apply chnage the local `level` accordingly in [main.tf](main.tf)

## Installation
Make sure terraform is installed. I recommend [tfenv](https://github.com/tfutils/tfenv) for managing your terraform binaries.

Update the `runtf.sh.sample` file with your credentials and accont details and rename it `runtf.sh`. **Important do not commit this new file to git!** (It should be ignored in `.gitignore` already)

Note: You may want to update the version numbers in [main.tf](main.tf) to the latest versions of  Terraform and the New Relic provider.

## Initialisation
Use the `runtf.sh` helper script where ever you would normally run `terraform`. It simply wraps the terraform with some environment variables that make it easier to switch between projects.

First initialise terraform:
```
./runtf.sh init
```

Plan the changes:
```
./runtf.sh plan -var-file="config.tfvars"
```

Apply the changes: 
```
./runtf.sh apply -var-file="config.tfvars"
```


## State storage
This demo does not include remote state storage. State will be stored locally.

