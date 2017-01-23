package intranet.backend

class UrlMappings {

    static mappings = {
        delete "/$controller/$id(.$format)?"(action:"delete")
        get "/$controller(.$format)?"(action:"index")
        get "/$controller/$id(.$format)?"(action:"show")
        post "/$controller(.$format)?"(action:"save")
        put "/$controller/$id(.$format)?"(action:"update")
        patch "/$controller/$id(.$format)?"(action:"patch")

        get "/announcements"(version:'1.0', controller: 'announcement', namespace:'v1')
        get "/announcements/$id(.$format)?"(version:'1.0', controller: 'announcement', action: 'show', namespace:'v1')
        delete "/announcements/$id(.$format)?"(action:"delete", version:'1.0', controller: 'announcement', namespace:'v1')
        post "/announcements(.$format)?"(action:"save", version:'1.0', controller: 'announcement', namespace:'v1')

        get "/announcements"(version:'2.0', controller: 'announcement', namespace:'v2')
        get "/announcements/$id(.$format)?"(version:'2.0', controller: 'announcement', action: 'show', namespace:'v2')
        delete "/announcements/$id(.$format)?"(action:"delete", version:'2.0', controller: 'announcement', namespace:'v2')
        post "/announcements(.$format)?"(action:"save", version:'2.0', controller: 'announcement', namespace:'v2')

        "/"(controller: 'application', action:'index')
        "500"(view: '/error')
        "404"(view: '/notFound')
    }
}
