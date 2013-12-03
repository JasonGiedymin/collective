# Marathon


## Tasks

Marathon runs on Mesos. Mesos runs tasks. Tasks once finished are exited. A 
simple task would be, "go send emails out to these 100 people", or "calculate 
xyz and come back with the result". Mesos once notified of a task will find a
cluster participant in the form of a slave or a master service which is free
and can run the offered task.


## The Good & Bad

The good is that tasks get distributed. The bad is long term monitoring. At the
moment there is no means in mesos to track or monitor tasks. Mesos once it
initiates a task is done. The only tracking left are resource and that a
task is running, but nothing more than an informational view post the initial
offer.

## Marathon

That is where Marathon comes into play. 

Marathon can continue interacting with running tasks, by scaling, destroying,
or even restarting them if need be. Much like upstart or init.d on Linux, you
can specify tasks as long running daemons.
