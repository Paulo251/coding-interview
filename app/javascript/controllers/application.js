import { application } from "controllers"

application.register("hello", class extends Controller {
  connect() {
    console.log("Hello controller connected")
  }
})
