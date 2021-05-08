class HelloworldController < Liberte::Controller
  get("/") { "Hello World!" }
  get("/error") { raise "Error!" }
  get("/get") { html(tags.html(tags.body(tags.form(tags.input(type: :submit),method: :post, action: "/post")))) }
  post("/post") { "post!" }
end
