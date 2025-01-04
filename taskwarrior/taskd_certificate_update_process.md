Go to server ~/.taskddata/pki

> ./generate
> ./generate.client toni
> cp *.pem ..

kill taskd process
> taskd server --daemon

Run copyCerts.sh on local machine
Should work
