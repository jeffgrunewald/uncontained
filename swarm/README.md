### Swarm walkthrough ###

On your local Mac (no vm needed), create a single-node swarm cluster
```
docker swarm init
```

Pull down the openfaas repo and create the stack deployment
```
git clone http://github.com/openfaas/faas.git \
    && cd faas \
    && docker stack deploy func --compose-file docker-compose.yml
```

Verify the deployment through your browser (localhost:8080)

Deploy the inception function

Run a json-based request on the following image files:
- http://elelur.com/data_images/mammals/whale/whale-07.jpg
- https://images-na.ssl-images-amazon.com/images/I/71JcfZ9e2mL._SX355_.jpg