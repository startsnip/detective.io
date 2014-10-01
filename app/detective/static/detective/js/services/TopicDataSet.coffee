angular.module('detective.service').factory("TopicDataSet", [
    '$resource'
    '$http'
    ($resource, $http)->
        $resource '/api/detective/common/v1/topicdataset/', {}, {
            get:
                method : 'GET'
                isArray: yes
                transformResponse: $http.defaults.transformResponse.concat([(data, headersGetter) ->
                    data.objects
                ])
            cachedGet:
                method : 'GET'
                isArray: yes
                transformResponse: $http.defaults.transformResponse.concat([(data, headersGetter) ->
                    data.objects
                ])
                cache  : yes
        }
])