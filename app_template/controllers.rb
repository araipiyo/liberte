class HelloworldController < Liberte::Controller
  action("/") { "Hello World!" }
  action("/error") { raise "Error!" }
end
