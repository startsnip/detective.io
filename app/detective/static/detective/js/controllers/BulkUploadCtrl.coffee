class BulkUploadCtrl
    # Injects dependancies
    @$inject: ['$scope', '$http', '$routeParams', 'Page', 'Individual']

    constructor: (@scope, @http, @routeParams, @Page, @Individual)->
        # ──────────────────────────────────────────────────────────────────────
        # Scope attributes
        # ──────────────────────────────────────────────────────────────────────
        @Page.title "Bulk Upload", no
        @scope.add_file_field = @add_file_field
        @scope.select_topic   = @select_topic
        @scope.send           = @send
        @scope.file_fields    = ["file1"] # start with one file field

        config =
            method  : "GET"
            url     : "/api/common/v1/topic/"
            headers :
                "Content-Type": "application/json"
        @http(config)
            .success (response) =>
                @scope.topics = response.objects
            .error (message)=>
                # TODO
                console.log message

    send: =>
        form_data = new FormData($('form').get(0))
        $.ajax
            url         : ""
            type        : "POST"
            xhr         : $.ajaxSettings.xhr
            data        : form_data
            cache       : false
            contentType : false
            processData : false
        
    add_file_field: =>
        @scope.file_fields.push("file" + (@scope.file_fields.length + 1))

    select_topic: (topic) =>
        @scope.topic_selected = topic

angular.module('detective').controller 'BulkUploadCtrl', BulkUploadCtrl