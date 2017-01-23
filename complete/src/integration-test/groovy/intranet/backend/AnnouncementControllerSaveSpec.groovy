package intranet.backend

import grails.plugins.rest.client.RestBuilder
import grails.test.mixin.integration.Integration
import grails.transaction.Rollback
import groovy.json.JsonOutput
import org.apache.commons.collections.Closure
import org.springframework.beans.factory.annotation.Value
import spock.lang.Specification

import javax.servlet.http.HttpServletResponse

@Rollback
@Integration
class AnnouncementControllerSaveSpec extends Specification implements LoginAs {

    def "POST /annoucements endpoint is secured"() {
        when: 'Requesting announcements'
        RestBuilder rest = new RestBuilder()
        String announcementJsonString = JsonOutput.toJson([title: 'Solved the mistery of the The Hounds of Baskerville',
                                                           body: 'The culprit is...'])
        def resp = rest.post("http://localhost:${serverPort}/announcements") {
            header("Accept-Version", "2.0")
            header("Accept", 'application/json')
            header("Content-Type", 'application/json')
            json announcementJsonString
        }

        then: 'the request was successful'
        resp.status == HttpServletResponse.SC_UNAUTHORIZED
    }

    def "POST /annoucements/ endpoint is not allowed for users without ROLE_BOSS"() {

        when: 'login with the watson'
        String accessToken = loginAs('watson', '221BakerStreet')

        then: 'watson is logged, thus he has a valid access token'
        accessToken

        when: 'Requesting de deletion of an announcement'
        RestBuilder rest = new RestBuilder()
        String announcementJsonString = JsonOutput.toJson([title: 'Solved the mistery of the The Hounds of Baskerville',
                                                           body: 'The culprit is...'])
        def resp = rest.post("http://localhost:${serverPort}/announcements") {
            header("Accept-Version", "2.0")
            header("Accept", 'application/json')
            header("Content-Type", 'application/json')
            header("Authorization", "Bearer ${accessToken}")
            json announcementJsonString
        }

        then: 'it is forbidden for watson to delete announcements'
        resp.status == HttpServletResponse.SC_FORBIDDEN

        when: 'login with the sherlock'
        accessToken = loginAs('sherlock', 'elementary')

        then: 'sherlock is logged, thus he has a valid access token'
        accessToken

        when: 'Requesting announcements for version 1.0'
        resp = rest.post("http://localhost:${serverPort}/announcements") {
            header("Accept-Version", "2.0")
            header("Accept", 'application/json')
            header("Content-Type", 'application/json')
            header("Authorization", "Bearer ${accessToken}")
            json announcementJsonString
        }

        then: 'the request was successful'
        resp.status == HttpServletResponse.SC_CREATED
    }
}
