#!/bin/bash

rsync -rvz --delete -e ssh bin static rob@ccmi.fit.cvut.cz:~/rsync/dmp.fairdata.solutions
rsync -rvz --delete -e ssh dist/build/DSServer/DSServer rob@ccmi.fit.cvut.cz:~/rsync/dmp.fairdata.solutions/dmp.fairdata.solutions

ssh -t rob@ccmi.fit.cvut.cz 'sudo systemctl restart dmp.fairdata.solutions.service'
