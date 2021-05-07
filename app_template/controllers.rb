class HelloworldController < Liberte::Controller
  action("/") { "Hello World!" }
  action("/error") { raise "Error!" }
  get("/get") { html("<html><body><form method='post' action='/post'><input type='submit'></form></body></html>") }
  post("/post") { "post!" }
end
