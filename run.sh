make_gitlab_dir() {
  mkdir -p /srv/gitlab
  mkdir -p /srv/gitlab/ssl
}

install_certs () {
  docker run -it --rm -p 443:443 -p 80:80 --name certbot \
    -v "/srv/gitlab/ssl:/etc/letsencrypt/live" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    quay.io/letsencrypt/letsencrypt:latest \
    certonly --standalone \
    -d "code.$BASE_URL" -d "chat.$BASE_URL" -d "registry.$BASE_URL"
}

run_gitlab () {
  docker-compose up -d
}

register_runner () {
  docker exec -i gitlabsetup_runner_1 gitlab-runner register \
    --url "http://web" \
    --executor docker \
    --docker-image ruby:2.1
}

make_gitlab_dir
install_certs
run_gitlab
echo "Enter 'Done' when Gitlab is accessable"
read DONE
register_runner
