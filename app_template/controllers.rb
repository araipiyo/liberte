class HelloworldController < Liberte::Controller
  get("/") { "Hello World!" }
  get("/error") { raise "Error!" }
  get("/get") { html("<html><body><form method='post' action='/post'><input type='submit'></form></body></html>") }
  post("/post") { "post!" }
end
