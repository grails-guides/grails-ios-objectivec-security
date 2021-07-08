package intranet.backend

import grails.plugins.rest.client.RestBuilder
import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.*
import org.springframework.beans.factory.annotation.Value
import spock.lang.Specification

import javax.servlet.http.HttpServletResponse

@Rollback
@Integration
class AnnouncementControllerDeleteSpec extends Specification implements LoginAs {

    def "DELETE /annoucements/ endpoint is secured"() {
        when: 'Requesting announcements for version 1.0'
        RestBuilder rest = new RestBuilder()
        def resp = rest.delete("http://localhost:${serverPort}/announcements/1") {
            header("Accept-Version", "1.0")
        }

        then: 'the request was successful'
        resp.status == HttpServletResponse.SC_UNAUTHORIZED
    }

    def "DELETE /annoucements/ endpoint is not allowed for users without ROLE_BOSS"() {

        when: 'login with the watson'
        String accessToken = loginAs('watson', '221BakerStreet')

        then: 'watson is logged, thus he has a valid access token'
        accessToken

        when: 'Requesting de deletion of an announcement'
        RestBuilder rest = new RestBuilder()
        def resp = rest.delete("http://localhost:${serverPort}/announcements/1") {
            header("Accept-Version", "1.0")
            header("Authorization", "Bearer ${accessToken}")
        }

        then: 'it is forbidden for watson to delete announcements'
        resp.status == HttpServletResponse.SC_FORBIDDEN

        when: 'login with the sherlock'
        accessToken = loginAs('sherlock', 'elementary')

        then: 'sherlock is logged, thus he has a valid access token'
        accessToken

        when: 'Requesting announcements for version 1.0'
        resp = rest.delete("http://localhost:${serverPort}/announcements/1") {
            header("Accept-Version", "1.0")
            header("Authorization", "Bearer ${accessToken}")
        }

        then: 'the request was successful'
        resp.status == HttpServletResponse.SC_NO_CONTENT
    }
}
