#web-vote-app
docker build -t muhakmalfadh/web-vote-app ./web-vote-app/
docker container create --name web-vote-app --env WEB_VOTE_NUMBER=01 muhakmalfadh/web-vote-app
docker container start web-vote-app

#vote-worker
docker build -t muhakmalfadh/vote-worker ./vote-worker/
docker container create --name vote-worker --env FROM_REDIS_HOST=1 --env TO_REDIS_HOST=1 muhakmalfadh/vote-worker
docker container start vote-worker

#results-app
docker build -t muhakmalfadh/results-app ./results-app/
docker container create --name results-app muhakmalfadh/results-app
docker container start results-app

#redis01
docker pull redis:3
docker container create --name redis01 redis:3
docker container start redis01

#store
docker pull postgres:9.5
docker container create --name store --env POSTGRES_USER=postgres --env POSTGRES_PASSWORD=pg8675309 postgres:9.5
docker container start store