import buildStaticRoute from "discourse/routes/build-static-route";
import { defaultHomepage } from "discourse/lib/utilities";
import { next } from "@ember/runloop";

const LoginRoute = buildStaticRoute("login");

LoginRoute.reopen({
  beforeModel() {
    
    if (!this.siteSettings.login_required) {
      var that = this
      next(() => that.send("showLogin"));
      // this.replaceWith(`/${defaultHomepage()}${query}`).then((e) => {
      //   window.location.search = query
      //   next(() => e.send("showLogin"));
      // });
    }
  },
});

export default LoginRoute;
