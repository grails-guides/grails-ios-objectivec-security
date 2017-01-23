package intranet.backend

import grails.plugins.rest.client.RestBuilder
import grails.test.mixin.integration.Integration
import grails.transaction.Rollback
import org.springframework.beans.factory.annotation.Value
import org.springframework.util.LinkedMultiValueMap
import org.springframework.util.MultiValueMap
import spock.lang.Specification

import javax.servlet.http.HttpServletResponse

@Rollback
@Integration
class OAuthAccessTokenControllerSpec extends Specification {

    def "POST /oauth/access_token endpoint is secured"() {
        when: 'Requesting announcements'
        RestBuilder rest = new RestBuilder()

        MultiValueMap<String, String> form = new LinkedMultiValueMap<String, String>()
        form.add("grant_type", "refresh_token")
        form.add("refresh_token", 'bogus')

        String url = "http://localhost:${serverPort}/oauth/access_token"
        println url
        def resp = rest.post(url) {
            contentType('application/x-www-form-urlencoded')
            body(form)
        }

        then: 'the request was successful'
        resp.status == HttpServletResponse.SC_FORBIDDEN
    }
}
