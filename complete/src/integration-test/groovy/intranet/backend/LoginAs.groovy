package intranet.backend

import grails.plugin.json.builder.JsonOutput
import grails.plugins.rest.client.RestBuilder
import org.springframework.beans.factory.annotation.Value

trait LoginAs {

    /**
     *
     * @return access_token
     */
    String loginAs(String username, String password) {
        String jsonString = JsonOutput.toJson([username: username, password: password])
        RestBuilder rest = new RestBuilder()
        def resp = rest.post("http://localhost:${serverPort}/api/login") {
            header("Accept", "application/json")
            header("Content-Type", "application/json")
            json jsonString
        }
        resp?.json?.access_token
    }
}
