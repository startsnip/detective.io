class ProfileCtrl
    # Injects dependencies
    @$inject: ['$scope', 'Common', 'Page', 'user', '$state', '$q', 'User', '$http']

    constructor: (@scope, @Common, @Page, user, $state, $q, @User, @http)->
        @Page.title user.username
        @Page.loading yes

        # ──────────────────────────────────────────────────────────────────────
        # Scope attributes
        # ──────────────────────────────────────────────────────────────────────
        # Is this our profile page?
        @scope.isMe = $state.is 'user.me'
        #
        @scope.shouldShowTopics = no
        # User info
        @scope.user =
            name : "#{user.first_name} #{user.last_name}"
            username : user.username
            gravatar : "http://www.gravatar.com/avatar/#{user.email}?s=200&d=mm"
            location : user.profile.location
            organization : user.profile.organization
            url : user.profile.url
        # All topics the user can access
        @scope.userTopics = []

        # ──────────────────────────────────────────────────────────────────────
        # Scope methods
        # ──────────────────────────────────────────────────────────────────────
        @scope.shoulShowValueFor = @shoulShowValueFor
        @scope.shouldShowFormFor = @shouldShowFormFor
        @scope.openFormFor = @openFormFor
        @scope.validateFormFor = @validateFormFor

        # Get the user's topics
        ($q.all [
            (@Common.query type: "topic", author__id: user.id).$promise
            (@http.get "/api/common/v1/user/#{@User.id}/groups")
        ]).then (results) =>
            # First we handle the topics owned by this user
            for topic in results[0]
                (@scope.userTopics.push topic) if @canShowTopic topic

            # Then we handle the topics this user can contribute to
            for group in results[1].data.objects
                (@scope.userTopics.push group.topic) if @canShowTopic group.topic

            # Finally we can stop page loading and display the topics
            @scope.shouldShowTopics = true
            (@Page.loading no) if do @Page.loading

        @edit =
            location : no
            organization : no
            url : no

    canShowTopic: (topic) =>
        topic.public or @User.hasReadPermission topic.ontology_as_mod

    shoulShowValueFor: (fieldName) =>
        return yes unless @scope.isMe
        not @edit[fieldName]

    shouldShowFormFor: (fieldName) =>
        return no unless @scope.isMe
        @edit[fieldName]

    openFormFor: (fieldName) =>
        @edit[fieldName] = yes

    validateFormFor: (fieldName) =>
        data = {}
        data[fieldName] = @scope.user[fieldName]
        (@http
            method : 'patch'
            url : "/api/common/v1/profile/#{@User.profile.id}/"
            data : data
        ).then =>
            @edit[fieldName] = no

angular.module('detective.controller').controller 'profileCtrl', ProfileCtrl
