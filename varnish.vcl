# See https://github.com/EFForg/action-center-platform/wiki/Deployment-Notes#cache-configuration

sub vcl_recv {
#FASTLY recv

  if (req.request != "HEAD" && req.request != "GET" && req.request != "FASTLYPURGE") {
      return(pass);
  }

  if (req.http.cookie ~ "logged_in" && req.url !~ "^/assets/") {
      set req.hash_always_miss = true;
      return(pass);
  }

  if (req.http.cookie ~ "^sweetAlert") {
      return(pass);
  }

  if (req.url !~ "^/(ahoy)/") {
      unset req.http.Cookie;
  }

  return(lookup);
}

sub vcl_fetch {
  if (req.http.cookie !~ "logged_in" && beresp.http.Set-Cookie !~ "^sweetAlert" && req.url !~ "^/(login)|(register)|(confirmation/new)|(unlock/new)|(password/new)|(password/edit)|(ahoy/)") {
      unset beresp.http.Set-Cookie;
  }

#FASTLY fetch

  if ((beresp.status == 500 || beresp.status == 503) && req.restarts < 1 && (req.request == "GET" || req.request == "HEAD")) {
      restart;
  }

  if (req.restarts > 0) {
      set beresp.http.Fastly-Restarts = req.restarts;
  }

  if (beresp.http.Set-Cookie) {
      set req.http.Fastly-Cachetype = "SETCOOKIE";
      return(pass);
  }

  if (beresp.http.Cache-Control ~ "private") {
      set req.http.Fastly-Cachetype = "PRIVATE";
      return(pass);
  }

  if (beresp.status == 500 || beresp.status == 503) {
      set req.http.Fastly-Cachetype = "ERROR";
      set beresp.ttl = 1s;
      set beresp.grace = 5s;
      return(deliver);
  }

  if (beresp.http.Expires || beresp.http.Surrogate-Control ~ "max-age" || beresp.http.Cache-Control ~ "(s-maxage|max-age)") {
      # keep the ttl here
  } else {
      # apply the default ttl
      set beresp.ttl = 3600s;
  }

  return(deliver);
}

sub vcl_hit {
#FASTLY hit

  if (!obj.cacheable) {
      return(pass);
  }
  return(deliver);
}

sub vcl_miss {
#FASTLY miss
  return(fetch);
}

sub vcl_deliver {
#FASTLY deliver
  return(deliver);
}

sub vcl_error {
#FASTLY error
}

sub vcl_pass {
#FASTLY pass
}

sub vcl_log {
#FASTLY log
}
